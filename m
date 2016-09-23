From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 12/13] Document a versioning strategy and use it
Date: Fri, 23 Sep 2016 13:17:07 -0600
Message-ID: <1474658228-5390-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is particularly important for the three shared libraries, and
we haven't been doing it right historically, perhaps due to libtool
braindamage.

The names of the shlibs are updated to:
  libibcm 1.0.11
  libibumad 3.1.11
  libibverbs 1.3.11
  librdmacm 1.1.11

The SONAME remains the same.

The overall package release is set to 11 due to libibumad having got up
to a .10 release.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                |   5 +-
 Documentation/versioning.md   | 108 ++++++++++++++++++++++++++++++++++++++++++
 libibcm/src/CMakeLists.txt    |   4 +-
 libibcm/src/libibcm.map       |   1 +
 libibumad/src/CMakeLists.txt  |   4 +-
 libibumad/src/libibumad.map   |   1 +
 libibverbs/src/CMakeLists.txt |   4 +-
 libibverbs/src/libibverbs.map |   1 +
 librdmacm/src/CMakeLists.txt  |   4 +-
 librdmacm/src/librdmacm.map   |   1 +
 10 files changed, 127 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/versioning.md

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 805b25bb8669..8d58db0b9c07 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -32,8 +32,9 @@ else()
 endif()
 
 set(PACKAGE_NAME "RDMA")
-# FIXME versioning strategy?
-set(PACKAGE_VERSION "1")
+
+# See Documentation/versioning.md
+set(PACKAGE_VERSION "11")
 
 #-------------------------
 # Basic standard paths
diff --git a/Documentation/versioning.md b/Documentation/versioning.md
new file mode 100644
index 000000000000..0cc542aa6b79
--- /dev/null
+++ b/Documentation/versioning.md
@@ -0,0 +1,108 @@
+# Overall Package Version
+
+This version number is set in the top level CMakeLists.txt:
+
+```sh
+set(PACKAGE_VERSION "11")
+````
+
+For upstream releases this is a single integer showing the release
+ordering. We do not attempt to encode any 'ABI' information in this version.
+
+Branched stabled releases can append an additional counter eg `11.2`.
+
+Unofficial releases should include a distributor tag, eg '11.vendor2'.
+
+When the PACKAGE_VERSION is changed, the packaging files should be updated:
+
+```diff
+diff --git a/CMakeLists.txt b/CMakeLists.txt
+index 389feee1e0f9..63854fe8f07f 100644
+--- a/CMakeLists.txt
++++ b/CMakeLists.txt
+@@ -26,7 +26,7 @@ project(RDMA C)
+ set(PACKAGE_NAME "RDMA")
+ 
+ # See Documentation/versioning.md
+-set(PACKAGE_VERSION "11")
++set(PACKAGE_VERSION "12")
+ 
+ #-------------------------
+ # Basic standard paths
+```
+
+# Shared Library Versions
+
+The shared libraries use the typical semantic versioning scheme, eg
+*libibumad* has a version like `3.1.11`.
+
+The version number is broken up into three fields:
+- '3' is called the SONAME and is embedded into the ELF:
+   ```sh
+   $ readelf -ds build/lib/libibumad.so.3.1.11
+    0x000000000000000e (SONAME)             Library soname: [libibumad.so.3]
+   ```
+
+   We do not expect this value to ever change for our libraries. It indicates
+   the overall ABI, changing it means the library will not dynamically to old
+   programs link anymore.
+
+- '1' is called the ABI level and is used within the ELF as the last component
+   symbol version tag.  This version must be changed every time a new symbol
+   is introduced. It allows the user to see what version of the ABI the
+   library provides.
+
+- '11' is the overall release number and is copied from `PACKAGE_VERSION` This
+  version increases with every package release, even if the library code did
+  not change. It allows the user to see what upstream source was used to build
+  the library.
+
+This version is encoded into the filename `build/lib/libibumad.so.3.1.11` and
+a symlink from `libibumad.so.3` to `build/lib/libibumad.so.3.1.11` is created.
+
+## Shared Library Symbol Versions
+
+Symbol versions are a linker technique that lets the library author provide
+two symbols with different ABIs that have the same API name. The linker
+differentiates the two cases internally. This allows the library author to
+change the ABI that the API uses. This project typically does not make use of
+this feature.
+
+As a secondary feature, the symbol version is also used by package managers
+like RPM to manage the ABI level. To make this work properly the ABI level
+must be correctly encoded into the symbol version.
+
+## Adding a new symbol
+
+First, increase the ABI level of the library. It is safe to re-use the ABI
+level for multiple new functions within a single release, but once a release
+is tagged the ABI level becomes *immutable*. The maintainer can provide
+guidence on what ABI level to use for each series.
+
+```diff
+ rdma_library(ibumad libibumad.map
+   # See Documentation/versioning.md
+-  3 3.1.${PACKAGE_VERSION}
++  3 3.2.${PACKAGE_VERSION}
+```
+
+Next, add your new symbol to the symbol version file:
+
+```diff
++ IBUMAD_3.2 {
++ 	global:
++ 		umad_new_symbol;
++ } IBUMAD_1.0;
+```
+
+NOTE: Once a release is made the stanzas in the map file are *immutable* and
+cannot be changed. Do not add your new symbol to old stanzas.
+
+The new symbol should appear in the ELF:
+
+```sh
+$ readelf -s build/lib/libibumad.so.3.1.11
+ 35: 00000000000031e0   450 FUNC    GLOBAL DEFAULT   12 umad_new_symbol@@IBUMAD_3.2
+```
+
+Finally update the `debian/libibumad3.symbols` file.
diff --git a/libibcm/src/CMakeLists.txt b/libibcm/src/CMakeLists.txt
index 2479886c6238..66b3362ec7a0 100644
--- a/libibcm/src/CMakeLists.txt
+++ b/libibcm/src/CMakeLists.txt
@@ -3,7 +3,9 @@ publish_headers(infiniband
   ../include/infiniband/cm_abi.h
   )
 
-rdma_library(ibcm libibcm.map 1 1.0.0
+rdma_library(ibcm libibcm.map
+  # See Documentation/versioning.md
+  1 1.0.${PACKAGE_VERSION}
   cm.c
   )
 target_link_libraries(ibcm LINK_PUBLIC ibverbs)
diff --git a/libibcm/src/libibcm.map b/libibcm/src/libibcm.map
index 3d83e481a6bb..c94e420a6cc8 100644
--- a/libibcm/src/libibcm.map
+++ b/libibcm/src/libibcm.map
@@ -1,3 +1,4 @@
+/* Do not change this file without reading Documentation/versioning.md */
 IBCM_1.0 {
 	global:
 		ib_cm_open_device;
diff --git a/libibumad/src/CMakeLists.txt b/libibumad/src/CMakeLists.txt
index b7b5d03bc53e..fbd15893d973 100644
--- a/libibumad/src/CMakeLists.txt
+++ b/libibumad/src/CMakeLists.txt
@@ -7,7 +7,9 @@ publish_headers(infiniband
   ../include/infiniband/umad_types.h
   )
 
-rdma_library(ibumad libibumad.map 3 3.1.0
+rdma_library(ibumad libibumad.map
+  # See Documentation/versioning.md
+  3 3.1.${PACKAGE_VERSION}
   sysfs.c
   umad.c
   umad_str.c
diff --git a/libibumad/src/libibumad.map b/libibumad/src/libibumad.map
index e42dc799d69e..8bf474e26ae2 100644
--- a/libibumad/src/libibumad.map
+++ b/libibumad/src/libibumad.map
@@ -1,3 +1,4 @@
+/* Do not change this file without reading Documentation/versioning.md */
 IBUMAD_1.0 {
 	global:
 		umad_init;
diff --git a/libibverbs/src/CMakeLists.txt b/libibverbs/src/CMakeLists.txt
index e1a54345c537..6989f7730c5e 100644
--- a/libibverbs/src/CMakeLists.txt
+++ b/libibverbs/src/CMakeLists.txt
@@ -17,7 +17,9 @@ else()
   set(NEIGH "")
 endif()
 
-rdma_library(ibverbs libibverbs.map 1 1.0.0
+rdma_library(ibverbs libibverbs.map
+  # See Documentation/versioning.md
+  1 1.3.${PACKAGE_VERSION}
   cmd.c
   compat-1_0.c
   device.c
diff --git a/libibverbs/src/libibverbs.map b/libibverbs/src/libibverbs.map
index 46744e551068..33cd6b63917b 100644
--- a/libibverbs/src/libibverbs.map
+++ b/libibverbs/src/libibverbs.map
@@ -1,3 +1,4 @@
+/* Do not change this file without reading Documentation/versioning.md */
 IBVERBS_1.0 {
 	global:
 		ibv_get_device_list;
diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/src/CMakeLists.txt
index 5324f625616d..0a60786c5f7a 100644
--- a/librdmacm/src/CMakeLists.txt
+++ b/librdmacm/src/CMakeLists.txt
@@ -8,7 +8,9 @@ publish_headers(infiniband
   ../include/infiniband/ib.h
   )
 
-rdma_library(rdmacm librdmacm.map 1 1.0.0
+rdma_library(rdmacm librdmacm.map
+  # See Documentation/versioning.md
+  1 1.1.${PACKAGE_VERSION}
   acm.c
   addrinfo.c
   cma.c
diff --git a/librdmacm/src/librdmacm.map b/librdmacm/src/librdmacm.map
index ffbd199d3119..65c049211c65 100644
--- a/librdmacm/src/librdmacm.map
+++ b/librdmacm/src/librdmacm.map
@@ -1,3 +1,4 @@
+/* Do not change this file without reading Documentation/versioning.md */
 RDMACM_1.0 {
 	global:
 		rdma_create_event_channel;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
