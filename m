From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 08/15] Unified CMake build system
Date: Mon, 22 Aug 2016 12:13:31 -0600
Message-ID: <1471889618-1605-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This replaces the random selection of auto* and custom stuff with a
simple unified cmake based scheme.

The input from cpp to gcc is validated to be identical.

An analysis of the post-install result shows the following differences:
 - cmake makes shlib symlinks libX.so -> libX.so.1 -> libX.so.1.0.0, while
   libtool does libX.so -> libX.so.1.0.0
 - librspreload's non-link name is lib/rsocket/librspreload.so (not .so.1)
   This correctly reflects the fact it is a soname-less LD_PRELOAD library.
   Symlinks are maintained for the other two incorrect names.
 - No static version of librspreload is produced. This library is only
   useful for LD_PRELOAD and cannot be statically linked to.
 - The provider shared library plugins and the LD_PRELOAD library
   have no SONAME. This is standard for plugin libraries.
 - The plugin shared libraries are not marked executable
 - -std=gnu99 is turned on globally
 - All shlibs have correct shared library dependencies (--as-needed and
   --no-undefined are turned on).
   Several binaries drop their pthreads dependency as they don't use it.
 - NDEBUG is controlled globally and is not defined.
   Previously only libcxgb4 defined it
 - libtool *.la files are produced by cmake since libtool is not used
   and have a few minor differences:
   - Providers do not list the 'libX.so' bogus name, the .so is called
     libX-rdmav2.so
   - version information (current/age/revision) is bogus
   - The .la files are not marked executable

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                              | 232 ++++++++++++++++++++++++++
 README.md                                   |  69 ++++++++
 buildlib/FindLDSymVer.cmake                 |  41 +++++
 buildlib/RDMA_BuildType.cmake               |  31 ++++
 buildlib/RDMA_DoFixup.cmake                 |  21 +++
 buildlib/RDMA_EnableCStd.cmake              |  23 +++
 buildlib/config.h.in                        |  29 ++++
 buildlib/fixup-include/rdma-rdma_user_rxe.h | 144 +++++++++++++++++
 buildlib/fixup-include/valgrind-memcheck.h  |   5 +
 buildlib/provider.map                       |   6 +
 buildlib/publish_headers.cmake              |  20 +++
 buildlib/rdma_functions.cmake               | 242 ++++++++++++++++++++++++++++
 libcxgb3/src/CMakeLists.txt                 |   6 +
 libcxgb4/src/CMakeLists.txt                 |   6 +
 libhfi1verbs/src/CMakeLists.txt             |   4 +
 libi40iw/src/CMakeLists.txt                 |   5 +
 libibcm/examples/CMakeLists.txt             |   2 +
 libibcm/src/CMakeLists.txt                  |   9 ++
 libibumad/man/CMakeLists.txt                |  42 +++++
 libibumad/src/CMakeLists.txt                |  14 ++
 libibumad/tests/CMakeLists.txt              |   5 +
 libibverbs/examples/CMakeLists.txt          |  29 ++++
 libibverbs/man/CMakeLists.txt               |  78 +++++++++
 libibverbs/src/CMakeLists.txt               |  34 ++++
 libipathverbs/CMakeLists.txt                |   4 +
 libipathverbs/src/CMakeLists.txt            |   4 +
 libmlx4/src/CMakeLists.txt                  |   9 ++
 libmlx5/src/CMakeLists.txt                  |   9 ++
 libmthca/src/CMakeLists.txt                 |  10 ++
 libnes/src/CMakeLists.txt                   |   4 +
 libocrdma/src/CMakeLists.txt                |   4 +
 librdmacm/examples/CMakeLists.txt           |  43 +++++
 librdmacm/man/CMakeLists.txt                |  65 ++++++++
 librdmacm/src/CMakeLists.txt                |  39 +++++
 librxe/CMakeLists.txt                       |   4 +
 librxe/man/CMakeLists.txt                   |   4 +
 librxe/src/CMakeLists.txt                   |   3 +
 37 files changed, 1299 insertions(+)
 create mode 100644 CMakeLists.txt
 create mode 100644 README.md
 create mode 100644 buildlib/FindLDSymVer.cmake
 create mode 100644 buildlib/RDMA_BuildType.cmake
 create mode 100644 buildlib/RDMA_DoFixup.cmake
 create mode 100644 buildlib/RDMA_EnableCStd.cmake
 create mode 100644 buildlib/config.h.in
 create mode 100644 buildlib/fixup-include/rdma-rdma_user_rxe.h
 create mode 100644 buildlib/fixup-include/valgrind-memcheck.h
 create mode 100644 buildlib/provider.map
 create mode 100644 buildlib/publish_headers.cmake
 create mode 100644 buildlib/rdma_functions.cmake
 create mode 100644 libcxgb3/src/CMakeLists.txt
 create mode 100644 libcxgb4/src/CMakeLists.txt
 create mode 100644 libhfi1verbs/src/CMakeLists.txt
 create mode 100644 libi40iw/src/CMakeLists.txt
 create mode 100644 libibcm/examples/CMakeLists.txt
 create mode 100644 libibcm/src/CMakeLists.txt
 create mode 100644 libibumad/man/CMakeLists.txt
 create mode 100644 libibumad/src/CMakeLists.txt
 create mode 100644 libibumad/tests/CMakeLists.txt
 create mode 100644 libibverbs/examples/CMakeLists.txt
 create mode 100644 libibverbs/man/CMakeLists.txt
 create mode 100644 libibverbs/src/CMakeLists.txt
 create mode 100644 libipathverbs/CMakeLists.txt
 create mode 100644 libipathverbs/src/CMakeLists.txt
 create mode 100644 libmlx4/src/CMakeLists.txt
 create mode 100644 libmlx5/src/CMakeLists.txt
 create mode 100644 libmthca/src/CMakeLists.txt
 create mode 100644 libnes/src/CMakeLists.txt
 create mode 100644 libocrdma/src/CMakeLists.txt
 create mode 100644 librdmacm/examples/CMakeLists.txt
 create mode 100644 librdmacm/man/CMakeLists.txt
 create mode 100644 librdmacm/src/CMakeLists.txt
 create mode 100644 librxe/CMakeLists.txt
 create mode 100644 librxe/man/CMakeLists.txt
 create mode 100644 librxe/src/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
new file mode 100644
index 000000000000..568e819aa976
--- /dev/null
+++ b/CMakeLists.txt
@@ -0,0 +1,232 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+# Run cmake as:
+#  mkdir build
+#  cmake -GNinja ..
+#  ninja
+#
+# Common options passed to cmake are:
+#  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
+#      Write a compile_commands.json file for clang tooling
+#  -DCMAKE_BUILD_TYPE=RelWithDebInfo
+#      Change the optimization level, Debug disables optimization
+#  -DENABLE_VALGRIND=1 (default disabled)
+#      Embed valgrind notations, this has a tiny negative performance impact
+#  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
+#      Do not link to libnl and do not resolve neighbours internally for Ethernet.
+
+cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
+project(RDMA C)
+
+set(PACKAGE_NAME "RDMA")
+# FIXME versioning strategy?
+set(PACKAGE_VERSION "1")
+
+#-------------------------
+# Basic standard paths
+# C include root
+set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
+# Executables
+set(BUILD_BIN ${CMAKE_BINARY_DIR}/bin)
+# Libraries
+set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
+
+set(SYSCONFDIR "${CMAKE_INSTALL_PREFIX}/etc")
+# Location to place provider .driver files
+set(CONFIG_DIR "${SYSCONFDIR}/libibverbs.d")
+
+#-------------------------
+# Load CMake components
+set(BUILDLIB "${CMAKE_SOURCE_DIR}/buildlib")
+set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${BUILDLIB}")
+
+include(FindPkgConfig)
+include(CheckCCompilerFlag)
+include(CheckIncludeFile)
+include(RDMA_EnableCStd)
+include(RDMA_BuildType)
+include(RDMA_DoFixup)
+include(publish_headers)
+include(rdma_functions)
+
+#-------------------------
+# Setup the basic C compiler
+RDMA_BuildType()
+include_directories(${BUILD_INCLUDE})
+# FIXME: Eliminate HAVE_CONFIG_H, we always have it.
+add_definitions(-DHAVE_CONFIG_H)
+add_definitions(-DIBV_CONFIG_DIR="${CONFIG_DIR}")
+
+# Require GNU99 mode
+RDMA_EnableCStd()
+
+# The code does not do the racy fcntl if the various CLOEXEC's are not
+# supported so it really doesn't work right if this isn't available. Thus hard
+# require it.
+CHECK_C_SOURCE_COMPILES("
+ #include <sys/types.h>
+ #include <sys/stat.h>
+ #include <sys/socket.h>
+ #include <fcntl.h>
+ int main(int argc,const char *argv[]) {
+    open(\".\",O_RDONLY | O_CLOEXEC);
+    socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
+    return 0;
+ }" HAS_CLOEXEC)
+if (NOT HAS_CLOEXEC)
+  message(FATAL_ERROR "O_CLOEXEC/SOCK_CLOEXEC/fopen(..,\"e\") support is required but not found")
+endif()
+
+# always_inline is supported
+CHECK_C_SOURCE_COMPILES("
+ inline __attribute__((always_inline)) int foo(void) {return 0;}
+ int main(int argc,const char *argv[]) { return foo(); }"
+  HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
+  FAIL_REGEX "warning")
+
+# Enable development support features
+# Prune unneeded shared libraries during linking
+RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+
+# Ensure all shared ELFs have fully described linking
+RDMA_AddOptCFlag(CMAKE_EXEC_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+
+# Enable gold linker - gold has different linking checks
+#RDMA_AddOptCFlag(CMAKE_EXEC_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+
+# Verify that GNU --version-script and asm(".symver") works
+find_package(LDSymVer REQUIRED)
+
+#-------------------------
+# Find libraries
+# pthread
+FIND_PACKAGE (Threads REQUIRED)
+
+# libnl
+if ((NOT DEFINED ENABLE_RESOLVE_NEIGH) OR (ENABLE_RESOLVE_NEIGH))
+  # FIXME use of pkgconfig is discouraged
+  pkg_check_modules(NL3 libnl-3.0 libnl-route-3.0)
+  if (NOT NL3_FOUND)
+    # FIXME: I don't know why we have this fallback, all supported distros
+    # have libnl3
+    pkg_check_modules(NL1 libnl-1)
+    if (NOT NL1_FOUND)
+      message(FATAL_ERROR "Cannot find libnl-3.0 or libnl-1")
+    endif()
+    set(NL_KIND 1)
+    set(NL_INCLUDE_DIRS ${NL1_INCLUDE_DIRS})
+    set(NL_LIBRARIES ${NL1_LIBRARIES})
+  else()
+    set(NL_KIND 3)
+    set(NL_INCLUDE_DIRS ${NL3_INCLUDE_DIRS})
+    set(NL_LIBRARIES ${NL3_LIBRARIES})
+  endif()
+
+  include_directories(${NL_INCLUDE_DIRS})
+else()
+  set(NL_KIND 0)
+  set(NL_LIBRARIES "")
+endif()
+
+# Statically determine sizeof(long), this is largely unnecessary, no new code
+# should rely on this.
+CHECK_C_SOURCE_COMPILES("
+ char dummy[sizeof(long) == 8?1:-1];
+ int main(int argc,const char *argv[]) { return 0; }"
+  SIZEOF_LONG_8)
+if (NOT SIZEOF_LONG_8)
+  CHECK_C_SOURCE_COMPILES("
+   char dummy[sizeof(long) == 4?1:-1];
+   int main(int argc,const char *argv[]) { return 0; }"
+    SIZEOF_LONG_4)
+endif()
+if (SIZEOF_LONG_8)
+  set(SIZEOF_LONG 8)
+elseif(SIZEOF_LONG_4)
+  set(SIZEOF_LONG 4)
+else()
+  message(FATAL_ERROR "Could not determine sizeof(long)")
+endif()
+
+# Are our kernel headers new enough?
+# If not replace them with built-in copies so we can continue to build.
+CHECK_INCLUDE_FILE("rdma/rdma_user_rxe.h" HAVE_RDMA_USER_RXE)
+RDMA_DoFixup("${HAVE_RDMA_USER_RXE}" "rdma/rdma_user_rxe.h")
+
+#-------------------------
+# Apply fixups
+
+# FIXME: We should probably always enable memcheck.h, and only selectively
+# turn it off in the real high performance paths. There is no reason umad
+# should ever have memcheck disabled for instance.
+if (ENABLE_VALGRIND)
+  CHECK_INCLUDE_FILE("valgrind/memcheck.h" ENABLE_VALGRIND)
+endif()
+RDMA_DoFixup("${ENABLE_VALGRIND}" "valgrind/memcheck.h")
+
+#-------------------------
+# Build Prep
+# Write out a git ignore file to the build directory if it isn't the source
+# directory. For developer convenience
+if (NOT ${CMAKE_CURRENT_BINARY_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
+  file(WRITE ${CMAKE_BINARY_DIR}/.gitignore "*")
+endif()
+
+configure_file(${BUILDLIB}/config.h.in ${BUILD_INCLUDE}/config.h)
+
+#-------------------------
+# Sub-directories
+# Libraries
+add_subdirectory(libibumad/src)
+add_subdirectory(libibumad/man)
+add_subdirectory(libibverbs/src)
+add_subdirectory(libibverbs/man)
+add_subdirectory(librdmacm/src)
+add_subdirectory(librdmacm/man)
+add_subdirectory(libibcm/src)
+
+# Providers
+add_subdirectory(libcxgb3/src)
+add_subdirectory(libcxgb4/src)
+add_subdirectory(libhfi1verbs/src)
+add_subdirectory(libi40iw/src)
+add_subdirectory(libipathverbs/src)
+add_subdirectory(libipathverbs/)
+add_subdirectory(libmlx4/src)
+add_subdirectory(libmlx5/src)
+add_subdirectory(libmthca/src)
+add_subdirectory(libnes/src)
+add_subdirectory(libocrdma/src)
+add_subdirectory(librxe/src)
+add_subdirectory(librxe/man)
+add_subdirectory(librxe/)
+
+# Binaries
+add_subdirectory(libibcm/examples)
+add_subdirectory(libibumad/tests)
+add_subdirectory(libibverbs/examples)
+add_subdirectory(librdmacm/examples)
+
+rdma_finalize_libs()
+
+#-------------------------
+# Display a summary
+# Only report things that are non-ideal
+message(STATUS "Missing Optional Items:")
+if (NOT HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE)
+  message(STATUS " Compiler attribute always_inline NOT supported")
+endif()
+if (NOT ENABLE_VALGRIND)
+  message(STATUS " Valgrind memcheck.h NOT enabled")
+endif()
+if (NL_KIND EQUAL 1)
+  message(STATUS " libnl 3 NOT found (using libnl 1 compat)")
+endif()
+if (NL_KIND EQUAL 0)
+  message(STATUS " neighbour resolution NOT enabled")
+endif()
+if (NOT HAVE_RDMA_USER_RXE)
+  message(STATUS " rdma/rdma_user_rxe.h NOT found (old system kernel headers)")
+endif()
diff --git a/README.md b/README.md
new file mode 100644
index 000000000000..b3e9b20f7987
--- /dev/null
+++ b/README.md
@@ -0,0 +1,69 @@
+# RDMA Plumbing
+
+This is the userspace components for the Linux Kernel's drivers/infiniband
+subsystem. Specifically this contains the userspace libraries for the
+following device nodes:
+
+ - /dev/infiniband/uverbsX (libibverbs)
+ - /dev/infiniband/rdma_cm (librdmacm)
+ - /dev/infiniband/umadX (libumad)
+ - /dev/infiniband/ucmX (libibcm, deprecated)
+
+Further, the userspace component of the RDMA kernel drivers are included under
+the providers/ directory. Support for the following Kernel RDMA drivers is
+included:
+
+ - iw_cxgb3.ko
+ - iw_cxgb4.ko
+ - hfi1.ko
+ - i40iw.ko
+ - ib_qib.ko
+ - mlx4_ib.ko
+ - mlx5_ib.ko
+ - ib_mthca.ko
+ - iw_nes.ko
+ - ocrdma.ko
+ - rdma_rxe.ko
+
+# Building
+
+This project uses a cmake based build system. Quick start:
+
+```sh
+$ mkdir build
+$ cd build
+$ cmake -GNinja ..
+$ ninja
+```
+
+*build/bin* will contain the sample programs and *build/lib* will contain the
+shared libraries.
+
+NOTE: Fedora Core uses the name 'ninja-build' for the ninja command.
+
+NOTE: It is not currently easy to run from the build directory, the plugins
+only load from the system path.
+
+# Building on CentOS 6/7
+
+For end users, the package can be built using GNU Make and the old cmake
+included with the distro:
+
+```sh
+$ mkdir build
+$ cd build
+$ cmake  ..
+$ make
+```
+
+Developers are suggested to install more modern tooling for the best experience.
+
+```sh
+$ yum install epel-release
+$ yum install cmake3 unzip
+$ curl -OL https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip
+$ unzip ninja-linux.zip
+$ install -m755 ninja /usr/local/bin/ninja
+```
+
+Use the 'cmake3' program in place of `cmake` in the above instructions.
\ No newline at end of file
diff --git a/buildlib/FindLDSymVer.cmake b/buildlib/FindLDSymVer.cmake
new file mode 100644
index 000000000000..df86bb3aa31a
--- /dev/null
+++ b/buildlib/FindLDSymVer.cmake
@@ -0,0 +1,41 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+# find_package helper to detect symbol version support in the compiler and
+# linker. If supported then LDSYMVER_MODE will be set to GNU
+
+# Basic sample GNU style map file
+file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/test.map" "
+IBVERBS_1.0 {
+        global:
+                ibv_get_device_list;
+        local: *;
+};
+
+IBVERBS_1.1 {
+        global:
+                ibv_get_device_list;
+} IBVERBS_1.0;
+")
+
+set(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
+set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS} "-Wl,--version-script=${CMAKE_CURRENT_BINARY_DIR}/test.map")
+
+# And matching source, this also checks that .symver asm works
+check_c_source_compiles("
+void ibv_get_device_list_1(void){}
+asm(\".symver ibv_get_device_list_1, ibv_get_device_list @ IBVERBS_1.1\");
+void ibv_get_device_list_0(void){}
+asm(\".symver ibv_get_device_list_0, ibv_get_device_list @@ IBVERBS_1.0\");
+
+int main(void){return 0;}" _LDSYMVER_SUCCESS)
+file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/test.map")
+set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})
+
+if (_LDSYMVER_SUCCESS)
+  set(LDSYMVER_MODE "GNU" CACHE STRING "How to set symbol versions on shared libraries")
+endif()
+
+include(FindPackageHandleStandardArgs)
+find_package_handle_standard_args(
+  LDSymVer
+  REQUIRED_VARS LDSYMVER_MODE
+  )
diff --git a/buildlib/RDMA_BuildType.cmake b/buildlib/RDMA_BuildType.cmake
new file mode 100644
index 000000000000..f5dab4397709
--- /dev/null
+++ b/buildlib/RDMA_BuildType.cmake
@@ -0,0 +1,31 @@
+# COPYRIGHT (c) 2015 Obsidian Research Corporation. See COPYING file
+
+# Set the default build type to RelWithDebInfo. Since RDMA is typically used
+# in performance contexts it doesn't make much sense to have the default build
+# turn off the optimizer.
+function(RDMA_BuildType)
+  set(build_types Debug Release RelWithDebInfo MinSizeRel)
+
+  if(NOT CMAKE_BUILD_TYPE)
+    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE String
+      "Options are ${build_types}"
+      FORCE
+      )
+    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${build_types})
+  endif()
+
+  # Remove NDEBUG from all the default cmake configs, this disables assert,
+  # which we don't want to ever do.
+  foreach (build_config ${build_types})
+    string(TOUPPER ${build_config} upper_case_build_config)
+    foreach (language CXX C)
+      set(VAR_TO_MODIFY "CMAKE_${language}_FLAGS_${upper_case_build_config}")
+      string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )"
+	" "
+	replacement
+	"${${VAR_TO_MODIFY}}"
+	)
+      set(${VAR_TO_MODIFY} "${replacement}" CACHE STRING "Default flags for ${build_config} configuration" FORCE)
+    endforeach()
+  endforeach()
+endfunction()
diff --git a/buildlib/RDMA_DoFixup.cmake b/buildlib/RDMA_DoFixup.cmake
new file mode 100644
index 000000000000..1e30cf6c761b
--- /dev/null
+++ b/buildlib/RDMA_DoFixup.cmake
@@ -0,0 +1,21 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Execute a header fixup based on NOT_NEEDED for HEADER
+
+# The buildlib includes alternate header file shims for several scenarios, if
+# the build system detects a feature is present then it should call OrcDoFixup
+# with the test as true. If false then the shim header will be installed.
+
+# Typically the shim header will replace a missing header with stubs, or it
+# will augment an existing header with include_next.
+function(RDMA_DoFixup not_needed header)
+  set(DEST "${BUILD_INCLUDE}/${header}")
+  if (NOT "${not_needed}")
+    get_filename_component(DIR ${DEST} DIRECTORY)
+    file(MAKE_DIRECTORY "${DIR}")
+    string(REPLACE / - header-bl ${header})
+    execute_process(COMMAND "ln" "-Tsf" "${BUILDLIB}/fixup-include/${header-bl}" "${DEST}")
+  else()
+    file(REMOVE ${DEST})
+  endif()
+endfunction()
diff --git a/buildlib/RDMA_EnableCStd.cmake b/buildlib/RDMA_EnableCStd.cmake
new file mode 100644
index 000000000000..9cbbb881cd19
--- /dev/null
+++ b/buildlib/RDMA_EnableCStd.cmake
@@ -0,0 +1,23 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Test if the CC compiler supports the flag and if so add it to TO_VAR
+function(RDMA_AddOptCFlag TO_VAR CACHE_VAR FLAG)
+  CHECK_C_COMPILER_FLAG("${FLAG}" ${CACHE_VAR})
+  if (${CACHE_VAR})
+    SET(${TO_VAR} "${${TO_VAR}} ${FLAG}" PARENT_SCOPE)
+  endif()
+endfunction()
+
+# Enable the minimum required gnu99 standard in the compiler.
+function(RDMA_EnableCStd)
+  if (CMAKE_VERSION VERSION_LESS "3.1")
+    # Check for support of the usual flag
+    CHECK_C_COMPILER_FLAG("-std=gnu99" SUPPORTS_GNU99)
+    if (SUPPORTS_GNU99)
+      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99" PARENT_SCOPE)
+    endif()
+  else()
+    # Newer cmake can do this internally
+    set(CMAKE_C_STANDARD 99 PARENT_SCOPE)
+  endif()
+endfunction()
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
new file mode 100644
index 000000000000..1e487fc6aa6b
--- /dev/null
+++ b/buildlib/config.h.in
@@ -0,0 +1,29 @@
+// FIXME: Remove this, ibverbs is included so we don't need to detect
+#define HAVE_IBV_DOFORK_RANGE 1
+#define HAVE_IBV_DONTFORK_RANGE 1
+#define HAVE_IBV_REGISTER_DRIVER 1
+#define HAVE_IBV_READ_SYSFS_FILE 1
+
+// FIXME: Remove this, The cmake version hard-requires symbol version support
+#define HAVE_SYMVER_SUPPORT 1
+
+// FIXME: Remove this, The cmake version hard-requires new style CLOEXEC support
+#define STREAM_CLOEXEC "e"
+
+// FIXME: Remove this, cmake always provides a valgrind/memcheck.h
+#define HAVE_VALGRIND_MEMCHECK_H 1
+
+#define SYSCONFDIR "@SYSCONFDIR@"
+
+// FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
+#cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
+
+#cmakedefine SIZEOF_LONG @SIZEOF_LONG@
+
+#if @NL_KIND@ == 3
+# define HAVE_LIBNL3 1
+#elif @NL_KIND@ == 1
+# define HAVE_LIBNL1 1
+#elif @NL_KIND@ == 0
+# define NRESOLVE_NEIGH 1
+#endif
diff --git a/buildlib/fixup-include/rdma-rdma_user_rxe.h b/buildlib/fixup-include/rdma-rdma_user_rxe.h
new file mode 100644
index 000000000000..1de99cfdaf7d
--- /dev/null
+++ b/buildlib/fixup-include/rdma-rdma_user_rxe.h
@@ -0,0 +1,144 @@
+/*
+ * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef RDMA_USER_RXE_H
+#define RDMA_USER_RXE_H
+
+#include <linux/types.h>
+
+union rxe_gid {
+	__u8	raw[16];
+	struct {
+		__be64	subnet_prefix;
+		__be64	interface_id;
+	} global;
+};
+
+struct rxe_global_route {
+	union rxe_gid	dgid;
+	__u32		flow_label;
+	__u8		sgid_index;
+	__u8		hop_limit;
+	__u8		traffic_class;
+};
+
+struct rxe_av {
+	__u8			port_num;
+	__u8			network_type;
+	struct rxe_global_route	grh;
+	union {
+		struct sockaddr		_sockaddr;
+		struct sockaddr_in	_sockaddr_in;
+		struct sockaddr_in6	_sockaddr_in6;
+	} sgid_addr, dgid_addr;
+};
+
+struct rxe_send_wr {
+	__u64			wr_id;
+	__u32			num_sge;
+	__u32			opcode;
+	__u32			send_flags;
+	union {
+		__be32		imm_data;
+		__u32		invalidate_rkey;
+	} ex;
+	union {
+		struct {
+			__u64	remote_addr;
+			__u32	rkey;
+		} rdma;
+		struct {
+			__u64	remote_addr;
+			__u64	compare_add;
+			__u64	swap;
+			__u32	rkey;
+		} atomic;
+		struct {
+			__u32	remote_qpn;
+			__u32	remote_qkey;
+			__u16	pkey_index;
+		} ud;
+		struct {
+			struct ib_mr *mr;
+			__u32        key;
+			int          access;
+		} reg;
+	} wr;
+};
+
+struct rxe_sge {
+	__u64	addr;
+	__u32	length;
+	__u32	lkey;
+};
+
+struct mminfo {
+	__u64			offset;
+	__u32			size;
+	__u32			pad;
+};
+
+struct rxe_dma_info {
+	__u32			length;
+	__u32			resid;
+	__u32			cur_sge;
+	__u32			num_sge;
+	__u32			sge_offset;
+	union {
+		__u8		inline_data[0];
+		struct rxe_sge	sge[0];
+	};
+};
+
+struct rxe_send_wqe {
+	struct rxe_send_wr	wr;
+	struct rxe_av		av;
+	__u32			status;
+	__u32			state;
+	__u64			iova;
+	__u32			mask;
+	__u32			first_psn;
+	__u32			last_psn;
+	__u32			ack_length;
+	__u32			ssn;
+	__u32			has_rd_atomic;
+	struct rxe_dma_info	dma;
+};
+
+struct rxe_recv_wqe {
+	__u64			wr_id;
+	__u32			num_sge;
+	__u32			padding;
+	struct rxe_dma_info	dma;
+};
+
+#endif /* RDMA_USER_RXE_H */
diff --git a/buildlib/fixup-include/valgrind-memcheck.h b/buildlib/fixup-include/valgrind-memcheck.h
new file mode 100644
index 000000000000..6457a5a0f6a1
--- /dev/null
+++ b/buildlib/fixup-include/valgrind-memcheck.h
@@ -0,0 +1,5 @@
+static inline void VALGRIND_MAKE_MEM_DEFINED(const void *mem,size_t len) {}
+#define VALGRIND_MAKE_MEM_DEFINED VALGRIND_MAKE_MEM_DEFINED
+
+static inline void VALGRIND_MAKE_MEM_UNDEFINED(const void *mem,size_t len) {}
+#define VALGRIND_MAKE_MEM_UNDEFINED VALGRIND_MAKE_MEM_UNDEFINED
diff --git a/buildlib/provider.map b/buildlib/provider.map
new file mode 100644
index 000000000000..4ede3a8b1dc0
--- /dev/null
+++ b/buildlib/provider.map
@@ -0,0 +1,6 @@
+/* The providers do not export any symbols at all. Instead they rely on
+   attribute(constructor) to cause their init function to run at dlopen
+   time. */
+{
+	local: *;
+};
\ No newline at end of file
diff --git a/buildlib/publish_headers.cmake b/buildlib/publish_headers.cmake
new file mode 100644
index 000000000000..91fc386d0e64
--- /dev/null
+++ b/buildlib/publish_headers.cmake
@@ -0,0 +1,20 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Copy headers from the source directory to the proper place in the
+# build/include directory
+function(PUBLISH_HEADERS DEST)
+  if(NOT ARGN)
+    message(SEND_ERROR "Error: PUBLISH_HEADERS called without any files")
+    return()
+  endif()
+
+  set(DDIR "${BUILD_INCLUDE}/${DEST}")
+  file(MAKE_DIRECTORY "${DDIR}")
+
+  foreach(SFIL ${ARGN})
+    get_filename_component(FIL ${SFIL} NAME)
+    execute_process(COMMAND "ln" "-Tsf"
+      "${CMAKE_CURRENT_SOURCE_DIR}/${SFIL}" "${DDIR}/${FIL}")
+    install(FILES "${SFIL}" DESTINATION "include/${DEST}/" RENAME "${FIL}")
+  endforeach()
+endfunction()
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
new file mode 100644
index 000000000000..f698855563e9
--- /dev/null
+++ b/buildlib/rdma_functions.cmake
@@ -0,0 +1,242 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Helper functions for use in the sub CMakeLists files to make them simpler
+# and more uniform.
+
+# Global list of pairs of (SHARED STATIC) libary target names
+set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
+
+# Modify shared library target DEST to use VERSION_SCRIPT as the linker map file
+function(rdma_set_library_map DEST VERSION_SCRIPT)
+  if (NOT IS_ABSOLUTE ${VERSION_SCRIPT})
+    set(VERSION_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/${VERSION_SCRIPT}")
+  endif()
+  set_property(TARGET ${DEST} APPEND_STRING PROPERTY
+    LINK_FLAGS " -Wl,--version-script,${VERSION_SCRIPT}")
+
+  # NOTE: This won't work with ninja prior to cmake 3.4
+  set_property(TARGET ${DEST} APPEND_STRING PROPERTY
+    LINK_DEPENDS ${VERSION_SCRIPT})
+endfunction()
+
+# Basic function to produce a standard libary with a GNU LD version script.
+function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
+  # Create a static library
+  add_library(${DEST}-static STATIC ${ARGN})
+  set_target_properties(${DEST}-static PROPERTIES
+    OUTPUT_NAME ${DEST}
+    LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  install(TARGETS ${DEST}-static DESTINATION lib)
+
+  list(APPEND RDMA_STATIC_LIBS ${DEST} ${DEST}-static)
+  set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+
+  # Create a shared library
+  add_library(${DEST} SHARED ${ARGN})
+  rdma_set_library_map(${DEST} ${VERSION_SCRIPT})
+  set_target_properties(${DEST} PROPERTIES
+    SOVERSION ${SOVERSION}
+    VERSION ${VERSION}
+    LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  install(TARGETS ${DEST} DESTINATION lib)
+endfunction()
+
+# Create a provider shared library for libibverbs
+function(rdma_provider DEST)
+  # Installed driver file
+  install(CODE "file(MAKE_DIRECTORY \"\$ENV{DESTDIR}${CONFIG_DIR}/\")")
+  install(CODE "file(WRITE \$ENV{DESTDIR}${CONFIG_DIR}/${DEST}.driver \"driver ${DEST}\\n\")")
+
+  # Uninstalled driver file
+  file(MAKE_DIRECTORY "${BUILD_LIB}/libibverbs.d/")
+  file(WRITE "${BUILD_LIB}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/${DEST}\n")
+
+  # FIXME: This symlink is provided for compat with the old build, but it
+  # never should have existed in the first place, nothing should use this
+  # name, we can probably remove it.
+  install(CODE "execute_process(COMMAND ln -sTf lib${DEST}-rdmav2.so \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/lib/lib${DEST}.so\")")
+
+  # Create a static provider library
+  add_library(${DEST} STATIC ${ARGN})
+  set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  install(TARGETS ${DEST} DESTINATION lib)
+
+  list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
+  set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+
+  # Create the plugin shared library
+  set(DEST ${DEST}-rdmav2)
+  add_library(${DEST} MODULE ${ARGN})
+  rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
+  target_link_libraries(${DEST} PRIVATE ibverbs)
+  target_link_libraries(${DEST} PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+  set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  # Provider Plugins do not use SONAME versioning, there is no reason to
+  # create the usual symlinks.
+
+  install(TARGETS ${DEST} DESTINATION lib)
+endfunction()
+
+ # Create an installed executable
+function(rdma_executable EXEC)
+  add_executable(${EXEC} ${ARGN})
+  set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
+  install(TARGETS ${EXEC} DESTINATION bin)
+endfunction()
+
+# Create an test executable (not-installed)
+function(rdma_test_executable EXEC)
+  add_executable(${EXEC} ${ARGN})
+  set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
+endfunction()
+
+# Install man pages. This deduces the section from the trailing integer in the
+# filename
+function(rdma_man_pages)
+  foreach(I ${ARGN})
+    string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT ${I})
+    install(FILES ${I} DESTINATION "share/man/man${MAN_SECT}/")
+  endforeach()
+endfunction()
+
+# Create an alias for a man page, using a symlink.
+# Input is a list of pairs of names (MAN_PAGE ALIAS)
+# NOTE: The section must currently be the same for both.
+function(rdma_alias_man_pages)
+  list(LENGTH ARGN LEN)
+  math(EXPR LEN ${LEN}-1)
+  foreach(I RANGE 0 ${LEN} 2)
+    list(GET ARGN ${I} FROM)
+    math(EXPR I ${I}+1)
+    list(GET ARGN ${I} TO)
+    string(REGEX REPLACE "^.+[.](.+)$" "\\1" MAN_SECT ${FROM})
+    install(CODE "execute_process(COMMAND ln -sTf ${FROM} \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/share/man/man${MAN_SECT}/${TO}\")")
+  endforeach()
+endfunction()
+
+# For compatability write out a libtool .la file. This is only meaningful if
+# the end user is statically linking, and only if the library has dependent
+# libraries.
+
+# FIXME: it isn't clear how this is actually useful for provider libraries and
+# libibverbs itself, the user must do some trick to get the constructor to run
+# in the provider, at least how to do that should be documented someplace..
+function(rdma_make_libtool_la SHARED STATIC LIBS)
+  get_property(LIB TARGET ${STATIC} PROPERTY OUTPUT_NAME SET)
+  if (LIB)
+    get_target_property(LIB ${STATIC} OUTPUT_NAME)
+  else()
+    set(LIB ${STATIC})
+  endif()
+
+  set(BARE_LAFN "${CMAKE_STATIC_LIBRARY_PREFIX}${LIB}.la")
+  set(BARE_LIBFN "${CMAKE_STATIC_LIBRARY_PREFIX}${LIB}${CMAKE_STATIC_LIBRARY_SUFFIX}")
+
+  get_property(SOLIB TARGET ${SHARED} PROPERTY OUTPUT_NAME SET)
+  if (SOLIB)
+    get_target_property(SOLIB ${SHARED} OUTPUT_NAME)
+  else()
+    set(SOLIB ${SHARED})
+  endif()
+
+  set(DLNAME "${CMAKE_SHARED_LIBRARY_PREFIX}${SOLIB}${CMAKE_SHARED_LIBRARY_SUFFIX}")
+  get_property(TMP TARGET ${SHARED} PROPERTY SOVERSION SET)
+  if (TMP)
+    get_target_property(VERSION ${SHARED} VERSION)
+    get_target_property(SOVERSION ${SHARED} SOVERSION)
+    set(NAMES "${DLNAME}.${VERSION} ${DLNAME}.${SOVERSION} ${DLNAME}")
+    set(DLNAME "${DLNAME}.${SOVERSION}")
+  else()
+    set(NAMES "${DLNAME}")
+    set(DLNAME "${CMAKE_SHARED_LIBRARY_PREFIX}${SOLIB}${CMAKE_SHARED_LIBRARY_SUFFIX}")
+  endif()
+
+  if (LIBS)
+    list(REMOVE_DUPLICATES LIBS)
+    foreach(I ${LIBS})
+      if (I MATCHES "^-l")
+	list(APPEND DEPS "${I}")
+      else()
+	list(APPEND DEPS "-l${I}")
+      endif()
+    endforeach()
+    string(REPLACE ";" " " DEPS "${DEPS}")
+  endif()
+
+  set(LAFN "${BUILD_LIB}/${BARE_LAFN}")
+  file(WRITE ${LAFN}
+    "# ${BARE_LAFN} - a libtool library file\n"
+    "# Generated by cmake\n"
+    "#\n"
+    "# Please DO NOT delete this file!\n"
+    "# It is necessary for linking the library.\n"
+    "\n"
+    "# The name that we can dlopen(3).\n"
+    "dlname='${DLNAME}'\n"
+    "\n"
+    "# Names of this library.\n"
+    "library_names='${NAMES}'\n"
+    "\n"
+    "# The name of the static archive.\n"
+    "old_library='${BARE_LIBFN}'\n"
+    "\n"
+    "# Linker flags that can not go in dependency_libs.\n"
+    "inherited_linker_flags=''\n"
+    "\n"
+    "# Libraries that this one depends upon.\n"
+    "dependency_libs='${DEPS}'\n"
+    "\n"
+    "# Names of additional weak libraries provided by this library\n"
+    "weak_library_names=''\n"
+    "\n"
+    "# Version information for ${CMAKE_STATIC_LIBRARY_PREFIX}${LIB}.\n"
+    # We don't try very hard to emulate this, it isn't used for static linking anyhow
+    "current=${SOVERSION}\n"
+    "age=0\n"
+    "revision=0\n"
+    "\n"
+    "# Is this an already installed library?\n"
+    "installed=yes\n"
+    "\n"
+    "# Should we warn about portability when linking against -modules?\n"
+    "shouldnotlink=no\n"
+    "\n"
+    "# Files to dlopen/dlpreopen\n"
+    "dlopen=''\n"
+    "dlpreopen=''\n"
+    "\n"
+    "# Directory that this library needs to be installed in:\n"
+    "libdir='${CMAKE_INSTALL_PREFIX}/lib'\n"
+    )
+  install(FILES ${LAFN} DESTINATION "lib/")
+endfunction()
+
+# Finalize the setup of the static libraries by copying the meta information
+# from the shared and setting up the libtool .la files.
+function(rdma_finalize_libs)
+  list(LENGTH RDMA_STATIC_LIBS LEN)
+  math(EXPR LEN ${LEN}-1)
+  foreach(I RANGE 0 ${LEN} 2)
+    list(GET RDMA_STATIC_LIBS ${I} SHARED)
+    math(EXPR I ${I}+1)
+    list(GET RDMA_STATIC_LIBS ${I} STATIC)
+
+    # PUBLIC libraries
+    get_property(TMP TARGET ${SHARED} PROPERTY INTERFACE_LINK_LIBRARIES SET)
+    if (TMP)
+      get_target_property(TMP ${SHARED} INTERFACE_LINK_LIBRARIES)
+      set_target_properties(${STATIC} PROPERTIES INTERFACE_LINK_LIBRARIES "${TMP}")
+      set(LIBS "${TMP}")
+    endif()
+
+    # PRIVATE libraries
+    get_property(TMP TARGET ${SHARED} PROPERTY LINK_LIBRARIES SET)
+    if (TMP)
+      get_target_property(TMP ${SHARED} LINK_LIBRARIES)
+      set_target_properties(${STATIC} PROPERTIES LINK_LIBRARIES "${TMP}")
+      list(APPEND LIBS "${TMP}")
+    endif()
+
+    rdma_make_libtool_la(${SHARED} ${STATIC} "${LIBS}")
+  endforeach()
+endfunction()
diff --git a/libcxgb3/src/CMakeLists.txt b/libcxgb3/src/CMakeLists.txt
new file mode 100644
index 000000000000..a578105e7b28
--- /dev/null
+++ b/libcxgb3/src/CMakeLists.txt
@@ -0,0 +1,6 @@
+rdma_provider(cxgb3
+  cq.c
+  iwch.c
+  qp.c
+  verbs.c
+)
diff --git a/libcxgb4/src/CMakeLists.txt b/libcxgb4/src/CMakeLists.txt
new file mode 100644
index 000000000000..79da381210e6
--- /dev/null
+++ b/libcxgb4/src/CMakeLists.txt
@@ -0,0 +1,6 @@
+rdma_provider(cxgb4
+  cq.c
+  dev.c
+  qp.c
+  verbs.c
+)
diff --git a/libhfi1verbs/src/CMakeLists.txt b/libhfi1verbs/src/CMakeLists.txt
new file mode 100644
index 000000000000..702bb5e23b30
--- /dev/null
+++ b/libhfi1verbs/src/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_provider(hfi1verbs
+  hfiverbs.c
+  verbs.c
+  )
diff --git a/libi40iw/src/CMakeLists.txt b/libi40iw/src/CMakeLists.txt
new file mode 100644
index 000000000000..d8a3a3c2c414
--- /dev/null
+++ b/libi40iw/src/CMakeLists.txt
@@ -0,0 +1,5 @@
+rdma_provider(i40iw
+  i40iw_uk.c
+  i40iw_umain.c
+  i40iw_uverbs.c
+)
diff --git a/libibcm/examples/CMakeLists.txt b/libibcm/examples/CMakeLists.txt
new file mode 100644
index 000000000000..a90639dae768
--- /dev/null
+++ b/libibcm/examples/CMakeLists.txt
@@ -0,0 +1,2 @@
+rdma_test_executable(cmpost cmpost.c)
+target_link_libraries(cmpost ibcm rdmacm)
diff --git a/libibcm/src/CMakeLists.txt b/libibcm/src/CMakeLists.txt
new file mode 100644
index 000000000000..01f85c0ea638
--- /dev/null
+++ b/libibcm/src/CMakeLists.txt
@@ -0,0 +1,9 @@
+publish_headers(infiniband
+  ../include/infiniband/cm.h
+  ../include/infiniband/cm_abi.h
+  )
+
+rdma_library(ibcm libibcm.map 1 1.0.0
+  cm.c
+  )
+target_link_libraries(ibcm PUBLIC ibverbs)
diff --git a/libibumad/man/CMakeLists.txt b/libibumad/man/CMakeLists.txt
new file mode 100644
index 000000000000..b7a191261ec0
--- /dev/null
+++ b/libibumad/man/CMakeLists.txt
@@ -0,0 +1,42 @@
+rdma_man_pages(
+  umad_addr_dump.3
+  umad_alloc.3
+  umad_attribute_str.3
+  umad_class_str.3
+  umad_close_port.3
+  umad_debug.3
+  umad_dump.3
+  umad_free.3
+  umad_get_ca.3
+  umad_get_ca_portguids.3
+  umad_get_cas_names.3
+  umad_get_fd.3
+  umad_get_issm_path.3
+  umad_get_mad.3
+  umad_get_mad_addr.3
+  umad_get_pkey.3
+  umad_get_port.3
+  umad_init.3
+  umad_mad_status_str.3
+  umad_method_str.3
+  umad_open_port.3
+  umad_poll.3
+  umad_recv.3
+  umad_register.3
+  umad_register2.3
+  umad_register_oui.3
+  umad_send.3
+  umad_set_addr.3
+  umad_set_addr_net.3
+  umad_set_grh.3
+  umad_set_grh_net.3
+  umad_set_pkey.3
+  umad_size.3
+  umad_status.3
+  umad_unregister.3
+  )
+rdma_alias_man_pages(
+  umad_get_ca.3 umad_release_ca.3
+  umad_get_port.3 umad_release_port.3
+  umad_init.3 umad_done.3
+  )
\ No newline at end of file
diff --git a/libibumad/src/CMakeLists.txt b/libibumad/src/CMakeLists.txt
new file mode 100644
index 000000000000..b7b5d03bc53e
--- /dev/null
+++ b/libibumad/src/CMakeLists.txt
@@ -0,0 +1,14 @@
+publish_headers(infiniband
+  ../include/infiniband/umad.h
+  ../include/infiniband/umad_cm.h
+  ../include/infiniband/umad_sa.h
+  ../include/infiniband/umad_sm.h
+  ../include/infiniband/umad_str.h
+  ../include/infiniband/umad_types.h
+  )
+
+rdma_library(ibumad libibumad.map 3 3.1.0
+  sysfs.c
+  umad.c
+  umad_str.c
+  )
diff --git a/libibumad/tests/CMakeLists.txt b/libibumad/tests/CMakeLists.txt
new file mode 100644
index 000000000000..9676029c8688
--- /dev/null
+++ b/libibumad/tests/CMakeLists.txt
@@ -0,0 +1,5 @@
+rdma_test_executable(umad_reg2 umad_reg2_compat.c)
+target_link_libraries(umad_reg2 ibumad)
+
+rdma_test_executable(umad_register2 umad_register2.c)
+target_link_libraries(umad_register2 ibumad)
diff --git a/libibverbs/examples/CMakeLists.txt b/libibverbs/examples/CMakeLists.txt
new file mode 100644
index 000000000000..5d0df01ca959
--- /dev/null
+++ b/libibverbs/examples/CMakeLists.txt
@@ -0,0 +1,29 @@
+# Shared example files
+add_library(ibverbs_tools STATIC
+  pingpong.c
+  )
+
+rdma_executable(ibv_asyncwatch asyncwatch.c)
+target_link_libraries(ibv_asyncwatch ibverbs)
+
+rdma_executable(ibv_devices device_list.c)
+target_link_libraries(ibv_devices ibverbs)
+
+rdma_executable(ibv_devinfo devinfo.c)
+target_link_libraries(ibv_devinfo ibverbs)
+
+# FIXME: pingpong.o should be a object library
+rdma_executable(ibv_rc_pingpong rc_pingpong.c)
+target_link_libraries(ibv_rc_pingpong ibverbs ibverbs_tools)
+
+rdma_executable(ibv_srq_pingpong srq_pingpong.c)
+target_link_libraries(ibv_srq_pingpong ibverbs ibverbs_tools)
+
+rdma_executable(ibv_uc_pingpong uc_pingpong.c)
+target_link_libraries(ibv_uc_pingpong ibverbs ibverbs_tools)
+
+rdma_executable(ibv_ud_pingpong ud_pingpong.c)
+target_link_libraries(ibv_ud_pingpong ibverbs ibverbs_tools)
+
+rdma_executable(ibv_xsrq_pingpong xsrq_pingpong.c)
+target_link_libraries(ibv_xsrq_pingpong ibverbs ibverbs_tools)
diff --git a/libibverbs/man/CMakeLists.txt b/libibverbs/man/CMakeLists.txt
new file mode 100644
index 000000000000..e9d757a77f34
--- /dev/null
+++ b/libibverbs/man/CMakeLists.txt
@@ -0,0 +1,78 @@
+rdma_man_pages(
+  ibv_alloc_mw.3
+  ibv_alloc_pd.3
+  ibv_asyncwatch.1
+  ibv_attach_mcast.3
+  ibv_bind_mw.3
+  ibv_create_ah.3
+  ibv_create_ah_from_wc.3
+  ibv_create_comp_channel.3
+  ibv_create_cq.3
+  ibv_create_cq_ex.3
+  ibv_create_flow.3
+  ibv_create_qp.3
+  ibv_create_qp_ex.3
+  ibv_create_srq.3
+  ibv_create_srq_ex.3
+  ibv_devices.1
+  ibv_devinfo.1
+  ibv_event_type_str.3
+  ibv_fork_init.3
+  ibv_get_async_event.3
+  ibv_get_cq_event.3
+  ibv_get_device_guid.3
+  ibv_get_device_list.3
+  ibv_get_device_name.3
+  ibv_get_srq_num.3
+  ibv_inc_rkey.3
+  ibv_modify_qp.3
+  ibv_modify_srq.3
+  ibv_open_device.3
+  ibv_open_qp.3
+  ibv_open_xrcd.3
+  ibv_poll_cq.3
+  ibv_post_recv.3
+  ibv_post_send.3
+  ibv_post_srq_recv.3
+  ibv_query_device.3
+  ibv_query_device_ex.3
+  ibv_query_gid.3
+  ibv_query_pkey.3
+  ibv_query_port.3
+  ibv_query_qp.3
+  ibv_query_rt_values_ex.3
+  ibv_query_srq.3
+  ibv_rate_to_mbps.3
+  ibv_rate_to_mult.3
+  ibv_rc_pingpong.1
+  ibv_reg_mr.3
+  ibv_req_notify_cq.3
+  ibv_rereg_mr.3
+  ibv_resize_cq.3
+  ibv_srq_pingpong.1
+  ibv_uc_pingpong.1
+  ibv_ud_pingpong.1
+  ibv_xsrq_pingpong.1
+  )
+rdma_alias_man_pages(
+  ibv_alloc_mw.3 ibv_dealloc_mw.3
+  ibv_alloc_pd.3 ibv_dealloc_pd.3
+  ibv_attach_mcast.3 ibv_detach_mcast.3
+  ibv_create_ah.3 ibv_destroy_ah.3
+  ibv_create_ah_from_wc.3 ibv_init_ah_from_wc.3
+  ibv_create_comp_channel.3 ibv_destroy_comp_channel.3
+  ibv_create_cq.3 ibv_destroy_cq.3
+  ibv_create_flow.3 ibv_destroy_flow.3
+  ibv_create_qp.3 ibv_destroy_qp.3
+  ibv_create_srq.3 ibv_destroy_srq.3
+  ibv_event_type_str.3 ibv_node_type_str.3
+  ibv_event_type_str.3 ibv_port_state_str.3
+  ibv_get_async_event.3 ibv_ack_async_event.3
+  ibv_get_cq_event.3 ibv_ack_cq_events.3
+  ibv_get_device_list.3 ibv_free_device_list.3
+  ibv_open_device.3 ibv_close_device.3
+  ibv_open_xrcd.3 ibv_close_xrcd.3
+  ibv_rate_to_mbps.3 mbps_to_ibv_rate.3
+  ibv_rate_to_mult.3 mult_to_ibv_rate.3
+  ibv_reg_mr.3 ibv_dereg_mr.3
+  )
\ No newline at end of file
diff --git a/libibverbs/src/CMakeLists.txt b/libibverbs/src/CMakeLists.txt
new file mode 100644
index 000000000000..5e680da430c1
--- /dev/null
+++ b/libibverbs/src/CMakeLists.txt
@@ -0,0 +1,34 @@
+publish_headers(infiniband
+  ../include/infiniband/arch.h
+  ../include/infiniband/driver.h
+  ../include/infiniband/kern-abi.h
+  ../include/infiniband/marshall.h
+  ../include/infiniband/opcode.h
+  ../include/infiniband/sa-kern-abi.h
+  ../include/infiniband/sa.h
+  ../include/infiniband/verbs.h
+  )
+
+if (NOT NL_KIND EQUAL 0)
+  set(NEIGH "neigh.c")
+else()
+  set(NEIGH "")
+endif()
+
+rdma_library(ibverbs libibverbs.map 1 1.0.0
+  cmd.c
+  compat-1_0.c
+  device.c
+  enum_strs.c
+  init.c
+  marshall.c
+  memory.c
+  ${NEIGH}
+  sysfs.c
+  verbs.c
+  )
+target_link_libraries(ibverbs PRIVATE
+  ${NL_LIBRARIES}
+  ${CMAKE_THREAD_LIBS_INIT}
+  ${CMAKE_DL_LIBS}
+  )
diff --git a/libipathverbs/CMakeLists.txt b/libipathverbs/CMakeLists.txt
new file mode 100644
index 000000000000..eba006e4c409
--- /dev/null
+++ b/libipathverbs/CMakeLists.txt
@@ -0,0 +1,4 @@
+install(FILES truescale.conf DESTINATION "${SYSCONFDIR}/modprobe.d/")
+install(FILES truescale-serdes.cmds
+  DESTINATION "sbin/"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
diff --git a/libipathverbs/src/CMakeLists.txt b/libipathverbs/src/CMakeLists.txt
new file mode 100644
index 000000000000..20924fda7900
--- /dev/null
+++ b/libipathverbs/src/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_provider(ipathverbs
+  ipathverbs.c
+  verbs.c
+  )
diff --git a/libmlx4/src/CMakeLists.txt b/libmlx4/src/CMakeLists.txt
new file mode 100644
index 000000000000..d64d817479bf
--- /dev/null
+++ b/libmlx4/src/CMakeLists.txt
@@ -0,0 +1,9 @@
+rdma_provider(mlx4
+  buf.c
+  cq.c
+  dbrec.c
+  mlx4.c
+  qp.c
+  srq.c
+  verbs.c
+)
diff --git a/libmlx5/src/CMakeLists.txt b/libmlx5/src/CMakeLists.txt
new file mode 100644
index 000000000000..a34a8063eeb2
--- /dev/null
+++ b/libmlx5/src/CMakeLists.txt
@@ -0,0 +1,9 @@
+rdma_provider(mlx5
+  buf.c
+  cq.c
+  dbrec.c
+  mlx5.c
+  qp.c
+  srq.c
+  verbs.c
+)
diff --git a/libmthca/src/CMakeLists.txt b/libmthca/src/CMakeLists.txt
new file mode 100644
index 000000000000..63d714704144
--- /dev/null
+++ b/libmthca/src/CMakeLists.txt
@@ -0,0 +1,10 @@
+rdma_provider(mthca
+  ah.c
+  buf.c
+  cq.c
+  memfree.c
+  mthca.c
+  qp.c
+  srq.c
+  verbs.c
+)
diff --git a/libnes/src/CMakeLists.txt b/libnes/src/CMakeLists.txt
new file mode 100644
index 000000000000..0c7fa8fad09f
--- /dev/null
+++ b/libnes/src/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_provider(nes
+  nes_umain.c
+  nes_uverbs.c
+)
diff --git a/libocrdma/src/CMakeLists.txt b/libocrdma/src/CMakeLists.txt
new file mode 100644
index 000000000000..08623adb4a6f
--- /dev/null
+++ b/libocrdma/src/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_provider(ocrdma
+  ocrdma_main.c
+  ocrdma_verbs.c
+  )
diff --git a/librdmacm/examples/CMakeLists.txt b/librdmacm/examples/CMakeLists.txt
new file mode 100644
index 000000000000..31c9606383a0
--- /dev/null
+++ b/librdmacm/examples/CMakeLists.txt
@@ -0,0 +1,43 @@
+# Shared example files
+add_library(rdmacm_tools STATIC
+  common.c
+  )
+
+rdma_executable(cmtime cmtime.c)
+target_link_libraries(cmtime rdmacm ${CMAKE_THREAD_LIBS_INIT} rdmacm_tools)
+
+rdma_executable(mckey mckey.c)
+target_link_libraries(mckey rdmacm ${CMAKE_THREAD_LIBS_INIT})
+
+rdma_executable(rcopy rcopy.c)
+target_link_libraries(rcopy rdmacm)
+
+rdma_executable(rdma_client rdma_client.c)
+target_link_libraries(rdma_client rdmacm)
+
+rdma_executable(rdma_server rdma_server.c)
+target_link_libraries(rdma_server rdmacm)
+
+rdma_executable(rdma_xclient rdma_xclient.c)
+target_link_libraries(rdma_xclient rdmacm)
+
+rdma_executable(rdma_xserver rdma_xserver.c)
+target_link_libraries(rdma_xserver rdmacm)
+
+rdma_executable(riostream riostream.c)
+target_link_libraries(riostream rdmacm rdmacm_tools)
+
+rdma_executable(rping rping.c)
+target_link_libraries(rping rdmacm ${CMAKE_THREAD_LIBS_INIT})
+
+rdma_executable(rstream rstream.c)
+target_link_libraries(rstream rdmacm rdmacm_tools)
+
+rdma_executable(ucmatose cmatose.c)
+target_link_libraries(ucmatose rdmacm rdmacm_tools)
+
+rdma_executable(udaddy udaddy.c)
+target_link_libraries(udaddy rdmacm rdmacm_tools)
+
+rdma_executable(udpong udpong.c)
+target_link_libraries(udpong rdmacm rdmacm_tools)
diff --git a/librdmacm/man/CMakeLists.txt b/librdmacm/man/CMakeLists.txt
new file mode 100644
index 000000000000..791c98265ad0
--- /dev/null
+++ b/librdmacm/man/CMakeLists.txt
@@ -0,0 +1,65 @@
+rdma_man_pages(
+  mckey.1
+  rcopy.1
+  rdma_accept.3
+  rdma_ack_cm_event.3
+  rdma_bind_addr.3
+  rdma_client.1
+  rdma_cm.7
+  rdma_connect.3
+  rdma_create_ep.3
+  rdma_create_event_channel.3
+  rdma_create_id.3
+  rdma_create_qp.3
+  rdma_create_srq.3
+  rdma_dereg_mr.3
+  rdma_destroy_ep.3
+  rdma_destroy_event_channel.3
+  rdma_destroy_id.3
+  rdma_destroy_qp.3
+  rdma_destroy_srq.3
+  rdma_disconnect.3
+  rdma_event_str.3
+  rdma_free_devices.3
+  rdma_get_cm_event.3
+  rdma_get_devices.3
+  rdma_get_dst_port.3
+  rdma_get_local_addr.3
+  rdma_get_peer_addr.3
+  rdma_get_recv_comp.3
+  rdma_get_request.3
+  rdma_get_send_comp.3
+  rdma_get_src_port.3
+  rdma_getaddrinfo.3
+  rdma_join_multicast.3
+  rdma_leave_multicast.3
+  rdma_listen.3
+  rdma_migrate_id.3
+  rdma_notify.3
+  rdma_post_read.3
+  rdma_post_readv.3
+  rdma_post_recv.3
+  rdma_post_recvv.3
+  rdma_post_send.3
+  rdma_post_sendv.3
+  rdma_post_ud_send.3
+  rdma_post_write.3
+  rdma_post_writev.3
+  rdma_reg_msgs.3
+  rdma_reg_read.3
+  rdma_reg_write.3
+  rdma_reject.3
+  rdma_resolve_addr.3
+  rdma_resolve_route.3
+  rdma_server.1
+  rdma_set_option.3
+  rdma_xclient.1
+  rdma_xserver.1
+  riostream.1
+  rping.1
+  # FIXME: rsocket has a text substitution but nothing ever filled it in.
+  rsocket.7
+  rstream.1
+  ucmatose.1
+  udaddy.1
+  )
diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/src/CMakeLists.txt
new file mode 100644
index 000000000000..c68b277f8c1c
--- /dev/null
+++ b/librdmacm/src/CMakeLists.txt
@@ -0,0 +1,39 @@
+publish_headers(rdma
+  ../include/rdma/rdma_cma.h
+  ../include/rdma/rdma_cma_abi.h
+  ../include/rdma/rdma_verbs.h
+  ../include/rdma/rsocket.h
+  )
+publish_headers(infiniband
+  ../include/infiniband/ib.h
+  )
+
+rdma_library(rdmacm librdmacm.map 1 1.0.0
+  acm.c
+  addrinfo.c
+  cma.c
+  indexer.c
+  rsocket.c
+  )
+target_link_libraries(rdmacm PUBLIC ibverbs)
+target_link_libraries(rdmacm PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+
+# The preload library is a bit special, it needs to be open coded
+# Since it is a LD_PRELOAD it has no soname, and is installed in sub dir
+add_library(rspreload SHARED
+  preload.c
+  indexer.c
+  )
+set_target_properties(rspreload PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+rdma_set_library_map(rspreload librspreload.map)
+target_link_libraries(rspreload PRIVATE
+  rdmacm
+  ${CMAKE_THREAD_LIBS_INIT}
+  ${CMAKE_DL_LIBS}
+)
+install(TARGETS rspreload DESTINATION lib/rsocket/)
+
+# These are for compat with old packaging, these name should not be used.
+# FIXME: Maybe we can get rid of them?
+install(CODE "execute_process(COMMAND ln -sTf librspreload.so \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/lib/rsocket/librspreload.so.1\")")
+install(CODE "execute_process(COMMAND ln -sTf librspreload.so \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/lib/rsocket/librspreload.so.1.0.0\")")
diff --git a/librxe/CMakeLists.txt b/librxe/CMakeLists.txt
new file mode 100644
index 000000000000..d736c67e53d9
--- /dev/null
+++ b/librxe/CMakeLists.txt
@@ -0,0 +1,4 @@
+install(FILES rxe_cfg
+  DESTINATION bin/
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE
+  )
diff --git a/librxe/man/CMakeLists.txt b/librxe/man/CMakeLists.txt
new file mode 100644
index 000000000000..69e8bd8cf20c
--- /dev/null
+++ b/librxe/man/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_man_pages(
+  rxe.7
+  rxe_cfg.8
+)
diff --git a/librxe/src/CMakeLists.txt b/librxe/src/CMakeLists.txt
new file mode 100644
index 000000000000..d8f3265176e4
--- /dev/null
+++ b/librxe/src/CMakeLists.txt
@@ -0,0 +1,3 @@
+rdma_provider(rxe
+  rxe.c
+  )
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
