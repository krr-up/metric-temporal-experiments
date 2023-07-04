"""
Test cases for main application functionality.
"""
import logging
from io import StringIO
from unittest import TestCase

from memelingo.utils.logger import setup_logger
from memelingo.utils.parser import get_parser
from memelingo import run_meta_clingcon, reify

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

    def test_meta(self):
        """
        Test the parser.
        """
        log = setup_logger("main", logging.DEBUG)
        prg = reify(prg= "a:-initially. #external initially.")
        run_meta_clingcon(prg,clambda=2)
        # run_meta([])
