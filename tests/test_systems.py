"""Test cases for various systems that implement MEL (Metric
Equilibrium Logic)."""
import logging
from typing import List, Union
from unittest import TestCase

from clingo import Control

from memelingo import reify
from memelingo.approaches.clingcon import ClinconApproach
from memelingo.approaches.fclingo import FclingoApproach
from memelingo.utils.logger import setup_logger

from . import _ClingoRes


class CommonTestCases:
    """Wrapper class to prevent running of base test cases by test
    runner."""

    # pylint: disable=R0903

    class TestCommonModels(TestCase):
        """Common test cases which test expected models produced by an
        implementation. Will be run for multiple system implementations."""

        def run_system(
            self,
            input_prog: Union[str, List[str]],
            n_models: int,
            horizon: int,
            enum: str = "auto",
        ) -> _ClingoRes:  # nocoverage
            """Run system on input program with parameters to produce result."""
            # pylint: disable=W0613
            return _ClingoRes()

        def test_lights(self):
            """
            Test number of models of traffic lights encoding.
            """
            input_files = ["examples/traffic-lights.lp"]
            res = self.run_system(input_prog=input_files, n_models=0, horizon=3)
            self.assertEqual(res.n_models, 14)
            self.assertTrue(res.atom_all(["(green,2)"]))
            self.assertTrue(res.atom_all(["(red,1)"]))
            self.assertTrue(res.atom_all(["(red,0)"]))
            self.assertTrue(res.atom_all(["(push,1)"]))
            self.assertTrue(res.atom_all(["t(1,5)"]))
            self.assertTrue(res.atom_all(["t(0,0)"]))
            for i in range(6, 19):
                self.assertTrue(res.atom_some([f"t(2,{i})"]))

        def test_initially(self):
            """
            Test occurrence of initially in the body of a rule.
            """

            prg = """
            a:-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=4, horizon=2)
            self.assertTrue(res.atom_all(["(a,0)", "t(0,0)", "(initially,0)"]))
            for i in range(1, 3):
                self.assertTrue(res.atom_some([f"t(1,{i})"]))

        def test_eventually_head(self):
            """
            Test occurrence of eventually in the head of a rule.
            """

            prg = """
            eventually((1,4),a):-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=0, horizon=2)
            self.assertEqual(res.n_models, 3)
            self.assertTrue(res.atom_all(["(a,1)"]))
            self.assertTrue(res.atom_some(["t(1,1)"]))
            self.assertTrue(res.atom_some(["t(1,2)"]))
            self.assertTrue(res.atom_some(["t(1,3)"]))

        def test_eventually_body(self):
            """
            Test occurrence of eventually in the body of a rule.
            """

            prg = """
            next((2,3),a):-initially.
            b:-eventually((1,4),a).
            #external initially.
            #external eventually((1,4),a).
            """
            res = self.run_system(
                input_prog=prg, n_models=10, horizon=3, enum="cautious"
            )
            self.assertTrue(res.atom_last(["(a,1)"]))
            self.assertTrue(res.atom_last(["(b,0)"]))

        def test_always(self):
            """
            Test occurrence of always in the head of a rule.
            """

            prg = """
            always((0,4),a):-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=10, horizon=2)
            self.assertEqual(res.n_models, 10)
            self.assertTrue(res.atom_all(["(a,0)"]))

        def test_next_omega(self):
            """
            Test occurrence of always in the head of a rule.
            """

            prg = """
            next((0,w),a):-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=10, horizon=2)
            self.assertEqual(res.n_models, 10)
            self.assertTrue(res.atom_all(["(a,1)"]))
            for i in range(1, 9):
                self.assertTrue(res.atom_some([f"t(1,{i})"]))


class TestClingcon(CommonTestCases.TestCommonModels):
    """Test expected models produced by clingcon MEL implementation."""

    def run_system(
        self,
        input_prog: Union[str, List[str]],
        n_models: int,
        horizon: int,
        enum: str = "auto",
    ) -> _ClingoRes:
        """Run clingcon MEL implementation."""
        res = _ClingoRes()
        if enum == "auto":
            ctl = Control(["--warn=none", str(n_models), f"-c lambda={horizon}"])
        else:
            ctl = Control(["--warn=none", f"-c lambda={horizon}"])
            ctl.configuration.solve.enum_mode = enum  # type: ignore
        if isinstance(input_prog, str):
            reified = reify(prg=input_prog)
        elif isinstance(input_prog, list):
            reified = reify(files=input_prog)
        else:
            raise RuntimeError("Should not happen")  # nocoverage
        app = ClinconApproach(ctl)
        setup_logger("main", getattr(logging, "WARNING"))
        app.load(reified)
        app.ground()
        app.solve(on_model=res.on_model)
        return res


class TestFclingo(CommonTestCases.TestCommonModels):
    """Test expected models produced by fclingo MEL implementation."""

    def run_system(
        self,
        input_prog: Union[str, List[str]],
        n_models: int,
        horizon: int,
        enum: str = "auto",
    ) -> _ClingoRes:
        """Run clingcon MEL implementation."""
        res = _ClingoRes()
        if enum == "auto":
            ctl = Control(["--warn=none", str(n_models), f"-c lambda={horizon}"])
        else:
            ctl = Control(["--warn=none", f"-c lambda={horizon}"])
            ctl.configuration.solve.enum_mode = enum  # type: ignore
        if isinstance(input_prog, str):
            reified = reify(prg=input_prog)
        elif isinstance(input_prog, list):
            reified = reify(files=input_prog)
        else:
            raise RuntimeError("Should not happen")  # nocoverage
        app = FclingoApproach(ctl)
        setup_logger("main", getattr(logging, "WARNING"))
        app.load(reified)
        app.ground()
        app.solve(on_model=res.on_model)
        return res

    # overwrite
    def test_always(self):
        """
        Test occurrence of always in the head of a rule.
        """

        prg = """
        always((0,4),a) :- initially.

        #external initially.
        #external a.
        """
        res = self.run_system(input_prog=prg, n_models=10, horizon=5)
        self.assertEqual(res.n_models, 1)
        self.assertTrue(res.atom_all(["(a,0)"]))
        self.assertTrue(res.atom_all(["t(0,0)"]))

    # overwrite
    def test_initially(self):
        """
        Test occurrence of initially in the body of a rule.
        """

        prg = """
        a:-initially.
        #external initially.
        """
        res = self.run_system(input_prog=prg, n_models=4, horizon=2)
        self.assertEqual(res.n_models, 1)
        self.assertTrue(res.atom_all(["(a,0)", "t(0,0)", "(initially,0)"]))
