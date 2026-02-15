"""
The Approach utils
"""

import logging
import os
from typing import Any, Callable, List, Optional

from clingo import Control, Function, Model, Number
from clingo.ast import ProgramBuilder, parse_files
from clingo.theory import Theory
from clingox.program import Program, ProgramObserver

log = logging.getLogger("main")
import importlib.resources


def get_encodings_path():
    """
    Returns the path to the encodings directory using the installed package resources.
    """
    try:
        # Try to get the path from the installed package
        with importlib.resources.path("memelingo", "encodings") as p:
            return str(p)
    except (ImportError, FileNotFoundError):
        # Fallback to the local path if not installed as a package
        raise FileNotFoundError(
            "Encodings directory not found. Please ensure the package is installed correctly."
        )
        return os.path.join(".", "src", "encodings")


ENCODINGS_PATH = get_encodings_path()


class MyApproach:
    """
    Basic class for a approach to meta metric logic
    """

    system_name = "clingo"

    def __init__(self, ctl: Control, timepoint_limit: int, asp_files: List[str]):
        """
        Creates an approach with a control
        Args:
            ctl (Control): The clingo control
            timepoint_limit: Limit for the timepoints
            asp_files (List[str]): The list of additional files needed to calculate the intervals
        """
        self.ctl = ctl
        self.timepoint_limit = timepoint_limit
        self.asp_files = asp_files

    def load(self, reified_prg: str):
        """
        Loads and adds needed info.
        Args:
            reified_prg (str): The reified program as a string
        """
        for f in self.files:
            self.ctl.load(f)
        self.ctl.add("base", [], f"#const v={self.timepoint_limit}.")
        if self.timepoint_limit is not None:
            print("Adding timepoint limit:", self.timepoint_limit)
            self.ctl.add("base", [], f"timepoint_limit({self.timepoint_limit}).")
        else:
            log.info("No timepoint limit provided, using unbounded timepoints.")
        self.ctl.add("base", [], reified_prg)

    @property
    def files(self):
        """
        List of files needed
        """
        files = self.asp_files

        return [os.path.join(ENCODINGS_PATH, file) for file in files]

    @property
    def command_line(self):
        """
        Command line to run the program
        """
        l = self.ctl.get_const("lambda")
        files = " ".join(self.files)
        return f"python -m {self.__class__.system_name} 0 - {files} -c lambda={l} -c v={self.timepoint_limit}"

    def ground(self):
        """
        Grounds the base program and adds a program observer to print such program
        """
        log.info("Grounding...")
        prg_printer = Program()
        self.ctl.register_observer(ProgramObserver(prg_printer))

        self.ctl.ground([("base", [])])

        # log.debug("------The grounded program ----")
        # log.debug(prg_printer.pretty_str())
        # log.debug("------------------------------")

    def solve(self, on_model: Optional[Callable] = None):
        """
        Calls the solve method
        Args:
            on_model (Optional[Callable], optional): A possible callback. Defaults to None.
        """
        log.info("Solving...")
        self.ctl.solve(on_model=self.custom_on_model(on_model=on_model))

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


class CApproach(MyApproach):
    """
    Approach that uses a Theory (Clingcon, ClingoDL and fClingo)
    """

    def __init__(
        self,
        ctl: Control,
        timepoint_limit: int,
        asp_files: List[str],
        theory_class,
    ):
        """
        Creates an approach

        Args:
            ctl (Control): The clingo control
            theory_class (_type_): The theory class used
            timepoint_limit: Limit for the timepoints
            asp_files (List[str]): The list of additional files needed to calculate the intervals
        """
        super().__init__(ctl, timepoint_limit, asp_files)
        self.theory_class = theory_class
        self.theory: Theory

    @property
    def files(self):
        """
        List of files needed
        """
        files = self.asp_files

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
        self.ctl.add("base", [], reified_prg)
        if self.timepoint_limit is not None:
            log.info(f"Adding timepoint limit: {self.timepoint_limit}")
            self.ctl.add("base", [], f"timepoint_limit({self.timepoint_limit}).")
        else:
            log.info("No timepoint limit provided, using unbounded timepoints.")

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
            for key, val in self.theory.assignment(mdl.thread_id):
                f = Function("t", [key.arguments[0], Number(int(str(val)))])
                mdl.extend([f])
            super_f(mdl)

        return on_model_function

    def solve(self, on_model: Optional[Callable] = None):
        """
        Calls the solve method and prepares the theory
        Args:
            on_model (Optional[Callable], optional): A possible callback. Defaults to None.
        """
        self.theory.prepare(self.ctl)
        super().solve(on_model=on_model)
