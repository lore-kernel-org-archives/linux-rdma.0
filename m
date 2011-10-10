From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: libmlx4: Pass the argument "foreign" to AM_INIT_AUTOMAKE()
Date: Mon, 10 Oct 2011 19:41:37 +0200
Message-ID: <201110101941.37440.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tell automake explicitly that the libmlx4 package is not a GNU package. This
change makes it possible to regenerate the configure script via autoreconf
instead of only via autogen.sh.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

---
 configure.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index 49dc1b0..111f0b0 100644
--- a/configure.in
+++ b/configure.in
@@ -5,7 +5,7 @@ AC_INIT(libmlx4, 1.0.2, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
 AC_CONFIG_SRCDIR([src/mlx4.h])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(libmlx4, 1.0.2)
+AM_INIT_AUTOMAKE([foreign])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_LIBTOOL
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
