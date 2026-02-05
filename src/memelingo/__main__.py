"""
The main entry point for the application.
"""

import argparse
import sys

from clingo.application import clingo_main

from .application import MemelingoApp


def parse_constants(arguments: list[str]) -> dict[str, str]:
    """
    Parse constants from the command line arguments.
    We need these constrants in both steps and since we can't fork the control object,
    we parse them here.

    Args:
        arguments (list): The command line arguments.
    Returns:
        list: A list of constants in the form <id>=<term>.
    """
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument(
        "-c",
        "--const",
        action="append",
        help="Replace term occurrences of <id> with <term> (must have form <id>=<term>)",
        type=lambda s: (
            s if "=" in s else parser.error("Constants must have form <id>=<term>")
        ),
    )
    args, _ = parser.parse_known_args(arguments)
    input_consts = (
        {c.split("=")[0]: c.split("=")[1] for c in args.const} if args.const else {}
    )
    return input_consts


def main():
    """
    Main function calling the application class
    """
    constants_dict = parse_constants(sys.argv[2:])
    clingo_main(MemelingoApp(sys.argv[0], constants=constants_dict), sys.argv[1:])
    sys.exit()


if __name__ == "__main__":
    main()
