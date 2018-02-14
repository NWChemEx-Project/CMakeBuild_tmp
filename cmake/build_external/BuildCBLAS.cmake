#
# This file will build Netlib's CBLAS distribution over an existing BLAS
# installation. To do this we use a mock superbuild in case we need to build
# BLAS for the user.
#
find_or_build_dependency(BLAS _was_Found)
enable_language(C Fortran)


ExternalProject_Add(CBLAS_External
        SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/CBLAS
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
                   -DSTAGE_DIR=${STAGE_DIR}
        BUILD_ALWAYS 1
        INSTALL_COMMAND $(MAKE) DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                         ${CORE_CMAKE_STRINGS}
        )
add_dependencies(CBLAS_External BLAS_External)
