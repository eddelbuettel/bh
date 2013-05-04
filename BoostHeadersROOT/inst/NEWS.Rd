\name{NEWS}
\title{News for Package \pkg{BH}}
\newcommand{\cpkg}{\href{http://CRAN.R-project.org/package=#1}{\pkg{#1}}}
\newcommand{\boost}{\href{http://www.boost.org}{\pkg{Boost}}}

\section{Changes in [unreleased] version 1.51.0-1 (2013-05-04)}{
  \itemize{
    \item Expanded \boost coverage by adding \boost packages
    \href{http://www.boost.org/doc/libs/release/libs/foreach}{\pkg{foreach}},
    \href{http://www.boost.org/doc/libs/1_53_0/libs/math/doc/sf_and_dist/html/math_toolkit/dist.html}{{\pkg{Statistical
  Distributions}} and
    \href{http://www.boost.org/doc/libs/release/libs/iostreams}{\pkg{iostreams}} 
    (which addresses, respectively, R-Forge issue tickets 2527, 2533 and 2768).
  }
}

\section{Changes in version 1.51.0-0 (2013-01-31)}{
  \itemize{
    \item First CRAN upload
    \item Package can be used to successfully build \cpkg{bigmemory} and
    \cpkg{RcppBDT}. It already contains significant portions of Boost libraries
    algorithm, bind, concept, config, container, date_time, detail,
    exceptions, filesystem, functional, interprocess, intrusive, iterator,
    math, mpl, numeric, preprocessor, random, range, smart_ptr,
    type_traits, unordered.
  }
}

