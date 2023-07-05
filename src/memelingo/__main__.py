"""
The main entry point for the application.
"""
import sys
from .utils.logger import setup_logger
from .utils.parser import get_parser
from .application import MemelingoApp
from clingo.application import clingo_main

def main():
    clingo_main(MemelingoApp(sys.argv[0]), sys.argv[1:])
    sys.exit()

if __name__ == "__main__":
    main()
