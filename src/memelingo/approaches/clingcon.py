"""
The Approach using clingcon
"""
from typing import Any, Callable

from clingcon import ClingconTheory
from clingo import Control, Function, Model, Number

from . import CApproach


class ClinconApproach(CApproach):
    """
    Clincon approach for metric logic
    """

    def __init__(self, ctl: Control):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(ctl, ClingconTheory, ["meta-clingcon-interval.lp"])

    def custom_on_model(self, on_model: Callable[..., Any] | None = None) -> Callable:
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
