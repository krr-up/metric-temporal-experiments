"""
The Approach using clingcon
"""
from typing import Any, Callable, Optional

from clingcon import ClingconTheory
from clingo import Control, Function, Model, Number

from . import CApproach


class ClingconApproach(CApproach):
    """
    Clingcon approach for metric logic
    """

    def __init__(self, ctl: Control, timepoint_limit: int):
        """
        Creates the approach
        Args:
            ctl (Control): clingo COntrol
        """
        super().__init__(
            ctl, timepoint_limit, ["meta-clingcon-interval.lp"], ClingconTheory
        )

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
