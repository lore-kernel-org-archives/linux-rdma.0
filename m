From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/17] IB/hfi1: Move constant to the right in bitwise
 operations
Date: Sat, 05 Mar 2016 08:49:29 -0800
Message-ID: <20160305164929.32025.47918.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Implement changes recommended by the Coccinelle tool to move constant to
the right in bitwise operations

-bash-4.2$ make coccicheck MODE=report M=drivers/infiniband/hw/hfi1/

drivers/infiniband/hw/hfi1/pio.c:765:4-16: Move constant to right.
drivers/infiniband/hw/hfi1/rc.c:2503:19-29: Move constant to right.
drivers/infiniband/hw/hfi1/chip.c:9813:11-22: Move constant to right.
drivers/infiniband/hw/hfi1/chip.c:14468:29-40: Move constant to right.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    6 +++---
 drivers/infiniband/hw/hfi1/pio.c  |    4 ++--
 drivers/infiniband/hw/hfi1/rc.c   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7799652..263c882 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9810,7 +9810,7 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 
 	if (do_transition) {
 		ret = set_physical_link_state(dd,
-					      PLS_OFFLINE | (rem_reason << 8));
+					      (rem_reason << 8) | PLS_OFFLINE);
 
 		if (ret != HCMD_SUCCESS) {
 			dd_dev_err(dd,
@@ -14465,8 +14465,8 @@ static void handle_temp_err(struct hfi1_devdata *dd)
 	 */
 	ppd->driver_link_ready = 0;
 	ppd->link_enabled = 0;
-	set_physical_link_state(dd, PLS_OFFLINE |
-				(OPA_LINKDOWN_REASON_SMA_DISABLED << 8));
+	set_physical_link_state(dd, (OPA_LINKDOWN_REASON_SMA_DISABLED << 8) |
+				PLS_OFFLINE);
 	/*
 	 * Step 2: Shutdown LCB and 8051
 	 *         After shutdown, do not restore DC_CFG_RESET value.
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 361b43d..e888e21 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -762,8 +762,8 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 
 	/* set the default partition key */
 	write_kctxt_csr(dd, hw_context, SC(CHECK_PARTITION_KEY),
-			(DEFAULT_PKEY &
-			 SC(CHECK_PARTITION_KEY_VALUE_MASK)) <<
+			(SC(CHECK_PARTITION_KEY_VALUE_MASK) &
+			 DEFAULT_PKEY) <<
 			SC(CHECK_PARTITION_KEY_VALUE_SHIFT));
 
 	/* per context type checks */
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 1ce0e08..351f136 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2500,7 +2500,7 @@ send_last:
 	return;
 
 rnr_nak:
-	qp->r_nak_state = IB_RNR_NAK | qp->r_min_rnr_timer;
+	qp->r_nak_state = qp->r_min_rnr_timer | IB_RNR_NAK;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue RNR NAK for later */
 	rc_defered_ack(rcd, qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
