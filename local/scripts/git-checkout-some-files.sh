#!/bin/bash

## overwritten files in 1.72.0-3 which had package-local changes we want to keep
## (mostly #pragma changes and alike to please CRAN)

files="inst/include/boost/bind.hpp \
inst/include/boost/function/function_base.hpp \
inst/include/boost/get_pointer.hpp \
inst/include/boost/move/detail/std_ns_begin.hpp \
inst/include/boost/mp11/function.hpp \
inst/include/boost/mpl/assert.hpp \
inst/include/boost/mpl/print.hpp \
inst/include/boost/numeric/ublas/storage.hpp \
inst/include/boost/random/detail/disable_warnings.hpp \
inst/include/boost/smart_ptr/bad_weak_ptr.hpp \
inst/include/boost/smart_ptr/detail/shared_count.hpp \
inst/include/boost/smart_ptr/detail/sp_counted_base_clang.hpp \
inst/include/boost/smart_ptr/scoped_ptr.hpp \
inst/include/boost/smart_ptr/shared_ptr.hpp \
inst/include/boost/system/detail/generic_category.hpp \
inst/include/boost/system/error_code.hpp \
inst/include/boost/test/detail/suppress_warnings.hpp \
inst/include/boost/tuple/detail/tuple_basic.hpp \
inst/include/boost/type_traits/detail/has_prefix_operator.hpp \
inst/include/boost/type_traits/has_logical_not.hpp \
inst/include/boost/winapi/basic_types.hpp"

for f in ${files}; do
    echo ${f}
    git checkout -- ${f}
done
