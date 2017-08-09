From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] verbs: Change the provider library file name suffix
Date: Wed, 9 Aug 2017 15:54:00 -0600
Message-ID: <20170809215400.GA6921@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This should have been changed when the private provider API was
introduced..

The intent of the 'rdmav2' suffix was to indicate the provider is ABI
compatible with the libibverbs loading it, with the new scheme the only
providers which are compatible have the same ABI private version.

Change the suffix to be rdmav15 to match the current private version,
and set things up to be able to track the map file/etc.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                   |  5 +++++
 buildlib/check-build             | 36 +++++++++++++++++++++++++++++++-----
 buildlib/config.h.in             |  1 +
 buildlib/rdma_functions.cmake    | 10 +++++-----
 debian/ibverbs-providers.install |  2 +-
 libibverbs/driver.h              |  7 -------
 libibverbs/ibverbs.h             |  2 --
 libibverbs/init.c                | 13 +++++--------
 8 files changed, 48 insertions(+), 28 deletions(-)

This will help Steve Wise out in his goal to make out of tree provider
modules..

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 617b3f5b01b077..2324cf49aff5a8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -45,6 +45,11 @@ set(PACKAGE_NAME "RDMA")
 
 # See Documentation/versioning.md
 set(PACKAGE_VERSION "15")
+# When this is changed the values in these files need changing too:
+#   debian/libibverbs1.symbols
+#   libibverbs/libibverbs.map
+set(IBVERBS_PABI_VERSION "15")
+set(IBVERBS_PROVIDER_SUFFIX "-rdmav${IBVERBS_PABI_VERSION}.so")
 
 #-------------------------
 # Basic standard paths
diff --git a/buildlib/check-build b/buildlib/check-build
index f12c4458600ed3..7671f4eb710bb0 100755
--- a/buildlib/check-build
+++ b/buildlib/check-build
@@ -48,7 +48,7 @@ def private_tmp():
 
 # -------------------------------------------------------------------------
 
-def get_symbol_vers(fn):
+def get_symbol_vers(fn,exported=True):
     """Return the symbol version suffixes from the ELF file, eg IB_VERBS_1.0, etc"""
     syms = subprocess.check_output(["readelf","--wide","-s",fn]);
     go = False;
@@ -60,13 +60,18 @@ def get_symbol_vers(fn):
 
         if I.startswith(" ") and go:
             itms = I.split();
-            if (len(itms) == 8 and itms[3] == "OBJECT" and
-                itms[4] == "GLOBAL" and itms[6] == "ABS"):
-                res.add(itms[7]);
+            if exported:
+                if (len(itms) == 8 and itms[3] == "OBJECT" and
+                    itms[4] == "GLOBAL" and itms[6] == "ABS"):
+                    res.add(itms[7]);
+            else:
+                if (len(itms) >= 8 and itms[3] == "FUNC" and
+                    itms[4] == "GLOBAL" and itms[6] == "UND"):
+                    res.add(itms[7]);
         else:
             go = False;
     if not res:
-        raise ValueError("Faild to read ELF symbol versions from %r"%(fn));
+        raise ValueError("Failed to read ELF symbol versions from %r"%(fn));
     return res;
 
 def check_lib_symver(args,fn):
@@ -114,6 +119,27 @@ def test_lib_names(args):
                 lfn = os.readlink(fn);
                 if not os.path.islink(lfn):
                     check_lib_symver(args,lfn);
+# -------------------------------------------------------------------------
+
+def check_verbs_abi(args,fn):
+    g = re.match(r"lib([^-]+)-rdmav(\d+).so",fn);
+    if g is None:
+        raise ValueError("Provider library has unknown file name format %r"%(fn));
+
+    private_ver = int(g.group(2));
+    syms = get_symbol_vers(fn,exported=False);
+    syms = {I.partition("@")[2] for I in syms};
+    assert "IBVERBS_PRIVATE_%u"%(private_ver) in syms;
+    assert len([I for I in syms if I.startswith("IBVERBS_PRIVATE")]) == 1;
+
+def test_verbs_private(args):
+    """Check that the IBVERBS_PRIVATE symbols match the library name, eg that the
+    map file and the cmake stuff are in sync."""
+    libd = os.path.join(args.BUILD,"lib");
+    with inDirectory(libd):
+        for fn in os.listdir("."):
+            if not os.path.islink(fn) and "rdmav" in fn:
+                check_verbs_abi(args,fn);
 
 # -------------------------------------------------------------------------
 
diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 2eb16be764630e..b879bc9034d328 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -24,6 +24,7 @@
 #define IBACM_LOG_FILE "@CMAKE_INSTALL_FULL_LOCALSTATEDIR@/log/ibacm.log"
 
 #define VERBS_PROVIDER_DIR "@VERBS_PROVIDER_DIR@"
+#define VERBS_PROVIDER_SUFFIX "@IBVERBS_PROVIDER_SUFFIX@"
 
 // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
 #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
diff --git a/buildlib/rdma_functions.cmake b/buildlib/rdma_functions.cmake
index 787efbf0b3dba6..ba1bf9c5c5f0c5 100644
--- a/buildlib/rdma_functions.cmake
+++ b/buildlib/rdma_functions.cmake
@@ -151,8 +151,8 @@ function(rdma_shared_provider DEST VERSION_SCRIPT SOVERSION VERSION)
     message(FATAL_ERROR "Unable to run buildlib/relpath, do you have python?")
   endif()
 
-  rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}-rdmav2.so")
-  rdma_create_symlink("lib${DEST}.so.${VERSION}" "${BUILD_LIB}/lib${DEST}-rdmav2.so")
+  rdma_install_symlink("${DEST_LINK_PATH}" "${VERBS_PROVIDER_DIR}/lib${DEST}${IBVERBS_PROVIDER_SUFFIX}")
+  rdma_create_symlink("lib${DEST}.so.${VERSION}" "${BUILD_LIB}/lib${DEST}${IBVERBS_PROVIDER_SUFFIX}")
 endfunction()
 
 # Create a provider shared library for libibverbs
@@ -174,12 +174,12 @@ function(rdma_provider DEST)
     set_target_properties(${DEST} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${BUILD_LIB}")
     install(TARGETS ${DEST} DESTINATION "${CMAKE_INSTALL_LIBDIR}")
 
-    list(APPEND RDMA_STATIC_LIBS ${DEST}-rdmav2 ${DEST})
+    list(APPEND RDMA_STATIC_LIBS "${DEST}-rdmav${IBVERBS_PABI_VERSION}" ${DEST})
     set(RDMA_STATIC_LIBS "${RDMA_STATIC_LIBS}" CACHE INTERNAL "")
   endif()
 
   # Create the plugin shared library
-  set(DEST ${DEST}-rdmav2)
+  set(DEST "${DEST}-rdmav${IBVERBS_PABI_VERSION}")
   add_library(${DEST} MODULE ${ARGN})
   # Even though these are modules we still want to use Wl,--no-undefined
   set_target_properties(${DEST} PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
@@ -199,7 +199,7 @@ function(rdma_provider DEST)
     # FIXME: This symlink is provided for compat with the old build, but it
     # never should have existed in the first place, nothing should use this
     # name, we can probably remove it.
-    rdma_install_symlink("lib${DEST}-rdmav2.so" "${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so")
+    rdma_install_symlink("lib${DEST}${IBVERBS_PROVIDER_SUFFIX}" "${CMAKE_INSTALL_LIBDIR}/lib${DEST}.so")
   endif()
 endfunction()
 
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 73088d82f6e0e8..43a8727f30e305 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -1,4 +1,4 @@
 etc/libibverbs.d/
-usr/lib/*/libibverbs/lib*-rdmav2.so
+usr/lib/*/libibverbs/lib*-rdmav*.so
 usr/lib/*/libmlx4.so.*
 usr/lib/*/libmlx5.so.*
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 298bd356ca3170..8ece40e28629b9 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -48,13 +48,6 @@
 #  define END_C_DECLS
 #endif /* __cplusplus */
 
-/*
- * Extension that low-level drivers should add to their .so filename
- * (probably via libtool "-release" option).  For example a low-level
- * driver named "libfoo" should build a plug-in named "libfoo-rdmav2.so".
- */
-#define IBV_DEVICE_LIBRARY_EXTENSION rdmav2
-
 struct verbs_device;
 
 enum verbs_xrcd_mask {
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 05fd2c88ea694f..c8e993c314876a 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -47,8 +47,6 @@
 #define symver(name, api, ver) asm(".symver " #name "," #api "@" #ver)
 #define default_symver(name, api)                                              \
 	asm(".symver " #name "," #api "@@" DEFAULT_ABI)
-#define private_symver(name, api)                                              \
-	asm(".symver " #name "," #api "@@IBVERBS_PRIVATE_14")
 
 #define PFX		"libibverbs: "
 
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 1c41b3692c5996..4d064bc6cdf213 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -192,10 +192,6 @@ void verbs_register_driver(const char *name,
 	tail_driver = driver;
 }
 
-#define __IBV_QUOTE(x)	#x
-#define IBV_QUOTE(x)	__IBV_QUOTE(x)
-#define DLOPEN_TRAILER "-" IBV_QUOTE(IBV_DEVICE_LIBRARY_EXTENSION) ".so"
-
 static void load_driver(const char *name)
 {
 	char *so_name;
@@ -204,7 +200,7 @@ static void load_driver(const char *name)
 	/* If the name is an absolute path then open that path after appending
 	   the trailer suffix */
 	if (name[0] == '/') {
-		if (asprintf(&so_name, "%s" DLOPEN_TRAILER, name) < 0)
+		if (asprintf(&so_name, "%s" VERBS_PROVIDER_SUFFIX, name) < 0)
 			goto out_asprintf;
 		dlhandle = dlopen(so_name, RTLD_NOW);
 		if (!dlhandle)
@@ -215,8 +211,9 @@ static void load_driver(const char *name)
 
 	/* If configured with a provider plugin path then try that next */
 	if (sizeof(VERBS_PROVIDER_DIR) > 1) {
-		if (asprintf(&so_name, VERBS_PROVIDER_DIR "/lib%s" DLOPEN_TRAILER, name) <
-		    0)
+		if (asprintf(&so_name,
+			     VERBS_PROVIDER_DIR "/lib%s" VERBS_PROVIDER_SUFFIX,
+			     name) < 0)
 			goto out_asprintf;
 		dlhandle = dlopen(so_name, RTLD_NOW);
 		free(so_name);
@@ -226,7 +223,7 @@ static void load_driver(const char *name)
 
 	/* Otherwise use the system libary search path. This is the historical
 	   behavior of libibverbs */
-	if (asprintf(&so_name, "lib%s" DLOPEN_TRAILER, name) < 0)
+	if (asprintf(&so_name, "lib%s" VERBS_PROVIDER_SUFFIX, name) < 0)
 		goto out_asprintf;
 	dlhandle = dlopen(so_name, RTLD_NOW);
 	if (!dlhandle)
-- 
2.7.4


-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
