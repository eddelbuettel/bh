#!/bin/bash
##
## CreateBoost.sh -- derived from CreateBoost.R
##
## Jay Emerson and Dirk Eddelbuettel,  2012 - 2014


## (1) Adjust these variables as needed 
## 
## -- on a standard git checkout, this repo it may be ~/git/bh
pkgdir="${HOME}/git/bh"
## -- current boost sources, placed eg in ${pkgdir}/local/
boosttargz="boost_1_54_0.tar.gz"
## -- current package version and date (and other metadata as needed)
version="1.54.0-5"
date="2014-11-09"



## (2) Additional resources we require and need to test for
##
## 'progs' lists the programs we need
progs="bcp"



## (3) Some internal constants and variables
## local directory in git repo
localdir="${pkgdir}/local"
## Derive the 'bootroot' name from the tarball, using basename(1)
boostver=$(basename ${boosttargz} ".tar.gz")
## create boost root directory name
boostroot="${localdir}/${boostver}"
## create boost tarball file name with full path
boostsources="${localdir}/${boosttargz}"
## target directory for headers
pkgincl="${pkgdir}/inst/include/"
## local files containing R package pieces
localfiles="${pkgdir}/local/files"



## (4) Display current settings
echo "Using these settings:
Date:          ${date}
Version:       ${version}
Boosttargz:    ${boosttargz}
PkgDir:        ${pkgdir}
PkgIncl:       ${pkgincl}
LocalDir:      ${localdir}
LocalFiles:    ${localfiles}
BoostRoot:     ${boostroot}
Boostsources:  ${boostsources}
"



## (5) Some sanity check here before continuing
for prog in ${progs}; do
    if [ ! -x /usr/bin/${prog} ] && [ ! -x /usr/local/bin/${prog} ]; then
	echo "Program '${prog}' not found, exiting"
	exit 1
    fi
done

if [ ! -f "${boostsources}" ]; then
    echo "Boost input file ${boostsources} missing, exiting." 
    exit 1
fi

if [ -d ${boostroot} ]; then
    echo "Old BoostRoot directory exists, removing it (ie ${boostroot})."
    rm -rf ${boostroot}
fi



## (6) Unpack boost
echo "Unpacking ${boosttargz} into LocalDir (ie ${localdir})."
(cd ${localdir} && tar xfz ${boostsources})



## (7) Install Boost dependencies needed for BH
##
## We used to copy using bcp from what the bigmemory and synchronicity packages need:
##   # The bigmemory Boost dependencies:
##   bcp --scan --boost=${boostroot} ../bigmemory/pkg/bigmemory/src/*.cpp ${pkgdir}/inst/include > bcp.log
##   # The synchronicity Boost dependencies:
##   bcp --scan --boost=${boostroot} ../bigmemory/pkg/synchronicity/src/*.cpp ${pkgdir}/inst/include > bcp.log
##
## But we now enumerate the corresponding libraries (derived from what
## bigmemory and synchronicity brought in) explicitly

echo "Copying Boost libraries into BH"

boostlibs="bind concept config container date_time detail exception functional integer interprocess intrusive io iterator math move mpl numeric pending preprocessor random range smart_ptr tupe typeof type_trains unordered utility uuid"

## this copies the Boost libraries listed in ${boostlibs} from the
## Boost sources in ${boostroot} into the target directory ${pkgincl}
bcp --boost=${boostroot}  ${boostlibs}  ${pkgincl}   > /dev/null  2>&1



# (8) Plus other Boost libraries:  filesystem, random, unordered, spirit
# Plus foreach (cf issue ticket #2527)
# Plus math/distributions + algorithm (cf issue ticket #2533)
# Plus iostream (cf issue ticket #2768) 
# Plus dynamic_bitset (cf issue ticket #4991 -- may be non-issue and already implied)
# Plus all of math (ie removing "/distributions" from "math/distributions"
# Plus heap (request of package RcppMLPACK)
# Plus any (request of [GitHub] package nabo by Greg Jeffries)
# Plus circular_buffer (email requesy by Ben Goodrich for use in RStan)
boostextras="filesystem random unordered spirit foreach math algorithm iostreams dynamic_bitset heap any circular_buffer"

bcp --boost=${boostroot}  ${boostextras}   ${pkgincl}   > /dev/null   2>&1

# TODO: check with other CRAN packages about what may be needed



## (9) Some post processing and cleanup
rm -rf ${pkgincl}/libs \
       ${pkgincl}/Jamroot \
       ${pkgincl}/boost.png \
       ${pkgincl}/doc \
       ${pkgincl}/boost.css \
       ${pkgincl}/rst.css 



## (10) Some file manips -- or rather, we might as well do this by hand ...
#cp -p ${localfiles}/NAMESPACE    ${pkgdir}
#cp -p ${localfiles}/inst/NEWS.Rd ${pkgdir}/inst/
cp -p ${localfiles}/man/*.Rd     ${pkgdir}/man

#sed -e "s/XXX/${version}/g" \
#    -e "s/YYY/${date}/g"    \
#    ${localfiles}/DESCRIPTION  >  ${pkgdir}/DESCRIPTION
sed -e "s/XXX/${version}/g" -e "s/YYY/${date}/g" \
    ${localfiles}/man/BH-package.Rd > ${pkgdir}/man/BH-package.Rd 


## (11) Unconditional cleanup
echo "Purging (temp. dir) BoostRoot"
rm -rf ${boostroot}


echo "Now check with 'git status' and add and commit as needed."



#########################################################################
# Now fix up things that don't work, if necessary.  Here, we need to stay
# organized and decide who is the maintainer of what, but this script
# is the master record of any changes made to the boost tree.

## bigmemory et.al. will require changes to support Windows; we
## believe the Mac and Linux versions will be fine without changes.

## We'll invite co-maintainers who identify changes needed to support
## their specific libraries.

