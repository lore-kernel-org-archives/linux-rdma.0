From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/5] Improve linker flag detection to work with clang and -Werror
Date: Fri,  7 Oct 2016 16:36:11 -0600
Message-ID: <1475879772-29458-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475879772-29458-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a linker flag is passed to a clang compile command then it
prints out a warning that the flag is a linker flag. If -Werror
is set then the warning is an error and all linker flag detection
is broken.

The fix is to only pass linker flags to the linker. cmake does not have
an integrated way to do this until 3.2, the recommended approach is to
abuse CMAKE_REQUIRED_LIBRARIES on older versions.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                 | 21 +++++++++++++--------
 buildlib/FindLDSymVer.cmake    | 16 ++++++++++++----
 buildlib/RDMA_EnableCStd.cmake | 25 +++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1611e90d7933..4d291d2c3fb7 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -31,6 +31,11 @@ else()
   string(REPLACE "-rdynamic" "" CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS}")
 endif()
 
+# Make RDMA_CHECK_C_LINKER_FLAG work better
+if(POLICY CMP0056)
+  cmake_policy(SET CMP0056 NEW)
+endif()
+
 set(PACKAGE_NAME "RDMA")
 
 # See Documentation/versioning.md
@@ -150,18 +155,18 @@ CHECK_C_SOURCE_COMPILES("
 
 # Enable development support features
 # Prune unneeded shared libraries during linking
-RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
-RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
-RDMA_AddOptCFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+RDMA_AddOptLDFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+RDMA_AddOptLDFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
+RDMA_AddOptLDFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_AS_NEEDED "-Wl,--as-needed")
 
 # Ensure all shared ELFs have fully described linking
-RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
-RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+RDMA_AddOptLDFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
+RDMA_AddOptLDFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undefined")
 
 # Enable gold linker - gold has different linking checks
-#RDMA_AddOptCFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
-#RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
-#RDMA_AddOptCFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptLDFlag(CMAKE_EXE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptLDFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
+#RDMA_AddOptLDFlag(CMAKE_MODULE_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-fuse-ld=gold")
 
 # Verify that GNU --version-script and asm(".symver") works
 find_package(LDSymVer REQUIRED)
diff --git a/buildlib/FindLDSymVer.cmake b/buildlib/FindLDSymVer.cmake
index c0f01a562e32..7169b2c4db68 100644
--- a/buildlib/FindLDSymVer.cmake
+++ b/buildlib/FindLDSymVer.cmake
@@ -16,8 +16,14 @@ IBVERBS_1.1 {
 } IBVERBS_1.0;
 ")
 
-set(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
-set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS} "-Wl,--version-script=${CMAKE_CURRENT_BINARY_DIR}/test.map")
+# See RDMA_CHECK_C_LINKER_FLAG
+set(SAFE_CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES}")
+set(SAFE_CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")
+if (POLICY CMP0056)
+  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--version-script=${CMAKE_CURRENT_BINARY_DIR}/test.map")
+else()
+  set(CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES} -Wl,--version-script=${CMAKE_CURRENT_BINARY_DIR}/test.map")
+endif()
 
 # And matching source, this also checks that .symver asm works
 check_c_source_compiles("
@@ -26,9 +32,11 @@ asm(\".symver ibv_get_device_list_1, ibv_get_device_list@IBVERBS_1.1\");
 void ibv_get_device_list_0(void){}
 asm(\".symver ibv_get_device_list_0, ibv_get_device_list@@IBVERBS_1.0\");
 
-int main(void){return 0;}" _LDSYMVER_SUCCESS)
+int main(int argc,const char *argv[]){return 0;}" _LDSYMVER_SUCCESS)
+
 file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/test.map")
-set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})
+set(CMAKE_EXE_LINKER_FLAGS "${SAFE_CMAKE_EXE_LINKER_FLAGS}")
+set(CMAKE_REQUIRED_LIBRARIES "${SAFE_CMAKE_REQUIRED_LIBRARIES}")
 
 if (_LDSYMVER_SUCCESS)
   set(LDSYMVER_MODE "GNU" CACHE INTERNAL "How to set symbol versions on shared libraries")
diff --git a/buildlib/RDMA_EnableCStd.cmake b/buildlib/RDMA_EnableCStd.cmake
index 9cbbb881cd19..bcf3ea525c73 100644
--- a/buildlib/RDMA_EnableCStd.cmake
+++ b/buildlib/RDMA_EnableCStd.cmake
@@ -1,5 +1,30 @@
 # COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
 
+# cmake does not have way to do this even slightly sanely until CMP0056
+function(RDMA_CHECK_C_LINKER_FLAG FLAG CACHE_VAR)
+  set(SAFE_CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES}")
+  set(SAFE_CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")
+
+  if (POLICY CMP0056)
+    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${FLAG}")
+  else()
+    set(CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES} ${FLAG}")
+  endif()
+
+  CHECK_C_COMPILER_FLAG("" ${CACHE_VAR})
+
+  set(CMAKE_EXE_LINKER_FLAGS "${SAFE_CMAKE_EXE_LINKER_FLAGS}")
+  set(CMAKE_REQUIRED_LIBRARIES "${SAFE_CMAKE_REQUIRED_LIBRARIES}")
+endfunction()
+
+# Test if the CC compiler supports the linker flag and if so add it to TO_VAR
+function(RDMA_AddOptLDFlag TO_VAR CACHE_VAR FLAG)
+  RDMA_CHECK_C_LINKER_FLAG("${FLAG}" ${CACHE_VAR})
+  if (${CACHE_VAR})
+    SET(${TO_VAR} "${${TO_VAR}} ${FLAG}" PARENT_SCOPE)
+  endif()
+endfunction()
+
 # Test if the CC compiler supports the flag and if so add it to TO_VAR
 function(RDMA_AddOptCFlag TO_VAR CACHE_VAR FLAG)
   CHECK_C_COMPILER_FLAG("${FLAG}" ${CACHE_VAR})
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
