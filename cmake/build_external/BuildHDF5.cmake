
set(HDF5_EXTRA_FLAGS "-Wno-unused-variable")
set(C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} ${HDF5_EXTRA_FLAGS}")

ExternalProject_Add(HDF5_External
    URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_14_0.tar.gz
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DCMAKE_C_FLAGS_INIT=${C_FLAGS_INIT} 
        -DBUILD_TESTING=OFF -DHDF5_BUILD_EXAMPLES=OFF -DHDF5_BUILD_CPP_LIB=OFF -DHDF5_ENABLE_PARALLEL=ON
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

