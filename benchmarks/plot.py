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


SUMMARY_ROWS = {"SUM", "AVG", "DEV", "DST", "BEST", "BETTER", "WORSE", "WORST"}

AGGREGATE_COLUMNS = {"min", "median", "max"}


def get_real_benchmark_name(name):
    return name.replace("memelingo-1/setting-ht", "")


def load_and_clean(raw: pd.DataFrame) -> dict[str, pd.DataFrame]:
    header_attr = raw.iloc[0]
    header_param = raw.iloc[1]

    # Data starts at row 2
    data = raw.iloc[1:].copy()
    print(data)

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

    for col in raw.columns[1:]:  # skip instance column
        if col in AGGREGATE_COLUMNS:
            break
        if "Unnamed" not in col:
            benchs.append(col)
        attr = header_attr[col]
        param = header_param[col]

        if pd.notna(attr):
            attrs.append(attr)

        if param in AGGREGATE_COLUMNS or pd.isna(param):
            continue

        current_bench = benchs[-1]
        if current_bench not in col_map:
            col_map[current_bench] = []
        col_map[current_bench].append((attrs[-1], param))

    instance_dfs = {}
    for _, row in data.iterrows():
        instance = row["instance"]

        matrix = []
        for bm, vals in col_map.items():
            row_vals = []
            for attr, param in vals:
                row_vals.append(param)
            matrix.append(row_vals)

        df_instance = pd.DataFrame(
            matrix, columns=list(attrs[: len(set(attrs))]), index=list(benchs)
        )

        instance_dfs[instance] = df_instance

    return instance_dfs


def plot_instance(instance: str, attrs: list[str], df: pd.DataFrame):
    plt.figure()
    for attr in attrs:
        plt.scatter(df.index, df[attr], label=attr)
    plt.xticks(rotation=45, ha="right")
    plt.ylabel("time (s)")
    plt.title(instance)
    plt.tight_layout()
    plt.show()


def main():
    path = "results.xlsx"  # change this later
    df = load_xlsx(path)
    df.to_csv("results.csv", index=False)
    df_instances = load_and_clean(df)

    instance = "instances/ft06"
    title = "ft06"

    plot_instance(title, ["time", "stime"], df_instances[instance])


if __name__ == "__main__":
    main()
