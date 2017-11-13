From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 1/2] buildlib: use cmake to find python
Date: Mon, 13 Nov 2017 14:00:15 +0100
Message-ID: <1923c475-0597-a597-36a5-8a33cccae6ef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Depending on the system, python might not be available as pythomn (but python2, python3, etc.)
Use FIND_PACKAGE to get the right executable.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 CMakeLists.txt                | 3 +++
 buildlib/rdma_functions.cmake | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5e6f245a..a283fba3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -279,6 +279,9 @@ else()
   set(HAVE_FULL_SYMBOL_VERSIONS 1)
 endif()
 
+# Look for Python
+FIND_PACKAGE (PythonInterp)
+
 #-------------------------
 # Find libraries
 # pthread
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index d69afd3d..53a978e8 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -144,7 +144,7 @@ function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
   install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
   # Compute a relative symlink from VERBS_PROVIDER_DIR to LIBDIR
-  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
+  execute_process(COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/buildlib/relpath
     "${CMAKE_INSTALL_FULL_LIBDIR}/lib${DEST}.so.${VERSION}"
     "${VERBS_PROVIDER_DIR}"
     OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE
-- 
2.15.0.167.g7819e496d


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
