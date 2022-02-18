

set(HPTT_GIT_TAG 36ee84a72704091a32234d5d3085baa523b94e1e)
if(ENABLE_DEV_MODE)
    set(HPTT_GIT_TAG master)
endif()

ExternalProject_Add(HPTT_External
    GIT_REPOSITORY https://github.com/ajaypanyala/hptt.git
    GIT_TAG ${HPTT_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_OPENMP=${USE_OPENMP} -DMARCH_FLAGS=${MARCH_FLAGS}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

