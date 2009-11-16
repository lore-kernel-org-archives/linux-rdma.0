From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ipath: Use bitmap_weight
Date: Mon, 16 Nov 2009 12:08:00 +0900
Message-ID: <1258340880-28269-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use bitmap_weight instead of finding all set bits in bitmap

Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/ipath/ipath_driver.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 013d138..d2787fe 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -39,6 +39,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
+#include <linux/bitmap.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -1697,7 +1698,7 @@ void ipath_chg_pioavailkernel(struct ipath_devdata *dd, unsigned start,
 			      unsigned len, int avail)
 {
 	unsigned long flags;
-	unsigned end, cnt = 0, next;
+	unsigned end, cnt = 0;
 
 	/* There are two bits per send buffer (busy and generation) */
 	start *= 2;
@@ -1748,12 +1749,7 @@ void ipath_chg_pioavailkernel(struct ipath_devdata *dd, unsigned start,
 
 	if (dd->ipath_pioupd_thresh) {
 		end = 2 * (dd->ipath_piobcnt2k + dd->ipath_piobcnt4k);
-		next = find_first_bit(dd->ipath_pioavailkernel, end);
-		while (next < end) {
-			cnt++;
-			next = find_next_bit(dd->ipath_pioavailkernel, end,
-					next + 1);
-		}
+		cnt = bitmap_weight(dd->ipath_pioavailkernel, end);
 	}
 	spin_unlock_irqrestore(&ipath_pioavail_lock, flags);
 
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
