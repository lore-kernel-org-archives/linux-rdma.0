From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/3] Add util/symver.h
Date: Thu, 24 Aug 2017 16:00:27 -0600
Message-ID: <1503612029-19854-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503612029-19854-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Macros to better support the Linux shared library symbol version mechanism.
These versions of the macros have a way to build with symbol versions
disabled for static linking, and also a way to disable all of the
compat symbols (eg to support uclibc).

The new cmake flag -DNO_COMPAT_SYMS=1 will cause the shared libraries
to be built only with default (@@) symbols.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                |   9 ++++
 buildlib/config.h.in          |   4 ++
 buildlib/rdma_functions.cmake |   3 ++
 util/CMakeLists.txt           |   1 +
 util/symver.h                 | 100 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 117 insertions(+)
 create mode 100644 util/symver.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2324cf49aff5a8..81ec949d6e9f4a 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -24,6 +24,10 @@
 #      Use the historical search path for providers, in the standard system library.
 #  -DKERNEL_DIR='.../linux' (default '')
 #      If set use the kernel UAPI headers from this kernel source tree.
+#  -DNO_COMPAT_SYMS=1 (default disabled)
+#      Do not generate backwards compatibility symbols in the shared
+#      libraries. This may is necessary if using a dynmic linker that does
+#      not support symbol versions, such as uclibc.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(rdma-core C)
@@ -267,6 +271,11 @@ RDMA_AddOptLDFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-unde
 
 # Verify that GNU --version-script and asm(".symver") works
 find_package(LDSymVer REQUIRED)
+if (NO_COMPAT_SYMS)
+  set(HAVE_LIMITED_SYMBOL_VERSIONS 1)
+else()
+  set(HAVE_FULL_SYMBOL_VERSIONS 1)
+endif()
 
 #-------------------------
 # Find libraries
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index b879bc9034d328..81982d89db3d5a 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -33,6 +33,10 @@
 
 #cmakedefine HAVE_WORKING_IF_H 1
 
+// Operating mode for symbol versions
+#cmakedefine HAVE_FULL_SYMBOL_VERSIONS 1
+#cmakedefine HAVE_LIMITED_SYMBOL_VERSIONS 1
+
 @SIZEOF_LONG_CODE@
 
 #if @NL_KIND@ == 3
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index ba1bf9c5c5f0c5..d69afd3deb7531 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -87,6 +87,7 @@ function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
     set_target_properties(${DEST}-static PROPERTIES
       OUTPUT_NAME ${DEST}
       ARCHIVE_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    target_compile_definitions(${DEST}-static PRIVATE _STATIC_LIBRARY_BUILD_=1)
     install(TARGETS ${DEST}-static DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
     list(APPEND RDMA_STATIC_LIBS ${DEST} ${DEST}-static)
@@ -122,6 +123,7 @@ function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
     add_library(${DEST}-static STATIC ${ARGN})
     set_target_properties(${DEST}-static PROPERTIES OUTPUT_NAME ${DEST})
     set_target_properties(${DEST}-static PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    target_compile_definitions(${DEST}-static PRIVATE _STATIC_LIBRARY_BUILD_=1)
     install(TARGETS ${DEST}-static DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
     list(APPEND RDMA_STATIC_LIBS ${DEST} ${DEST}-static)
@@ -172,6 +174,7 @@ function(rdma_provider DEST)
   if (ENABLE_STATIC)
     add_library(${DEST} STATIC ${ARGN})
     set_target_properties(${DEST} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    target_compile_definitions(${DEST} PRIVATE _STATIC_LIBRARY_BUILD_=1)
     install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
     list(APPEND RDMA_STATIC_LIBS "${DEST}-rdmav${IBVERBS_PABI_VERSION}" ${DEST})
diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
index 581bf6822ec39f..2ba6a7c79e222c 100644
--- a/util/CMakeLists.txt
+++ b/util/CMakeLists.txt
@@ -1,5 +1,6 @@
 publish_internal_headers(util
   compiler.h
+  symver.h
   util.h
   )
 
diff --git a/util/symver.h b/util/symver.h
new file mode 100644
index 00000000000000..e739b5a11cc2ac
--- /dev/null
+++ b/util/symver.h
@@ -0,0 +1,100 @@
+/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file
+
+   These definitions help using the ELF symbol version feature, and must be
+   used in conjunction with the library's map file.
+ */
+
+#ifndef __UTIL_SYMVER_H
+#define __UTIL_SYMVER_H
+
+#include <config.h>
+#include <ccan/str.h>
+
+/*
+  These macros should only be used if the library is defining compatibility
+  symbols, eg:
+
+    213: 000000000000a650   315 FUNC    GLOBAL DEFAULT   13 ibv_get_device_list@IBVERBS_1.0
+    214: 000000000000b020   304 FUNC    GLOBAL DEFAULT   13 ibv_get_device_list@@IBVERBS_1.1
+
+  Symbols which have only a single implementation should use a normal extern
+  function and be placed in the correct stanza in the linker map file.
+
+  Follow this pattern to use this feature:
+    public.h:
+      struct ibv_device **ibv_get_device_list(int *num_devices);
+    foo.c:
+      // Implement the latest version
+      LATEST_SYMVER_FUNC(ibv_get_device_list, 1_1, "IBVERBS_1.1",
+			 struct ibv_device **,
+			 int *num_devices)
+      {
+       ...
+      }
+
+      // Implement the compat version
+      COMPAT_SYMVER_FUNC(ibv_get_device_list, 1_0, "IBVERBS_1.0",
+			 struct ibv_device_1_0 **,
+			 int *num_devices)
+      {
+       ...
+      }
+
+  As well as matching information in the map file.
+
+  These macros deal with the various uglyness in gcc surrounding symbol
+  versions
+
+    - The internal name __public_1_x is synthesized by the macro
+    - A prototype for the internal name is created by the macro
+    - If statically linking the latest symbol expands into a normal function
+      definition
+    - If statically linking the compat symbols expand into unused static
+      functions are are discarded by the compiler.
+    - The prototype of the latest symbol is checked against the public
+      prototype (only when compiling statically)
+
+  The extra prototypes are included only to avoid -Wmissing-prototypes
+  warnings.  See also Documentation/versioning.md
+*/
+
+#define _MAKE_SYMVER(_local_sym, _public_sym, _ver_str)                        \
+	asm(".symver " #_local_sym "," #_public_sym "@" _ver_str)
+#define _MAKE_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)             \
+	_ret __##_public_sym##_##_uniq(__VA_ARGS__);                           \
+	_MAKE_SYMVER(__##_public_sym##_##_uniq, _public_sym, _ver_str);        \
+	_ret __##_public_sym##_##_uniq(__VA_ARGS__)
+
+#if defined(HAVE_FULL_SYMBOL_VERSIONS) && !defined(_STATIC_LIBRARY_BUILD_)
+
+    // Produce all symbol versions for dynamic linking
+
+#   define COMPAT_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)         \
+	_MAKE_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, __VA_ARGS__)
+#   define LATEST_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)         \
+	_MAKE_SYMVER_FUNC(_public_sym, _uniq, "@" _ver_str, _ret, __VA_ARGS__)
+
+#elif defined(HAVE_LIMITED_SYMBOL_VERSIONS) && !defined(_STATIC_LIBRARY_BUILD_)
+
+    /* Produce only implemenations for the latest symbol and tag it with the
+     * correct symbol versions. This supports dynamic linkers that do not
+     * understand symbol versions
+     */
+#    define COMPAT_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)        \
+	static inline _ret __##_public_sym##_##_uniq(__VA_ARGS__)
+#    define LATEST_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)        \
+	_MAKE_SYMVER_FUNC(_public_sym, _uniq, "@" _ver_str, _ret, __VA_ARGS__)
+
+#else
+
+    // Static linking, or linker does not support symbol versions
+#   define COMPAT_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)         \
+	static inline _ret __##_public_sym##_##_uniq(__VA_ARGS__)
+#   define LATEST_SYMVER_FUNC(_public_sym, _uniq, _ver_str, _ret, ...)         \
+	static _ret __##_public_sym##_##_uniq(__VA_ARGS__)                     \
+	    __attribute__((alias(stringify(_public_sym))));                    \
+	extern _ret _public_sym(__VA_ARGS__)
+
+#endif
+
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
