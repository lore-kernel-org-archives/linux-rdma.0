From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] staging/rdma/hfi1: Cleanup comments and logs in PHY code
Date: Thu, 18 Feb 2016 11:12:16 -0800
Message-ID: <20160218191213.20983.26970.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is a set of minor fixes including comment and log message cleanups
and improvements to the PHY layer code.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   11 +++++++----
 drivers/staging/rdma/hfi1/qsfp.c |    4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 6e44d52..483b37a 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5946,10 +5946,10 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 	u64 qsfp_int_mgmt = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
 
 	if (reg & QSFP_HFI0_MODPRST_N) {
-		dd_dev_info(dd, "%s: ModPresent triggered QSFP interrupt\n",
-			    __func__);
-
 		if (!qsfp_mod_present(ppd)) {
+			dd_dev_info(dd, "%s: QSFP module removed\n",
+				    __func__);
+
 			ppd->driver_link_ready = 0;
 			/*
 			 * Cable removed, reset all our information about the
@@ -5989,6 +5989,9 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 				queue_work(ppd->hfi1_wq, &ppd->link_down_work);
 			}
 		} else {
+			dd_dev_info(dd, "%s: QSFP module inserted\n",
+				    __func__);
+
 			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 			ppd->qsfp_info.cache_valid = 0;
 			ppd->qsfp_info.cache_refresh_required = 1;
@@ -6009,7 +6012,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 	}
 
 	if (reg & QSFP_HFI0_INT_N) {
-		dd_dev_info(dd, "%s: IntN triggered QSFP interrupt\n",
+		dd_dev_info(dd, "%s: Interrupt received from QSFP module\n",
 			    __func__);
 		spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 		ppd->qsfp_info.check_interrupt_flags = 1;
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index e38a0eb..07330b0 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -187,7 +187,7 @@ done:
 
 /*
  * Write page n, offset m of QSFP memory as defined by SFF 8636
- * in the cache by writing @addr = ((256 * n) + m)
+ * by writing @addr = ((256 * n) + m)
  */
 int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	       int len)
@@ -253,7 +253,7 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 
 /*
  * Access page n, offset m of QSFP memory as defined by SFF 8636
- * in the cache by reading @addr = ((256 * n) + m)
+ * by reading @addr = ((256 * n) + m)
  */
 int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	      int len)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
