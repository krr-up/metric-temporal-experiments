from argparse import ArgumentParser

import clingo


def read_map(map_file: str, ctl: clingo.Control):
    """
    Read the map file and return the map as a string.
    """
    with open(map_file, "r") as file:
        map_str = file.read().splitlines()[4:]

    with ctl.backend() as bck:
        for row in range(len(map_str)):
            for col in range(len(map_str[row])):
                if map_str[row][col] in [".", "E", "S"]:
                    v = clingo.Function("", [clingo.Number(col), clingo.Number(row)])
                    a = bck.add_atom(clingo.Function("vertex", [v]))
                    bck.add_rule([a])
                    if row > 0 and map_str[row - 1][col] in [".", "E", "S", "G"]:
                        y = clingo.Function(
                            "", [clingo.Number(col), clingo.Number(row - 1)]
                        )
                        a2 = bck.add_atom(clingo.Function("edge", [v, y]))
                        bck.add_rule([a2])
                        a3 = bck.add_atom(clingo.Function("edge", [y, v]))
                        bck.add_rule([a3])
                    if col > 0 and map_str[row][col - 1] in [".", "E", "S", "G"]:
                        y = clingo.Function(
                            "", [clingo.Number(col - 1), clingo.Number(row)]
                        )
                        a2 = bck.add_atom(clingo.Function("edge", [v, y]))
                        bck.add_rule([a2])
                        a3 = bck.add_atom(clingo.Function("edge", [y, v]))
                        bck.add_rule([a3])


def read_agents(scen_file: str, agent_count: int, ctl: clingo.Control) -> str:
    map_name = ""
    with ctl.backend() as bck:
        with open(scen_file, "r") as file:
            for i, line in enumerate(file.readlines()[1 : agent_count + 1], start=1):
                sline = line.split()

                if i == 1:
                    # read map name
                    map_name = sline[1]

                a = bck.add_atom(clingo.Function("agent", [clingo.Number(i)]))
                bck.add_rule([a])

                start = clingo.Function(
                    "", [clingo.Number(int(sline[4])), clingo.Number(int(sline[5]))]
                )
                a = bck.add_atom(clingo.Function("start", [clingo.Number(i), start]))
                bck.add_rule([a])

                goal = clingo.Function(
                    "", [clingo.Number(int(sline[6])), clingo.Number(int(sline[7]))]
                )
                a = bck.add_atom(clingo.Function("goal", [clingo.Number(i), goal]))
                bck.add_rule([a])

    return map_name
