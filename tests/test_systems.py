"""Test cases for various systems that implement MEL (Metric
Equilibrium Logic)."""
import logging
from typing import List, Union
from unittest import TestCase

from clingo import Control

from memelingo import reify
from memelingo.approaches.asp import ASPApproach
from memelingo.approaches.clingcon import ClingconApproach
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
            lmbd: int,
            enum: str = "auto",
            timepoint_limit: int = 40,
        ) -> _ClingoRes:  # nocoverage
            """Run system on input program with parameters to produce result."""
            # pylint: disable=W0613
            return _ClingoRes()

        def test_lights(self):
            """
            Test number of models of traffic lights encoding.
            """
            input_files = ["examples/traffic-lights.lp"]
            res = self.run_system(input_prog=input_files, n_models=0, lmbd=3)
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
            res = self.run_system(input_prog=prg, n_models=4, lmbd=2)
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
            res = self.run_system(input_prog=prg, n_models=0, lmbd=2)
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
            res = self.run_system(input_prog=prg, n_models=10, lmbd=3, enum="cautious")
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
            res = self.run_system(input_prog=prg, n_models=10, lmbd=2)
            self.assertEqual(res.n_models, 10)
            self.assertTrue(res.atom_all(["(a,0)"]))

        def test_previous(self):
            """
            Test occurrence of always in the head of a rule.
            """

            prg = """
            next((0,w),previous((2,3),a)):-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=10, lmbd=2)
            self.assertEqual(res.n_models, 1)
            self.assertTrue(res.atom_all(["(a,0)"]))
            self.assertTrue(res.atom_all(["t(0,0)"]))
            self.assertTrue(res.atom_all(["t(1,2)"]))

        def test_next_omega(self):
            """
            Test occurrence of always in the head of a rule.
            """

            prg = """
            next((0,w),a):-initially.
            #external initially.
            """
            res = self.run_system(input_prog=prg, n_models=10, lmbd=2)
            self.assertEqual(res.n_models, 10)
            self.assertTrue(res.atom_all(["(a,1)"]))
            for i in range(1, 9):
                self.assertTrue(res.atom_some([f"t(1,{i})"]))

        def test_next_derived(self):
            """
            Test occurrence of always in the head of a rule.
            """

            prg = """
            :- not next((1,2),a), initially.
            {a}.
            #external initially.
            #external next((1,2),a).
            """
            res = self.run_system(input_prog=prg, n_models=10, lmbd=2)
            self.assertEqual(res.n_models, 2)
            self.assertTrue(res.atom_all(["(a,1)"]))


class TestASP(CommonTestCases.TestCommonModels):
    """Test expected models produced by ASP MEL implementation."""

    def run_system(
        self,
        input_prog: Union[str, List[str]],
        n_models: int,
        lmbd: int,
        enum: str = "auto",
        timepoint_limit: int = 40,
    ) -> _ClingoRes:
        """Run clingcon MEL implementation."""
        res = _ClingoRes()
        if enum == "auto":
            ctl = Control(["--warn=none", str(n_models), f"-c lambda={lmbd}"])
        else:
            ctl = Control(["--warn=none", f"-c lambda={lmbd}"])
            ctl.configuration.solve.enum_mode = enum  # type: ignore
        if isinstance(input_prog, str):
            reified = reify(prg=input_prog)
        elif isinstance(input_prog, list):
            reified = reify(files=input_prog)
        else:
            raise RuntimeError("Should not happen")  # nocoverage
        app = ASPApproach(ctl, timepoint_limit)
        setup_logger("main", getattr(logging, "WARNING"))
        app.load(reified)
        app.ground()
        app.solve(on_model=res.on_model)
        return res

    def test_next_omega(self):
        """
        Overwrite!

        Test occurrence of always in the head of a rule.

        In this case the timepoints are not necessarily from 0 to 9 they
        can have any number within the limit
        """

        prg = """
        next((0,w),a):-initially.
        #external initially.
        """
        res = self.run_system(input_prog=prg, n_models=10, lmbd=2)
        self.assertEqual(res.n_models, 10)
        self.assertTrue(res.atom_all(["(a,1)"]))


class TestClingcon(CommonTestCases.TestCommonModels):
    """Test expected models produced by clingcon MEL implementation."""

    def run_system(
        self,
        input_prog: Union[str, List[str]],
        n_models: int,
        lmbd: int,
        enum: str = "auto",
        timepoint_limit: int = 40,
    ) -> _ClingoRes:
        """Run clingcon MEL implementation."""
        res = _ClingoRes()
        if enum == "auto":
            ctl = Control(["--warn=none", str(n_models), f"-c lambda={lmbd}"])
        else:
            ctl = Control(["--warn=none", f"-c lambda={lmbd}"])
            ctl.configuration.solve.enum_mode = enum  # type: ignore
        if isinstance(input_prog, str):
            reified = reify(prg=input_prog)
        elif isinstance(input_prog, list):
            reified = reify(files=input_prog)
        else:
            raise RuntimeError("Should not happen")  # nocoverage
        app = ClingconApproach(ctl, timepoint_limit)
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
        lmbd: int,
        enum: str = "auto",
        timepoint_limit: int = 40,
    ) -> _ClingoRes:
        """Run clingcon MEL implementation."""
        res = _ClingoRes()
        if enum == "auto":
            ctl = Control(["--warn=none", str(n_models), f"-c lambda={lmbd}"])
        else:
            ctl = Control(["--warn=none", f"-c lambda={lmbd}"])
            ctl.configuration.solve.enum_mode = enum  # type: ignore
        if isinstance(input_prog, str):
            reified = reify(prg=input_prog)
        elif isinstance(input_prog, list):
            reified = reify(files=input_prog)
        else:
            raise RuntimeError("Should not happen")  # nocoverage
        app = FclingoApproach(ctl, timepoint_limit)
        setup_logger("main", getattr(logging, "WARNING"))
        app.load(reified)
        app.ground()
        app.solve(on_model=res.on_model)
        return res

    # overwrite
    def test_always(self):
        """
        Test occurrence of always in the head of a rule.

        IMPORTANT!!: This test only works when assignments can be left undefined:
        meaning that the rule

        &fsum{t(T)} = t(T) :- time(T).

        needs to be commented out
        """
        return
        # prg = """
        # always((0,4),a) :- initially.

        # #external initially.
        # #external a.
        # """
        # res = self.run_system(input_prog=prg, n_models=10, lmbd=5)
        # self.assertEqual(res.n_models, 1)
        # self.assertTrue(res.atom_all(["(a,0)"]))
        # self.assertTrue(res.atom_all(["t(0,0)"]))

    # overwrite
    def test_initially(self):
        """
        Test occurrence of initially in the body of a rule.

        IMPORTANT!!: This test only works when assignments can be left undefined:
        meaning that the rule

        &fsum{t(T)} = t(T) :- time(T).

        needs to be commented out
        """
        return
        # prg = """
        # a:-initially.
        # #external initially.
        # """
        # res = self.run_system(input_prog=prg, n_models=4, lmbd=2)
        # self.assertEqual(res.n_models, 1)
        # self.assertTrue(res.atom_all(["(a,0)", "t(0,0)", "(initially,0)"]))
