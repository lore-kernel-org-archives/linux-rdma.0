From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] Add -DIN_PLACE=1 to cmake
Date: Thu, 22 Dec 2016 15:15:59 -0700
Message-ID: <20161222221559.GA15947@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This configures the paths to run the software from the local build
directory. Much of this is done automatically by how cmake uses rpath,
but the two cases where we dlopen things have to be handled by us.

The simple solution is to hard wire the build directory path into the
binaries.

'etc' is also relocated to build/etc/ as that is part of how the verbs
providers are located.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                | 23 +++++++++++++++++++++--
 README.md                     |  3 ++-
 build.sh                      |  4 ++--
 buildlib/rdma_functions.cmake |  4 ++--
 ibacm/CMakeLists.txt          |  5 +++++
 5 files changed, 32 insertions(+), 7 deletions(-)

Steve, this is a refined version of what I sent you ealier, does it
work for you?

I haven't tested ibacm, not very familiar with it.

diff --git a/CMakeLists.txt b/CMakeLists.txt
index d40c03ce68181e..3d546f22790d98 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -5,6 +5,9 @@
 #  ninja
 #
 # Common options passed to cmake are:
+#  -DIN_PLACE=1
+#      Configure the build to be run from the build directory, this results in something
+#      that is not installable.
 #  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
 #      Write a compile_commands.json file for clang tooling
 #  -DCMAKE_BUILD_TYPE=RelWithDebInfo
@@ -45,6 +48,13 @@ set(PACKAGE_VERSION "12")
 
 #-------------------------
 # Basic standard paths
+
+# Override the CMAKE_INSTALL_ dirs to be under the build/ directory
+if (IN_PLACE)
+  set(CMAKE_INSTALL_SYSCONFDIR "${CMAKE_BINARY_DIR}/etc")
+  set(CMAKE_INSTALL_BINDIR "${CMAKE_BINARY_DIR}/bin")
+endif()
+
 include(GNUInstallDirs)
 # C include root
 set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
@@ -52,9 +62,9 @@ set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
 set(BUILD_BIN ${CMAKE_BINARY_DIR}/bin)
 # Libraries
 set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
+# Used for IN_PLACE configuration
+set(BUILD_ETC ${CMAKE_BINARY_DIR}/etc)
 
-# Location to place provider .driver files
-set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
 set(CMAKE_INSTALL_INITDDIR "${CMAKE_INSTALL_SYSCONFDIR}/init.d"
   CACHE PATH "Location for init.d files")
 set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system"
@@ -87,6 +97,15 @@ else()
   set(CMAKE_INSTALL_FULL_UDEV_RULESDIR "${CMAKE_INSTALL_UDEV_RULESDIR}")
 endif()
 
+# Location to place provider .driver files
+if (IN_PLACE)
+  set(CONFIG_DIR "${BUILD_ETC}/libibverbs.d")
+  set(VERBS_PROVIDER_DIR "${BUILD_LIB}")
+  set(ACM_PROVIDER_DIR "${BUILD_LIB}/ibacm")
+else()
+  set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
+endif()
+
 set(DISTRO_FLAVOUR "None" CACHE
   STRING "Flavour of distribution to install for. This primarily impacts the init.d scripts installed.")
 
diff --git a/README.md b/README.md
index b77256ef44aba3..4c1450eb249a11 100644
--- a/README.md
+++ b/README.md
@@ -42,7 +42,8 @@ $ bash build.sh
 ```
 
 *build/bin* will contain the sample programs and *build/lib* will contain the
-shared libraries.
+shared libraries. The build is configured to run all the programs 'in-place'
+and cannot be installed.
 
 NOTE: It is not currently easy to run from the build directory, the plugins
 only load from the system path.
diff --git a/build.sh b/build.sh
index 10518d85bfd86f..17dc4408f73a5a 100755
--- a/build.sh
+++ b/build.sh
@@ -23,9 +23,9 @@ fi
 cd "$BUILDDIR"
 
 if [ "x$NINJA" == "x" ]; then
-    $CMAKE ..
+    $CMAKE -DIN_PLACE=1 ..
     make
 else
-    $CMAKE -GNinja ..
+    $CMAKE -DIN_PLACE=1 -GNinja ..
     $NINJA
 fi
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index fcd47a35bda26f..5256ad997f05bb 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -79,8 +79,8 @@ function(rdma_provider DEST)
   install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "${CONFIG_DIR}")
 
   # Uninstalled driver file
-  file(MAKE_DIRECTORY "${BUILD_LIB}/libibverbs.d/")
-  file(WRITE "${BUILD_LIB}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/${DEST}\n")
+  file(MAKE_DIRECTORY "${BUILD_ETC}/libibverbs.d/")
+  file(WRITE "${BUILD_ETC}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/lib${DEST}\n")
 
   # Create a static provider library
   # FIXME: This is probably pointless, the provider library has no symbols so
diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 505fba30a11c1f..feb1de41b994b9 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -36,6 +36,11 @@ target_link_libraries(ibacmp LINK_PRIVATE
 set_target_properties(ibacmp PROPERTIES
   LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
 install(TARGETS ibacmp DESTINATION "${ACM_PROVIDER_DIR}")
+# ACM providers are linked into a subdir so that IN_PLACE can work.
+file(MAKE_DIRECTORY "${BUILD_LIB}/ibacm/")
+execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
+    "../libibacmp.so"
+    "${BUILD_LIB}/ibacm/libibacmp.so")
 
 rdma_executable(ib_acme
   src/acme.c
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
