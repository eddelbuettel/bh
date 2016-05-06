## bh [![Build Status](https://travis-ci.org/eddelbuettel/bh.svg)](https://travis-ci.org/eddelbuettel/bh) [![License](https://img.shields.io/badge/license-BSL--1.0-brightgreen.svg?style=flat)](http://www.boost.org/users/license.html) [![CRAN](http://www.r-pkg.org/badges/version/BH)](http://cran.r-project.org/package=BH) [![Downloads](http://cranlogs.r-pkg.org/badges/BH?color=brightgreen)](http://www.r-pkg.org/pkg/BH)

Boost Headers for R

### About

This package provides [R](http://www.r-project.org) with access to
[Boost](http://www.boost.org/) header files.  [Boost](http://www.boost.org/)
provides free peer-reviewed portable C++ source libraries.  A large part of
[Boost](http://www.boost.org/) is provided as C++ template code which is
resolved entirely at compile-time without linking.  

This package aims to provide the most useful subset of
[Boost](http://www.boost.org/) libraries for template use among CRAN
packages. By placing these libraries in this package, we offer a more
efficient distribution system for CRAN as replication of this code in the
sources of other packages is avoided.

It can be used via the `LinkingTo:` field in the `DESCRIPTION` field of an R
package --- and the R package infrastructure tools will then know how to set
include flags correctly on all architectures supported by R.

Not that this can be used solely by headers-only Boost libraries. This
covers most of Boost, but excludes some libraries which require linking for
parts or all of their functionality. 

### Coverage

As of release 1.60.0-2, the following Boost libraries are included:

> algorithm any bimap bind circular_buffer concept config container date_time
> detail dynamic_bitset exception filesystem flyweight foreach functional
> fusion geometry graph heap icl integer interprocess intrusive io iostreams
> iterator math move mpl multiprcecision numeric pending phoenix preprocessor
> random range smart_ptr spirit tuple type_trains typeof unordered utility
> uuid

### See Also

See the [BH](http://dirk.eddelbuettel.com/code/bh.html) page for some more details.

The [mailing list](http://lists.r-forge.r-project.org/cgi-bin/mailman/listinfo/boostheaders-devel)
at [R-Forge](http://www.r-forge.r-project.org) is a good place for questions,
comments and general discussion. The [issue tracker](https://github.com/eddelbuettel/bh/issues)
can be used for bugs.

### Updating

We aim to maintain this package in a somewhat conservative fashion and do not always
immediately jump the newest Boost releases.  Rather, we (used to) start from the
[Debian sources for Boost](https://packages.debian.org/sid/libboost-all-dev)
to ensure that we work with a version that is at the same time current yet
mature.  But on occassion, and as needed, and more recently, we will also go
directly to Boost releases. 

In general, we plan to keep the package up-to-date with [Boost](http://www.boost.org/)
upstream, but will not necessarily follow each and every new release as we
also value the merits of relative release stability. 

If needed, the script `local/script/CreateBoost.sh` can be used to update a forked
version to a newer version of [Boost](http://www.boost.org/).

### But what about the size?

We know. We erroneously thought that committing the Boost tarballs would be a
good idea. It wasn't. First attempts at pruning the history
[using bfg](https://rtyley.github.io/bfg-repo-cleaner/) were not that
successful.  If someone has a script doing this well we would take another
look.

Otherwise we recommend to just start from
[CreateBoost.sh](https://github.com/eddelbuettel/bh/blob/master/local/scripts/CreateBoost.sh). 

### Authors 

Dirk Eddelbuettel, Jay Emerson and Michael Kane

## License

This package is provided under the same license as Boost itself, the BSL-1.0
