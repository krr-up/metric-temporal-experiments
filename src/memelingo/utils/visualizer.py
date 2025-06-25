"""
Visualizer of timmed traces
"""

import logging
import os

from clingo import Control
from clingo.script import enable_python
from clingraph.clingo_utils import ClingraphContext  # type: ignore
from clingraph.graphviz import compute_graphs, render  # type: ignore
from clingraph.orm import Factbase  # type: ignore

log = logging.getLogger("main")


ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))


def visualize(
    trace: str,
    name_format: str = "{graph_name}",
    view: bool = True,
    view_subformulas: bool = False,
) -> None:
    """
    Visualize the automata using clingraph
    """
    log.info("Visualizing trace...")
    args = []
    args.append("--warn=none")
    fb = Factbase(default_graph="trace")
    ctl = Control(args)
    ctx = ClingraphContext()
    log.debug(trace)
    ctl.add("base", [], trace)
    print(trace)
    if view_subformulas:
        ctl.add("base", [], "view_subformulas.")
    log.debug("File")
    log.debug(os.path.join(ENCODINGS_PATH, "viz/viz-trace.lp"))
    ctl.load(os.path.join(ENCODINGS_PATH, "viz/viz-trace.lp"))
    enable_python()
    print("Will ground")
    ctl.ground([("base", [])], context=ctx)
    print("Grounded")
    ctl.solve(on_model=fb.add_model)
    print("Solved")
    graphs = compute_graphs(fb)
    print("Computed graphs")
    files = render(
        graphs, view=view, name_format=name_format, engine="neato", format="svg"
    )
    print("Rendered graphs")
    log.info("Render saved in %s", files)
