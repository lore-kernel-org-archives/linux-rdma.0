From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] management: update libraries version information
Date: Sun, 1 Nov 2009 21:58:36 +0200
Message-ID: <20091101195836.GM29434@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update libraries version information. Since last management release
APIs were changed in:

- libibnetdisc
- libibmad (backward compatible)
- libibumad
- libosmvendor

And only internal changes in:

- libosmcomp
- libopensm

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/libibnetdisc.ver |    2 +-
 libibmad/libibmad.ver                          |    2 +-
 libibumad/libibumad.ver                        |    2 +-
 opensm/complib/libosmcomp.ver                  |    2 +-
 opensm/libvendor/libosmvendor.ver              |    2 +-
 opensm/opensm/libopensm.ver                    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/libibnetdisc.ver b/infiniband-diags/libibnetdisc/libibnetdisc.ver
index a0a5f3c..508c058 100644
--- a/infiniband-diags/libibnetdisc/libibnetdisc.ver
+++ b/infiniband-diags/libibnetdisc/libibnetdisc.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=1:0:0
+LIBVERSION=2:0:0
diff --git a/libibmad/libibmad.ver b/libibmad/libibmad.ver
index 1d405d4..02c4657 100644
--- a/libibmad/libibmad.ver
+++ b/libibmad/libibmad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:0:1
+LIBVERSION=4:0:2
diff --git a/libibumad/libibumad.ver b/libibumad/libibumad.ver
index 21cf1ed..a886bba 100644
--- a/libibumad/libibumad.ver
+++ b/libibumad/libibumad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=1:3:0
+LIBVERSION=2:0:0
diff --git a/opensm/complib/libosmcomp.ver b/opensm/complib/libosmcomp.ver
index f076585..2081810 100644
--- a/opensm/complib/libosmcomp.ver
+++ b/opensm/complib/libosmcomp.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=2:4:0
+LIBVERSION=2:5:0
diff --git a/opensm/libvendor/libosmvendor.ver b/opensm/libvendor/libosmvendor.ver
index 0c3a85b..e9c513b 100644
--- a/opensm/libvendor/libosmvendor.ver
+++ b/opensm/libvendor/libosmvendor.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=2:0:0
+LIBVERSION=3:0:0
diff --git a/opensm/opensm/libopensm.ver b/opensm/opensm/libopensm.ver
index f552dd0..d9e728b 100644
--- a/opensm/opensm/libopensm.ver
+++ b/opensm/opensm/libopensm.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:3:1
+LIBVERSION=3:4:1
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
