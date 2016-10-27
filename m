From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/4] Support -DKERNEL_DIR to use kernel UAPI headers directly
Date: Thu, 27 Oct 2016 17:06:07 -0600
Message-ID: <1477609570-8087-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477609570-8087-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is useful to painlessly test if the kernel headers work with the
build. All the kernel header shimming is moved into
buildlib/RDMA_LinuxHeaders.cmake, new headers can be added to the list.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                   | 11 ++----
 buildlib/RDMA_LinuxHeaders.cmake | 85 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 7 deletions(-)
 create mode 100644 buildlib/RDMA_LinuxHeaders.cmake

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 230aab5ee01f..7abaa895c173 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -19,6 +19,8 @@
 #      Produce static libraries along with the usual shared libraries.
 #  -DVERBS_PROVIDER_DIR='' (default /usr/lib.../libibverbs)
 #      Use the historical search path for providers, in the standard system library.
+#  -DKERNEL_DIR='.../linux' (default '')
+#      If set use the kernel UAPI headers from this kernel source tree.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(RDMA C)
@@ -241,10 +243,7 @@ endif()
 # should rely on this.
 check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
 
-# Are our kernel headers new enough?
-# If not replace them with built-in copies so we can continue to build.
-CHECK_INCLUDE_FILE("rdma/rdma_user_rxe.h" HAVE_RDMA_USER_RXE)
-RDMA_DoFixup("${HAVE_RDMA_USER_RXE}" "rdma/rdma_user_rxe.h")
+include(RDMA_LinuxHeaders)
 
 #-------------------------
 # Apply fixups
@@ -375,9 +374,7 @@ else()
     message(STATUS " netlink/route/link.h and net/if.h NOT co-includable (old headers)")
   endif()
 endif()
-if (NOT HAVE_RDMA_USER_RXE)
-  message(STATUS " rdma/rdma_user_rxe.h NOT found (old system kernel headers)")
-endif()
+rdma_report_missing_kheaders()
 if (NOT HAVE_C_WARNINGS)
   message(STATUS " extended C warnings NOT supported")
 endif()
diff --git a/buildlib/RDMA_LinuxHeaders.cmake b/buildlib/RDMA_LinuxHeaders.cmake
new file mode 100644
index 000000000000..bd16d8deca72
--- /dev/null
+++ b/buildlib/RDMA_LinuxHeaders.cmake
@@ -0,0 +1,85 @@
+# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
+
+# Check that the system kernel headers are new enough, if not replace the
+# headers with our internal copy.
+
+set(DEFAULT_TEST "int main(int argc,const char *argv[]) {return 1;}")
+set(MISSING_HEADERS "")
+
+function(rdma_canon_header PATH OUT_VAR)
+  string(TOUPPER "${PATH}" HAVE)
+  string(REPLACE " " "_" HAVE "${HAVE}")
+  string(REPLACE "/" "_" HAVE "${HAVE}")
+  string(REPLACE "." "_" HAVE "${HAVE}")
+  set("${OUT_VAR}" "HAVE_${HAVE}" PARENT_SCOPE)
+endfunction()
+
+function(rdma_check_kheader PATH C_TEST)
+  rdma_canon_header("${PATH}" HAVE)
+
+  if(KERNEL_DIR)
+    # Drop a symlink back to the kernel into our include/ directory
+    if (EXISTS "${KERNEL_DIR}/include/uapi/${PATH}")
+      set(DEST "${BUILD_INCLUDE}/${PATH}")
+
+      if(CMAKE_VERSION VERSION_LESS "2.8.12")
+	get_filename_component(DIR ${DEST} PATH)
+      else()
+	get_filename_component(DIR ${DEST} DIRECTORY)
+      endif()
+      file(MAKE_DIRECTORY "${DIR}")
+
+      # We cannot just -I the kernel UAPI dir, it depends on some
+      # post-processing of things like linux/stddef.h. Instead we symlink the
+      # kernel headers into our tree and rely on the distro's fixup of
+      # non-rdma headers.  The RDMA headers are all compatible with this
+      # scheme.
+      execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "create_symlink"
+	"${KERNEL_DIR}/include/uapi/${PATH}"
+	"${DEST}")
+    else()
+      message(FATAL_ERROR "Kernel tree does not contain expected UAPI header"
+	"${KERNEL_DIR}/include/uapi/${PATH}")
+    endif()
+
+    set(CMAKE_REQUIRED_INCLUDES "${BUILD_INCLUDE}")
+  endif()
+
+  # Note: The RDMA kernel headers use sockaddr{_in,_in6,}/etc so we have to
+  # include system headers to define sockaddrs before testing any of them.
+  CHECK_C_SOURCE_COMPILES("
+ #include <sys/socket.h>
+ #include <netinet/in.h>
+ #include <${PATH}>
+${C_TEST}" "${HAVE}")
+
+  if(KERNEL_DIR)
+    if (NOT "${${HAVE}}")
+      # Run the compile test against the linked kernel header, this is to help
+      # make sure the compile tests work before the headers hit the distro
+      message(FATAL_ERROR "Kernel UAPI header failed compile test"
+	"${PATH}")
+    endif()
+  else()
+    RDMA_DoFixup("${${HAVE}}" "${PATH}")
+    if (NOT "${${HAVE}}")
+      list(APPEND MISSING_HEADERS "${PATH}")
+      set(MISSING_HEADERS "${MISSING_HEADERS}" PARENT_SCOPE)
+    endif()
+  endif()
+endfunction()
+
+function(rdma_report_missing_kheaders)
+  foreach(I IN LISTS MISSING_HEADERS)
+    message(STATUS " ${I} NOT found (old system kernel headers)")
+  endforeach()
+endfunction()
+
+# This list is topologically sorted
+rdma_check_kheader("rdma/ib_user_verbs.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/ib_user_sa.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/ib_user_cm.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/ib_user_mad.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/rdma_netlink.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/rdma_user_cm.h" "${DEFAULT_TEST}")
+rdma_check_kheader("rdma/rdma_user_rxe.h" "${DEFAULT_TEST}")
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
