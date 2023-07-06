"""
Test cases for main application functionality.
"""
import logging
from io import StringIO
from unittest import TestCase

from clingo import Control

from memelingo import reify, run_meta_clingcon
from memelingo.utils.logger import setup_logger
from memelingo.utils.parser import get_parser

from . import _ClingoRes


class TestMain(TestCase):
    """
    Test cases for main application functionality.
    """

    def test_logger(self):
        """
        Test the logger.
        """
        log = setup_logger("main", logging.DEBUG)
        sio = StringIO()
        for handler in log.handlers:
            handler.setStream(sio)
        log.info("test123")
        self.assertRegex(sio.getvalue(), "test123")

    def test_parser(self):
        """
        Test the parser.
        """
        parser = get_parser()
        ret = parser.parse_args(["--log", "info"])
        self.assertEqual(ret.log, logging.INFO)

    def test_lights(self):
        """
        Test the parser.
        """
        res = _ClingoRes()
        rprg = reify(files=["examples/traffic-lights.lp"])
        ctl = Control(["--warn=none", "0", "-c lambda=3"])
        run_meta_clingcon(ctl, rprg, on_model=res.on_model)
        self.assertEqual(res.n_models, 14)

    def test_initially(self):
        """
        Test the parser.
        """

        prg = """
        a:-initially.
        #external initially.
        """
        length = 2
        models = 4

        res = _ClingoRes()
        ctl = Control(["--warn=none", str(models), f"-c lambda={length}"])
        run_meta_clingcon(ctl, reify(prg=prg), on_model=res.on_model)
        self.assertTrue(res.atom_all(["(a,0)", "t(0,0)", "(initially,0)"]))
        for i in range(1, 3):
            self.assertTrue(res.atom_some([f"t(1,{i})"]))

    def test_eventually(self):
        """
        Test the parser.
        """

        prg = """
        eventually((1,4),a):-initially.
        #external initially.
        #external a.
        """
        length = 2
        models = 0

        res = _ClingoRes()
        ctl = Control(["--warn=none", str(models), f"-c lambda={length}"])
        run_meta_clingcon(ctl, reify(prg=prg), on_model=res.on_model)
        self.assertEqual(res.n_models, 3)
        self.assertTrue(res.atom_all(["(a,1)"]))
        self.assertTrue(res.atom_some(["t(1,1)"]))
        self.assertTrue(res.atom_some(["t(1,2)"]))
        self.assertTrue(res.atom_some(["t(1,3)"]))
