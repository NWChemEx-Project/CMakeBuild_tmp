
    if(BLAS_INT4)
        set(LINALG_REQUIRED_COMPONENTS "lp64")
    else()
        set(LINALG_REQUIRED_COMPONENTS "ilp64")
    endif()

    if("${LINALG_VENDOR}" STREQUAL "IntelMKL")
        set(LINALG_THREAD_LAYER "sequential")
        if(USE_OPENMP)
            set(LINALG_THREAD_LAYER "openmp")
        endif()
        set(_LA_TL ON)
    elseif("${LINALG_VENDOR}" STREQUAL "IBMESSL")
        if(USE_OPENMP)
            set(LINALG_THREAD_LAYER "smp")
            set(_LA_TL ON)
        endif()
    else()
        set(_LA_TL OFF)
    endif()

    set(BLAS_PREFERENCE_LIST      ${LINALG_VENDOR})
    set(LAPACK_PREFERENCE_LIST    ${LINALG_VENDOR})
    set(ScaLAPACK_PREFERENCE_LIST ${LINALG_VENDOR})

    set(LINALG_PREFER_STATIC ON)
    if(BUILD_SHARED_LIBS)
      set(LINALG_PREFER_STATIC OFF)
    endif()
    
    set(_BLAS_PREFERS_STATIC       "-DBLAS_PREFERS_STATIC=${LINALG_PREFER_STATIC}")
    set(_LAPACK_PREFERS_STATIC     "-DLAPACK_PREFERS_STATIC=${LINALG_PREFER_STATIC}")
    set(_ScaLAPACK_PREFERS_STATIC  "-DScaLAPACK_PREFERS_STATIC=${LINALG_PREFER_STATIC}")

    if(_LA_TL)
        set(_BLAS_THREAD_LAYER              "-DBLAS_THREAD_LAYER=${LINALG_THREAD_LAYER}")
        set(_LAPACK_THREAD_LAYER            "-DLAPACK_THREAD_LAYER=${LINALG_THREAD_LAYER}")
        set(_ScaLAPACK_THREAD_LAYER         "-DScaLAPACK_THREAD_LAYER=${LINALG_THREAD_LAYER}")
    endif()

    set(_BLAS_REQUIRED_COMPONENTS       "-DBLAS_REQUIRED_COMPONENTS=${LINALG_REQUIRED_COMPONENTS}")
    set(_LAPACK_REQUIRED_COMPONENTS     "-DLAPACK_REQUIRED_COMPONENTS=${LINALG_REQUIRED_COMPONENTS}")
    set(_ScaLAPACK_REQUIRED_COMPONENTS  "-DScaLAPACK_REQUIRED_COMPONENTS=${LINALG_REQUIRED_COMPONENTS}")

    set(_BLAS_PREFIX   "-DBLAS_PREFIX=${LINALG_PREFIX}")
    if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL")
        set(LAPACK_PREFERENCE_LIST ReferenceLAPACK)
        if(USE_SCALAPACK)
            set(ScaLAPACK_PREFERENCE_LIST ReferenceScaLAPACK)
            find_or_build_dependency(ScaLAPACK)
            set(_ScaLAPACK_PREFIX "-DScaLAPACK_PREFIX=${CMAKE_INSTALL_PREFIX}")
        else()
            find_or_build_dependency(LAPACK)
        endif()

        set(_LAPACK_PREFIX   "-DLAPACK_PREFIX=${CMAKE_INSTALL_PREFIX}")
        if(${LINALG_VENDOR} STREQUAL "BLIS")
            set(_BLAS_PREFIX   "-DBLAS_PREFIX=${CMAKE_INSTALL_PREFIX}")
        endif()
    endif()

    set(GXC_GIT_TAG 8642cddc684a12bf9b0c0126cb45eb3818bb77e2)
    if(ENABLE_DEV_MODE)
      set(GXC_GIT_TAG master)
    endif()

ExternalProject_Add(GauXC_External
    GIT_REPOSITORY https://github.com/ajaypanyala/GauXC.git
    GIT_TAG ${GXC_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DCMAKE_CXX_FLAGS_INIT="-DOMPI_SKIP_MPICXX" -DGAUXC_ENABLE_TESTS=OFF
        -DGAUXC_ENABLE_CUDA=${USE_CUDA} -DENABLE_XHOST=OFF -DCMAKE_CUDA_ARCHITECTURES=${GPU_ARCH}
        -DGAUXC_ENABLE_OPENMP=${USE_OPENMP} -DGAUXC_ENABLE_MAGMA=OFF 
        ${_BLAS_PREFIX} ${_LAPACK_PREFIX} ${_ScaLAPACK_PREFIX} 
        -DBLAS_PREFERENCE_LIST=${BLAS_PREFERENCE_LIST} -DLAPACK_PREFERENCE_LIST=${LAPACK_PREFERENCE_LIST}
        -DScaLAPACK_PREFERENCE_LIST=${ScaLAPACK_PREFERENCE_LIST}
        ${_BLAS_PREFERS_STATIC} ${_LAPACK_PREFERS_STATIC} ${_ScaLAPACK_PREFERS_STATIC}
        ${_BLAS_THREAD_LAYER} ${_LAPACK_THREAD_LAYER} ${_ScaLAPACK_THREAD_LAYER}
        ${_BLAS_REQUIRED_COMPONENTS} ${_LAPACK_REQUIRED_COMPONENTS}  ${_ScaLAPACK_REQUIRED_COMPONENTS}

    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL")
    if(USE_SCALAPACK)
        add_dependencies(GauXC_External ScaLAPACK_External)
    else()
        add_dependencies(GauXC_External LAPACK_External)
    endif()
endif()