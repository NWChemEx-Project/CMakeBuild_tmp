# - Try to find TAL_SH Library
#
#  To aid find_package in locating TAL_SH, the user may set the
#  variable TALSH_ROOT_DIR to the root of the TAL_SH install
#  directory.
#
#  Once done this will define
#  TALSH_FOUND - System has TAL_SH
#  TALSH_INCLUDE_DIR - The TAL_SH include directories
#  TALSH_LIBRARY - The library needed to use TAL_SH

if(NOT DEFINED TALSH_ROOT_DIR)
    find_package(PkgConfig)
    pkg_check_modules(PC_TALSH QUIET libtalsh)
endif()

find_path(TALSH_INCLUDE_DIR talsh.h
          HINTS ${PC_TALSH_INCLUDEDIR}
                ${PC_TALSH_INCLUDE_DIRS}
          PATHS ${TALSH_ROOT_DIR}
          )

find_library(TALSH_LIBRARY
             NAMES talsh
             HINTS ${PC_TALSH_LIBDIR}
                   ${PC_TALSH_LIBRARY_DIRS}
	     PATHS ${TALSH_ROOT_DIR}
	  )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TALSH DEFAULT_MSG
                                  TALSH_LIBRARY
                                  TALSH_INCLUDE_DIR)

set(TALSH_LIBRARIES ${TALSH_LIBRARY})
set(TALSH_INCLUDE_DIRS ${TALSH_INCLUDE_DIR})
