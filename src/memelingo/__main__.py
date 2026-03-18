"""
The main entry point for the application.
"""

import sys
from typing import Optional
import os
import argparse
from clingo.application import clingo_main
from memelingo.utils.parser import get_parser
from memelingo.application import make_app
from pprint import pprint

import logging

log = logging.getLogger(__name__)


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


def main() -> None:
    """
    Run the main function.
    """
    constants_dict = parse_constants(sys.argv[2:])
    if len(sys.argv) < 2:
        parser = get_parser()
        parser.print_help()
        # print("Usage: metasp <solve | reify | transform> [options] <files>")
        exit(1)

    system_name = sys.argv[1]
    App_class = make_app(system_name)
    if system_name[-2:] == "dl":
        sys.argv.append("--propagate=full")
    exit_status = clingo_main(App_class(constants=constants_dict), sys.argv[2:])
    sys.exit(exit_status)


if __name__ == "__main__":
    main()
