"""
The Approach using plain ASP
"""

from clingo import Control
import os
from typing import Any, Callable, Optional

from . import MyApproach, ENCODINGS_PATH

from clingodl import ClingoDLTheory
from clingcon import ClingconTheory
from clingo import Control, Function, Model, Number

from . import CApproach


class MLPhtcPlain(CApproach):
    """
    Clingcon approach for metric logic plain with eventually and always
    """

    system_name = "clingcon"
    theory = ClingconTheory()

    def __init__(self, ctl: Control, timepoint_limit: int):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["mlp-lpnmr-htc.lp"])


class MLPhtcPlainDL(CApproach):
    """
    Clingcon approach for metric logic plain with eventually and always
    """

    system_name = "clingodl"
    theory = ClingoDLTheory()

    def __init__(self, ctl: Control, timepoint_limit: int):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["mlp-lpnmr-htcdl.lp"])


class MLPhtcExtended(CApproach):
    """
    Clingcon approach for metric logic extended with eventually and always
    """

    system_name = "clingcon"
    theory = ClingconTheory()

    def __init__(self, ctl: Control, timepoint_limit: int):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["mlp-tplp-htc.lp"])


class MLPhtcExtendedDL(CApproach):
    """
    Clingcon approach for metric logic extended with eventually and always
    """

    system_name = "clingodl"
    theory = ClingoDLTheory()

    def __init__(self, ctl: Control, timepoint_limit: int):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["mlp-tplp-htcdl.lp"])
