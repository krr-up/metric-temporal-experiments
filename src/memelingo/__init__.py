"""
The memelingo project.
"""
import logging
import os
from typing import List, Optional

from clingo import Control, Symbol
from clingox.reify import Reifier

log = logging.getLogger("main")
ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))


def reify(prg: Optional[str] = None, files: Optional[List] = None) -> str:
    """
    Reifies the program and files provided

        Returns: a string representing the reified program
    """
    if files is None:
        files = []
    symbols: List[Symbol] = []

    ctl = Control(["--warn=none"])
    reifier = Reifier(symbols.append, reify_steps=False)
    ctl.register_observer(reifier)
    if prg is not None:
        ctl.add("base", [], prg)
    for f in files:
        ctl.load(f)
    ctl.ground([("base", [])])
    rprg = "\n".join([str(s) + "." for s in symbols])
    log.debug("\n------ Reified Program ------\n %s", rprg)
    return rprg
