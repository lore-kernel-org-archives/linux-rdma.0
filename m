From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 4/4] RDMA/libocrdma: Update libocrdma version string
Date: Thu, 25 Feb 2016 02:50:47 -0500
Message-ID: <1456386647-22315-5-git-send-email-devesh.sharma@broadcom.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456386647-22315-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updated version string from 1.0.6 to 1.0.7

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 configure.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 653bc43..c8f930b 100644
--- a/configure.in
+++ b/configure.in
@@ -1,11 +1,11 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libocrdma, 1.0.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(libocrdma, 1.0.7, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/ocrdma_main.h])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(libocrdma, 1.0.6)
+AM_INIT_AUTOMAKE(libocrdma, 1.0.7)
 AM_PROG_LIBTOOL
 
 AC_ARG_ENABLE(libcheck, [ --disable-libcheck    do not test for the presence of ib libraries],
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
