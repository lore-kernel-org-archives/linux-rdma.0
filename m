From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/7] autogen.sh: Introduce autoreconf
Date: Sun, 7 Aug 2011 20:02:31 +0200
Message-ID: <201108072002.31662.bvanassche@acm.org>
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

There is no need to invoke the different autotools individually - autoreconf
already does that.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 autogen.sh |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index fd47839..f6ff02c 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,8 +1,3 @@
 #! /bin/sh
 
-set -x
-aclocal -I config
-libtoolize --force --copy
-autoheader
-automake --foreign --add-missing --copy
-autoconf
+autoreconf -ivf
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
