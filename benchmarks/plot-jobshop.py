# btool conv -m time,ctime,csolve,ground0,groundN,timeout,conflicts,choices,domain,vars,cons,mem,error,memout,status,atoms,rules
import pandas as pd
import matplotlib.pyplot as plt


def load_xlsx(path: str) -> pd.DataFrame:
    """
    Load an Excel file into a pandas DataFrame.
    """
    df = pd.read_excel(path)
    return df


import pandas as pd
import sys


SUMMARY_ROWS = {"SUM", "AVG", "DEV", "DST", "BEST", "BETTER", "WORSE", "WORST"}

AGGREGATE_COLUMNS = {"min", "median", "max"}


def get_lambda(name):
    return name.split("_")[1]


def get_approach(name):
    return name.split("_")[2].replace("mlp-tplp-", "")


def get_factor(name):
    return name.split("_")[-1]


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

    col_map = {}  # column_index -> (benchmark, parameter)
    attrs = []
    benchs = []

    # NEW: Track actual column names for each benchmark/attr pair
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

        # NEW: Store the actual column name
        column_lookup[(current_bench, attrs[-1])] = col

    instance_dfs = {}
    print(col_map)
    for _, row in data.iterrows():
        instance = row["instance"]
        print(f"Processing instance: {instance}")
        matrix = []
        for bm, vals in col_map.items():
            row_vals = []
            for attr, param in vals:
                # FIXED: Get actual value from row instead of param
                actual_col = column_lookup[(bm, attr)]
                row_vals.append(row[actual_col])
            matrix.append(row_vals)

        print(matrix)
        df_instance = pd.DataFrame(
            matrix, columns=list(attrs[: len(set(attrs))]), index=list(benchs)
        )

        instance_dfs[instance] = df_instance

    return instance_dfs


def plot_instance(
    instance: str, attrs: list[str], df: pd.DataFrame, join_approaches=False
):
    plt.figure()
    for attr in attrs:
        plt.scatter(df.index, df[attr], label=attr)
    plt.xticks(
        rotation=45,
        ha="right",
    )
    plt.ylabel("time (s)")
    plt.title(instance)
    plt.tight_layout()
    plt.show()


def plot_instance_single(instance: str, attrs: list[str], df: pd.DataFrame):
    """
    Plot all approaches on a single plot with different colors.
    X-axis shows lambda values.
    Highlights UNKNOWN status points (like timeout) and marks UNSATISFIABLE instances.
    """
    # Extract metadata
    df_meta = df.copy()
    df_meta["lambda"] = df_meta.index.map(get_lambda)
    df_meta["approach"] = df_meta.index.map(get_approach)

    # Convert lambda to numeric, handling any errors
    df_meta["lambda"] = pd.to_numeric(df_meta["lambda"], errors="coerce")

    # Drop rows where lambda or approach is NaN
    df_meta = df_meta.dropna(subset=["lambda", "approach"])

    # Also ensure the attribute columns are numeric
    for attr in attrs:
        df_meta[attr] = pd.to_numeric(df_meta[attr], errors="coerce")

    # Define colors for approaches
    colors = {"htc": "blue", "ht": "red", "htcdl": "green"}
    markers = {"htc": "o", "ht": "s", "htcdl": "^"}

    fig, ax = plt.subplots(figsize=(10, 6))

    approaches = sorted(df_meta["approach"].unique())

    # Track UNSAT instances for annotation
    unsat_lambdas = set()

    for approach in approaches:
        mask = df_meta["approach"] == approach
        subset = df_meta[mask].sort_values("lambda")

        # Skip if subset is empty
        if subset.empty:
            continue

        for attr in attrs:
            color = colors.get(approach, "black")
            marker = markers.get(approach, "o")

            # Filter out NaN values for plotting
            valid_data = subset.dropna(subset=["lambda", attr])

            if valid_data.empty:
                continue

            # Plot regular points
            ax.plot(
                valid_data["lambda"],
                valid_data[attr],
                marker=marker,
                label=f"{approach} - {attr}",
                color=color,
                linewidth=2,
                markersize=8,
            )

            # Handle status column if it exists
            if "status" in subset.columns:
                subset_status = subset.copy()

                # Find UNKNOWN status points (like timeout)
                unknown_mask = subset_status["status"] == "UNKNOWN"
                unknown_points = subset_status[unknown_mask].dropna(
                    subset=["lambda", attr]
                )

                if not unknown_points.empty:
                    # Draw red X markers over UNKNOWN points
                    ax.scatter(
                        unknown_points["lambda"],
                        unknown_points[attr],
                        marker="x",
                        s=200,
                        color="red",
                        linewidths=3,
                        zorder=10,
                        label=f"{approach} - UNKNOWN" if attr == attrs[0] else "",
                    )

                    # Add a red circle around UNKNOWN points
                    ax.scatter(
                        unknown_points["lambda"],
                        unknown_points[attr],
                        marker="o",
                        s=300,
                        facecolors="none",
                        edgecolors="red",
                        linewidths=2,
                        zorder=9,
                    )

                # Track UNSATISFIABLE instances
                unsat_mask = subset_status["status"] == "UNSATISFIABLE"
                unsat_points = subset_status[unsat_mask]
                for _, row in unsat_points.iterrows():
                    if pd.notna(row["lambda"]):
                        unsat_lambdas.add(row["lambda"])

    ax.set_xlabel("Lambda", fontsize=12)
    ax.set_ylabel("time (s)", fontsize=12)
    ax.set_title(instance, fontsize=14, fontweight="bold")

    if unsat_lambdas:
        for lambda_val in sorted(unsat_lambdas):
            # Add a vertical line
            ax.axvline(
                x=lambda_val,
                color="orange",
                linestyle="--",
                linewidth=2,
                alpha=0.7,
                zorder=0,
                label="UNSAT" if lambda_val == min(unsat_lambdas) else "",
            )

    # Clean up legend to avoid duplicates
    handles, labels = ax.get_legend_handles_labels()
    by_label = dict(zip(labels, handles))
    ax.legend(by_label.values(), by_label.keys(), loc="best")

    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.show()


def main():
    path = "results-jobshop-new.xlsx"  # change this later
    df = load_xlsx(path)
    df.to_csv("results-jobshop-new.csv", index=False)
    df_instances = load_and_clean(df)

    if len(sys.argv) > 1:
        instance = sys.argv[1]
    else:
        raise RuntimeError("Missing instance argument")
    # instance = "instances/ft06"
    full_instance = "instances/" + instance
    title = instance
    plot_instance_single(title, ["time"], df_instances[full_instance])
    # plot_instance(title, ["time"], df_instances[full_instance])


if __name__ == "__main__":
    main()
