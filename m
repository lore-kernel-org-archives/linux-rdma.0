From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] management: update shared library versions
Date: Sun, 23 May 2010 00:29:47 +0300
Message-ID: <20100522212947.GA28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update shared library version in accordance with recent changes.

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
index e811662..faee531 100644
--- a/infiniband-diags/libibnetdisc/libibnetdisc.ver
+++ b/infiniband-diags/libibnetdisc/libibnetdisc.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:0:0
+LIBVERSION=4:0:0
diff --git a/libibmad/libibmad.ver b/libibmad/libibmad.ver
index c61611c..6c65a39 100644
--- a/libibmad/libibmad.ver
+++ b/libibmad/libibmad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=5:0:0
+LIBVERSION=6:0:1
diff --git a/libibumad/libibumad.ver b/libibumad/libibumad.ver
index d36fbbc..3c739b6 100644
--- a/libibumad/libibumad.ver
+++ b/libibumad/libibumad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=2:2:0
+LIBVERSION=3:0:0
diff --git a/opensm/complib/libosmcomp.ver b/opensm/complib/libosmcomp.ver
index 9596990..85faef0 100644
--- a/opensm/complib/libosmcomp.ver
+++ b/opensm/complib/libosmcomp.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:1:0
+LIBVERSION=3:2:0
diff --git a/opensm/libvendor/libosmvendor.ver b/opensm/libvendor/libosmvendor.ver
index 49fe59c..cb41fe5 100644
--- a/opensm/libvendor/libosmvendor.ver
+++ b/opensm/libvendor/libosmvendor.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:2:0
+LIBVERSION=3:3:0
diff --git a/opensm/opensm/libopensm.ver b/opensm/opensm/libopensm.ver
index 863d716..2490490 100644
--- a/opensm/opensm/libopensm.ver
+++ b/opensm/opensm/libopensm.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=3:5:1
+LIBVERSION=4:0:0
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
