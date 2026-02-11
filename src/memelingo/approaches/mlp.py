"""
The Approach using plain ASP
"""

from clingo import Control
import os

from . import MyApproach, ENCODINGS_PATH


class MLPhtExtended(MyApproach):
    """
    ASP approach for metric logic TPLP version
    """

    def __init__(self, ctl: Control, timepoint_limit):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["mlp-tplp-ht.lp"])

    def load(self, reified_prg: str):
        """
        Loads and adds needed info.
        Args:
            reified_prg (str): The reified program as a string
        """
        super().load(reified_prg)
