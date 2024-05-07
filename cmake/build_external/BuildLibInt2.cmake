#
# This file will build LibInt using a mock super-build incase Eigen3 needs to be
# built as well
#
find_or_build_dependency(Eigen3)
package_dependency(Eigen3 DEPENDENCY_PATHS)
set(TEST_LIBINT FALSE)
if(${PROJECT_NAME} STREQUAL "TestBuildLibInt")
    set(TEST_LIBINT TRUE)
endif()

set(LIBINT_VERSION 2.9.0)
set(LIBINT_URL https://github.com/evaleev/libint)
set(LIBINT_TAR ${LIBINT_URL}/releases/download/v${LIBINT_VERSION})
set(LIBINT_TAR ${LIBINT_TAR}/libint-${LIBINT_VERSION})
if(TEST_LIBINT)
    #Grab the small version of libint for testing purposes
    set(LIBINT_TAR ${LIBINT_TAR}-test-mpqc4.tgz)
else()
    set(LIBINT_TAR ${LIBINT_TAR}.tgz)
endif()

# append platform-specific optimization options for non-Debug builds
set(LIBINT_EXTRA_FLAGS "-Wno-unused-variable")
set(CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} ${LIBINT_EXTRA_FLAGS}")

set (LI_SRC_SDIR libint-${LIBINT_VERSION})
if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
  set(LI_SRC_SDIR ".")
endif()

if(LIBINT_ERI)
  set(LIBINT_TAR ${LIBINT_ERI})
  set(LI_SRC_SDIR ".")
endif()

if(ENABLE_OFFLINE_BUILD)
  set(LIBINT_TAR ${DEPS_LOCAL_PATH}/libint-${LIBINT_VERSION}.tgz)
endif()

ExternalProject_Add(LibInt2_External
        URL ${LIBINT_TAR}
        SOURCE_SUBDIR ${LI_SRC_SDIR}
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DCMAKE_CXX_FLAGS_INIT=${CXX_FLAGS_INIT}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
        ${CORE_CMAKE_STRINGS}
        )

add_dependencies(LibInt2_External Eigen3_External)

