From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] libibverbs: Use autoreconf in autogen.sh
Date: Mon, 22 Apr 2013 10:41:55 -0700
Message-ID: <1366652516-9547-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The old sequence of Autotools commands listed in autogen.sh is no
longer correct.  Instead, just use the single "autoreconf" command,
which will invoke all the Right Autotools commands in the correct
order.

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 autogen.sh | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index fd47839..6c9233e 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,8 +1,4 @@
 #! /bin/sh
 
 set -x
-aclocal -I config
-libtoolize --force --copy
-autoheader
-automake --foreign --add-missing --copy
-autoconf
+autoreconf -ifv -I config
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
