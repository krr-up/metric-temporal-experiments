"""
The memelingo project.
"""
import logging
import os
from typing import Callable, List

import clingo
from clingcon import ClingconTheory
from clingo import Control, Function, Number, Symbol
from clingo.ast import ProgramBuilder, parse_string
from clingodl import ClingoDLTheory
from clingox.reify import ReifiedTheory, ReifiedTheoryTerm, Reifier

log = logging.getLogger("main")
ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))


def reify(prg: str = None, files: List = None):
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
    log.debug("\n------ Reified Program ------\n" + rprg)
    return rprg


def run_meta_clingcon(ctl: Control, reified_prg: str, on_model: Callable = None):
    thy = ClingconTheory()
    thy.register(ctl)

    meta_prg = ""
    files = ["meta.lp", "meta-melingo.lp", "meta-clingcon-interval.lp"]
    for file in files:
        with open(os.path.join(ENCODINGS_PATH, file)) as f:
            meta_prg += "\n".join(f.readlines())

    # load program
    with ProgramBuilder(ctl) as pb:
        parse_string(meta_prg, lambda ast: thy.rewrite_ast(ast, pb.add))

    # ground base
    ctl.add("base", [], reified_prg)
    ctl.ground([("base", [])])
    thy.prepare(ctl)

    models = []

    def clingcon_on_model(mdl):
        for key, val in thy.assignment(mdl.thread_id):
            f = Function("t", [key.arguments[0], Number(val)])
            mdl.extend([f])
            if on_model is not None:
                on_model(mdl)

    ctl.solve(on_model=clingcon_on_model)
    return models


def run_meta_clingodl(ctl: Control, reified_prg: str, on_model: Callable = None):
    thy = ClingoDLTheory()
    thy.register(ctl)

    meta_prg = ""
    files = ["meta.lp", "meta-melingo.lp", "meta-clingodl-interval.lp"]
    for file in files:
        with open(os.path.join(ENCODINGS_PATH, file)) as f:
            meta_prg += "\n".join(f.readlines())

    # load program
    with ProgramBuilder(ctl) as pb:
        parse_string(meta_prg, lambda ast: thy.rewrite_ast(ast, pb.add))

    # ground base
    ctl.add("base", [], reified_prg)
    ctl.ground([("base", [])])
    thy.prepare(ctl)

    models = []

    def clingodl_on_model(mdl):
        for key, val in thy.assignment(mdl.thread_id):
            f = Function("t", [key.arguments[0], Number(val)])
            mdl.extend([f])
            if on_model is not None:
                on_model(mdl)

    ctl.solve(on_model=clingodl_on_model)
    return models
