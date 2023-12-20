"""
The Approach using plain ASP
"""

from clingo import Control

from . import MyApproach

from . import CApproach

class ASPApproach(MyApproach):
    """
    ASP approach for metric logic
    """

    def __init__(self, ctl: Control, timepoint_limit):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, timepoint_limit, ["meta-asp-interval.lp"])

    def load(self, reified_prg: str):
        """
        Loads and adds needed info.
        Args:
            reified_prg (str): The reified program as a string
        """
        super().load(reified_prg)
        self.ctl.add("base", [], f"#const tplimit={self.timepoint_limit}.")