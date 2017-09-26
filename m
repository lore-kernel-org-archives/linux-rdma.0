From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 2/7] IB/hfi1: Only reset QSFP after link up and turn
 off AOC TX
Date: Tue, 26 Sep 2017 06:06:03 -0700
Message-ID: <20170926130602.31476.31827.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926130434.31476.81826.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

QSFP reset enables AOC transmitters by default. They should be off
before moving to high power mode to complete the setup. There is no
need to reset the QSFP during LNI failure as it was reset at link down.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   12 +++++++++++-
 drivers/infiniband/hw/hfi1/chip.h     |    2 +-
 drivers/infiniband/hw/hfi1/platform.c |    4 +++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 1c810d6..27b75a8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9415,7 +9415,7 @@ static void set_qsfp_int_n(struct hfi1_pportdata *ppd, u8 enable)
 	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK, mask);
 }
 
-void reset_qsfp(struct hfi1_pportdata *ppd)
+int reset_qsfp(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	u64 mask, qsfp_mask;
@@ -9445,6 +9445,13 @@ void reset_qsfp(struct hfi1_pportdata *ppd)
 	 * for alarms and warnings
 	 */
 	set_qsfp_int_n(ppd, 1);
+
+	/*
+	 * After the reset, AOC transmitters are enabled by default. They need
+	 * to be turned off to complete the QSFP setup before they can be
+	 * enabled again.
+	 */
+	return set_qsfp_tx(ppd, 0);
 }
 
 static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
@@ -10406,6 +10413,9 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 			& (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) {
 		/* went down while attempting link up */
 		check_lni_states(ppd);
+
+		/* The QSFP doesn't need to be reset on LNI failure */
+		ppd->qsfp_info.reset_needed = 0;
 	}
 
 	/* the active link width (downgrade) is 0 on link down */
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 461f937..50b8645 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -723,7 +723,7 @@ void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
 void handle_link_bounce(struct work_struct *work);
 void handle_start_link(struct work_struct *work);
 void handle_sma_message(struct work_struct *work);
-void reset_qsfp(struct hfi1_pportdata *ppd);
+int reset_qsfp(struct hfi1_pportdata *ppd);
 void qsfp_event(struct work_struct *work);
 void start_freeze_handling(struct hfi1_pportdata *ppd, int flags);
 int send_idle_sma(struct hfi1_devdata *dd, u64 message);
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index a8af96d..d486355 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -790,7 +790,9 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 	 * reuse of stale settings established in our previous pass through.
 	 */
 	if (ppd->qsfp_info.reset_needed) {
-		reset_qsfp(ppd);
+		ret = reset_qsfp(ppd);
+		if (ret)
+			return ret;
 		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 	} else {
 		ppd->qsfp_info.reset_needed = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
