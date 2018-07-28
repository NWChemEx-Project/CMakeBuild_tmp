

ExternalProject_Add(HPTT_External
    GIT_REPOSITORY git@github.com:ajaypanyala/hptt.git
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

