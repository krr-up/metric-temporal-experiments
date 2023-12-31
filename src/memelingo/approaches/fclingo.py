"""
The Approach using clingcon
"""
import logging
from typing import Any, Callable, Optional

from clingcon import ClingconTheory
from clingo import Control, Function, Model, Number
from clingo.ast import ProgramBuilder, parse_files
from fclingo import THEORY, Translator
from fclingo.parsing import HeadBodyTransformer
from fclingo.translator import ConstraintAtom

from . import CApproach

log = logging.getLogger("main")


class Config:
    """
    Fclingo configuraton
    """

    # pylint: disable=too-few-public-methods
    def __init__(self, max_int, min_int, print_trans) -> None:
        self.max_int = max_int
        self.min_int = min_int
        self.print_trans = print_trans


class FclingoApproach(CApproach):
    """
    Clincon approach for metric logic
    """

    def __init__(self, ctl: Control):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, ClingconTheory, ["meta-fclingo-interval.lp"])
        ctl.add("base", [], THEORY)
        self.translator = Translator(ctl, Config(0, 10, False))

    def parse_load_files(self):
        """
        Parses and loads the files
        """

        with ProgramBuilder(self.ctl) as pb:
            hbt = HeadBodyTransformer()
            parse_files(
                self.files,
                lambda ast: self.theory.rewrite_ast(
                    ast, lambda stm: pb.add(hbt.visit(stm))
                ),
            )

    def custom_on_model(
        self, on_model: Optional[Callable[..., Any]] = None
    ) -> Callable:
        """
        Custom on_model that takes care of assignments
        Args:
            on_model (Callable[..., Any] | None, optional): A possible callback. Defaults to None.

        Returns:
            _type_: A function that can be passed to the on_model in solve
        """
        super_f = super().custom_on_model(on_model)

        def on_model_function(mdl: Model) -> None:
            self.theory.on_model(mdl)
            defined = [
                str(s.arguments[0])
                for s in mdl.symbols(atoms=True)
                if s.match("__def", 1)
            ]
            for key, val in self.theory.assignment(mdl.thread_id):
                if str(key) not in defined:
                    continue
                f = Function("t", [key.arguments[0], Number(int(str(val)))])
                mdl.extend([f])
            super_f(mdl)

        return on_model_function

    def solve(self, on_model: Optional[Callable] = None):
        """
        Calls the solve method
        Args:
            on_model (Optional[Callable], optional): A possible callback. Defaults to None.
        """
        log.debug("Solving...")
        new_theory_atoms = set()
        for atom in self.ctl.theory_atoms:
            new_theory_atoms.add(ConstraintAtom.copy(atom))
        self.translator.translate(new_theory_atoms)

        self.ctl.solve(on_model=self.custom_on_model(on_model=on_model))
