From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 4/4] RDMA/libocrdma: update version string
Date: Tue, 1 Jul 2014 11:24:05 +0530
Message-ID: <62250735-397f-4028-87f1-7f139cbc1e7a@CMEXHTCAS1.ad.emulex.com>
References: <1404194045-26900-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404194045-26900-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The version string is updated to 1.0.3

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 configure.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 15aabb1..acc77f6 100644
--- a/configure.in
+++ b/configure.in
@@ -1,11 +1,11 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libocrdma, 1.0.2, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(libocrdma, 1.0.3, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/ocrdma_main.h])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(libocrdma, 1.0.2)
+AM_INIT_AUTOMAKE(libocrdma, 1.0.3)
 AM_PROG_LIBTOOL
 
 AC_ARG_ENABLE(libcheck, [ --disable-libcheck    do not test for the presence of ib libraries],
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
