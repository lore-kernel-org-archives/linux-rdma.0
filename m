From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Sun, 12 Feb 2017 16:16:52 +0200
Message-ID: <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486909012-15064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Install direct verbs header file into /usr/include/infiniband/
folder and allow for possible users to explicitly include it
into their applications.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/rdma_functions.cmake    | 51 ++++++++++++++++++++++++++++++++++++++++
 buildlib/relpath                 |  7 ++++++
 debian/ibverbs-providers.install |  4 ++++
 debian/ibverbs-providers.symbols |  4 ++++
 providers/mlx5/CMakeLists.txt    |  7 +++++-
 providers/mlx5/libmlx5.map       |  8 +++++++
 redhat/rdma-core.spec            |  3 +++
 7 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 buildlib/relpath
 create mode 100644 debian/ibverbs-providers.symbols
 create mode 100644 providers/mlx5/libmlx5.map

diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 5256ad9..5012e22 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -72,6 +72,57 @@ function(rdma_library DEST VERSION_SCRIPT SOVERSION VERSION)
   install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 endfunction()
 
+# Create a special provider with exported symbols in it The shared provider
+# exists as a normal system library with the normal shared library SONAME and
+# other convections. The system library is symlinked into the
+# VERBS_PROVIDER_DIR so it can be dlopened as a provider as well.
+function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
+  # Installed driver file
+  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" "driver ${DEST}\n")
+  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${DEST}.driver" DESTINATION "${CONFIG_DIR}")
+
+  # Uninstalled driver file
+  file(MAKE_DIRECTORY "${BUILD_ETC}/libibverbs.d/")
+  file(WRITE "${BUILD_ETC}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/lib${DEST}\n")
+
+  # Create a static provider library
+  if (ENABLE_STATIC)
+    add_library(${DEST} STATIC ${ARGN})
+    set_target_properties(${DEST} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+    install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+
+    list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
+    set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
+  endif()
+
+  # Create the plugin shared library
+  add_library(${DEST} SHARED ${ARGN})
+  rdma_set_library_map(${DEST} ${VERSION_SCRIPT})
+
+  target_link_libraries(${DEST} LINK_PRIVATE ${COMMON_LIBS_PIC})
+  target_link_libraries(${DEST} LINK_PRIVATE ibverbs)
+  target_link_libraries(${DEST} LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
+  set_target_properties(${DEST} PROPERTIES
+    SOVERSION ${SOVERSION}
+    VERSION ${VERSION}
+    LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
+  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+
+  # Compute a relative symlink from VERBS_PROVIDER_DIR to LIBDIR
+  execute_process(COMMAND python ${CMAKE_SOURCE_DIR}/buildlib/relpath
+    "${CMAKE_INSTALL_FULL_LIBDIR}/lib${DEST}.so.${VERSION}"
+    "${VERBS_PROVIDER_DIR}"
+    OUTPUT_VARIABLE DEST_LINK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
+  rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")
+
+  # cmake doesn't create target DESTINATION directories until everything is
+  # finished, do it manually here so we can create the in-tree symlink.
+  execute_process(COMMAND "${CMAKE_COMMAND}" -E make_directory "${BUILD_LIB}")
+  execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink
+    "lib${DEST}.so.${VERSION}"
+    "${BUILD_LIB}/lib${DEST}-rdmav2.so")
+endfunction()
+
 # Create a provider shared library for libibverbs
 function(rdma_provider DEST)
   # Installed driver file
diff --git a/buildlib/relpath b/buildlib/relpath
new file mode 100644
index 0000000..b80cf63
--- /dev/null
+++ b/buildlib/relpath
@@ -0,0 +1,7 @@
+#!/usr/bin/env python
+# Copyright 2017 Mellanox Technologies, Inc. See COPYING.
+
+import os
+import sys
+
+print(os.path.relpath(sys.argv[1], sys.argv[2]))
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 70244ee..7bacc2e 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -1,8 +1,12 @@
+usr/include/infiniband/mlx5dv.h
 etc/libibverbs.d/
 etc/modprobe.d/truescale.conf
 usr/bin/rxe_cfg
 usr/lib/*/libibverbs/lib*-rdmav2.so
+usr/lib/*/libmlx5.*
 usr/lib/truescale-serdes.cmds
 usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
+usr/share/man/man3/mlx5dv_*.3
+usr/share/man/man7/mlx5dv.7
 usr/share/man/man7/rxe.7
 usr/share/man/man8/rxe_cfg.8
diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
new file mode 100644
index 0000000..b114deb
--- /dev/null
+++ b/debian/ibverbs-providers.symbols
@@ -0,0 +1,4 @@
+libmlx5.so.1 ibverbs-providers #MINVER#
+ MLX5_1.0@MLX5_1.0 13-1
+ mlx5dv_init_obj@MLX5_1.0 13-1
+ mlx5dv_query_device@MLX5_1.0 13-1
diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index 44df83b..25e10af 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -10,7 +10,8 @@ if (MLX5_MW_DEBUG)
   add_definitions("-DMW_DEBUG")
 endif()
 
-rdma_provider(mlx5
+rdma_shared_provider(mlx5 libmlx5.map
+  1 1.0.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
@@ -19,3 +20,7 @@ rdma_provider(mlx5
   srq.c
   verbs.c
 )
+
+publish_headers(infiniband
+  mlx5dv.h
+)
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
new file mode 100644
index 0000000..7ce3eb1
--- /dev/null
+++ b/providers/mlx5/libmlx5.map
@@ -0,0 +1,8 @@
+/* Export symbols should be added below according to
+   Documentation/versioning.md document. */
+MLX5_1.0 {
+	global:
+		mlx5dv_query_device;
+		mlx5dv_init_obj;
+	local: *;
+};
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 9bdfdff..ade4b4a 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -359,12 +359,15 @@ rm -rf %{buildroot}/%{_initrddir}/
 %dir %{_libdir}/libibverbs
 %{_libdir}/libibverbs*.so.*
 %{_libdir}/libibverbs/*.so
+%{_libdir}/libmlx5.so*
 %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
 %doc %{_docdir}/%{name}-%{version}/libibverbs.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
 %{_bindir}/rxe_cfg
 %{_mandir}/man7/rxe*
 %{_mandir}/man8/rxe*
+%{_mandir}/man3/mlx5dv*
+%{_mandir}/man7/mlx5dv*
 
 %files -n libibverbs-utils
 %{_bindir}/ibv_*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
