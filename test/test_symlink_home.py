from collections import namedtuple
from os import path

import pytest

from scripts.symlink_home import main


@pytest.fixture
def base_dirs(tmp_path):
    bd = namedtuple("Basedir", ["src", "dest"])
    bd.src = tmp_path / "src"
    bd.src.mkdir()
    foo = bd.src / "foo"
    foo.write_text("foo")
    bd.dest = tmp_path / "dest"
    bd.dest.mkdir()
    return bd


def test_link_one(base_dirs):
    argv = [
        "--base_src",
        f"{str(base_dirs.src)}/",
        "--base_dest",
        f"{str(base_dirs.dest)}/",
        "foo",
    ]
    assert main(argv) == 0
    assert path.lexists(str(base_dirs.dest / "foo"))


def test_link_prefix(base_dirs):
    argv = [
        "--base_src",
        f"{str(base_dirs.src)}/",
        "--base_dest",
        f"{str(base_dirs.dest)}/.",
        "foo",
    ]
    assert main(argv) == 0
    assert path.lexists(str(base_dirs.dest / ".foo"))
