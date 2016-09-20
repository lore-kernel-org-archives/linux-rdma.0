From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 09/16] Support obsolete cmake from 2013
Date: Tue, 20 Sep 2016 16:10:18 -0600
Message-ID: <1474409425-15769-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474409425-15769-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

cmake 2.8.12 is also from 2013, however .12 is broadly compatible with
versions up 3.6. However, there were significant changes between .11 and .12,
such that .11 doesn't trivially work.

For some reason Centos 7 only includes 2.8.11 (Centos 6 includes .12). Even
though cmake 3.5.x is available from EPEL, make it easy for everyone and patch
in .11 support, this can be reverted someday.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                | 2 +-
 buildlib/RDMA_DoFixup.cmake   | 6 +++++-
 buildlib/rdma_functions.cmake | 5 +++--
 libibcm/src/CMakeLists.txt    | 2 +-
 libibverbs/src/CMakeLists.txt | 2 +-
 librdmacm/src/CMakeLists.txt  | 6 +++---
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 50ae527419a1..b8875b4853c0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -13,7 +13,7 @@
 #      Do not link to libnl and do not resolve neighbours internally for Ethernet,
 #      and do not build iwpmd.
 
-cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
+cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(RDMA C)
 
 # CMake likes to use -rdynamic too much, they fixed it in 3.4.
diff --git a/buildlib/RDMA_DoFixup.cmake b/buildlib/RDMA_DoFixup.cmake
index 3ffd50aa1de4..75704ddcfe9f 100644
--- a/buildlib/RDMA_DoFixup.cmake
+++ b/buildlib/RDMA_DoFixup.cmake
@@ -11,7 +11,11 @@
 function(RDMA_DoFixup not_needed header)
   set(DEST "${BUILD_INCLUDE}/${header}")
   if (NOT "${not_needed}")
-    get_filename_component(DIR ${DEST} DIRECTORY)
+    if(CMAKE_VERSION VERSION_LESS "2.8.12")
+      get_filename_component(DIR ${DEST} PATH)
+    else()
+      get_filename_component(DIR ${DEST} DIRECTORY)
+    endif()
     file(MAKE_DIRECTORY "${DIR}")
     string(REPLACE / - header-bl ${header})
     execute_process(COMMAND "ln" "-Tsf" "${BUILDLIB}/fixup-include/${header-bl}" "${DEST}")
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index d82ed4757bb7..ea53f382553f 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -98,8 +98,8 @@ function(rdma_provider DEST)
   # Even though these are modules we still want to use Wl,--no-undefined
   set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
   rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
-  target_link_libraries(${DEST} PRIVATE ibverbs)
-  target_link_libraries(${DEST} PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+  target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
+  target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
   set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
   # Provider Plugins do not use SONAME versioning, there is no reason to
   # create the usual symlinks.
@@ -259,6 +259,7 @@ function(rdma_finalize_libs)
     list(GET RDMA_STATIC_LIBS ${I} STATIC)
 
     # PUBLIC libraries
+    set(LIBS "")
     get_property(TMP TARGET ${SHARED} PROPERTY INTERFACE_LINK_LIBRARIES SET)
     if (TMP)
       get_target_property(TMP ${SHARED} INTERFACE_LINK_LIBRARIES)
diff --git a/libibcm/src/CMakeLists.txt b/libibcm/src/CMakeLists.txt
index 01f85c0ea638..2479886c6238 100644
--- a/libibcm/src/CMakeLists.txt
+++ b/libibcm/src/CMakeLists.txt
@@ -6,4 +6,4 @@ publish_headers(infiniband
 rdma_library(ibcm libibcm.map 1 1.0.0
   cm.c
   )
-target_link_libraries(ibcm PUBLIC ibverbs)
+target_link_libraries(ibcm LINK_PUBLIC ibverbs)
diff --git a/libibverbs/src/CMakeLists.txt b/libibverbs/src/CMakeLists.txt
index 2683f3538300..e1a54345c537 100644
--- a/libibverbs/src/CMakeLists.txt
+++ b/libibverbs/src/CMakeLists.txt
@@ -29,7 +29,7 @@ rdma_library(ibverbs libibverbs.map 1 1.0.0
   sysfs.c
   verbs.c
   )
-target_link_libraries(ibverbs PRIVATE
+target_link_libraries(ibverbs LINK_PRIVATE
   ${NL_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   ${CMAKE_DL_LIBS}
diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/src/CMakeLists.txt
index 5954a345184a..5324f625616d 100644
--- a/librdmacm/src/CMakeLists.txt
+++ b/librdmacm/src/CMakeLists.txt
@@ -15,8 +15,8 @@ rdma_library(rdmacm librdmacm.map 1 1.0.0
   indexer.c
   rsocket.c
   )
-target_link_libraries(rdmacm PUBLIC ibverbs)
-target_link_libraries(rdmacm PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+target_link_libraries(rdmacm LINK_PUBLIC ibverbs)
+target_link_libraries(rdmacm LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
 
 # The preload library is a bit special, it needs to be open coded
 # Since it is a LD_PRELOAD it has no soname, and is installed in sub dir
@@ -26,7 +26,7 @@ add_library(rspreload SHARED
   )
 set_target_properties(rspreload PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
 rdma_set_library_map(rspreload librspreload.map)
-target_link_libraries(rspreload PRIVATE
+target_link_libraries(rspreload LINK_PRIVATE
   rdmacm
   ${CMAKE_THREAD_LIBS_INIT}
   ${CMAKE_DL_LIBS}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
