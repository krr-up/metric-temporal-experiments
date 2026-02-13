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


def get_agents(name):
    return name.split("_")[2].replace("a", "")


def get_instance_prefix(name):
    """Extract instance prefix without group, e.g., 'instances/x6_y6_a1' from 'instances/x6_y6_a1_f10'"""
    # Remove 'instances/' prefix if present
    name = name.replace("instances/", "")
    # Split by '_f' and take the first part
    if "_f" in name:
        return name.split("_f")[0]
    return name


def get_factor(name):
    """Extract factor number, e.g., '10' from 'instances/x6_y6_a1_f10'"""
    print(f"Extracting factor from name: {name}")
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


# More academic color scheme (colorblind-friendly)
colors = {
    "htc": "#000848",  # Blue
    "htcdl": "#025bff",  # Green
    "ht": "#58AF4D",  # Orange
}
markers = {"htc": "o", "ht": "s", "htcdl": "^"}

# More formal approach names for legend
approach_labels = {"htc": "clingcon", "ht": "clingo", "htcdl": "clingo-dl"}

CONFIG = {
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


def config_axes(ax, y_label, x_label, matching_instances, title=None):
    # Formatting
    if title:
        ax.set_title(title, fontsize=12, fontweight="normal", pad=15)
    ax.set_xlabel(x_label, fontsize=11, fontweight="light")
    ax.set_ylabel(y_label, fontsize=11, fontweight="light")

    ax.set_xticks(sorted(matching_instances.keys()))
    ax.margins(x=0.05, y=0.05)
    ax.legend(
        loc="best",
        frameon=True,
        framealpha=0.95,
        edgecolor="lightgray",
        fancybox=False,
        shadow=False,
    )
    ax.grid(True, alpha=0.3, linestyle="--", linewidth=0.5)
    ax.set_axisbelow(True)  # Grid behind data
    # Spines (borders) styling
    for spine in ax.spines.values():
        spine.set_linewidth(0.5)
        spine.set_color("gray")


def plot_instance_by_group(
    instance_prefix: str,
    attrs: list[str],
    all_instances: dict[str, pd.DataFrame],
    groupping_function: callable,
    group_by: str = "row",
    y="time (s)",
    x="factor",
    thick_attr=None,
    figsize=(7, 4),  # More standard academic size
    save_path=None,  # Option to save figure
    dpi=300,  # High DPI for publications
    approaches_skipped=None,
    group_skip=None,
    title=None,
):
    """
    Plot all approaches for instances matching the prefix, grouped by group.
    X-axis shows group values (f1, f10, f50, etc.)
    Each approach (column/benchmark) is one line.

    If thick_attr is provided, fills the area between the main line and the thick_attr line
    with lower opacity.
    """
    approaches_skipped = approaches_skipped or []
    group_skip = group_skip or set()
    # Filter instances matching the prefix
    matching_instances = {}
    if group_by == "row":
        for inst_name, inst_df in all_instances.items():
            if get_instance_prefix(inst_name) == instance_prefix:
                print("Yes!")
                group = groupping_function(inst_name)
                print(group)
                if group is not None:
                    matching_instances[group] = (inst_name, inst_df)
    elif group_by == "column":
        all_prefixes = {
            get_instance_prefix(inst): inst for inst in all_instances.keys()
        }
        if instance_prefix not in all_prefixes:
            print(f"No instance found matching prefix: {instance_prefix}")
            print(f"Available instances: {list(all_prefixes)}")
            return
        inst_df = all_instances[all_prefixes[instance_prefix]]
        group_matrix = {}
        for row in inst_df.index:
            group = groupping_function(row)
            print(f"Extracted group: {group} from row: {row}")
            if group is not None:
                if group not in group_matrix:
                    group_matrix[group] = []
                group_matrix[group].append(row)
        for group, rows in group_matrix.items():
            matching_instances[group] = (instance_prefix, inst_df.loc[rows])

    if not matching_instances:
        print(f"No instances found matching prefix: {instance_prefix}")
        return

    # Set publication-quality matplotlib parameters
    plt.rcParams.update(CONFIG)

    fig, ax = plt.subplots(figsize=figsize)

    # Get all approaches (benchmarks/columns in the dataframe)
    first_df = list(matching_instances.values())[0][1]
    approaches = [get_approach(bench) for bench in first_df.index]
    print(f"Approaches found: {approaches}")
    # Track UNKNOWN instances for annotation
    unknown_groups = {}

    for idx, benchmark in enumerate(first_df.index):
        print(f"Processing benchmark {idx}: {benchmark}")
        approach = approaches[idx]
        color = colors.get(approach, "black")
        marker = markers.get(approach, "o")
        label = approach_labels.get(approach, approach)

        # Collect data points for this approach across all groups
        groups = []
        values = []
        thick_values = []
        statuses = []

        for group in sorted(matching_instances.keys()):
            if group in group_skip:
                continue
            inst_name, inst_df = matching_instances[group]
            print(inst_df)
            print(inst_name)
            # Get data for this approach
            for attr in attrs:
                if attr in inst_df.columns:
                    print(
                        f"Extracting value for approach: {approach}, group: {group}, attr: {attr}"
                    )

                    value = inst_df.loc[benchmark, attr]
                    value_numeric = pd.to_numeric(value, errors="coerce")

                    if pd.notna(value_numeric):
                        groups.append(group)
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

        if not groups:
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
                    zip(groups, values, thick_values, statuses)
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
                groups,
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
            unknown_groups[approach] = set()
            for i, (f, v, s) in enumerate(zip(groups, values, statuses)):
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
                    unknown_groups[approach].add(f)

    # Add legend entry for UNKNOWN
    if any(unknown_groups.values()):
        ax.scatter(
            [],
            [],
            marker="x",
            s=80,
            color="red",
            linewidths=1,
            label="Timeout",
        )

    config_axes(
        ax=ax, y_label=y, x_label=x, matching_instances=matching_instances, title=title
    )

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
        plot_instance_by_group(
            instance_prefix,
            ["time"],
            df_instances,
            groupping_function=get_factor,
            group_by="row",
            y="Time (s)",
            x="Factor",
            thick_attr="stime",
            figsize=(3, 4),  # Single column width for papers
            save_path=save_path,
            dpi=300,
            # approaches_skipped=["ht"],
            group_skip={30, 35, 40, 45, 50},
            title=f"Agents = {get_agents(instance_prefix)}",
        )

        # plot_instance_by_group(
        #     instance_prefix,
        #     ["rules"],
        #     df_instances,
        #     groupping_function=get_group,
        #     group_by="row",
        #     y="#rules",
        #     # thick_attr="stime",
        #     figsize=(6, 4),  # Single column width for papers
        #     save_path=save_path,
        #     dpi=300,
        #     # approaches_skipped=["ht"],
        #     group_skip={30, 35, 40, 45, 50},
        # )

        # plot_instance_by_group(
        #     instance_prefix,
        #     ["time"],
        #     df_instances,
        #     groupping_function=get_lambda,
        #     group_by="column",
        #     y="Time (s)",
        #     thick_attr="stime",
        #     figsize=(6, 4),  # Single column width for papers
        #     save_path=save_path,
        #     dpi=300,
        #     # approaches_skipped=["ht"],
        #     # group_skip={30, 35, 40, 45, 50},
        # )


if __name__ == "__main__":
    main()
