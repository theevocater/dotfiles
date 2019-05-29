#!/usr/bin/env python3
import argparse
import os
from os import path
from typing import List, Optional


def main(argv: Optional[List[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="symlink n files to a base path")
    parser.add_argument("files", metavar="file", nargs="+", help="file to symlink")
    parser.add_argument("--base_src", required=True, help="base src directory")
    parser.add_argument("--base_dest", required=True, help="base dest directory")
    args = parser.parse_args(argv)

    dotfiles_base = path.abspath(path.dirname(args.base_src))
    # user might pass something like ~/., need to parse that correctly
    home = path.dirname(path.expanduser(args.base_dest))
    pre = path.basename(args.base_dest)
    files = args.files
    for f in files:
        h = path.join(home, f"{pre}{f}")
        # check islink as well in case of broken links
        if path.lexists(h):
            r = input(f"{h} exists, overwrite? y[n] ").lower()
            if "n" == r or "no" == r:
                print(f"Skipping {f}")
                continue
            else:
                os.remove(h)
                print(f"Overwritting {f}")

        os.symlink(path.join(dotfiles_base, f), h)
    return 0


if __name__ == "__main__":
    exit(main())
