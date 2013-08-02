\name{NEWS}
\title{News for Package \pkg{BH}}
\newcommand{\cpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}
\newcommand{\boost}{\href{http://www.boost.org}{\pkg{Boost}}}
\newcommand{\boostPkg}{\href{http://www.boost.org/doc/libs/release/libs/#1}{\pkg{#1}}}
\newcommand{\boostPkgTwo}{\href{http://www.boost.org/doc/libs/release/libs/#1}{\pkg{#2}}}

\section{Changes in version 1.51.0-3 (2013-08-02)}{
  \itemize{
    \item Expanded \boost coverage by adding \boost package \boostPkg{spirit}.
  }
}

\section{Changes in version 1.51.0-2 (2013-07-29)}{
  \itemize{
    \item Expanded \boost coverage by adding \boost packages \boostPkg{random} and \boostPkg{unordered}.
  }
}

\section{Changes in [unreleased] version 1.51.0-1 (2013-05-04)}{
  \itemize{
    \item Expanded \boost coverage by adding \boost packages \boostPkg{foreach},
    \boostPkgTwo{libs/math/doc/sf_and_dist/html/math_toolkit/dist.html}{statistical distributions},
    and \boostPkg{iostreams}. This addresses, respectively, R-Forge issue tickets 2527, 2533 and 2768).
    \item The package can now also be used to compile CRAN package
    \pkg{ExactNumCI} and \pkg{rcppbugs}.
  }
}

\section{Changes in version 1.51.0-0 (2013-01-31)}{
  \itemize{
    \item First CRAN upload
    \item The package can be used to build \cpkg{bigmemory} and
    \cpkg{RcppBDT} as it already contains significant portions of Boost libraries
    algorithm, bind, concept, config, container, date_time, detail,
    exceptions, filesystem, functional, interprocess, intrusive, iterator,
    math, mpl, numeric, preprocessor, random, range, smart_ptr,
    type_traits, unordered.
  }
}

