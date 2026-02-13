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


def get_lambda(name):
    return name.split("_")[1]


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
    instance_prefix: str,
    attrs: list[str],
    all_instances: dict[str, pd.DataFrame],
    y="time (s)",
    thick_attr=None,
    figsize=(7, 4),  # More standard academic size
    save_path=None,  # Option to save figure
    dpi=300,  # High DPI for publications
    approaches_skipped=None,
    factor_skip=None,
):
    """
    Plot all approaches for instances matching the prefix, grouped by factor.
    X-axis shows factor values (f1, f10, f50, etc.)
    Each approach (column/benchmark) is one line.

    If thick_attr is provided, fills the area between the main line and the thick_attr line
    with lower opacity.
    """
    approaches_skipped = approaches_skipped or []
    factor_skip = factor_skip or set()
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

    # More academic color scheme (colorblind-friendly)
    colors = {
        "htc": "#000848",  # Blue
        "htcdl": "#025bff",  # Green
        "ht": "#58AF4D",  # Orange
    }
    markers = {"htc": "o", "ht": "s", "htcdl": "^"}

    # More formal approach names for legend
    approach_labels = {"htc": "clingcon", "ht": "clingo", "htcdl": "clingo-dl"}

    # Set publication-quality matplotlib parameters
    plt.rcParams.update(
        {
            "font.family": "serif",
            "font.serif": ["Times New Roman", "DejaVu Serif"],
            "font.size": 10,
            "axes.labelsize": 11,
            "axes.titlesize": 12,
            "xtick.labelsize": 10,
            "ytick.labelsize": 10,
            "legend.fontsize": 9,
            "legend.frameon": True,
            "legend.framealpha": 0.9,
            "legend.edgecolor": "gray",
            "grid.alpha": 0.3,
            "grid.linestyle": "--",
            "lines.linewidth": 1,
            "lines.markersize": 4,
        }
    )

    fig, ax = plt.subplots(figsize=figsize)

    # Get all approaches (benchmarks/columns in the dataframe)
    first_df = list(matching_instances.values())[0][1]
    approaches = [get_approach(bench) for bench in first_df.index]

    # Track UNKNOWN instances for annotation
    unknown_factors = {}

    for idx, benchmark in enumerate(first_df.index):
        approach = approaches[idx]
        color = colors.get(approach, "black")
        marker = markers.get(approach, "o")
        label = approach_labels.get(approach, approach)

        # Collect data points for this approach across all factors
        factors = []
        values = []
        thick_values = []
        statuses = []

        for factor in sorted(matching_instances.keys()):
            if factor in factor_skip:
                continue
            inst_name, inst_df = matching_instances[factor]

            # Get data for this approach
            for attr in attrs:
                if attr in inst_df.columns:
                    value = inst_df.loc[benchmark, attr]
                    value_numeric = pd.to_numeric(value, errors="coerce")

                    if pd.notna(value_numeric):
                        factors.append(factor)
                        values.append(value_numeric)

                        # Get thick attribute value if specified
                        if thick_attr and thick_attr in inst_df.columns:
                            thick_value = inst_df.loc[benchmark, thick_attr]
                            thick_value_numeric = pd.to_numeric(
                                thick_value, errors="coerce"
                            )
                            thick_values.append(
                                thick_value_numeric
                                if pd.notna(thick_value_numeric)
                                else 0
                            )
                        else:
                            thick_values.append(0)

                        # Get status if available
                        if "status" in inst_df.columns:
                            status = inst_df.loc[benchmark, "status"]
                            statuses.append(status)
                        else:
                            statuses.append(None)

        if not factors:
            continue

        # Plot the line for this approach
        if approach not in approaches_skipped:
            # Fill area between main line and thick attribute (if specified)
            if thick_attr and thick_values:
                # Create segments for fill_between, excluding UNKNOWN points
                # We'll fill between each consecutive pair of non-UNKNOWN points

                # Group consecutive non-UNKNOWN points
                segments_x = []
                segments_y_bottom = []
                segments_y_top = []

                current_x = []
                current_y_bottom = []
                current_y_top = []

                for i, (f, v, tv, s) in enumerate(
                    zip(factors, values, thick_values, statuses)
                ):
                    if s != "UNKNOWN" and not pd.isna(s):
                        current_x.append(f)
                        current_y_bottom.append(tv)
                        current_y_top.append(v)
                    else:
                        # UNKNOWN encountered - save current segment if it exists
                        if len(current_x) > 0:
                            segments_x.append(current_x)
                            segments_y_bottom.append(current_y_bottom)
                            segments_y_top.append(current_y_top)
                            # Reset for next segment
                            current_x = []
                            current_y_bottom = []
                            current_y_top = []

                # Don't forget the last segment
                if len(current_x) > 0:
                    segments_x.append(current_x)
                    segments_y_bottom.append(current_y_bottom)
                    segments_y_top.append(current_y_top)

                # Draw each segment
                for seg_x, seg_bottom, seg_top in zip(
                    segments_x, segments_y_bottom, segments_y_top
                ):
                    ax.fill_between(
                        seg_x,
                        seg_bottom,
                        seg_top,
                        alpha=0.25,
                        color=color,
                        linewidth=0,
                    )

            ax.plot(
                factors,
                values,
                marker=marker,
                label=label,
                color=color,
                linewidth=1,
                markersize=5,
                markeredgewidth=0.5,
                markeredgecolor="white",
                zorder=5,
            )

            # Mark UNKNOWN points
            unknown_factors[approach] = set()
            for i, (f, v, s) in enumerate(zip(factors, values, statuses)):
                if s == "UNKNOWN" or pd.isna(s):
                    ax.scatter(
                        [f],
                        [v],
                        marker="x",
                        s=80,
                        color="red",
                        linewidths=1,
                        zorder=10,
                    )
                    unknown_factors[approach].add(f)

    # Add legend entry for UNKNOWN
    if any(unknown_factors.values()):
        ax.scatter(
            [],
            [],
            marker="x",
            s=80,
            color="red",
            linewidths=1,
            label="Timeout",
        )

    # Formatting
    ax.set_xlabel("Factor", fontsize=11, fontweight="normal")
    ax.set_ylabel(y, fontsize=11, fontweight="normal")

    # Cleaner title (or remove if caption will be in LaTeX)
    # ax.set_title(f"{instance_prefix}", fontsize=12, fontweight='normal', pad=10)

    # Set x-axis to show factor values
    ax.set_xticks(sorted(matching_instances.keys()))

    # Optional: Set y-axis to log scale if values span orders of magnitude
    # ax.set_yscale('log')

    # Tighter axis limits
    ax.margins(x=0.05, y=0.05)

    # Legend positioning
    ax.legend(
        loc="best",
        frameon=True,
        framealpha=0.95,
        edgecolor="lightgray",
        fancybox=False,
        shadow=False,
    )

    # Grid styling
    ax.grid(True, alpha=0.3, linestyle="--", linewidth=0.5)
    ax.set_axisbelow(True)  # Grid behind data

    # Spines (borders) styling
    for spine in ax.spines.values():
        spine.set_linewidth(0.5)
        spine.set_color("gray")

    plt.tight_layout()

    # Save if path provided
    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", format="pdf")
        print(f"Figure saved to {save_path}")

    # plt.show()


def main():
    path = sys.argv[1]
    df = load_xlsx(path)
    df_instances = load_and_clean(df)
    if len(sys.argv) > 2:
        instances = [sys.argv[2]]
    else:
        instances = ["x6_y6_a1", "x6_y6_a2", "x6_y6_a3", "x6_y6_a4"]

    for instance_prefix in instances:
        # Optional: save path for PDF
        save_path = f"plots/{instance_prefix}.pdf"
        print(
            f"Plotting instance prefix: {instance_prefix} with save path: {save_path}"
        )
        # plot_instance_by_factor(
        #     instance_prefix,
        #     ["time"],
        #     df_instances,
        #     y="Time (s)",
        #     thick_attr="stime",
        #     figsize=(6, 4),  # Single column width for papers
        #     save_path=save_path,
        #     dpi=300,
        #     # approaches_skipped=["ht"],
        #     factor_skip={30, 35, 40, 45, 50},
        # )

        plot_instance_by_factor(
            instance_prefix,
            ["rules"],
            df_instances,
            y="#rules",
            # thick_attr="stime",
            figsize=(6, 4),  # Single column width for papers
            save_path=save_path,
            dpi=300,
            # approaches_skipped=["ht"],
            factor_skip={30, 35, 40, 45, 50},
        )


if __name__ == "__main__":
    main()
