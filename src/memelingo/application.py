"""
Clingo application extended to include automata
"""
import logging
import textwrap

from clingo import Model, Symbol
from clingo.application import Application, ApplicationOptions, Flag
from typing import List

from . import reify, run_meta_clingcon
from .utils.logger import setup_logger
from .utils.visualizer import visualize

def _sym_to_prg(symbols:List[Symbol]):
    '''
    Turns symbols into a program
    '''
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


    def parse_log_level(self, log_level):
        """
        Parse log
        """
        if log_level is not None:
            self._log_level = log_level
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
        options.add_flag(group, 'view', 'Visualize the timed trace using clingraph', self._view)



    def print_model(self, model: Model, _) -> None:
        """
        Print a model on the console
        """
        s_strings = [str(s) for s in model.symbols(shown=True, theory=True)]
        print(" ".join(s_strings))
        if self._view:
            visualize(_sym_to_prg(model.symbols(atoms=True, theory=True)),name_format=f"timed_trace_{model.number}")

    def main(self, control, files):
        """
        Main function ran on call
        """
        # pylint: disable=W0201
        log = setup_logger("main", getattr(logging, self._log_level))

        input_lambda = control.get_const("lambda")
        if input_lambda is None:
            log.warning(
                textwrap.dedent(
                    """The constant `lambda` is required for the metric meta-encoding.
                Provided with the argument `-c lambda=X` By default is set to 10 (9 steps)."""
                )
            )
        reified_prg = reify(files=files)
        run_meta_clingcon(control, reified_prg, on_model=None)
