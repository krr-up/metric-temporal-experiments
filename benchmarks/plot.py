# btool conv -m time,ctime,csolve,ground0,groundN,timeout,conflicts,choices,domain,vars,cons,mem,error,memout,status,atoms,rules
import pandas as pd
import matplotlib.pyplot as plt
import sys
import re


def load_xlsx(path: str) -> pd.DataFrame:
    """
    Load an Excel file into a pandas DataFrame.
    """
    df = pd.read_excel(path)
    return df


SUMMARY_ROWS = {"SUM", "AVG", "DEV", "DST", "BEST", "BETTER", "WORSE", "WORST"}
AGGREGATE_COLUMNS = {"min", "median", "max"}


def get_instance_prefix(name):
    """Extract instance prefix without factor, e.g., 'instances/x6_y6_a1' from 'instances/x6_y6_a1_f10'"""
    # Remove 'instances/' prefix if present
    name = name.replace("instances/", "")
    # Split by '_f' and take the first part
    if "_f" in name:
        return name.split("_f")[0]
    return name


def get_factor(name):
    """Extract factor number, e.g., '10' from 'instances/x6_y6_a1_f10'"""
    match = re.search(r"_f(\d+)", name)
    if match:
        return int(match.group(1))
    return None


def get_approach(benchmark_name):
    """Extract approach from benchmark column name"""
    # e.g., 'memelingo-1/allapproaches_mlp-tplp-ht' -> 'ht'
    if "mlp-tplp-" in benchmark_name:
        return benchmark_name.split("mlp-tplp-")[-1]
    return benchmark_name


def load_and_clean(raw: pd.DataFrame) -> dict[str, pd.DataFrame]:
    header_attr = raw.iloc[0]
    header_param = raw.iloc[1]

    # Data starts at row 2
    data = raw.iloc[1:].copy()

    # First column = instance / summary labels
    instance_col = data.columns[0]
    data = data.rename(columns={instance_col: "instance"})
    # Drop empty rows
    data = data.dropna(how="all")

    # Drop summary rows
    data = data[~data["instance"].isin(SUMMARY_ROWS)]

    col_map = {}  # benchmark -> [(attr, param)]
    attrs = []
    benchs = []

    # Track actual column names for each benchmark/attr pair
    column_lookup = {}  # (benchmark, attr) -> actual_column_name

    for col in raw.columns[1:]:  # skip instance column
        if col in AGGREGATE_COLUMNS:
            break
        if "Unnamed" not in col:
            benchs.append(col)
        attr = header_attr[col]
        param = header_param[col]

        if pd.notna(attr):
            attrs.append(attr)

        if param in AGGREGATE_COLUMNS:
            continue
        if pd.isna(param):
            param = 0

        current_bench = benchs[-1]
        if current_bench not in col_map:
            col_map[current_bench] = []
        col_map[current_bench].append((attrs[-1], param))

        # Store the actual column name
        column_lookup[(current_bench, attrs[-1])] = col

    instance_dfs = {}
    for _, row in data.iterrows():
        instance = row["instance"]
        matrix = []
        for bm, vals in col_map.items():
            row_vals = []
            for attr, param in vals:
                actual_col = column_lookup[(bm, attr)]
                row_vals.append(row[actual_col])
            matrix.append(row_vals)

        df_instance = pd.DataFrame(
            matrix, columns=list(attrs[: len(set(attrs))]), index=list(benchs)
        )

        instance_dfs[instance] = df_instance

    return instance_dfs


def plot_instance_by_factor(
    instance_prefix: str, attrs: list[str], all_instances: dict[str, pd.DataFrame]
):
    """
    Plot all approaches for instances matching the prefix, grouped by factor.
    X-axis shows factor values (f1, f10, f50, etc.)
    Each approach (column/benchmark) is one line.
    """
    # Filter instances matching the prefix
    matching_instances = {}
    for inst_name, inst_df in all_instances.items():
        if get_instance_prefix(inst_name) == instance_prefix:
            factor = get_factor(inst_name)
            if factor is not None:
                matching_instances[factor] = (inst_name, inst_df)

    if not matching_instances:
        print(f"No instances found matching prefix: {instance_prefix}")
        return

    # Define colors for approaches
    colors = {"htc": "blue", "ht": "red", "htcdl": "green"}
    markers = {"htc": "o", "ht": "s", "htcdl": "^"}

    fig, ax = plt.subplots(figsize=(10, 6))

    # Get all approaches (benchmarks/columns in the dataframe)
    first_df = list(matching_instances.values())[0][1]
    approaches = [get_approach(bench) for bench in first_df.index]

    # Track UNKNOWN instances for annotation
    unknown_factors = {}  # approach -> set of factors with UNKNOWN

    for idx, benchmark in enumerate(first_df.index):
        approach = approaches[idx]
        color = colors.get(approach, "black")
        marker = markers.get(approach, "o")

        # Collect data points for this approach across all factors
        factors = []
        values = []
        statuses = []

        for factor in sorted(matching_instances.keys()):
            inst_name, inst_df = matching_instances[factor]

            # Get data for this approach
            for attr in attrs:
                if attr in inst_df.columns:
                    value = inst_df.loc[benchmark, attr]

                    # Convert to numeric
                    value_numeric = pd.to_numeric(value, errors="coerce")

                    if pd.notna(value_numeric):
                        factors.append(factor)
                        values.append(value_numeric)

                        # Get status if available
                        if "status" in inst_df.columns:
                            status = inst_df.loc[benchmark, "status"]
                            statuses.append(status)
                        else:
                            statuses.append(None)

        if not factors:
            continue

        # Plot the line for this approach
        if approach != "ht":
            ax.plot(
                factors,
                values,
                marker=marker,
                label=f"{approach}",
                color=color,
                linewidth=2,
                markersize=8,
            )

            # Mark UNKNOWN points
            unknown_factors[approach] = set()
            for i, (f, v, s) in enumerate(zip(factors, values, statuses)):
                if s == "UNKNOWN":
                    ax.scatter(
                        [f],
                        [v],
                        marker="x",
                        s=200,
                        color="red",
                        linewidths=3,
                        zorder=10,
                    )
                    ax.scatter(
                        [f],
                        [v],
                        marker="o",
                        s=300,
                        facecolors="none",
                        edgecolors="red",
                        linewidths=2,
                        zorder=9,
                    )
                    unknown_factors[approach].add(f)

    # Add legend entry for UNKNOWN
    if any(unknown_factors.values()):
        ax.scatter(
            [], [], marker="x", s=200, color="red", linewidths=3, label="UNKNOWN"
        )

    ax.set_xlabel("Factor", fontsize=12)
    ax.set_ylabel("rules", fontsize=12)
    ax.set_title(f"Instance: {instance_prefix}", fontsize=14, fontweight="bold")

    # Set x-axis to show factor values
    ax.set_xticks(sorted(matching_instances.keys()))

    ax.legend(loc="best")
    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.show()


def main():
    path = "results-mapf.xlsx"
    df = load_xlsx(path)
    df.to_csv("results-mapf.csv", index=False)
    df_instances = load_and_clean(df)

    if len(sys.argv) > 1:
        instance_prefix = sys.argv[1]
    else:
        raise RuntimeError("Missing instance prefix argument (e.g., 'x6_y6_a1')")

    # Plot by factor for the given instance prefix
    # plot_instance_by_factor(instance_prefix, ["time"], df_instances)
    plot_instance_by_factor(instance_prefix, ["rules"], df_instances)


if __name__ == "__main__":
    main()
