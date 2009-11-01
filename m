From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: p
Date: Sun, 1 Nov 2009 21:58:55 +0200
Message-ID: <20091101195855.GN29434@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From bf49c02f6eb474fcc25af40de68991de23ee629f Mon Sep 17 00:00:00 2001
From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date: Sun, 1 Nov 2009 21:55:47 +0200
Subject: [PATCH] management: bump package versions

Bump IB management packages versions:

	libibumad-1.3.3
	libibmad-1.3.3
	opensm-3.3.3
	infiniband-diags-1.5.3

Update mailing list name in configure.in files.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/configure.in |    2 +-
 libibmad/configure.in         |    2 +-
 libibumad/configure.in        |    2 +-
 opensm/configure.in           |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
index 3ef35cc..5865727 100644
--- a/infiniband-diags/configure.in
+++ b/infiniband-diags/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(infiniband-diags, 1.5.2, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
+AC_INIT(infiniband-diags, 1.5.3, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
 AM_INIT_AUTOMAKE
diff --git a/libibmad/configure.in b/libibmad/configure.in
index b4f5c41..ce31729 100644
--- a/libibmad/configure.in
+++ b/libibmad/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libibmad, 1.3.2, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
+AC_INIT(libibmad, 1.3.3, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/sa.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
diff --git a/libibumad/configure.in b/libibumad/configure.in
index 6dbfeaf..3152491 100644
--- a/libibumad/configure.in
+++ b/libibumad/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libibumad, 1.3.2, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
+AC_INIT(libibumad, 1.3.3, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/umad.c])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
diff --git a/opensm/configure.in b/opensm/configure.in
index 8a6b4c0..2c68cbd 100644
--- a/opensm/configure.in
+++ b/opensm/configure.in
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(opensm, 3.3.2, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org)
+AC_INIT(opensm, 3.3.3, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([opensm/osm_opensm.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADERS(include/config.h include/opensm/osm_config.h)
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
