"""
Clingo application extended to include automata
"""

import logging
import textwrap
from typing import Sequence
import sys
from clingo import Model, Symbol, SymbolType
from clingo.application import Application, ApplicationOptions, Flag

from . import reify

# from .approaches.asp import ASPApproach
# from .approaches.clingcon import ClingconApproach
from .approaches.mlp import MLPhtExtended, MLPhtPlain
from .approaches.mlp_htc import (
    MLPhtcExtended,
    MLPhtcExtendedDL,
    MLPhtcPlain,
    MLPhtcPlainDL,
)
from .utils.logger import setup_logger
from .utils.visualizer import visualize

log = logging.getLogger("main")

APPROACHES = {
    "mlp-lpnmr-ht": MLPhtPlain,
    "mlp-lpnmr-htc": MLPhtcPlain,
    "mlp-lpnmr-htcdl": MLPhtcPlainDL,
    "mlp-tplp-htc": MLPhtcExtended,
    "mlp-tplp-htcdl": MLPhtcExtendedDL,
    "mlp-tplp-ht": MLPhtExtended,
}


def _sym_to_prg(symbols: Sequence[Symbol]):
    """
    Turns symbols into a program
    """
    return "\n".join([f"{str(s)}." for s in symbols])


class MemelingoApp(Application):
    """
    Application class extending clingo
    """

    def __init__(self, name, constants=None):
        """
        Create application
        """
        self.program_name = name
        self._log_level = "WARNING"
        self._view = Flag()
        self._view_subformulas = Flag()
        self._approach_class = MLPhtcExtended
        self._timepoint_limit = None
        self._constants = {} if constants is None else constants

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
        if approach not in APPROACHES:
            log.error(
                f"Approach {approach} not recognized. Available approaches: {', '.join(APPROACHES.keys())}"
            )
            return False
        print(f"Using approach {approach}")
        self._approach_class = APPROACHES[approach]
        return True

    def parse_timepoint_limit(self, timepoint):
        """
        Parse timepoint limit
        """
        self._timepoint_limit = timepoint
        return True

    def register_options(self, options: ApplicationOptions) -> None:
        """
        Add custom options
        """
        group = "Clingo.Memelingo"
        self.options = options
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
                Metric Approach used for calculating models """
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
        options.add(
            group,
            "timepoint-limit",
            textwrap.dedent(
                """\
                Limit for the timepoint"""
            ),
            self.parse_timepoint_limit,
            argument="<timepoint>",
        )
        if self._approach_class is not None:
            if hasattr(self._approach_class, "theory"):
                print("Theory")
                print(self._approach_class.theory)
                self._approach_class.theory.register_options(self.options)

    def print_model1(self, model: Model, _) -> None:
        """
        Prints the model as in telingo, separating the states.

        Args:
            model (Model): The clingo model to be printed.
        """
        for s in model.symbols(shown=True):
            print(f"{s}\n")

    def print_model(self, model: Model, _) -> None:
        """
        Prints the model as in telingo, separating the states.

        Args:
            model (Model): The clingo model to be printed.
        """
        l = int(self._constants.get("lambda", 10))
        table = {}
        extra_shown = []
        for sym in model.symbols(shown=True, theory=True):
            if (
                sym.type == SymbolType.Function
                and len(sym.arguments) > 0
                and sym.name == ""
            ):
                table.setdefault(sym.arguments[-1].number, []).append(sym.arguments[0])
            else:
                extra_shown.append(sym)
        if len(extra_shown) > 0:
            # sys.stdout.write(" Other shown symbols:\n")
            sys.stdout.write("\n")
            for sym in extra_shown:
                sys.stdout.write(" {}".format(sym))
            sys.stdout.write("\n\n")
        for step in range(l):
            symbols = table.get(step, [])
            sys.stdout.write(" State {}:".format(step))
            sig = None
            for sym in sorted(symbols):
                # if (sym.name, len(sym.arguments), sym.positive) != sig:
                sys.stdout.write("\n ")
                # sig = (sym.name, len(sym.arguments), sym.positive)
                sys.stdout.write(" {}".format(sym))
            sys.stdout.write("\n")
        sys.stdout.write("\n")
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
        if self._timepoint_limit is not None:
            self._constants["timepoint_limit"] = int(self._timepoint_limit)
        local_log = setup_logger("main", getattr(logging, self._log_level))

        input_lambda = control.get_const("lambda")
        if input_lambda is None:
            local_log.warning(
                textwrap.dedent(
                    """The constant `lambda` is required for the metric meta-encoding.
                Provided with the argument `-c lambda=X` By default is set to 10 (9 steps)."""
                )
            )
        reified_prg = reify(files=files, constants=self._constants)
        app = self._approach_class(control, timepoint_limit=self._timepoint_limit)
        files_str = " ".join(files)
        reify_command = f"python -m clingo {files_str} --output=reify"
        log.info(reify_command + " | " + app.command_line)
        app.load(reified_prg)
        app.ground()
        app.solve(on_model=None)
