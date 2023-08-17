"""
Clingo application extended to include automata
"""
import logging
import textwrap
from typing import Sequence

from clingo import Model, Symbol
from clingo.application import Application, ApplicationOptions, Flag

from . import reify
from .approaches.clingcon import ClinconApproach
from .utils.logger import setup_logger
from .utils.visualizer import visualize

log = logging.getLogger("main")


def _sym_to_prg(symbols: Sequence[Symbol]):
    """
    Turns symbols into a program
    """
    return "\n".join([f"{str(s)}." for s in symbols])


class MemelingoApp(Application):
    """
    Application class extending clingo
    """

    def __init__(self, name):
        """
        Create application
        """
        self.program_name = name
        self._log_level = "WARNING"
        self._view = Flag()
        self._view_subformulas = Flag()
        self._approach_class = ClinconApproach

    def parse_log_level(self, log_level):
        """
        Parse log
        """
        if log_level is not None:
            self._log_level = log_level.upper()
            return self._log_level in ["INFO", "WARNING", "DEBUG", "ERROR"]

        return True

    def parse_approach(self, approach):
        """
        Parse approach
        """
        if approach == "clingcon":
            self._approach_class = ClinconApproach
        else:
            return False

        return True

    def register_options(self, options: ApplicationOptions) -> None:
        """
        Add custom options
        """
        group = "Clingo.Memelingo"
        # Add an option of the system to run
        options.add(
            group,
            "log",
            textwrap.dedent(
                """\
                Provide logging level.
                                            <level> ={DEBUG|INFO|ERROR|WARNING}
                                            (default: WARNING)"""
            ),
            self.parse_log_level,
            argument="<level>",
        )
        options.add(
            group,
            "approach",
            textwrap.dedent(
                """\
                Metric Approach used for calculating models
                    <clingcon> """
            ),
            self.parse_approach,
            argument="<approach>",
        )
        options.add_flag(
            group, "view", "Visualize the timed trace using clingraph", self._view
        )
        options.add_flag(
            group,
            "view-subformulas",
            "Visualize the timed trace using clingraph and show all the subformulas that hold in each state",
            self._view_subformulas,
        )

    def print_model(self, model: Model, _) -> None:
        """
        Print a model on the console
        """
        log.debug("------- Full model -----")
        log.debug(
            "\n".join(
                [str(s) for s in model.symbols(atoms=True, shown=True, theory=True)]
            )
        )
        s_strings = [
            str(s)
            for s in model.symbols(shown=True, theory=True)
            if s.name in ["", "t"]
        ]
        print(" ".join(s_strings))
        if self._view or self._view_subformulas:
            visualize(
                _sym_to_prg(model.symbols(atoms=True, theory=True)),
                name_format=f"timed_trace_{model.number}",
                view_subformulas=self._view_subformulas.flag,
            )

    def main(self, control, files):
        """
        Main function ran on call
        """
        # pylint: disable=W0201
        local_log = setup_logger("main", getattr(logging, self._log_level))

        input_lambda = control.get_const("lambda")
        if input_lambda is None:
            local_log.warning(
                textwrap.dedent(
                    """The constant `lambda` is required for the metric meta-encoding.
                Provided with the argument `-c lambda=X` By default is set to 10 (9 steps)."""
                )
            )
        reified_prg = reify(files=files)
        app = self._approach_class(control)
        app.load(reified_prg)
        app.ground()
        app.solve(on_model=None)
