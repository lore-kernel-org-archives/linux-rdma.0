From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/7] Makefile.am: Fix an automake warning
Date: Sun, 7 Aug 2011 20:01:48 +0200
Message-ID: <201108072001.48196.bvanassche@acm.org>
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

Avoid that automake reports the following warning message:
Makefile.am:1: `INCLUDES' is the old name for `AM_CPPFLAGS' (or `*_CPPFLAGS')

A quote from the automake manual:
INCLUDES
    This does the same job as AM_CPPFLAGS (or any per-target _CPPFLAGS variable
    if it is used). It is an older name for the same functionality. This
    variable is deprecated; we suggest using AM_CPPFLAGS and per-target
    _CPPFLAGS instead.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index e6a50ba..cd00a65 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-INCLUDES = -I$(srcdir)/include
+AM_CPPFLAGS = -I$(srcdir)/include
 
 lib_LTLIBRARIES = src/libibverbs.la
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
