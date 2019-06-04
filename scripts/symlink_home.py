#!/usr/bin/env python3
import argparse
import os
import sys
from os import path
from typing import List, Optional


def main(argv: Optional[List[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="symlink n files to a base path")
    parser.add_argument("src", help="src directory")
    parser.add_argument("dest", help="dest directory")
    parser.add_argument("files", metavar="file", nargs="+", help="file to symlink")
    parser.add_argument("-p", "--prefix", help="prefix of the dest filename")
    args = parser.parse_args(argv)

    src = path.abspath(path.expanduser(args.src))
    dest = path.dirname(path.expanduser(args.dest))
    prefix = ""
    if args.prefix:
        prefix = args.prefix
    files = args.files
    retv = 1
    for f in files:
        s = path.join(src, f)
        if not path.exists(s):
            print('=== Warning !! ===', file=sys.stderr)
            print(f'=== {str(s)} does not exist ===', file=sys.stderr)
            continue

        d = path.join(dest, f"{prefix}{f}")
        if path.lexists(d):
            r = input(f"{d} exists, overwrite? y[n] ").lower()
            if "n" == r or "no" == r:
                print(f'Skipping {f}')
                continue
            else:
                os.remove(d)
                print(f"Overwritting {f}")

        os.symlink(s, d)
        retv = 0
    return retv


if __name__ == "__main__":
    exit(main())
