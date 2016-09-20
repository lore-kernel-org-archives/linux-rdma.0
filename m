From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 08/16] Unified CMake build system
Date: Tue, 20 Sep 2016 16:10:17 -0600
Message-ID: <1474409425-15769-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This replaces the various autoconf/automake/libtool based schemes
unified cmake based scheme.

At this commit both schemes exist in the tree and can be run concurrently.
Except for the differences noted below they produce identical
'make install' and identical intput to cpp. This commit is intended
to be nearly 'no change' in terms of building.

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
 - NDEBUG is controlled globally.
   Previously only libcxgb4 explicitly defined it
   Distros force this to be set during package built so this is no
   change
 - libtool *.la files are produced by cmake since libtool is not used
   and have a few minor differences:
   - Providers do not list the 'libX.so' bogus name, the .so is called
     libX-rdmav2.so
   - version information (current/age/revision) is bogus
   - The .la files are not marked executable

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                              | 293 ++++++++++++++++++++++++
 COPYING                                     |   6 +
 COPYING.BSD                                 |  26 +++
 COPYING.GPL2                                | 339 ++++++++++++++++++++++++++++
 README.md                                   |  97 ++++++++
 buildlib/FindLDSymVer.cmake                 |  41 ++++
 buildlib/RDMA_DoFixup.cmake                 |  21 ++
 buildlib/RDMA_EnableCStd.cmake              |  23 ++
 buildlib/config.h.in                        |  35 +++
 buildlib/fixup-include/rdma-rdma_user_rxe.h | 144 ++++++++++++
 buildlib/fixup-include/valgrind-drd.h       |   3 +
 buildlib/fixup-include/valgrind-memcheck.h  |   5 +
 buildlib/provider.map                       |   6 +
 buildlib/publish_headers.cmake              |  20 ++
 buildlib/rdma_functions.cmake               | 279 +++++++++++++++++++++++
 ibacm/CMakeLists.txt                        |  69 ++++++
 iwpmd/src/CMakeLists.txt                    |  12 +
 libcxgb3/src/CMakeLists.txt                 |   6 +
 libcxgb4/src/CMakeLists.txt                 |   8 +
 libhfi1verbs/src/CMakeLists.txt             |   4 +
 libi40iw/src/CMakeLists.txt                 |   5 +
 libibcm/examples/CMakeLists.txt             |   2 +
 libibcm/src/CMakeLists.txt                  |   9 +
 libibumad/man/CMakeLists.txt                |  42 ++++
 libibumad/src/CMakeLists.txt                |  14 ++
 libibumad/tests/CMakeLists.txt              |   5 +
 libibverbs/examples/CMakeLists.txt          |  31 +++
 libibverbs/man/CMakeLists.txt               |  83 +++++++
 libibverbs/src/CMakeLists.txt               |  36 +++
 libipathverbs/CMakeLists.txt                |   4 +
 libipathverbs/src/CMakeLists.txt            |   4 +
 libmlx4/src/CMakeLists.txt                  |   9 +
 libmlx5/src/CMakeLists.txt                  |   9 +
 libmthca/src/CMakeLists.txt                 |  10 +
 libnes/src/CMakeLists.txt                   |   4 +
 libocrdma/src/CMakeLists.txt                |   4 +
 librdmacm/examples/CMakeLists.txt           |  43 ++++
 librdmacm/man/CMakeLists.txt                |  65 ++++++
 librdmacm/src/CMakeLists.txt                |  39 ++++
 librxe/CMakeLists.txt                       |   4 +
 librxe/man/CMakeLists.txt                   |   4 +
 librxe/src/CMakeLists.txt                   |   3 +
 srp_daemon/man/CMakeLists.txt               |   4 +
 srp_daemon/srp_daemon/CMakeLists.txt        |  32 +++
 44 files changed, 1902 insertions(+)
 create mode 100644 CMakeLists.txt
 create mode 100644 COPYING
 create mode 100644 COPYING.BSD
 create mode 100644 COPYING.GPL2
 create mode 100644 README.md
 create mode 100644 buildlib/FindLDSymVer.cmake
 create mode 100644 buildlib/RDMA_DoFixup.cmake
 create mode 100644 buildlib/RDMA_EnableCStd.cmake
 create mode 100644 buildlib/config.h.in
 create mode 100644 buildlib/fixup-include/rdma-rdma_user_rxe.h
 create mode 100644 buildlib/fixup-include/valgrind-drd.h
 create mode 100644 buildlib/fixup-include/valgrind-memcheck.h
 create mode 100644 buildlib/provider.map
 create mode 100644 buildlib/publish_headers.cmake
 create mode 100644 buildlib/rdma_functions.cmake
 create mode 100644 ibacm/CMakeLists.txt
 create mode 100644 iwpmd/src/CMakeLists.txt
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
 create mode 100644 srp_daemon/man/CMakeLists.txt
 create mode 100644 srp_daemon/srp_daemon/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
new file mode 100644
index 000000000000..50ae527419a1
--- /dev/null
+++ b/CMakeLists.txt
@@ -0,0 +1,293 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+# Run cmake as:
+#  mkdir build
+#  cmake -GNinja ..
+#  ninja
+#
+# Common options passed to cmake are:
+#  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
+#      Write a compile_commands.json file for clang tooling
+#  -DENABLE_VALGRIND=1 (default disabled)
+#      Embed valgrind notations, this has a tiny negative performance impact
+#  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
+#      Do not link to libnl and do not resolve neighbours internally for Ethernet,
+#      and do not build iwpmd.
+
+cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
+project(RDMA C)
+
+# CMake likes to use -rdynamic too much, they fixed it in 3.4.
+if(POLICY CMP0065)
+  cmake_policy(SET CMP0065 NEW)
+else()
+  # .. but we really do want to opt out.
+  string(REPLACE "-rdynamic" "" CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS}")
+endif()
+
+set(PACKAGE_NAME "RDMA")
+# FIXME versioning strategy?
+set(PACKAGE_VERSION "1")
+
+#-------------------------
+# Basic standard paths
+include(GNUInstallDirs)
+# C include root
+set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
+# Executables
+set(BUILD_BIN ${CMAKE_BINARY_DIR}/bin)
+# Libraries
+set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
+
+# Location to place provider .driver files
+set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
+set(CMAKE_INSTALL_INITDDIR "${CMAKE_INSTALL_SYSCONFDIR}/init.d"
+  CACHE PATH "Location for init.d files")
+set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd"
+  CACHE PATH "Location for systemd service files")
+
+set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
+  CACHE PATH "Location for ibacm provider plugin shared library files.")
+
+#-------------------------
+# Load CMake components
+set(BUILDLIB "${CMAKE_SOURCE_DIR}/buildlib")
+set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${BUILDLIB}")
+
+include(FindPkgConfig)
+include(CheckCCompilerFlag)
+include(CheckIncludeFile)
+include(CheckTypeSize)
+include(RDMA_EnableCStd)
+include(RDMA_DoFixup)
+include(publish_headers)
+include(rdma_functions)
+
+#-------------------------
+# Setup the basic C compiler
+include_directories(${BUILD_INCLUDE})
+# FIXME: Eliminate HAVE_CONFIG_H, we always have it.
+add_definitions(-DHAVE_CONFIG_H)
+
+# Require GNU99 mode
+RDMA_EnableCStd()
+
+# Extra warnings. Turn on -Wextra to keep aware of interesting developments from gcc,
+# but turn off some that are not terribly useful for this source.
+# FIXME: I wonder how many of the signed compares are bugs?
+RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WARNINGS
+  "-Wall -Wextra -Wno-sign-compare -Wno-unused-parameter")
+
+# At some point around 5.4 gcc fixed missing-field-initializers to ignore this
+# common idiom we use extensively. Since this is a useful warning for
+# developers try and leave it on if the compiler supports it.
+CHECK_C_SOURCE_COMPILES("
+ struct foo { int a; int b; };
+ int main(int argc,const char *argv[]) { struct foo tmp = {}; return tmp.a; }"
+  HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS
+  FAIL_REGEX "warning")
+if (NOT HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS)
+  RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WNO_MISSING_FIELD_INITIALIZERS "-Wno-missing-field-initializers")
+endif()
+
+# Check that the compiler supports -fno-strict-aliasing.
+# The use of this flag in the source is discouraged
+set(NO_STRICT_ALIASING_FLAGS "")
+RDMA_AddOptCFlag(NO_STRICT_ALIASING_FLAGS HAVE_NO_STRICT_ALIASING
+  "-fno-strict-aliasing")
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
+RDMA_AddOptCFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+
+# Ensure all shared ELFs have fully described linking
+RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+
+# Enable gold linker - gold has different linking checks
+#RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptCFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
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
+if (NOT DEFINED ENABLE_RESOLVE_NEIGH)
+  set(ENABLE_RESOLVE_NEIGH "ON" CACHE BOOL "Enable internal resolution of neighbours for Etherent")
+endif()
+if (ENABLE_RESOLVE_NEIGH)
+  # FIXME use of pkgconfig is discouraged
+  pkg_check_modules(NL3 libnl-3.0 libnl-route-3.0)
+  if (NL3_FOUND)
+    set(NL_KIND 3)
+    set(NL_INCLUDE_DIRS ${NL3_INCLUDE_DIRS})
+    set(NL_LIBRARIES ${NL3_LIBRARIES})
+  else()
+    # FIXME: I don't know why we have this fallback, all supported distros
+    # have libnl3
+    pkg_check_modules(NL1 libnl-1)
+    if (NL1_FOUND)
+      set(NL_KIND 1)
+      set(NL_INCLUDE_DIRS ${NL1_INCLUDE_DIRS})
+      set(NL_LIBRARIES ${NL1_LIBRARIES})
+    else()
+      message(FATAL_ERROR "Cannot find libnl-3.0 or libnl-1")
+    endif()
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
+check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
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
+  CHECK_INCLUDE_FILE("valgrind/memcheck.h" HAVE_VALGRIND_MEMCHECK)
+  CHECK_INCLUDE_FILE("valgrind/drd.h" HAVE_VALGRIND_DRD)
+else()
+  set(HAVE_VALGRIND_MEMCHECK 0)
+  set(HAVE_VALGRIND_DRD 0)
+endif()
+RDMA_DoFixup("${HAVE_VALGRIND_MEMCHECK}" "valgrind/memcheck.h")
+RDMA_DoFixup("${HAVE_VALGRIND_DRD}" "valgrind/drd.h")
+
+# Older glibc does not include librt
+CHECK_C_SOURCE_COMPILES("
+#include <time.h>
+int main(int argc,const char *argv[]) {
+   clock_gettime(CLOCK_MONOTONIC,0);
+   clock_nanosleep(CLOCK_MONOTONIC,0,0,0);
+   return 0;
+};" LIBC_HAS_LIBRT)
+if (NOT LIBC_HAS_LIBRT)
+  set(RT_LIBRARIES "rt")
+endif()
+
+#-------------------------
+# Build Prep
+# Write out a git ignore file to the build directory if it isn't the source
+# directory. For developer convenience
+if (NOT ${CMAKE_CURRENT_BINARY_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
+  file(WRITE ${CMAKE_BINARY_DIR}/.gitignore "*")
+endif()
+
+configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOTES @ONLY)
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
+add_subdirectory(ibacm)
+if (NOT NL_KIND EQUAL 0)
+  add_subdirectory(iwpmd/src)
+endif()
+add_subdirectory(libibcm/examples)
+add_subdirectory(libibumad/tests)
+add_subdirectory(libibverbs/examples)
+add_subdirectory(librdmacm/examples)
+add_subdirectory(srp_daemon/srp_daemon)
+add_subdirectory(srp_daemon/man)
+
+rdma_finalize_libs()
+
+#-------------------------
+# Display a summary
+# Only report things that are non-ideal.
+message(STATUS "Missing Optional Items:")
+if (NOT HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE)
+  message(STATUS " Compiler attribute always_inline NOT supported")
+endif()
+if (NOT HAVE_VALGRIND_MEMCHECK)
+  message(STATUS " Valgrind memcheck.h NOT enabled")
+endif()
+if (NOT HAVE_VALGRIND_DRD)
+  message(STATUS " Valgrind drd.h NOT enabled")
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
+if (NOT HAVE_C_WARNINGS)
+  message(STATUS " extended C warnings NOT supported")
+endif()
+if (NOT HAVE_NO_STRICT_ALIASING)
+  message(STATUS " -fno-strict-aliasing NOT supported")
+endif()
+if (NOT HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS)
+  message(STATUS " -Wmissing-field-initializers does NOT work")
+endif()
diff --git a/COPYING b/COPYING
new file mode 100644
index 000000000000..ac58180e900c
--- /dev/null
+++ b/COPYING
@@ -0,0 +1,6 @@
+Unless otherwise stated this software is available to you under a choice of
+one of two licenses.  You may choose to be licensed under the terms of the the
+OpenIB.org BSD license (see COPYING.BSD) or the GNU General Public License
+(GPL) Version 2 (see COPYING.GPL2), both included in this package.
+
+Refer to individual files for information on the copyright holders.
diff --git a/COPYING.BSD b/COPYING.BSD
new file mode 100644
index 000000000000..59b3a397a13b
--- /dev/null
+++ b/COPYING.BSD
@@ -0,0 +1,26 @@
+		       OpenIB.org BSD license
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions
+are met:
+
+  * Redistributions of source code must retain the above copyright
+    notice, this list of conditions and the following disclaimer.
+
+  * Redistributions in binary form must reproduce the above
+    copyright notice, this list of conditions and the following
+    disclaimer in the documentation and/or other materials provided
+    with the distribution.
+
+THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
+INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
+CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
+ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGE.
diff --git a/COPYING.GPL2 b/COPYING.GPL2
new file mode 100644
index 000000000000..d159169d1050
--- /dev/null
+++ b/COPYING.GPL2
@@ -0,0 +1,339 @@
+                    GNU GENERAL PUBLIC LICENSE
+                       Version 2, June 1991
+
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
+ 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+                            Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+License is intended to guarantee your freedom to share and change free
+software--to make sure the software is free for all its users.  This
+General Public License applies to most of the Free Software
+Foundation's software and to any other program whose authors commit to
+using it.  (Some other Free Software Foundation software is covered by
+the GNU Lesser General Public License instead.)  You can apply it to
+your programs, too.
+
+  When we speak of free software, we are referring to freedom, not
+price.  Our General Public Licenses are designed to make sure that you
+have the freedom to distribute copies of free software (and charge for
+this service if you wish), that you receive source code or can get it
+if you want it, that you can change the software or use pieces of it
+in new free programs; and that you know you can do these things.
+
+  To protect your rights, we need to make restrictions that forbid
+anyone to deny you these rights or to ask you to surrender the rights.
+These restrictions translate to certain responsibilities for you if you
+distribute copies of the software, or if you modify it.
+
+  For example, if you distribute copies of such a program, whether
+gratis or for a fee, you must give the recipients all the rights that
+you have.  You must make sure that they, too, receive or can get the
+source code.  And you must show them these terms so they know their
+rights.
+
+  We protect your rights with two steps: (1) copyright the software, and
+(2) offer you this license which gives you legal permission to copy,
+distribute and/or modify the software.
+
+  Also, for each author's protection and ours, we want to make certain
+that everyone understands that there is no warranty for this free
+software.  If the software is modified by someone else and passed on, we
+want its recipients to know that what they have is not the original, so
+that any problems introduced by others will not reflect on the original
+authors' reputations.
+
+  Finally, any free program is threatened constantly by software
+patents.  We wish to avoid the danger that redistributors of a free
+program will individually obtain patent licenses, in effect making the
+program proprietary.  To prevent this, we have made it clear that any
+patent must be licensed for everyone's free use or not licensed at all.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.
+
+                    GNU GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License applies to any program or other work which contains
+a notice placed by the copyright holder saying it may be distributed
+under the terms of this General Public License.  The "Program", below,
+refers to any such program or work, and a "work based on the Program"
+means either the Program or any derivative work under copyright law:
+that is to say, a work containing the Program or a portion of it,
+either verbatim or with modifications and/or translated into another
+language.  (Hereinafter, translation is included without limitation in
+the term "modification".)  Each licensee is addressed as "you".
+
+Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running the Program is not restricted, and the output from the Program
+is covered only if its contents constitute a work based on the
+Program (independent of having been made by running the Program).
+Whether that is true depends on what the Program does.
+
+  1. You may copy and distribute verbatim copies of the Program's
+source code as you receive it, in any medium, provided that you
+conspicuously and appropriately publish on each copy an appropriate
+copyright notice and disclaimer of warranty; keep intact all the
+notices that refer to this License and to the absence of any warranty;
+and give any other recipients of the Program a copy of this License
+along with the Program.
+
+You may charge a fee for the physical act of transferring a copy, and
+you may at your option offer warranty protection in exchange for a fee.
+
+  2. You may modify your copy or copies of the Program or any portion
+of it, thus forming a work based on the Program, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) You must cause the modified files to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    b) You must cause any work that you distribute or publish, that in
+    whole or in part contains or is derived from the Program or any
+    part thereof, to be licensed as a whole at no charge to all third
+    parties under the terms of this License.
+
+    c) If the modified program normally reads commands interactively
+    when run, you must cause it, when started running for such
+    interactive use in the most ordinary way, to print or display an
+    announcement including an appropriate copyright notice and a
+    notice that there is no warranty (or else, saying that you provide
+    a warranty) and that users may redistribute the program under
+    these conditions, and telling the user how to view a copy of this
+    License.  (Exception: if the Program itself is interactive but
+    does not normally print such an announcement, your work based on
+    the Program is not required to print an announcement.)
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Program,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Program, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Program.
+
+In addition, mere aggregation of another work not based on the Program
+with the Program (or with a work based on the Program) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may copy and distribute the Program (or a work based on it,
+under Section 2) in object code or executable form under the terms of
+Sections 1 and 2 above provided that you also do one of the following:
+
+    a) Accompany it with the complete corresponding machine-readable
+    source code, which must be distributed under the terms of Sections
+    1 and 2 above on a medium customarily used for software interchange; or,
+
+    b) Accompany it with a written offer, valid for at least three
+    years, to give any third party, for a charge no more than your
+    cost of physically performing source distribution, a complete
+    machine-readable copy of the corresponding source code, to be
+    distributed under the terms of Sections 1 and 2 above on a medium
+    customarily used for software interchange; or,
+
+    c) Accompany it with the information you received as to the offer
+    to distribute corresponding source code.  (This alternative is
+    allowed only for noncommercial distribution and only if you
+    received the program in object code or executable form with such
+    an offer, in accord with Subsection b above.)
+
+The source code for a work means the preferred form of the work for
+making modifications to it.  For an executable work, complete source
+code means all the source code for all modules it contains, plus any
+associated interface definition files, plus the scripts used to
+control compilation and installation of the executable.  However, as a
+special exception, the source code distributed need not include
+anything that is normally distributed (in either source or binary
+form) with the major components (compiler, kernel, and so on) of the
+operating system on which the executable runs, unless that component
+itself accompanies the executable.
+
+If distribution of executable or object code is made by offering
+access to copy from a designated place, then offering equivalent
+access to copy the source code from the same place counts as
+distribution of the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+  4. You may not copy, modify, sublicense, or distribute the Program
+except as expressly provided under this License.  Any attempt
+otherwise to copy, modify, sublicense or distribute the Program is
+void, and will automatically terminate your rights under this License.
+However, parties who have received copies, or rights, from you under
+this License will not have their licenses terminated so long as such
+parties remain in full compliance.
+
+  5. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Program or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Program (or any work based on the
+Program), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Program or works based on it.
+
+  6. Each time you redistribute the Program (or any work based on the
+Program), the recipient automatically receives a license from the
+original licensor to copy, distribute or modify the Program subject to
+these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties to
+this License.
+
+  7. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Program at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Program by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Program.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system, which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+  8. If the distribution and/or use of the Program is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Program under this License
+may add an explicit geographical distribution limitation excluding
+those countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  9. The Free Software Foundation may publish revised and/or new versions
+of the General Public License from time to time.  Such new versions will
+be similar in spirit to the present version, but may differ in detail to
+address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Program
+specifies a version number of this License which applies to it and "any
+later version", you have the option of following the terms and conditions
+either of that version or of any later version published by the Free
+Software Foundation.  If the Program does not specify a version number of
+this License, you may choose any version ever published by the Free Software
+Foundation.
+
+  10. If you wish to incorporate parts of the Program into other free
+programs whose distribution conditions are different, write to the author
+to ask for permission.  For software which is copyrighted by the Free
+Software Foundation, write to the Free Software Foundation; we sometimes
+make exceptions for this.  Our decision will be guided by the two goals
+of preserving the free status of all derivatives of our free software and
+of promoting the sharing and reuse of software generally.
+
+                            NO WARRANTY
+
+  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+REPAIR OR CORRECTION.
+
+  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGES.
+
+                     END OF TERMS AND CONDITIONS
+
+            How to Apply These Terms to Your New Programs
+
+  If you develop a new program, and you want it to be of the greatest
+possible use to the public, the best way to achieve this is to make it
+free software which everyone can redistribute and change under these terms.
+
+  To do so, attach the following notices to the program.  It is safest
+to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least
+the "copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the program's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+
+Also add information on how to contact you by electronic and paper mail.
+
+If the program is interactive, make it output a short notice like this
+when it starts in an interactive mode:
+
+    Gnomovision version 69, Copyright (C) year name of author
+    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+    This is free software, and you are welcome to redistribute it
+    under certain conditions; type `show c' for details.
+
+The hypothetical commands `show w' and `show c' should show the appropriate
+parts of the General Public License.  Of course, the commands you use may
+be called something other than `show w' and `show c'; they could even be
+mouse-clicks or menu items--whatever suits your program.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the program, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+  `Gnomovision' (which makes passes at compilers) written by James Hacker.
+
+  <signature of Ty Coon>, 1 April 1989
+  Ty Coon, President of Vice
+
+This General Public License does not permit incorporating your program into
+proprietary programs.  If your program is a subroutine library, you may
+consider it more useful to permit linking proprietary applications with the
+library.  If this is what you want to do, use the GNU Lesser General
+Public License instead of this License.
diff --git a/README.md b/README.md
new file mode 100644
index 000000000000..26f44c1f2d8c
--- /dev/null
+++ b/README.md
@@ -0,0 +1,97 @@
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
+The userspace component of the libibverbs RDMA kernel drivers are included
+under the providers/ directory. Support for the following Kernel RDMA drivers
+is included:
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
+Additional service daemons are provided for:
+ - srp_daemon (ib_srp.ko)
+ - iwpmd (for iwarp kernel providers)
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
+NOTE: It is not currently easy to run from the build directory, the plugins
+only load from the system path.
+
+### Debian Derived
+
+```sh
+$ apt-get install build-essential cmake gcc libnl-3-dev libnl-route-3-dev ninja-build pkg-config valgrind
+```
+
+### Fedora
+
+```sh
+$ dnf install cmake gcc libnl3-devel pkgconfig valgrind-devel ninja-build
+```
+
+NOTE: Fedora Core uses the name 'ninja-build' for the ninja command.
+
+### OpenSuSE
+
+```sh
+$ zypper install cmake gcc libnl3-devel ninja pkg-config valgrind-devel
+```
+
+## Building on CentOS 6/7
+
+Install required packages:
+
+```sh
+$ yum install cmake gcc libnl3-devel make pkgconfig valgrind-devel
+```
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
diff --git a/buildlib/FindLDSymVer.cmake b/buildlib/FindLDSymVer.cmake
new file mode 100644
index 000000000000..c0f01a562e32
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
+asm(\".symver ibv_get_device_list_1, ibv_get_device_list@IBVERBS_1.1\");
+void ibv_get_device_list_0(void){}
+asm(\".symver ibv_get_device_list_0, ibv_get_device_list@@IBVERBS_1.0\");
+
+int main(void){return 0;}" _LDSYMVER_SUCCESS)
+file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/test.map")
+set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})
+
+if (_LDSYMVER_SUCCESS)
+  set(LDSYMVER_MODE "GNU" CACHE INTERNAL "How to set symbol versions on shared libraries")
+endif()
+
+include(FindPackageHandleStandardArgs)
+find_package_handle_standard_args(
+  LDSymVer
+  REQUIRED_VARS LDSYMVER_MODE
+  )
diff --git a/buildlib/RDMA_DoFixup.cmake b/buildlib/RDMA_DoFixup.cmake
new file mode 100644
index 000000000000..3ffd50aa1de4
--- /dev/null
+++ b/buildlib/RDMA_DoFixup.cmake
@@ -0,0 +1,21 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Execute a header fixup based on NOT_NEEDED for HEADER
+
+# The buildlib includes alternate header file shims for several scenarios, if
+# the build system detects a feature is present then it should call RDMA_DoFixup
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
index 000000000000..984d51bfaa09
--- /dev/null
+++ b/buildlib/config.h.in
@@ -0,0 +1,35 @@
+// FIXME: Remove this, ibverbs is included so we don't need to detect
+#define HAVE_IBV_DOFORK_RANGE 1
+#define HAVE_IBV_DONTFORK_RANGE 1
+#define HAVE_IBV_REGISTER_DRIVER 1
+#define HAVE_IBV_READ_SYSFS_FILE 1
+
+// FIXME: Remove this, we provide the netlink kernel headers ibacm needs
+#define HAVE_NETLINK 1
+
+// FIXME: Remove this, The cmake version hard-requires symbol version support
+#define HAVE_SYMVER_SUPPORT 1
+
+// FIXME: Remove this, The cmake version hard-requires new style CLOEXEC support
+#define STREAM_CLOEXEC "e"
+
+// FIXME: Remove this, cmake always provides a valgrind/memcheck.h
+#define HAVE_VALGRIND_MEMCHECK_H 1
+#define INCLUDE_VALGRIND 1
+
+#define SYSCONFDIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@"
+
+#define IBV_CONFIG_DIR "@CONFIG_DIR@"
+
+// FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
+#cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
+
+@SIZEOF_LONG_CODE@
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
diff --git a/buildlib/fixup-include/valgrind-drd.h b/buildlib/fixup-include/valgrind-drd.h
new file mode 100644
index 000000000000..9e491fc68047
--- /dev/null
+++ b/buildlib/fixup-include/valgrind-drd.h
@@ -0,0 +1,3 @@
+static inline void ANNOTATE_BENIGN_RACE_SIZED(const void *mem,size_t len,const char *desc) {}
+#define ANNOTATE_BENIGN_RACE_SIZED ANNOTATE_BENIGN_RACE_SIZED
+
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
index 000000000000..e985a6fe97d8
--- /dev/null
+++ b/buildlib/provider.map
@@ -0,0 +1,6 @@
+/* The providers do not export any symbols at all. Instead they rely on
+   attribute(constructor) to cause their init function to run at dlopen
+   time. */
+{
+	local: *;
+};
diff --git a/buildlib/publish_headers.cmake b/buildlib/publish_headers.cmake
new file mode 100644
index 000000000000..ccd22960c141
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
+    install(FILES "${SFIL}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DEST}/" RENAME "${FIL}")
+  endforeach()
+endfunction()
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
new file mode 100644
index 000000000000..d82ed4757bb7
--- /dev/null
+++ b/buildlib/rdma_functions.cmake
@@ -0,0 +1,279 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Helper functions for use in the sub CMakeLists files to make them simpler
+# and more uniform.
+
+# Global list of pairs of (SHARED STATIC) libary target names
+set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
+
+# Install a symlink during 'make install'
+function(rdma_install_symlink LINK_CONTENT DEST)
+  # Create a link in the build tree with the right content
+  get_filename_component(FN "${DEST}" NAME)
+  execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
+    "${LINK_CONTENT}"
+    "${CMAKE_CURRENT_BINARY_DIR}/${FN}")
+
+  # Have cmake install it. Doing it this way lets cpack work if we ever wish
+  # to use that.
+  get_filename_component(DIR "${DEST}" PATH)
+  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${FN}"
+    DESTINATION "${DIR}")
+endfunction()
+
+# Wrapper for install() that runs the single file through configure_file first.
+# This only works with the basic single file install(FILE file ARGS..) pattern
+function(rdma_subst_install ARG1 file)
+  if (NOT "${ARG1}" STREQUAL "FILES")
+    message(FATAL_ERROR "Bad use of rdma_subst_install")
+  endif()
+  configure_file("${file}" "${CMAKE_CURRENT_BINARY_DIR}/${file}" @ONLY)
+  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${file}" ${ARGN})
+endfunction()
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
+  install(TARGETS ${DEST}-static DESTINATION "${CMAKE_INSTALL_LIBDIR}")
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
+  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+endfunction()
+
+# Create a provider shared library for libibverbs
+function(rdma_provider DEST)
+  # Installed driver file
+  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" "driver ${DEST}\n")
+  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "${CONFIG_DIR}")
+
+  # Uninstalled driver file
+  file(MAKE_DIRECTORY "${BUILD_LIB}/libibverbs.d/")
+  file(WRITE "${BUILD_LIB}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/${DEST}\n")
+
+  # FIXME: This symlink is provided for compat with the old build, but it
+  # never should have existed in the first place, nothing should use this
+  # name, we can probably remove it.
+  rdma_install_symlink("lib${DEST}-rdmav2.so" "${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so")
+
+  # Create a static provider library
+  # FIXME: This is probably pointless, the provider library has no symbols so
+  # what good is it? Presumably it should be used with -Wl,--whole-archive,
+  # but we don't have any directions on how to make static linking work..
+  add_library(${DEST} STATIC ${ARGN})
+  set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+
+  list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
+  set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+
+  # Create the plugin shared library
+  set(DEST ${DEST}-rdmav2)
+  add_library(${DEST} MODULE ${ARGN})
+  # Even though these are modules we still want to use Wl,--no-undefined
+  set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
+  rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
+  target_link_libraries(${DEST} PRIVATE ibverbs)
+  target_link_libraries(${DEST} PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+  set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  # Provider Plugins do not use SONAME versioning, there is no reason to
+  # create the usual symlinks.
+
+  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+endfunction()
+
+ # Create an installed executable
+function(rdma_executable EXEC)
+  add_executable(${EXEC} ${ARGN})
+  set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
+  install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_BINDIR}")
+endfunction()
+
+ # Create an installed executable (under sbin)
+function(rdma_sbin_executable EXEC)
+  add_executable(${EXEC} ${ARGN})
+  set_target_properties(${EXEC} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BUILD_BIN}")
+  install(TARGETS ${EXEC} DESTINATION "${CMAKE_INSTALL_SBINDIR}")
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
+    install(FILES ${I} DESTINATION "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/")
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
+    rdma_install_symlink("${FROM}" "${CMAKE_INSTALL_MANDIR}/man${MAN_SECT}/${TO}")
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
+    "libdir='${CMAKE_INSTALL_FULL_LIBDIR}'\n"
+    )
+  install(FILES ${LAFN} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
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
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
new file mode 100644
index 000000000000..8887c13af463
--- /dev/null
+++ b/ibacm/CMakeLists.txt
@@ -0,0 +1,69 @@
+publish_headers(infiniband
+  include/infiniband/acm.h
+  include/infiniband/acm_prov.h
+  )
+
+# FIXME: To config.h
+add_definitions("-DIBACM_CONFIG_PATH=\"${CMAKE_INSTALL_FULL_SYSCONFDIR}/rdma\"")
+add_definitions("-DIBACM_LIB_PATH=\"${ACM_PROVIDER_DIR}\"")
+add_definitions("-DIBACM_BIN_PATH=\"${CMAKE_INSTALL_FULL_BINDIR}\"")
+
+# FIXME: Fixup the include scheme to not require all these -Is
+include_directories("include")
+include_directories("src")
+include_directories("linux")
+
+# NOTE: ibacm exports symbols from its own binary for use by ibacm
+rdma_sbin_executable(ibacm
+  src/acm.c
+  src/acm_util.c
+  )
+target_link_libraries(ibacm
+  ibverbs
+  ibumad
+  ${CMAKE_THREAD_LIBS_INIT}
+  ${CMAKE_DL_LIBS}
+  )
+# FIXME: We should probably list the symbols we want to export..
+set_target_properties(ibacm PROPERTIES ENABLE_EXPORTS TRUE)
+
+# This is a plugin module that dynamically links to ibacm
+add_library(ibacmp MODULE
+  prov/acmp/src/acmp.c
+  )
+rdma_set_library_map(ibacmp "prov/acmp/src/libibacmp.map")
+target_link_libraries(ibacmp
+  ibacm
+  ibverbs
+  ibumad
+  ${CMAKE_THREAD_LIBS_INIT}
+  )
+set_target_properties(ibacmp PROPERTIES
+  LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+install(TARGETS ibacmp DESTINATION "${ACM_PROVIDER_DIR}")
+
+rdma_executable(ib_acme
+  linux/libacm_linux.c
+  src/acme.c
+  src/libacm.c
+  src/parse.c
+  )
+target_link_libraries(ib_acme
+  ibverbs
+  )
+target_compile_definitions(ib_acme PRIVATE "-DACME_PRINTS")
+
+rdma_man_pages(
+  man/ib_acme.1
+  man/ibacm.1
+  man/ibacm.7
+  man/ibacm_prov.7
+  )
+
+# FIXME: update the .init.in
+set(rdmascript "openibd")
+set(prefix "${CMAKE_INSTALL_PREFIX}")
+rdma_subst_install(FILES "ibacm.init.in"
+  DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+  RENAME "ibacm"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
diff --git a/iwpmd/src/CMakeLists.txt b/iwpmd/src/CMakeLists.txt
new file mode 100644
index 000000000000..5ffc21264ae2
--- /dev/null
+++ b/iwpmd/src/CMakeLists.txt
@@ -0,0 +1,12 @@
+rdma_executable(iwpmd
+  iwarp_pm_common.c
+  iwarp_pm_helper.c
+  iwarp_pm_server.c
+  )
+target_link_libraries(iwpmd
+  ${NL_LIBRARIES}
+  ${CMAKE_THREAD_LIBS_INIT}
+  )
+# FIXME iwpmd_init init.d file
+# FIXME iwpmd.service systemd file
+# FIXME iwpmd.conf
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
index 000000000000..a9b6546015ef
--- /dev/null
+++ b/libcxgb4/src/CMakeLists.txt
@@ -0,0 +1,8 @@
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
+
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
index 000000000000..e9ac533a4a2b
--- /dev/null
+++ b/libibverbs/examples/CMakeLists.txt
@@ -0,0 +1,31 @@
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
+
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
index 000000000000..05313e5b99e9
--- /dev/null
+++ b/libibverbs/man/CMakeLists.txt
@@ -0,0 +1,83 @@
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
+  ibv_create_rwq_ind_table.3
+  ibv_create_srq.3
+  ibv_create_srq_ex.3
+  ibv_create_wq.3
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
+  ibv_modify_wq.3
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
+  ibv_create_rwq_ind_table.3 ibv_destroy_rwq_ind_table.3
+  ibv_create_srq.3 ibv_destroy_srq.3
+  ibv_create_wq.3 ibv_destroy_wq.3
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
index 000000000000..2683f3538300
--- /dev/null
+++ b/libibverbs/src/CMakeLists.txt
@@ -0,0 +1,36 @@
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
+
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
index 000000000000..359438ef0e49
--- /dev/null
+++ b/libipathverbs/CMakeLists.txt
@@ -0,0 +1,4 @@
+install(FILES truescale.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/modprobe.d/")
+install(FILES truescale-serdes.cmds
+  DESTINATION "${CMAKE_INSTALL_SBINDIR}"
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
index 000000000000..5954a345184a
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
+install(TARGETS rspreload DESTINATION "${CMAKE_INSTALL_LIBDIR}/rsocket/")
+
+# These are for compat with old packaging, these name should not be used.
+# FIXME: Maybe we can get rid of them?
+rdma_install_symlink("librspreload.so" "${CMAKE_INSTALL_LIBDIR}/rsocket/librspreload.so.1")
+rdma_install_symlink("librspreload.so" "${CMAKE_INSTALL_LIBDIR}/rsocket/librspreload.so.1.0.0")
diff --git a/librxe/CMakeLists.txt b/librxe/CMakeLists.txt
new file mode 100644
index 000000000000..3652ab3d56a5
--- /dev/null
+++ b/librxe/CMakeLists.txt
@@ -0,0 +1,4 @@
+install(FILES rxe_cfg
+  DESTINATION "${CMAKE_INSTALL_BINDIR}"
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
diff --git a/srp_daemon/man/CMakeLists.txt b/srp_daemon/man/CMakeLists.txt
new file mode 100644
index 000000000000..f05de60b97aa
--- /dev/null
+++ b/srp_daemon/man/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_man_pages(
+  ibsrpdm.1
+  srp_daemon.1
+  )
diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/srp_daemon/CMakeLists.txt
new file mode 100644
index 000000000000..79feaec16889
--- /dev/null
+++ b/srp_daemon/srp_daemon/CMakeLists.txt
@@ -0,0 +1,32 @@
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
+
+rdma_sbin_executable(srp_daemon
+  srp_daemon.c
+  srp_handle_traps.c
+  srp_sync.c
+  )
+target_link_libraries(srp_daemon
+  ibverbs
+  ibumad
+  ${RT_LIBRARIES}
+  ${CMAKE_THREAD_LIBS_INIT}
+  )
+
+rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/ibsrpdm")
+# FIXME: Why?
+rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/run_srp_daemon")
+install(FILES srp_daemon.sh DESTINATION "${CMAKE_INSTALL_SBINDIR}")
+
+install(FILES logrotate-srp_daemon DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/logrotate.d" RENAME "srp_daemon")
+install(FILES rsyslog-srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rsyslog.d" RENAME "srp_daemon.conf")
+install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
+
+# FIXME: The ib init.d file should really be included in rdma-plumbing as well.
+set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
+# NOTE: These defaults are for CentOS, packagers should override.
+set(DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
+set(DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
+configure_file(srpd.in "${CMAKE_CURRENT_BINARY_DIR}/srpd")
+install(FILES "${CMAKE_CURRENT_BINARY_DIR}/srpd"
+  DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
