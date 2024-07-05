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

Manuals for Kinesis Advantage 360 Pro:

- [User's manual](manuals/manual.pdf)
- [Quick start guide](manuals/quick_starrt.pdf)

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

There are a couple of `.patch` files taken with `git diff`:

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

## Builds

The default GitHub actions have been disabled and replaced with a [`Jenkinsfile`](Jenkinsfile)
and the [`Dockerfile`](Dockerfile) has been rewritten and improved.

To build the firmware:

```console
$ make
```

The `left.uf2` and `right.uf2` files are in a tarball `firmware/Adv360-firmware_${env.VERSION}.tar.gz`.

## ZMK

The Advantage 360 Pro uses [ZMK](https://www.zmk.dev). According to [the Kinesis repo](UPSTREAM.md) it
uses [a customized version of ZMK](https://github.com/ReFil/zmk/tree/adv360-z3.5), but support for the
Kinesis Advantage 360 has been merged in [`zmkfirmware/zmk#1454`](https://github.com/zmkfirmware/zmk/pull/1454).

- [Supported Hardware](https://zmk.dev/docs/hardware#onboard): Advantage 360 Pro

### Use Tap-Dance

Tap-Dance: https://zmk.dev/docs/behaviors/tap-dance

 * Both: `tap` `C` -> `C`
 * Normal layer: `tap,tap` `C` -> `ctrl C`
 * Mac layer:    `tap,tap` `C` -> `cmd C`

## References

- [ZMK Cheat sheet](https://peccu.github.io/zmk-cheat-sheet/)
- [ZMK Docs](https://www.zmk.dev/docs/)

