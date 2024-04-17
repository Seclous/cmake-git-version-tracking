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

include(${CMAKE_CURRENT_LIST_DIR}/git_watcher_functions.cmake)

# And off we go...
Main()
