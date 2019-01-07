
## Upgrading BH on CRAN from 1.66 to 1.69

We ran two initial reverse-dependency checks, with results pushed to the
[usual repo](https://github.com/RcppCore/rcpp-logs).  The finally summary is
[in this
file](https://github.com/RcppCore/rcpp-logs/blob/master/results/bh/BH-Summary-20181216-2.txt)
with the moneyline being 

> 141 successes, 10 failures, and 8 skipped packages. 

Of the 10 failures, four are due to missing depends or suggests: these
packages passed once installed.  Of the remaining six, three are recurring
issues we also have with _e.g._ Rcpp.  

That leaves three regressions, or as CRAN calls it, 'change to worse'. We
verified that these packages do indeed pass with the CRAN version of BH,
_i.e_, 1.66.


### First regression: phonics

The package uses 

```c++
using namespace Rcpp;
using namespace boost;
using namespace std;
```

which flattens namespaces---and now reaps a collision as `distance()` is no
longer unique. 

Simply prefixing the four or five occurrances with `std::` fixes it.

```diff
diff -ru phonics.orig/src/metaphone.cpp phonics/src/metaphone.cpp
--- phonics.orig/src/metaphone.cpp      2018-08-16 19:05:22.000000000 +0000
+++ phonics/src/metaphone.cpp   2018-12-20 03:31:06.325881441 +0000
@@ -151,13 +151,13 @@
         break;
       case 'G':
         if (nc == 'H') {
-          if(!(is("BDH", at(word, distance(word.begin(), i) - 3)) ||
-             at(word, distance(word.begin(), i) - 4) == 'H')) {
+          if(!(is("BDH", at(word, std::distance(word.begin(), i) - 3)) ||
+              at(word, std::distance(word.begin(), i) - 4) == 'H')) {
             meta += 'F';
             i++;
           }
         } else if(nc == 'N') {
-          if (is(alpha, nnc) && substr(word, distance(word.begin(), i) + 1, 3) != "NED") {
+          if (is(alpha, nnc) && substr(word, std::distance(word.begin(), i) + 1, 3) != "NED") {
             meta += 'K';
           }
         } else if(is(soft, nc) && pc != 'G') {
@@ -187,7 +187,7 @@
         } else if(nc == 'H') {
           meta += 'X';
           i += 1;
-        } else if(!traditional && substr(word, distance(word.begin(), i) + 1, 3) == "CHW") {
+        } else if(!traditional && substr(word, std::distance(word.begin(), i) + 1, 3) == "CHW") {
           meta += 'X';
           i += 2;
         } else {
@@ -200,7 +200,7 @@
         } else if(nc == 'H') {
           meta += '0';
           i += 1;
-        } else if(substr(word, distance(word.begin(), i) + 1, 2) != "CH") {
+        } else if(substr(word, std::distance(word.begin(), i) + 1, 2) != "CH") {
           meta += 'T';
         }
         break;
```


### Second regression: RcppStreams

Here we end up with a linking error.  The following symbol, expanded with
`c++filt` is coming up as missing:

```sh
$ c++filt _ZN5boost5proto6detail17display_expr_implC1ERKS2_
boost::proto::detail::display_expr_impl::display_expr_impl(boost::proto::detail::display_expr_impl const&)
$
```

I am the upstream author/maintainer here so I need to figure this out myself.
This looks somewhat tricky, but a quick commenting-out of an optional /
verbose display call does the trick. So that is what we may end up doing.



### Third regression:  TDA

This generated _a lot_ of `error: ‘next’ is not a member of ‘boost’` when
`boost::next(somevar)` was invoked.  A quick Google search suggests that
the declaration moved to another header file and that including
`boost/next_prior.hpp` should fix it -- and it does.

```diff
diff -ru TDA.orig/src/diag.cpp TDA/src/diag.cpp
--- TDA.orig/src/diag.cpp       2018-08-06 00:09:20.000000000 +0000
+++ TDA/src/diag.cpp    2018-12-20 03:48:10.404143947 +0000
@@ -5,6 +5,8 @@
 // for Rcpp
 #include <Rcpp.h>

+#include <boost/next_prior.hpp>
+
 // for Rips
 #include <tdautils/ripsL2.h>
 #include <tdautils/ripsArbit.h>
```

That may not be the best place for the include but it demonstrated that we
simply need to add it somewhere so that `diag.cpp` compiles.


## Package Access

We installed the release candiate package in the [ghrr drat
repo](http://ghrr.github.io/drat/).  To install BH 1.69.0-0, either install
the [drat package](https://cloud.r-project.org/package=drat) and set the repo
as described at the [ghrr drat repo](http://ghrr.github.io/drat/), or just do

```r
install.packages("BH", repo="http://ghrr.github.io/drat/")
```

This will allow for continued testing of BH 1.69.0 before we upload it to
CRAN, probably early January.
