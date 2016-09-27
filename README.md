menagerie
=========

[![Gem Version](https://img.shields.io/gem/v/menagerie.svg)](https://rubygems.org/gems/menagerie)
[![Dependency Status](https://img.shields.io/gemnasium/akerl/menagerie.svg)](https://gemnasium.com/akerl/menagerie)
[![Build Status](https://img.shields.io/circleci/project/akerl/menagerie/master.svg)](https://circleci.com/gh/akerl/menagerie)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/menagerie.svg)](https://codecov.io/github/akerl/menagerie)
[![Code Quality](https://img.shields.io/codacy/5e3980050b4b4d55bbb6443027d4f517.svg)](https://www.codacy.com/app/akerl/menagerie)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Simple release management tool for controlling versioned artifacts

## Usage

Menagerie manages Collections of Releases, as well as the Artifacts that are used in those Releases. A quick tl;dr:

* Artifact -- a downloaded asset: a compiled Linux kernel, the python package, a picture of your cat, etc
* Release -- a set of Artifacts at specific versions: "Python 2.7, Linux kernel 3.18.1, and the 3rd revision of your cat's picture"
* Collection - all the Releases currently downloaded, including the "latest" release as well any previous releases

Also relevant are "Orphans"; these are artifacts that are not needed by any currently tracked releases.

The gem provides a simple script that will print out the contents of an existing collection:

```
Release: 0
  initrd: 0.0.36
  kernel: 3.19-rc7_1
  rootfs: 0.0.73
Release: 1
  initrd: 0.0.36
  kernel: 3.19-rc7_1
  rootfs: 0.0.71
Release: 2
  initrd: 0.0.36
  kernel: 3.19-rc6_1
  rootfs: 0.0.69

Orphans:
  kernel
    3.19-rc5_1
```

To start using Menagerie, create a collection:

```
require 'menagerie'
my_collection = Menagerie.new
```

Initially, your collection has no releases. To add a release, call `.add_release` with the details for the artifacts you want to install:

```
new_artifacts = [
    {
        name: 'kernel',
        version: '3.19-rc7_1',
        url: 'https://github.com/dock0/kernel/releases/download/3.19-rc7_1/vmlinuz'
    },
    {
        name: 'initrd',
        version: '0.0.36',
        url: 'https://github.com/dock0/initrd/releases/download/0.0.36/initrd.img'
    }
]
my_collection.add_release(new_artifacts)
```

This will download the new artifacts into `./artifacts` and symlink them into `./releases/0`, with `./latest` linked to `./releases/0`:

```
# tree
.
├── artifacts
│   ├── initrd
│   │   └── 0.0.36
│   └── kernel
│       └── 3.19-rc7_1
├── latest -> releases/0
└── releases
    └── 0
        ├── initrd -> ../../artifacts/initrd/0.0.36
        └── kernel -> ../../artifacts/kernel/3.19-rc7_1
```

Now lets say you update your kernel package, so you want to make a new releaes with your updated 3.19_1 kernel:

```
new_artifacts = [
    {
        name: 'kernel',
        version: '3.19_1',
        url: 'https://github.com/dock0/kernel/releases/download/3.19-rc7_1/vmlinuz'
    },
    {
        name: 'initrd',
        version: '0.0.36',
        url: 'https://github.com/dock0/initrd/releases/download/0.0.36/initrd.img'
    }
]
my_collection.add_release(new_artifacts)
```

Menagerie will rotate the '0' release to '1', download the new kernel, and link the correct assets into '0'. Note that it doesn't download a new copy of the initrd asset, as the version didn't change:

```
# tree
.
├── artifacts
│   ├── initrd
│   │   └── 0.0.36
│   └── kernel
│       ├── 3.19_1
│       └── 3.19-rc7_1
├── latest -> releases/0
└── releases
    ├── 0
    │   ├── initrd -> ../../artifacts/initrd/0.0.36
    │   └── kernel -> ../../artifacts/kernel/3.19_1
    └── 1
        ├── initrd -> ../../artifacts/initrd/0.0.36
        └── kernel -> ../../artifacts/kernel/3.19-rc7_1
```

Menagerie will retain 5 old releases by default (for a total of 6, including the current version). Older releases will be removed, and orphaned artifacts (those no longer used in any releases) will be deleted. To change the retention or disable reaping of orphans, pass the desired options to Menagerie when you create your collection:

```
larger_collection = Menagerie.new(options: { retention: 20 }) # this will retain 20 old releases

permanent_collection = Menagerie.new(options: { reap: false }) # this will not reap orphaned artifacts
```

By default, Menagerie will log to STDOUT when it manipulates releases and artifacts. You can disable this via the `verbose` option:

```
quiet_collection = Menagerie.new(options: { verbose: false })
```

You can also override the paths used for artifacts/releases and the "latest" symlink, via the `paths` parameter:

```
custom_paths = {
    artifacts: '/srv/artifacts',
    releases: '/opt/releases',
    latest: '/var/latest_release'
}

my_collection = Menagerie.new(paths: custom_paths)
```

## Installation

    gem install menagerie

## License

menagerie is released under the MIT License. See the bundled LICENSE file for details.

