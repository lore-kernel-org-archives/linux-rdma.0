From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 3/8] autogen.sh: Use autoreconf in autogen.sh
Date: Tue, 16 Jul 2013 23:59:47 +0200
Message-ID: <317ae98daf0eec49ffb297a5fc59b3738366af6d.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

The old sequence of Autotools commands listed in autogen.sh is no
longer correct.  Instead, just use the single "autoreconf" command,
which will invoke all the Right Autotools commands in the correct
order.

Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 autogen.sh | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index f433312..6c9233e 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,9 +1,4 @@
 #! /bin/sh
 
 set -x
-test -d ./config || mkdir ./config
-aclocal -I config
-libtoolize --force --copy
-autoheader
-automake --foreign --add-missing --copy
-autoconf
+autoreconf -ifv -I config
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
