# git_watcher.cmake
# https://raw.githubusercontent.com/andrew-hardin/cmake-git-version-tracking/master/git_watcher.cmake
#
# Released under the MIT License.
# https://raw.githubusercontent.com/andrew-hardin/cmake-git-version-tracking/master/LICENSE


# This file defines a target that monitors the state of a git repo.
# If the state changes (e.g. a commit is made), then a file gets reconfigured.
# Here are the primary variables that control script behavior:
#
#   PRE_CONFIGURE_FILE (REQUIRED)
#   -- The path to the file that'll be configured.
#
#   POST_CONFIGURE_FILE (REQUIRED)
#   -- The path to the configured PRE_CONFIGURE_FILE.
#
#   GIT_STATE_FILE (OPTIONAL)
#   -- The path to the file used to store the previous build's git state.
#      Defaults to the current binary directory.
#
#   GIT_WORKING_DIR (OPTIONAL)
#   -- The directory from which git commands will be run.
#      Defaults to the directory with the top level CMakeLists.txt.
#
#   GIT_EXECUTABLE (OPTIONAL)
#   -- The path to the git executable. It'll automatically be set if the
#      user doesn't supply a path.
#
#   GIT_FAIL_IF_NONZERO_EXIT (OPTIONAL)
#   -- Raise a FATAL_ERROR if any of the git commands return a non-zero
#      exit code. This is set to TRUE by default. You can set this to FALSE
#      if you'd like the build to continue even if a git command fails.
#
#   GIT_IGNORE_UNTRACKED (OPTIONAL)
#   -- Ignore the presence of untracked files when detecting if the
#      working tree is dirty. This is set to FALSE by default.
#
# DESIGN
#   - This script was designed similar to a Python application
#     with a Main() function. I wanted to keep it compact to
#     simplify "copy + paste" usage.
#
#   - This script is invoked under two CMake contexts:
#       1. Configure time (when build files are created).
#       2. Build time (called via CMake -P).
#     The first invocation is what registers the script to
#     be executed at build time.
#
# MODIFICATIONS
#   You may wish to track other git properties like when the last
#   commit was made. There are two sections you need to modify,
#   and they're tagged with a ">>>" header.
# Short hand for converting paths to absolute.
macro(PATH_TO_ABSOLUTE var_name)
    get_filename_component(${var_name} "${${var_name}}" ABSOLUTE)
endmacro()

# Check that a required variable is set.
macro(CHECK_REQUIRED_VARIABLE var_name)
    if(NOT DEFINED ${var_name})
        message(FATAL_ERROR "The \"${var_name}\" variable must be defined.")
    endif()
    PATH_TO_ABSOLUTE(${var_name})
endmacro()

# Check that an optional variable is set, or, set it to a default value.
macro(CHECK_OPTIONAL_VARIABLE_NOPATH var_name default_value)
    if(NOT DEFINED ${var_name})
        set(${var_name} ${default_value})
    endif()
endmacro()

# Check that an optional variable is set, or, set it to a default value.
# Also converts that path to an abspath.
macro(CHECK_OPTIONAL_VARIABLE var_name default_value)
    CHECK_OPTIONAL_VARIABLE_NOPATH(${var_name} ${default_value})
    PATH_TO_ABSOLUTE(${var_name})
endmacro()

CHECK_REQUIRED_VARIABLE(PRE_CONFIGURE_FILE)
CHECK_REQUIRED_VARIABLE(POST_CONFIGURE_FILE)
CHECK_OPTIONAL_VARIABLE(GIT_STATE_FILE "${CMAKE_CURRENT_BINARY_DIR}/git-state-hash")
CHECK_OPTIONAL_VARIABLE(GIT_WORKING_DIR "${CMAKE_SOURCE_DIR}")
CHECK_OPTIONAL_VARIABLE_NOPATH(GIT_FAIL_IF_NONZERO_EXIT TRUE)
CHECK_OPTIONAL_VARIABLE_NOPATH(GIT_IGNORE_UNTRACKED FALSE)

# Check the optional git variable.
# If it's not set, we'll try to find it using the CMake packaging system.
if(NOT DEFINED GIT_EXECUTABLE)
    find_package(Git QUIET REQUIRED)
endif()
CHECK_REQUIRED_VARIABLE(GIT_EXECUTABLE)

include(${CMAKE_CURRENT_LIST_DIR}/git_watcher_functions.cmake)

# And off we go...
Main()
