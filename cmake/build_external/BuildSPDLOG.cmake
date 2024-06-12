include(${CMAKE_CURRENT_LIST_DIR}/dep_versions.cmake)

if(ENABLE_OFFLINE_BUILD)
ExternalProject_Add(SPDLOG_External
    URL ${DEPS_LOCAL_PATH}/spdlog
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DSPDLOG_INSTALL=ON
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
)
else()
ExternalProject_Add(SPDLOG_External
    GIT_REPOSITORY https://github.com/gabime/spdlog
    GIT_TAG ${SPDLOG_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DSPDLOG_INSTALL=ON
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
)
endif()
