"""
The main entry point for the application.
"""
import sys

from clingo.application import clingo_main

from .application import MemelingoApp


def main():
    """
    Main function calling the application class
    """
    clingo_main(MemelingoApp(sys.argv[0]), sys.argv[1:])
    sys.exit()


if __name__ == "__main__":
    main()
