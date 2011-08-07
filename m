From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/7] Add "foreign" option to AM_INIT_AUTOMAKE
Date: Sun, 7 Aug 2011 20:01:08 +0200
Message-ID: <201108072001.08990.bvanassche@acm.org>
References: <201108072000.16383.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108072000.16383.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tell automake that the libibverbs package does not follow the GNU standards.
This change makes it possible to use 'autoreconf' for the libibverbs package.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 configure.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index ead3564..4988756 100644
--- a/configure.in
+++ b/configure.in
@@ -6,7 +6,7 @@ AC_CONFIG_SRCDIR([src/ibverbs.h])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
 AC_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE(libibverbs, 1.1.5)
+AM_INIT_AUTOMAKE([foreign])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 dnl Checks for programs
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
