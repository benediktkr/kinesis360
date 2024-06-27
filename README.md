# ADV360-PRO-ZMK

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Fkinesis360%2Fmain&style=flat-square)](https://jenkins.sudo.is/job/ben/job/kinesis360/job/main/)
[![version](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Fkinesis360%2Fmain&style=flat-square&status=%24%7Bdescription%7D&subject=version&build=lastStable&color=blue)](https://git.sudo.is/ben/kinesis360/packages)
[![codeberg](https://www.sudo.is/readmes/codeberg.svg)](https://codeberg.org/ben/kinesis360)
[![git](https://www.sudo.is/readmes/git.sudo.is-ben.svg)](https://git.sudo.is/ben/kinesis360)
[![github](https://www.sudo.is/readmes/github-benediktkr.svg)](https://github.com/benediktkr/kinesis360)
[![matrix](https://www.sudo.is/readmes/matrix-ben-sudo.is.svg)](https://matrix.to/#/@ben:sudo.is)

## Overview

The repo forked [`KinesisCorporation/Adv360-Pro-ZMK`](https://github.com/KinesisCorporation/Adv360-Pro-ZMK)
at 45fca6f6010b50cec3e7f8df4fe4af4bad1e470e.

See [`UPSTREAM.md`](UPSTREAM.md) for original `README.md` file.

## Git

|               | Repository
|:--------------|:---------------
| `git.sudo.is` | [`ben/kinesis360`](https://git.sudo.is/ben/kinesis360)
| Codeberg      | [`benk/kinesis360`](https://codeberg.org/benk/kinesis360)
| GitHub        | [`benediktkr/kinesis360`](https://github.com/benediktkr/kinesis360)


The `V3.0` branch of this repo tracks the main branch on of the `KinesisCorporation/Adv360-Pro-ZMK` repo.

```console
$ git remote add upstream https://github.com/KinesisCorporation/Adv360-Pro-ZMK
$ git fetch
$ git checkout --track upstream/V3.0
$ git branch --set-upstream-to=upstream/V3.0 V3.0
$ git pull upstream V3.0
```

In `.git/config` it looks like:

```ini
[branch "V3.0"]
        remote = upstream
        merge = refs/heads/V3.0
```

There are a cuple of `.patch` files taken with `git diff`:

- [`since-fork.patch`](since-fork.patch): All changes since the work
- [`config-since-fork.patch`](config-since-fork.patch): Changes in `config` since the fork

Updating the `.patch` files:

```console
$ git checkout V3.0
$ git pull upstream V3.0
$ fork=45fca6f6010b50cec3e7f8df4fe4af4bad1e470e
$ git diff $fork --no-prefix --patch -- config/ > config-since-fork.patch
```

The `config-since-fork.patch` file has the actual config changes, but the
full `since-fork.patch` is kept for completeness.

## Use Tap-Dance

Tap-Dance: https://zmk.dev/docs/behaviors/tap-dance

 * Both: `tap` `C` -> `C`
 * Normal layer: `tap,tap` `C` -> `ctrl C`
 * Mac layer:    `tap,tap` `C` -> `cmd C`

## References

- [ZMK Cheat sheet](https://peccu.github.io/zmk-cheat-sheet/)
- [Advantage 360 Pro User's manual](manuals/manual.pdf)
- [Quick start guide](manuals/quick_start.pdf)

