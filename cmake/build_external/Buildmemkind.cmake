set(MEMKIND_GIT_TAG master)

ExternalProject_Add(memkind_External
    GIT_REPOSITORY https://github.com/memkind/memkind.git
    GIT_TAG ${MEMKIND_GIT_TAG}
    UPDATE_DISCONNECTED 1

    CONFIGURE_COMMAND ./autogen.sh COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
    CXX=${CMAKE_CXX_COMPILER}
    CC=${CMAKE_C_COMPILER}

    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    BUILD_IN_SOURCE 1
  )
