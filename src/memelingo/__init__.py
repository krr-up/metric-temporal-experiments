"""
The memelingo project.
"""
import os
import clingo
from clingcon import ClingconTheory
from clingo import Control, Symbol, Number, Function
from clingo.ast import ProgramBuilder, parse_string
from clingox.reify import Reifier, ReifiedTheory, ReifiedTheoryTerm
from typing import List

import logging

log = logging.getLogger('main')
ENCODINGS_PATH = os.path.join('.',os.path.join('src','encodings'))

def reify(prg:str=None, files:List =None):
    if files is None:
        files=[]
    symbols: List[Symbol] = []

    ctl = Control(["--warn=none"])
    reifier = Reifier(symbols.append, reify_steps=False)
    ctl.register_observer(reifier)
    ctl.add("base", [], prg)
    for f in files:
        ctl.load(f)
    ctl.ground([('base', [])])
    rprg = "\n".join([str(s)+"." for s in symbols])
    log.debug("\n------ Reified Program ------\n"+rprg)
    return rprg


def run_meta_clingcon(prg:str, clambda:int, models:int=20):
    ctl = Control(["--warn=none",f"{models}",f"-c lambda={clambda}"])
    thy = ClingconTheory()
    thy.register(ctl)

    with open(os.path.join(ENCODINGS_PATH,'meta-melingo.lp')) as f:
        meta_prg = "\n".join(f.readlines())

    # load program
    with ProgramBuilder(ctl) as pb:
        parse_string(meta_prg, lambda ast : thy.rewrite_ast(ast, pb.add))


    # ground base
    ctl.ground([("base", [])])
    thy.prepare(ctl)

    models = []
    with ctl.solve(yield_=True) as hnd:
        for mdl in hnd:

            for key, val in thy.assignment(mdl.thread_id):
                f = Function('t',[key.arguments[0],Number(val)])
                mdl.extend([f])
            models.append(str(s) for s in mdl.symbols(theory=True,shown=True))

    for i, model in enumerate(models):
        print(f"\nAnswer {i}:")
        print(" ".join(model))