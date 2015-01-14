From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] RDMA/libocrdma: update libocrdma version string
Date: Wed, 14 Jan 2015 12:23:52 +0530
Message-ID: <99b55899-3b89-4a5e-b9f4-84e72705d4d7@CMEXHTCAS2.ad.emulex.com>
References: <1421218432-17812-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421218432-17812-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

version string updated from 1.0.4 to 1.0.5
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 configure.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 3b0cf21..140c07b 100644
--- a/configure.in
+++ b/configure.in
@@ -1,11 +1,11 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.57)
-AC_INIT(libocrdma, 1.0.4, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
+AC_INIT(libocrdma, 1.0.5, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/ocrdma_main.h])
 AC_CONFIG_AUX_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(libocrdma, 1.0.4)
+AM_INIT_AUTOMAKE(libocrdma, 1.0.5)
 AM_PROG_LIBTOOL
 
 AC_ARG_ENABLE(libcheck, [ --disable-libcheck    do not test for the presence of ib libraries],
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
