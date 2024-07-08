#!/usr/bin/env python3

from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from datetime import date
import os


def get_version():
    # The VERSION var always exists when running in docker, because it is declared as a build arg
    if len(os.environ.get("VERSION", "")) > 0:
        return os.environ["VERSION"]
    else:
        # The git module is not available in the docker image, but it gets passed VERSION
        # as a build arg via the Makefile, so it does not need to run this.
        import git
        calver_today = date.today().isoformat().replace("-", ".")
        calver_append = git.Repo().head.object.hexsha[:7]
        return f"{calver_today}_{calver_append}"


def make_parser():
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument("--version", default=get_version(), help="Version number")
    parser.add_argument("--version-macro", action="store_true", help="Print version.dtsi")
    return parser


def get_args():
    parser = make_parser()
    return parser.parse_args()


def zmk_kp_char(char):
    kp_vals = {
        ":": "COLON",
        "-": "MINUS",
        "_": "UNDERSCORE",
        ".": "DOT",
        " ": "SPACE",
    }
    if char in kp_vals:
        val = kp_vals[char]
        return f"<&kp {val}>"
    elif char.isdigit():
        return f"<&kp N{char}>"
    elif char.isalpha():
        char_upper = char.upper()
        return f"<&kp {char_upper}>"
    else:
        raise SystemExit(f"No mapping for character: '{char}'")


def zmk_kp(text):
    kp = [zmk_kp_char(a) for a in text]
    # Always end with RETURN
    kp.append("<&kp RET>")
    return ", ".join(kp)


def make_version_macro_bindings(version, git_commit, git_branch):
    kp_version = zmk_kp(f"Version: {version}")
    kp_bindings = [kp_version]
    if git_commit:
        kp_git_commit = zmk_kp(f"Git commit: {git_commit[:7]}")
        kp_bindings.append(kp_git_commit)
    if git_branch:
        kp_git_branch = zmk_kp(f"Git branch: {git_branch}")
        kp_bindings.append(kp_git_branch)
    return ", ".join(kp_bindings)


def make_version_macro(version):
    git_commit = os.environ.get("GIT_COMMIT", "")[:7]
    git_branch = os.environ.get("GIT_BRANCH", "")
    bindings = make_version_macro_bindings(version, git_commit, git_branch)
    return "\n".join([
        '#define VERSION_MACRO',
        'macro_ver: macro_ver {',
        '  compatible = "zmk,behavior-macro";',
        '  label = "macro_ver";',
        '  #binding-cells = <0>;',
        f'  bindings = {bindings};',
        '};'
    ])


def main():
    args = get_args()
    if args.version_macro:
        version_macro = make_version_macro(args.version)
        print(version_macro)
    else:
        print(args.version)


if __name__ == "__main__":
    main()
