From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 04/13] Do not produce static libraries by default
Date: Fri, 23 Sep 2016 13:16:59 -0600
Message-ID: <1474658228-5390-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We no longer recommend that static libraries are distributed, this
never worked sanely for libibverbs.

Use:
 cmake -DENABLE_STATIC=1

To restore the old behaviour

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                |  6 ++++++
 buildlib/rdma_functions.cmake | 34 +++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index be82c2896d75..9b9e34e5cd9d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -15,6 +15,8 @@
 #  -DENABLE_RESOLVE_NEIGH=0 (default enabled)
 #      Do not link to libnl and do not resolve neighbours internally for Ethernet,
 #      and do not build iwpmd.
+#  -DENABLE_STATIC=1 (default disabled)
+#      Produce static libraries along with the usual shared libraries.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(RDMA C)
@@ -66,6 +68,10 @@ include(RDMA_DoFixup)
 include(publish_headers)
 include(rdma_functions)
 
+if (NOT DEFINED ENABLE_STATIC)
+  set(ENABLE_STATIC "OFF" CACHE BOOL "Produce static linking libraries as well as shared libraries.")
+endif()
+
 #-------------------------
 # Setup the basic C compiler
 RDMA_BuildType()
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 8fe8828c0e84..a4ecd7d4f2fe 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -47,14 +47,16 @@ endfunction()
 # Basic function to produce a standard libary with a GNU LD version script.
 function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
   # Create a static library
-  add_library(${DEST}-static STATIC ${ARGN})
-  set_target_properties(${DEST}-static PROPERTIES
-    OUTPUT_NAME ${DEST}
-    LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
-  install(TARGETS ${DEST}-static DESTINATION "${CMAKE_INSTALL_LIBDIR}")
-
-  list(APPEND RDMA_STATIC_LIBS ${DEST} ${DEST}-static)
-  set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+  if (ENABLE_STATIC)
+    add_library(${DEST}-static STATIC ${ARGN})
+    set_target_properties(${DEST}-static PROPERTIES
+      OUTPUT_NAME ${DEST}
+      LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    install(TARGETS ${DEST}-static DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+
+    list(APPEND RDMA_STATIC_LIBS ${DEST} ${DEST}-static)
+    set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+  endif()
 
   # Create a shared library
   add_library(${DEST} SHARED ${ARGN})
@@ -85,12 +87,14 @@ function(rdma_provider DEST)
   # FIXME: This is probably pointless, the provider library has no symbols so
   # what good is it? Presumably it should be used with -Wl,--whole-archive,
   # but we don't have any directions on how to make static linking work..
-  add_library(${DEST} STATIC ${ARGN})
-  set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
-  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+  if (ENABLE_STATIC)
+    add_library(${DEST} STATIC ${ARGN})
+    set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
-  list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
-  set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+    list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
+    set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+  endif()
 
   # Create the plugin shared library
   set(DEST ${DEST}-rdmav2)
@@ -155,6 +159,10 @@ endfunction()
 # from the shared and setting up the libtool .la files.
 function(rdma_finalize_libs)
   list(LENGTH RDMA_STATIC_LIBS LEN)
+  if (LEN LESS 2)
+    return()
+  endif()
+
   math(EXPR LEN ${LEN}-1)
   foreach(I RANGE 0 ${LEN} 2)
     list(GET RDMA_STATIC_LIBS ${I} SHARED)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
