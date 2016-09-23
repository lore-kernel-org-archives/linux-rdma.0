From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 09/13] verbs: Move the providers into /usr/lib.../libibverbs by default
Date: Fri, 23 Sep 2016 13:17:04 -0600
Message-ID: <1474658228-5390-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Debian packaging has always used this path, provide
official support for this configuration so Debian does not
rely on the absolute path in the .driver file, which breaks biarch.

Since there is no reason for the providers to be in the system
library search path (they export no symbols, and have no soname)
make this the default configuration.

The old behaviour can be restored by using:

 cmake -DVERBS_PROVIDER_DIR=''

This continues to support out-of-tree drivers by searching both
the provider path and the system library path if an unqualified
name is given in the .driver file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                |  6 +++++
 buildlib/config.h.in          |  2 ++
 buildlib/rdma_functions.cmake | 16 ++++++++-----
 libibverbs/src/init.c         | 55 ++++++++++++++++++++++++++++++-------------
 4 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 713788f188e3..7ae236f88f67 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -17,6 +17,8 @@
 #      and do not build iwpmd.
 #  -DENABLE_STATIC=1 (default disabled)
 #      Produce static libraries along with the usual shared libraries.
+#  -DVERBS_PROVIDER_DIR='' (default /usr/lib.../libibverbs)
+#      Use the historical search path for providers, in the standard system library.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(RDMA C)
@@ -53,6 +55,10 @@ set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd"
 set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
   CACHE PATH "Location for ibacm provider plugin shared library files.")
 
+# Location to find the provider plugin shared library files
+set(VERBS_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/libibverbs"
+  CACHE PATH "Location for provider plugin shared library files. If set to empty the system search path is used.")
+
 # Allow the 'run' dir to be configurable, this historically has been /var/run, but
 # some systems now use /run/
 set(CMAKE_INSTALL_RUNDIR "var/run"
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 78994a39d7ad..8ae2a4e536c0 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -31,6 +31,8 @@
 #define IBACM_PORT_FILE "@CMAKE_INSTALL_FULL_RUNDIR@/ibacm.port"
 #define IBACM_LOG_FILE "@CMAKE_INSTALL_FULL_LOCALSTATEDIR@/log/ibacm.log"
 
+#define VERBS_PROVIDER_DIR "@VERBS_PROVIDER_DIR@"
+
 // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
 #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
 
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 260dd18d78df..06ccd518c81d 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -78,11 +78,6 @@ function(rdma_provider DEST)
   file(MAKE_DIRECTORY "${BUILD_LIB}/libibverbs.d/")
   file(WRITE "${BUILD_LIB}/libibverbs.d/${DEST}.driver" "driver ${BUILD_LIB}/${DEST}\n")
 
-  # FIXME: This symlink is provided for compat with the old build, but it
-  # never should have existed in the first place, nothing should use this
-  # name, we can probably remove it.
-  rdma_install_symlink("lib${DEST}-rdmav2.so" "${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so")
-
   # Create a static provider library
   # FIXME: This is probably pointless, the provider library has no symbols so
   # what good is it? Presumably it should be used with -Wl,--whole-archive,
@@ -108,7 +103,16 @@ function(rdma_provider DEST)
   # Provider Plugins do not use SONAME versioning, there is no reason to
   # create the usual symlinks.
 
-  install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+  if (VERBS_PROVIDER_DIR)
+    install(TARGETS ${DEST} DESTINATION "${VERBS_PROVIDER_DIR}")
+  else()
+    install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
+
+    # FIXME: This symlink is provided for compat with the old build, but it
+    # never should have existed in the first place, nothing should use this
+    # name, we can probably remove it.
+    rdma_install_symlink("lib${DEST}-rdmav2.so" "${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so")
+  endif()
 endfunction()
 
  # Create an installed executable
diff --git a/libibverbs/src/init.c b/libibverbs/src/init.c
index bca0e02d11e1..7ae0fc87d332 100644
--- a/libibverbs/src/init.c
+++ b/libibverbs/src/init.c
@@ -190,33 +190,56 @@ void verbs_register_driver(const char *name, verbs_driver_init_func init_func)
 	register_driver(name, NULL, init_func);
 }
 
+#define __IBV_QUOTE(x)	#x
+#define IBV_QUOTE(x)	__IBV_QUOTE(x)
+#define DLOPEN_TRAILER "-" IBV_QUOTE(IBV_DEVICE_LIBRARY_EXTENSION) ".so"
+
 static void load_driver(const char *name)
 {
 	char *so_name;
 	void *dlhandle;
 
-#define __IBV_QUOTE(x)	#x
-#define IBV_QUOTE(x)	__IBV_QUOTE(x)
-
-	if (asprintf(&so_name,
-		     name[0] == '/' ?
-		     "%s-" IBV_QUOTE(IBV_DEVICE_LIBRARY_EXTENSION) ".so" :
-		     "lib%s-" IBV_QUOTE(IBV_DEVICE_LIBRARY_EXTENSION) ".so",
-		     name) < 0) {
-		fprintf(stderr, PFX "Warning: couldn't load driver '%s'.\n",
-			name);
+	/* If the name is an absolute path then open that path after appending
+	   the trailer suffix */
+	if (name[0] == '/') {
+		if (asprintf(&so_name, "%s" DLOPEN_TRAILER, name) < 0)
+			goto out_asprintf;
+		dlhandle = dlopen(so_name, RTLD_NOW);
+		if (!dlhandle)
+			goto out_dlopen;
+		free(so_name);
 		return;
 	}
 
-	dlhandle = dlopen(so_name, RTLD_NOW);
-	if (!dlhandle) {
-		fprintf(stderr, PFX "Warning: couldn't load driver '%s': %s\n",
-			name, dlerror());
-		goto out;
+	/* If configured with a provider plugin path then try that next */
+	if (sizeof(VERBS_PROVIDER_DIR) >= 1) {
+		if (asprintf(&so_name, VERBS_PROVIDER_DIR "/lib%s" DLOPEN_TRAILER, name) <
+		    0)
+			goto out_asprintf;
+		dlhandle = dlopen(so_name, RTLD_NOW);
+		free(so_name);
+		if (dlhandle)
+			return;
 	}
 
-out:
+	/* Otherwise use the system libary search path. This is the historical
+	   behavior of libibverbs */
+	if (asprintf(&so_name, "lib%s" DLOPEN_TRAILER, name) < 0)
+		goto out_asprintf;
+	dlhandle = dlopen(so_name, RTLD_NOW);
+	if (!dlhandle)
+		goto out_dlopen;
+	free(so_name);
+	return;
+
+out_asprintf:
+	fprintf(stderr, PFX "Warning: couldn't load driver '%s'.\n", name);
+	return;
+out_dlopen:
+	fprintf(stderr, PFX "Warning: couldn't load driver '%s': %s\n", so_name,
+		dlerror());
 	free(so_name);
+	return;
 }
 
 static void load_drivers(void)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
