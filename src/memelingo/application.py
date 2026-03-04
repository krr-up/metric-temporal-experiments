"""
Clingo application extended to include automata
"""

import logging
import textwrap
from tkinter import constants
from typing import Optional, Sequence
import sys
from clingo import Model, Symbol, SymbolType
from clingo.application import Application, ApplicationOptions, Flag

from clingcon.__main__ import ClingconApp
from clingodl.__main__ import ClingoDLApp
from clingo.script import enable_python
from . import reify

from .approaches.mlp import MLPhtExtended, MLPhtPlain
from .approaches.mlp_htc import (
    MLPhtcExtended,
    MLPhtcExtendedDL,
    MLPhtcPlain,
    MLPhtcPlainDL,
)
from .utils.logger import setup_logger
from .utils.visualizer import visualize
import meta_tools
import tempfile

log = logging.getLogger("main")


class ClingoApp(Application):
    def __init__(self, name):
        self.program_name = name

    def print_model(self, model: Model, printer) -> None:
        model_symbols = " ".join(
            [str(s).replace("__", "&") for s in model.symbols(shown=True)]
        )
        sys.stdout.write(model_symbols + "\n")

    def main(self, ctl, files):
        for f in files:
            ctl.load(f)
        if not files:
            ctl.load("-")
        ctl.ground([("base", [])])
        ctl.solve()


APP_INFO = {
    "mlp-lpnmr-ht": {
        "application": ClingoApp,
        "files": ["src/memelingo/encodings/mlp-lpnmr-ht.lp"],
    },
    "mlp-lpnmr-htc": {
        "application": ClingconApp,
        "files": ["src/memelingo/encodings/mlp-lpnmr-htc.lp"],
    },
    "mlp-lpnmr-htcdl": {
        "application": ClingoDLApp,
        "files": ["src/memelingo/encodings/mlp-lpnmr-htcdl.lp"],
    },
    "mlp-tplp-htc": {
        "application": ClingconApp,
        "files": ["src/memelingo/encodings/mlp-tplp-htc.lp"],
    },
    "mlp-tplp-htcdl": {
        "application": ClingoDLApp,
        "files": ["src/memelingo/encodings/mlp-tplp-htcdl.lp"],
    },
    "mlp-tplp-ht": {
        "application": ClingoApp,
        "files": ["src/memelingo/encodings/mlp-tplp-ht.lp"],
    },
}


def get_app_by_name(app_name: str) -> Optional[Application]:
    """
    Get the application wrapper for the given name.

    Args:
        app_name (str): The name of the application.
    Returns:
        Optional[ClingoControl]: The application wrapper or None if not found.
    """
    if app_name not in APP_INFO:
        msg = f"Control name '{app_name}' not found. Available options: {list(APP_INFO.keys())}"
        log.error(msg)
        raise ValueError(msg)
    return APP_INFO[app_name]["application"]


def make_app(app_name: str) -> Application:

    base_class = get_app_by_name(app_name)

    class MemelingoApp(base_class):
        def __init__(self, constants=None):
            """
            Create application

            Args:
                config (dict): The configuration dictionary.
                constants (Optional[dict], optional): The constants required by the system that will become attributes. Defaults to None.
            """
            super().__init__(f"Memelingo ({base_class}) {app_name}")
            self.constants = constants or {}
            self._log_level = "warning"
            enable_python()

        @property
        def name(self):
            return f"{app_name}"

        def parse_log_level(self, log_level):
            """
            Parse log

            Args:
                log_level (str): The log level to set.
            Returns:
                bool: True if the log level is valid, False otherwise.
            """
            if log_level is not None:
                self._log_level = log_level.upper()
                return self._log_level in ["INFO", "WARNING", "DEBUG", "ERROR"]

            return True

        def parse_system_config(self, name, type="str") -> callable:
            def parse_option(value):
                if type == "list":
                    if name not in self.metasp_config:
                        self.metasp_config[name] = []
                    self.metasp_config[name].append(value)
                else:
                    self.metasp_config[name] = value
                return True

            return parse_option

        def parse_config(self, config_file):
            """
            Parse configuration file

            Args:
                config_file (str): The path to the configuration file.
            Returns:
                bool: True if the configuration file is valid, False otherwise.
            """
            if config_file is not None:
                self.metasp_config_file = config_file
                return True
            return False

        def register_options(self, options: ApplicationOptions) -> None:
            """
            Add custom options

            Args:
                options (ApplicationOptions): The application options to register.
            """
            group = "Memelingo - " + self.name
            options.add(
                group,
                "log",
                textwrap.dedent(
                    """\
                    Logging level.
                                                <level> ={debug|info|error|warning}
                                                (default: warning)"""
                ),
                self.parse_log_level,
                argument="<level>",
            )
            super().register_options(options)

        def main(self, control, files):
            """
            Main entry point for the application.
            """
            rsymbols = meta_tools.classic_reify(
                ["--preserve-facts=symtab"]
                + [f"-c {k}={v}" for k, v in self.constants.items()],
                "",
                programs=[("base", [])],
                files=files,
            )
            simple_reified_prg = "\n".join([f"{str(s)}." for s in rsymbols])
            with tempfile.NamedTemporaryFile(
                "w", delete=False, suffix=".lp"
            ) as tmp_file:
                tmp_file.write(simple_reified_prg)
                reified_path = tmp_file.name
            files = APP_INFO[app_name]["files"] + [reified_path]
            print(files)
            super().main(control, files)

    return MemelingoApp
