from collections import namedtuple
from os import path
from unittest import mock

import pytest

from scripts.symlink_home import main


@pytest.fixture
def base_dirs(tmp_path):
    bd = namedtuple('Basedir', ['src', 'dest'])
    bd.src = tmp_path / 'src'
    bd.src.mkdir()
    foo = bd.src / 'foo'
    foo.write_text('foo')
    bd.dest = tmp_path / 'dest'
    bd.dest.mkdir()
    return bd


def test_link_one(base_dirs):
    argv = [f'{str(base_dirs.src)}/', f'{str(base_dirs.dest)}/', 'foo']
    assert main(argv) == 0
    assert path.lexists(str(base_dirs.dest / 'foo'))


def test_link_not_exist(base_dirs, capsys):
    argv = [f'{str(base_dirs.src)}/', f'{str(base_dirs.dest)}/', 'bar']
    assert main(argv) == 1
    assert not path.lexists(str(base_dirs.dest / 'bar'))
    _, err = capsys.readouterr()
    src_bar = str(base_dirs.src / 'bar')
    assert err == ('=== Warning !! ===\n' f'=== {src_bar} does not exist ===\n')


def test_link_prefix(base_dirs):
    argv = [f'{str(base_dirs.src)}/', f'{str(base_dirs.dest)}/', '--prefix', '.', 'foo']
    assert main(argv) == 0
    assert path.lexists(str(base_dirs.dest / '.foo'))


def test_link_exists_skip(base_dirs, capsys):
    dest_foo = base_dirs.dest / '.foo'
    dest_foo.write_text('foo')
    argv = [f'{str(base_dirs.src)}/', f'{str(base_dirs.dest)}/', '--prefix', '.', 'foo']
    with mock.patch('builtins.input') as inp:
        inp.return_value = 'n'
        assert main(argv) == 1
    assert not path.islink(str(base_dirs.dest / '.foo'))
    out, _ = capsys.readouterr()
    assert out == f'Skipping foo\n'


def test_link_exists_overwrite(base_dirs, capsys):
    dest_foo = base_dirs.dest / '.foo'
    dest_foo.write_text('foo')
    argv = [f'{str(base_dirs.src)}/', f'{str(base_dirs.dest)}/', '--prefix', '.', 'foo']
    with mock.patch('builtins.input') as inp:
        inp.return_value = 'y'
        assert main(argv) == 0
    assert path.islink(str(base_dirs.dest / '.foo'))
    out, _ = capsys.readouterr()
    assert out == f'Overwritting foo\n'
