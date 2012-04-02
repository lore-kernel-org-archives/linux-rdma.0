From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 3/6] [ofa_kernel] Add
  cxgb4_0000_correct__netdev_alloc_page.patch
Date: Mon, 2 Apr 2012 00:05:19 -0500
Message-ID: <20120402050516.GA20002@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 .../cxgb4_0000_correct__netdev_alloc_page.patch    |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 kernel_patches/backport/3.0_sles11sp2/cxgb4_0000_correct__netdev_alloc_page.patch

diff --git a/kernel_patches/backport/3.0_sles11sp2/cxgb4_0000_correct__netdev_alloc_page.patch b/kernel_patches/backport/3.0_sles11sp2/cxgb4_0000_correct__netdev_alloc_page.patch
new file mode 100644
index 0000000..8d5fe01
--- /dev/null
+++ b/kernel_patches/backport/3.0_sles11sp2/cxgb4_0000_correct__netdev_alloc_page.patch
@@ -0,0 +1,16 @@
+From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
+Subject: Correct __netdev_alloc_page usage
+
+Index: ofa_kernel-1.5.4.1/drivers/net/cxgb4/sge.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/net/cxgb4/sge.c
++++ ofa_kernel-1.5.4.1/drivers/net/cxgb4/sge.c
+@@ -527,7 +527,7 @@ static unsigned int refill_fl(struct ada
+ #endif
+ 
+ 	while (n--) {
+-		pg = __netdev_alloc_page(adap->port[0], gfp);
++		pg = __netdev_alloc_page(adap->port[0], gfp, NULL);
+ 		if (unlikely(!pg)) {
+ 			q->alloc_failed++;
+ 			break;
-- 
1.7.7


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
