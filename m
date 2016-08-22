From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 09/15] Support obsolete cmake from 2013
Date: Mon, 22 Aug 2016 12:13:32 -0600
Message-ID: <1471889618-1605-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 buildlib/RDMA_DoFixup.cmake   | 8 ++++++--
 buildlib/rdma_functions.cmake | 5 +++--
 libibcm/src/CMakeLists.txt    | 2 +-
 libibverbs/src/CMakeLists.txt | 2 +-
 librdmacm/src/CMakeLists.txt  | 6 +++---
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 568e819aa976..4058c8a68258 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -14,7 +14,7 @@
 #  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
 #      Do not link to libnl and do not resolve neighbours internally for Ethernet.
 
-cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
+cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(RDMA C)
 
 set(PACKAGE_NAME "RDMA")
diff --git a/buildlib/RDMA_DoFixup.cmake b/buildlib/RDMA_DoFixup.cmake
index 1e30cf6c761b..75704ddcfe9f 100644
--- a/buildlib/RDMA_DoFixup.cmake
+++ b/buildlib/RDMA_DoFixup.cmake
@@ -3,7 +3,7 @@
 # Execute a header fixup based on NOT_NEEDED for HEADER
 
 # The buildlib includes alternate header file shims for several scenarios, if
-# the build system detects a feature is present then it should call OrcDoFixup
+# the build system detects a feature is present then it should call RDMA_DoFixup
 # with the test as true. If false then the shim header will be installed.
 
 # Typically the shim header will replace a missing header with stubs, or it
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
index f698855563e9..34b4c7b53d19 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -68,8 +68,8 @@ function(rdma_provider DEST)
   set(DEST ${DEST}-rdmav2)
   add_library(${DEST} MODULE ${ARGN})
   rdma_set_library_map(${DEST} ${BUILDLIB}/provider.map)
-  target_link_libraries(${DEST} PRIVATE ibverbs)
-  target_link_libraries(${DEST} PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+  target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
+  target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
   set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
   # Provider Plugins do not use SONAME versioning, there is no reason to
   # create the usual symlinks.
@@ -222,6 +222,7 @@ function(rdma_finalize_libs)
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
index 5e680da430c1..62f962e73e97 100644
--- a/libibverbs/src/CMakeLists.txt
+++ b/libibverbs/src/CMakeLists.txt
@@ -27,7 +27,7 @@ rdma_library(ibverbs libibverbs.map 1 1.0.0
   sysfs.c
   verbs.c
   )
-target_link_libraries(ibverbs PRIVATE
+target_link_libraries(ibverbs LINK_PRIVATE
   ${NL_LIBRARIES}
   ${CMAKE_THREAD_LIBS_INIT}
   ${CMAKE_DL_LIBS}
diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/src/CMakeLists.txt
index c68b277f8c1c..da7ee1c95167 100644
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
