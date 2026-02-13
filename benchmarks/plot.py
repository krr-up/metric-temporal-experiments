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
    """Configure axes styling for plots"""
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
    ax.set_axisbelow(True)

    for spine in ax.spines.values():
        spine.set_linewidth(0.5)
        spine.set_color("gray")


def plot_filled_segments(ax, groups, values, thick_values, statuses, color):
    """Plot filled area between lines, excluding UNKNOWN segments"""
    if not thick_values:
        return

    segments_x = []
    segments_y_bottom = []
    segments_y_top = []

    current_x = []
    current_y_bottom = []
    current_y_top = []

    for g, v, tv, s in zip(groups, values, thick_values, statuses):
        if s != "UNKNOWN" and not pd.isna(s):
            current_x.append(g)
            current_y_bottom.append(tv)
            current_y_top.append(v)
        else:
            if len(current_x) > 0:
                segments_x.append(current_x)
                segments_y_bottom.append(current_y_bottom)
                segments_y_top.append(current_y_top)
                current_x = []
                current_y_bottom = []
                current_y_top = []

    if len(current_x) > 0:
        segments_x.append(current_x)
        segments_y_bottom.append(current_y_bottom)
        segments_y_top.append(current_y_top)

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


def plot_approach_line(ax, groups, values, statuses, approach, label):
    """Plot line for a single approach with UNKNOWN markers"""
    color = colors.get(approach, "black")
    marker = markers.get(approach, "o")

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
    unknown_groups = set()
    for g, v, s in zip(groups, values, statuses):
        if s == "UNKNOWN" or pd.isna(s):
            ax.scatter(
                [g],
                [v],
                marker="x",
                s=80,
                color="red",
                linewidths=1,
                zorder=10,
            )
            unknown_groups.add(g)

    return unknown_groups


def plot_instance_by_row(
    instance_prefix: str,
    attrs: list[str],
    all_instances: dict[str, pd.DataFrame],
    grouping_function: callable,
    y="time (s)",
    x="factor",
    thick_attr=None,
    figsize=(7, 4),
    save_path=None,
    dpi=300,
    approaches_skipped=None,
    group_skip=None,
    title=None,
):
    """
    Plot when grouping is by ROWS (different instances in rows, approaches in columns).
    E.g., instances x6_y6_a1_f1, x6_y6_a1_f10, etc. are different rows.
    """
    approaches_skipped = approaches_skipped or []
    group_skip = group_skip or set()

    # Filter instances matching the prefix and extract groups
    matching_instances = {}
    for inst_name, inst_df in all_instances.items():
        if get_instance_prefix(inst_name) == instance_prefix:
            group = grouping_function(inst_name)
            if group is not None and group not in group_skip:
                matching_instances[group] = (inst_name, inst_df)

    if not matching_instances:
        print(f"No instances found matching prefix: {instance_prefix}")
        return

    plt.rcParams.update(CONFIG)
    fig, ax = plt.subplots(figsize=figsize)

    # Get all approaches from first instance
    first_df = list(matching_instances.values())[0][1]
    all_unknown = {}

    # Loop: for each approach (column), collect data across groups (rows)
    for benchmark in first_df.index:
        approach = get_approach(benchmark)

        if approach in approaches_skipped:
            continue

        label = approach_labels.get(approach, approach)

        # Collect data across all groups for this approach
        groups = []
        values = []
        thick_values = []
        statuses = []

        for group in sorted(matching_instances.keys()):
            inst_name, inst_df = matching_instances[group]

            for attr in attrs:
                if attr in inst_df.columns and benchmark in inst_df.index:
                    value = inst_df.loc[benchmark, attr]
                    value_numeric = pd.to_numeric(value, errors="coerce")

                    if pd.notna(value_numeric):
                        groups.append(group)
                        values.append(value_numeric)

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

                        if "status" in inst_df.columns:
                            statuses.append(inst_df.loc[benchmark, "status"])
                        else:
                            statuses.append(None)

        if not groups:
            continue

        # Plot filled area
        if thick_attr and thick_values:
            plot_filled_segments(
                ax,
                groups,
                values,
                thick_values,
                statuses,
                colors.get(approach, "black"),
            )

        # Plot line
        unknown = plot_approach_line(ax, groups, values, statuses, approach, label)
        all_unknown[approach] = unknown

    # Add timeout legend entry
    if any(all_unknown.values()):
        ax.scatter([], [], marker="x", s=80, color="red", linewidths=1, label="Timeout")

    config_axes(ax, y, x, matching_instances, title)
    plt.tight_layout()

    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", format="pdf")
        print(f"Figure saved to {save_path}")

    plt.show()


def plot_instance_by_column(
    instance_name: str,
    attrs: list[str],
    all_instances: dict[str, pd.DataFrame],
    grouping_function: callable,
    y="time (s)",
    x="lambda",
    thick_attr=None,
    figsize=(7, 4),
    save_path=None,
    dpi=300,
    approaches_skipped=None,
    group_skip=None,
    title=None,
):
    """
    Plot when grouping is by COLUMNS (single instance, different approaches in columns).
    E.g., single instance with columns: approach1_lambda10, approach1_lambda20, etc.
    """
    approaches_skipped = approaches_skipped or []
    group_skip = group_skip or set()

    # Find the instance
    all_prefixes = {get_instance_prefix(inst): inst for inst in all_instances.keys()}
    if instance_name not in all_prefixes:
        print(f"No instance found matching: {instance_name}")
        print(f"Available instances: {list(all_prefixes.keys())}")
        return

    inst_df = all_instances[all_prefixes[instance_name]]

    # Group columns (benchmarks) by grouping function
    group_matrix = {}
    for benchmark in inst_df.index:
        group = grouping_function(benchmark)
        if group is not None and group not in group_skip:
            if group not in group_matrix:
                group_matrix[group] = []
            group_matrix[group].append(benchmark)

    if not group_matrix:
        print(f"No groups found for instance: {instance_name}")
        return

    plt.rcParams.update(CONFIG)
    fig, ax = plt.subplots(figsize=figsize)

    # Get unique approaches
    approaches_set = set()
    for benchmarks in group_matrix.values():
        for benchmark in benchmarks:
            approaches_set.add(get_approach(benchmark))

    all_unknown = {}

    # Loop: for each approach, collect data across groups (columns)
    for approach in sorted(approaches_set):
        if approach in approaches_skipped:
            continue

        label = approach_labels.get(approach, approach)

        groups = []
        values = []
        thick_values = []
        statuses = []

        for group in sorted(group_matrix.keys()):
            # Find benchmark for this approach in this group
            benchmark = None
            for b in group_matrix[group]:
                if get_approach(b) == approach:
                    benchmark = b
                    break

            if benchmark is None:
                continue

            for attr in attrs:
                if attr in inst_df.columns:
                    value = inst_df.loc[benchmark, attr]
                    value_numeric = pd.to_numeric(value, errors="coerce")

                    if pd.notna(value_numeric):
                        groups.append(group)
                        values.append(value_numeric)

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

                        if "status" in inst_df.columns:
                            statuses.append(inst_df.loc[benchmark, "status"])
                        else:
                            statuses.append(None)

        if not groups:
            continue

        # Plot filled area
        if thick_attr and thick_values:
            plot_filled_segments(
                ax,
                groups,
                values,
                thick_values,
                statuses,
                colors.get(approach, "black"),
            )

        # Plot line
        unknown = plot_approach_line(ax, groups, values, statuses, approach, label)
        all_unknown[approach] = unknown

    # Add timeout legend entry
    if any(all_unknown.values()):
        ax.scatter([], [], marker="x", s=80, color="red", linewidths=1, label="Timeout")

    config_axes(ax, y, x, group_matrix, title)
    plt.tight_layout()

    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", format="pdf")
        print(f"Figure saved to {save_path}")

    plt.show()


def plot_multiple_instances_by_row(
    instance_prefixes: list[str],
    attrs: list[str],
    all_instances: dict[str, pd.DataFrame],
    grouping_function: callable,
    y="time (s)",
    x="factor",
    thick_attr=None,
    figsize=(12, 3),  # Width for multiple subplots, smaller height
    save_path=None,
    dpi=300,
    approaches_skipped=None,
    group_skip=None,
    subplot_titles=None,  # Optional titles for each subplot
):
    """
    Plot multiple instances side-by-side with shared y-axis and legend.
    """
    approaches_skipped = approaches_skipped or []
    group_skip = group_skip or set()
    subplot_titles = subplot_titles or instance_prefixes

    n_plots = len(instance_prefixes)

    plt.rcParams.update(CONFIG)

    # Create subplots in a row, sharing y-axis
    fig, axes = plt.subplots(1, n_plots, figsize=figsize, sharey=True)

    # Handle case of single subplot
    if n_plots == 1:
        axes = [axes]

    # Track which approaches appear (for shared legend)
    all_approaches = set()
    all_unknown = False

    # Plot each instance in its own subplot
    for idx, (instance_prefix, ax) in enumerate(zip(instance_prefixes, axes)):
        # Filter instances matching the prefix
        matching_instances = {}
        for inst_name, inst_df in all_instances.items():
            if get_instance_prefix(inst_name) == instance_prefix:
                group = grouping_function(inst_name)
                if group is not None and group not in group_skip:
                    matching_instances[group] = (inst_name, inst_df)

        if not matching_instances:
            print(f"No instances found matching prefix: {instance_prefix}")
            continue

        # Get all approaches from first instance
        first_df = list(matching_instances.values())[0][1]

        # Loop: for each approach, collect data across groups
        for benchmark in first_df.index:
            approach = get_approach(benchmark)

            if approach in approaches_skipped:
                continue

            all_approaches.add(approach)
            label = approach_labels.get(approach, approach)

            # Collect data across all groups for this approach
            groups = []
            values = []
            thick_values = []
            statuses = []

            for group in sorted(matching_instances.keys()):
                inst_name, inst_df = matching_instances[group]

                for attr in attrs:
                    if attr in inst_df.columns and benchmark in inst_df.index:
                        value = inst_df.loc[benchmark, attr]
                        value_numeric = pd.to_numeric(value, errors="coerce")

                        if pd.notna(value_numeric):
                            groups.append(group)
                            values.append(value_numeric)

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

                            if "status" in inst_df.columns:
                                statuses.append(inst_df.loc[benchmark, "status"])
                            else:
                                statuses.append(None)

            if not groups:
                continue

            # Plot filled area
            if thick_attr and thick_values:
                plot_filled_segments(
                    ax,
                    groups,
                    values,
                    thick_values,
                    statuses,
                    colors.get(approach, "black"),
                )

            # Plot line (no label here - we'll add legend separately)
            color = colors.get(approach, "black")
            marker = markers.get(approach, "o")

            ax.plot(
                groups,
                values,
                marker=marker,
                color=color,
                linewidth=1,
                markersize=5,
                markeredgewidth=0.5,
                markeredgecolor="white",
                zorder=5,
            )

            # Mark UNKNOWN points
            for g, v, s in zip(groups, values, statuses):
                if s == "UNKNOWN" or pd.isna(s):
                    ax.scatter(
                        [g],
                        [v],
                        marker="x",
                        s=80,
                        color="red",
                        linewidths=1,
                        zorder=10,
                    )
                    all_unknown = True

        # Configure individual subplot
        ax.set_xlabel(x, fontsize=11, fontweight="light")
        if idx == 0:  # Only leftmost plot gets y-label
            ax.set_ylabel(y, fontsize=11, fontweight="light")

        # Set title for this subplot
        ax.set_title(subplot_titles[idx], fontsize=12, fontweight="normal", pad=10)

        ax.set_xticks(sorted(matching_instances.keys()))
        ax.margins(x=0.05, y=0.05)
        ax.grid(True, alpha=0.3, linestyle="--", linewidth=0.5)
        ax.set_axisbelow(True)

        for spine in ax.spines.values():
            spine.set_linewidth(0.5)
            spine.set_color("gray")

    # Create shared legend
    handles = []
    labels = []

    # Add approach lines to legend
    for approach in sorted(all_approaches):
        color = colors.get(approach, "black")
        marker = markers.get(approach, "o")
        label = approach_labels.get(approach, approach)

        line = plt.Line2D(
            [0],
            [0],
            color=color,
            marker=marker,
            linewidth=1,
            markersize=5,
            markeredgewidth=0.5,
            markeredgecolor="white",
            label=label,
        )
        handles.append(line)
        labels.append(label)

    # Add timeout marker if needed
    if all_unknown:
        timeout_marker = plt.Line2D(
            [0],
            [0],
            marker="x",
            color="red",
            markerfacecolor="red",
            markersize=8,
            linewidth=0,
            label="Timeout",
        )
        handles.append(timeout_marker)
        labels.append("Timeout")

    # Add legend to the figure (not individual subplots)
    fig.legend(
        handles,
        labels,
        loc="upper center",
        bbox_to_anchor=(0.5, 1.0),  # Changed from 1.08 to 1.0
        ncol=len(handles),
        frameon=True,
        framealpha=0.95,
        edgecolor="lightgray",
        fancybox=False,
    )

    # Adjust layout to make room for legend
    plt.tight_layout(rect=[0, 0, 1, 0.95])  # Leave 5% space at top for legend

    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", format="pdf")
        print(f"Figure saved to {save_path}")

    plt.show()


def main():
    path = sys.argv[1]
    df = load_xlsx(path)
    df_instances = load_and_clean(df)

    if len(sys.argv) > 2:
        # Single instance - use original function
        instance_prefix = sys.argv[2]
        save_path = f"plots/{instance_prefix}_factor.pdf"

        plot_instance_by_row(
            instance_prefix,
            ["time"],
            df_instances,
            grouping_function=get_factor,
            y="Time (s)",
            x="Factor",
            thick_attr="stime",
            figsize=(3, 4),
            save_path=save_path,
            dpi=300,
            group_skip={30, 35, 40, 45, 50},
            title=f"Agents = {get_agents(instance_prefix)}",
        )
    else:
        # Multiple instances - use new function
        instances = ["x6_y6_a1", "x6_y6_a2", "x6_y6_a3", "x6_y6_a4"]
        save_path = "plots/all_instances_factor.pdf"

        # Generate subplot titles
        subplot_titles = [f"Agents = {get_agents(inst)}" for inst in instances]

        plot_multiple_instances_by_row(
            instances,
            ["time"],
            df_instances,
            grouping_function=get_factor,
            y="Time (s)",
            x="Factor",
            thick_attr="stime",
            figsize=(12, 3),  # 4 subplots × 3 inches each
            save_path=save_path,
            dpi=300,
            group_skip={30, 35, 40, 45, 50},
            approaches_skipped=["ht"],  # Skip clingo-dl for better visibility
            subplot_titles=subplot_titles,
        )


if __name__ == "__main__":
    main()
