From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/15] IB/hfi1: Ignore non-temperature warnings on a downed
 link
Date: Thu, 12 May 2016 10:22:33 -0700
Message-ID: <20160512172231.9741.19366.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

QSFP modules can raise an interrupt to inform us of expected conditions
while the link is down, such as RX power low. Actively ignore these
conditions when the link is down as they only add reporting noise.
Continue reporting conditions that are valid at all times, such as
temperature alarms and warnings.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   17 +++++++++++------
 drivers/staging/rdma/hfi1/diag.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h  |    1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index dcae8e7..f6ae0ba 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6105,7 +6105,7 @@ int acquire_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 	}
 
 	/* this access is valid only when the link is up */
-	if ((ppd->host_link_state & HLS_UP) == 0) {
+	if (ppd->host_link_state & HLS_DOWN) {
 		dd_dev_info(dd, "%s: link state %s not up\n",
 			    __func__, link_state_name(ppd->host_link_state));
 		ret = -EBUSY;
@@ -7429,7 +7429,7 @@ void apply_link_downgrade_policy(struct hfi1_pportdata *ppd, int refresh_widths)
 retry:
 	mutex_lock(&ppd->hls_lock);
 	/* only apply if the link is up */
-	if (!(ppd->host_link_state & HLS_UP)) {
+	if (ppd->host_link_state & HLS_DOWN) {
 		/* still going up..wait and retry */
 		if (ppd->host_link_state & HLS_GOING_UP) {
 			if (++tries < 1000) {
@@ -9252,6 +9252,12 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 		dd_dev_info(dd, "%s: QSFP cable temperature too low\n",
 			    __func__);
 
+	/*
+	 * The remaining alarms/warnings don't matter if the link is down.
+	 */
+	if (ppd->host_link_state & HLS_DOWN)
+		return 0;
+
 	if ((qsfp_interrupt_status[1] & QSFP_HIGH_VCC_ALARM) ||
 	    (qsfp_interrupt_status[1] & QSFP_HIGH_VCC_WARNING))
 		dd_dev_info(dd, "%s: QSFP supply voltage too high\n",
@@ -9346,9 +9352,8 @@ void qsfp_event(struct work_struct *work)
 		return;
 
 	/*
-	 * Turn DC back on after cables has been
-	 * re-inserted. Up until now, the DC has been in
-	 * reset to save power.
+	 * Turn DC back on after cable has been re-inserted. Up until
+	 * now, the DC has been in reset to save power.
 	 */
 	dc_start(dd);
 
@@ -10074,7 +10079,7 @@ u32 driver_physical_state(struct hfi1_pportdata *ppd)
  */
 u32 driver_logical_state(struct hfi1_pportdata *ppd)
 {
-	if (ppd->host_link_state && !(ppd->host_link_state & HLS_UP))
+	if (ppd->host_link_state && (ppd->host_link_state & HLS_DOWN))
 		return IB_PORT_DOWN;
 
 	switch (ppd->host_link_state & HLS_UP) {
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 4cf6e8d..d262918 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -996,7 +996,7 @@ static long hfi1_assign_snoop_link_credits(struct hfi1_pportdata *ppd,
 	u16  per_vl_credits;
 	__be16 be_per_vl_credits;
 
-	if (!(ppd->host_link_state & HLS_UP))
+	if (ppd->host_link_state & HLS_DOWN)
 		goto err_exit;
 	if (total_credits  <  vl15_credits)
 		goto err_exit;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 7351898..6485a1d 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -453,6 +453,7 @@ struct rvt_sge_state;
 #define HLS_LINK_COOLDOWN BIT(__HLS_LINK_COOLDOWN_BP)
 
 #define HLS_UP (HLS_UP_INIT | HLS_UP_ARMED | HLS_UP_ACTIVE)
+#define HLS_DOWN ~(HLS_UP)
 
 /* use this MTU size if none other is given */
 #define HFI1_DEFAULT_ACTIVE_MTU 10240

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
