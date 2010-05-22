From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] management: packages versions update
Date: Sun, 23 May 2010 00:30:23 +0300
Message-ID: <20100522213023.GB28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Management packages versions update.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/configure.in |    2 +-
 libibmad/configure.in         |    2 +-
 libibumad/configure.in        |    2 +-
 opensm/configure.in           |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
index 85913f0..f472b1b 100644
--- a/infiniband-diags/configure.in
+++ b/infiniband-diags/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(infiniband-diags, 1.5.5, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(infiniband-diags, 1.5.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
 AM_INIT_AUTOMAKE
diff --git a/libibmad/configure.in b/libibmad/configure.in
index 068d99c..0a15862 100644
--- a/libibmad/configure.in
+++ b/libibmad/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libibmad, 1.3.4, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(libibmad, 1.3.5, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/sa.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
diff --git a/libibumad/configure.in b/libibumad/configure.in
index c211de8..435e55c 100644
--- a/libibumad/configure.in
+++ b/libibumad/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libibumad, 1.3.4, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(libibumad, 1.3.5, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/umad.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
diff --git a/opensm/configure.in b/opensm/configure.in
index ef1c126..5cdb0df 100644
--- a/opensm/configure.in
+++ b/opensm/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(opensm, 3.3.5, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(opensm, 3.3.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([opensm/osm_opensm.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADERS(include/config.h include/opensm/osm_config.h)
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
