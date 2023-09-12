"""
The Approach utils
"""
import logging
import os
from typing import Callable, List, Optional

from clingo import Control, Model
from clingo.ast import ProgramBuilder, parse_files
from clingo.theory import Theory
from clingox.program import Program, ProgramObserver

log = logging.getLogger("main")
ENCODINGS_PATH = os.path.join(".", os.path.join("src", "encodings"))


class MyApproach:
    """
    Basic class for a approach to meta metric logic
    """

    def __init__(self, ctl: Control):
        """
        Creates an approach with a control
        Args:
            ctl (Control): The clingo control
        """
        self.ctl = ctl

    def load(self, reified_prg: str):
        """
        Loads and adds needed info.
        Args:
            reified_prg (str): The reified program as a string
        """
        self.ctl.add("base", [], reified_prg)

    def ground(self):
        """
        Grounds the base program and adds a program observer to print such program
        """
        log.debug("Grounding...")
        prg_printer = Program()
        self.ctl.register_observer(ProgramObserver(prg_printer))

        self.ctl.ground([("base", [])])

        log.debug("------The grounded program ----")
        log.debug(prg_printer.pretty_str())
        log.debug("------------------------------")

    def solve(self, on_model: Optional[Callable] = None):
        """
        Calls the solve method
        Args:
            on_model (Optional[Callable], optional): A possible callback. Defaults to None.
        """
        self.ctl.solve(on_model=on_model)  # nocoverage


class CApproach(MyApproach):
    """
    Approach that uses a Theory (Clingcon, ClingoDL and fClingo)
    """

    def __init__(self, ctl: Control, theory_class, interval_files: List[str]):
        """
        Creates an approach

        Args:
            ctl (Control): The clingo control
            theory_class (_type_): The theory class used
            interval_files (List[str]): The list of additional files needed to calculate the intervals
        """
        super().__init__(ctl)
        self.theory_class = theory_class
        self.theory: Theory
        self.interval_files = interval_files

    @property
    def files(self):
        files = ["meta.lp", "meta-melingo.lp"] + self.interval_files

        return [os.path.join(ENCODINGS_PATH, file) for file in files]


    def parse_load_files(self):
        """
        Parses and loads the files
        """
    
        with ProgramBuilder(self.ctl) as pb:
            parse_files(
                self.files,
                lambda ast: self.theory.rewrite_ast(ast, pb.add),
            )

    def load(self, reified_prg: str):
        """
        Loads the files and the reified program

        Args:
            reified_prg (str): The reified program as a string
        """
        log.debug("Loading...")

        self.theory = self.theory_class()
        self.theory.register(self.ctl)
        self.parse_load_files()
        super().load(reified_prg)

    def custom_on_model(self, on_model: Optional[Callable] = None) -> Callable:
        """
        Custom on_model that takes care of assignments
        Args:
            on_model (Callable[..., Any] | None, optional): A possible callback. Defaults to None.

        Returns:
            : A function that can be passed to the on_model in solve
        """
        def on_model_function(mdl: Model):
            if on_model is not None:
                on_model(mdl)

        return on_model_function

    def solve(self, on_model: Optional[Callable] = None):
        """
        Calls the solve method and prepares the theory
        Args:
            on_model (Optional[Callable], optional): A possible callback. Defaults to None.
        """
        log.debug("Solving...")
        self.theory.prepare(self.ctl)

        self.ctl.solve(on_model=self.custom_on_model(on_model=on_model))
