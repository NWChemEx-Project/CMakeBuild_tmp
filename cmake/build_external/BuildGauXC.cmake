

ExternalProject_Add(GauXC_External
    GIT_REPOSITORY https://github.com/wavefunction91/GauXC.git
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DCMAKE_CXX_FLAGS_INIT="-DOMPI_SKIP_MPICXX" -DGAUXC_ENABLE_TESTS=OFF
        -DGAUXC_ENABLE_CUDA=${USE_CUDA} -DCMAKE_CUDA_ARCHITECTURES=${NV_GPU_ARCH} -DGAUXC_ENABLE_MAGMA=OFF
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

