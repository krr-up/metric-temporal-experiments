"""
Clingo application extended to include automata
"""
import logging
import textwrap

from clingo import Model
from clingo.application import Application, ApplicationOptions, Flag

log = logging.getLogger("main")
from . import reify, run_meta_clingcon, run_meta_clingodl
from .utils.logger import setup_logger


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

    def parse_log_level(self, log):
        """
        Parse log
        """
        if log is not None:
            self._log_level = log
        return True

    def register_options(self, options: ApplicationOptions) -> None:
        """
        Add custom options
        """
        group = "Clingo.Memelingo"
        # TODO add an option of the system to run
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

    def print_model(self, model: Model, _) -> None:
        """
        Print a model on the console
        """
        s_strings = [str(s) for s in model.symbols(shown=True, theory=True)]
        print(" ".join(s_strings))

    def main(self, ctl, files):
        """
        Main function ran on call
        """
        # pylint: disable=W0201
        log = setup_logger("main", getattr(logging, self._log_level))

        input_lambda = ctl.get_const("lambda")
        if input_lambda is None:
            log.warning(
                textwrap.dedent(
                    """The constant `lambda` is required for the metric meta-encoding.
                Provided with the argument `-c lambda=X` By default is set to 10 (9 steps)."""
                )
            )
        reified_prg = reify(files=files)
        run_meta_clingcon(ctl, reified_prg, on_model=None)
        # run_meta_clingodl(ctl,reified_prg,on_model=None)
