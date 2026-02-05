import re
from pathlib import Path


def extract_answers(logfile, outdir="instances_out"):
    """
    Reads a clingo/pyclingo output log, extracts all Answer blocks,
    and writes each as a separate .lp file.
    """
    path = Path(logfile)
    outdir = Path(outdir)
    outdir.mkdir(exist_ok=True)

    with open(path, "r") as f:
        text = f.read()

    # Find "Answer: N" blocks
    pattern = re.compile(
        r"Answer:\s*(\d+)\s*\n(.*?)(?=(?:Answer: \d+)|SATISFIABLE|UNSATISFIABLE|$)",
        re.S,
    )
    matches = pattern.findall(text)

    if not matches:
        print("No answers found in the file.")
        return

    for num, content in matches:
        facts = content.strip()
        fname = outdir / f"instance_{int(num):03d}.lp"
        with open(fname, "w") as f:
            # ensure ending period per line
            lines = [ln.strip() for ln in facts.splitlines() if ln.strip()]
            for ln in lines:
                if not ln.endswith("."):
                    ln += "."
                f.write(ln + "\n")
        print(f"✅ wrote {fname.name} with {len(lines)} lines")

    print(f"\nDone. {len(matches)} answer files written to '{outdir}/'.")


if __name__ == "__main__":
    import argparse

    p = argparse.ArgumentParser(description="Extract .lp instances from clingo output")
    p.add_argument("logfile", help="Path to clingo output file")
    p.add_argument(
        "--outdir", default="instances_out", help="Output directory for .lp files"
    )
    args = p.parse_args()
    extract_answers(args.logfile, args.outdir)
