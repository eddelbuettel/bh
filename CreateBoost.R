## Jay Emerson
## September 2, 2012

## TODO(DE): Are we sure this isn't more easily written as a shell script?

## First, download the new version of the Boost Libraries and
## set the variables boostall and version, here:
boostall <- 'boost_1_51_0.tar.gz'
version <- '1.51.0.0'
date <- '2012-09-03'
pkgdir <- 'pkg/BoostHeaders'          # No trailing slash

boostroot <- gsub('.tar.gz', '', boostall)

## Next, move the old BoostHeaders package aside for safety, and
## I'll do a sanity check here before continuing:

if (!file.exists(boostall) && !file.exists(boostroot)) {
  stop('That Boost input does not exist')
}
if (file.exists(pkgdir)) {
  cat("svn rmdir pkg/BoostHeaders\n")
  cat("Then when this is done and tested, add it back into the svn\n")
  stop('Move aside the old BoostHeaders')
}
########################################################################
# Unpack, copy from boost to BoostHeaders/inst/include,
# and build the supporting infrastructure of the package.

if (!file.exists(boostroot)) {
  system(paste('tar -zxf', boostall))
}

system(paste('mkdir', pkgdir))
system(paste('mkdir ', pkgdir, '/inst', sep=""))
system(paste('mkdir ', pkgdir, '/inst/include', sep=""))

# bcp --scan --boost=boost_1_51_0 ../bigmemory/pkg/bigmemory/src/*.cpp test
system(paste('bcp --scan --boost=', boostroot,
             ' ../bigmemory/pkg/bigmemory/src/*.cpp ',
             pkgdir, '/inst/include > bcp.log', sep=''))

system(paste('/bin/rm -r ', pkgdir, '/inst/include/libs', sep=''))
system(paste('/bin/rm -r ', pkgdir, '/inst/include/Jamroot', sep=''))

system(paste('cp BoostHeadersROOT/DESCRIPTION', pkgdir))
system(paste('cp BoostHeadersROOT/LICENSE*', pkgdir))
system(paste('cp BoostHeadersROOT/NAMESPACE', pkgdir))
system(paste('cp -rp BoostHeadersROOT/man', pkgdir))

system(paste('sed -i "s/XXX/', version, '/g" ', pkgdir, '/DESCRIPTION',
             sep=""))
system(paste('sed -i "s/YYY/', date, '/g" ', pkgdir, '/DESCRIPTION',
             sep=""))
system(paste('sed -i "s/XXX/', version,
             '/g" ', pkgdir, '/man/BoostHeaders-package.Rd', sep=""))
system(paste('sed -i "s/YYY/', date,
             '/g" ', pkgdir, '/man/BoostHeaders-package.Rd', sep=""))

########################################################################
# Now fix up things that don't work.  Here, we need to stay
# organized and decide who is the maintainer of what, but this script
# is the master record of any changes made to the boost tree.

## bigmemory et.al. will require changes to support Windows; we
## believe the Mac and Linux versions will be fine without changes.

## We'll invite co-maintainers who identify changes needed to support
## their specific libraries.


