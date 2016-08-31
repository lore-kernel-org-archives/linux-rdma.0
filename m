From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] IB/hfi1: Add QSFP sanity pre-check
Date: Wed, 31 Aug 2016 07:24:33 -0700
Message-ID: <20160831142432.27232.78069.stgit@scvm10.sc.intel.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Sometimes a QSFP device does not respond in the expected time
after a power-on.  Add a read pre-check/retry when starting
the link on driver load.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   86 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/chip.h |    1 
 drivers/infiniband/hw/hfi1/hfi.h  |    2 +
 drivers/infiniband/hw/hfi1/init.c |    1 
 4 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index b32638d..ec3635a 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9490,6 +9490,78 @@ static void init_lcb(struct hfi1_devdata *dd)
 	write_csr(dd, DC_LCB_CFG_TX_FIFOS_RESET, 0x00);
 }
 
+/*
+ * Perform a test read on the QSFP.  Return 0 on success, -ERRNO
+ * on error.
+ */
+static int test_qsfp_read(struct hfi1_pportdata *ppd)
+{
+	int ret;
+	u8 status;
+
+	/* report success if not a QSFP */
+	if (ppd->port_type != PORT_TYPE_QSFP)
+		return 0;
+
+	/* read byte 2, the status byte */
+	ret = one_qsfp_read(ppd, ppd->dd->hfi1_id, 2, &status, 1);
+	if (ret < 0)
+		return ret;
+	if (ret != 1)
+		return -EIO;
+
+	return 0; /* success */
+}
+
+/*
+ * Values for QSFP retry.
+ *
+ * Give up after 10s (20 x 500ms).  The overall timeout was empirically
+ * arrived at from experience on a large cluster.
+ */
+#define MAX_QSFP_RETRIES 20
+#define QSFP_RETRY_WAIT 500 /* msec */
+
+/*
+ * Try a QSFP read.  If it fails, schedule a retry for later.
+ * Called on first link activation after driver load.
+ */
+static void try_start_link(struct hfi1_pportdata *ppd)
+{
+	if (test_qsfp_read(ppd)) {
+		/* read failed */
+		if (ppd->qsfp_retry_count >= MAX_QSFP_RETRIES) {
+			dd_dev_err(ppd->dd, "QSFP not responding, giving up\n");
+			return;
+		}
+		dd_dev_info(ppd->dd,
+			    "QSFP not responding, waiting and retrying %d\n",
+			    (int)ppd->qsfp_retry_count);
+		ppd->qsfp_retry_count++;
+		queue_delayed_work(ppd->hfi1_wq, &ppd->start_link_work,
+				   msecs_to_jiffies(QSFP_RETRY_WAIT));
+		return;
+	}
+	ppd->qsfp_retry_count = 0;
+
+	/*
+	 * Tune the SerDes to a ballpark setting for optimal signal and bit
+	 * error rate.  Needs to be done before starting the link.
+	 */
+	tune_serdes(ppd);
+	start_link(ppd);
+}
+
+/*
+ * Workqueue function to start the link after a delay.
+ */
+void handle_start_link(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+						  start_link_work.work);
+	try_start_link(ppd);
+}
+
 int bringup_serdes(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
@@ -9525,14 +9597,8 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 		set_qsfp_int_n(ppd, 1);
 	}
 
-	/*
-	 * Tune the SerDes to a ballpark setting for
-	 * optimal signal and bit error rate
-	 * Needs to be done before starting the link
-	 */
-	tune_serdes(ppd);
-
-	return start_link(ppd);
+	try_start_link(ppd);
+	return 0;
 }
 
 void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
@@ -9549,6 +9615,10 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 	ppd->driver_link_ready = 0;
 	ppd->link_enabled = 0;
 
+	ppd->qsfp_retry_count = MAX_QSFP_RETRIES; /* prevent more retries */
+	flush_delayed_work(&ppd->start_link_work);
+	cancel_delayed_work_sync(&ppd->start_link_work);
+
 	ppd->offline_disabled_reason =
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED);
 	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SMA_DISABLED, 0,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index ed11107..e295737 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -706,6 +706,7 @@ void handle_link_up(struct work_struct *work);
 void handle_link_down(struct work_struct *work);
 void handle_link_downgrade(struct work_struct *work);
 void handle_link_bounce(struct work_struct *work);
+void handle_start_link(struct work_struct *work);
 void handle_sma_message(struct work_struct *work);
 void reset_qsfp(struct hfi1_pportdata *ppd);
 void qsfp_event(struct work_struct *work);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index a021e66..28b9128 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -605,6 +605,7 @@ struct hfi1_pportdata {
 	struct work_struct freeze_work;
 	struct work_struct link_downgrade_work;
 	struct work_struct link_bounce_work;
+	struct delayed_work start_link_work;
 	/* host link state variables */
 	struct mutex hls_lock;
 	u32 host_link_state;
@@ -659,6 +660,7 @@ struct hfi1_pportdata {
 	u8 linkinit_reason;
 	u8 local_tx_rate;	/* rate given to 8051 firmware */
 	u8 last_pstate;		/* info only */
+	u8 qsfp_retry_count;
 
 	/* placeholders for IB MAD packet settings */
 	u8 overrun_threshold;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b793545..000dc07 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -500,6 +500,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	INIT_WORK(&ppd->link_downgrade_work, handle_link_downgrade);
 	INIT_WORK(&ppd->sma_message_work, handle_sma_message);
 	INIT_WORK(&ppd->link_bounce_work, handle_link_bounce);
+	INIT_DELAYED_WORK(&ppd->start_link_work, handle_start_link);
 	INIT_WORK(&ppd->linkstate_active_work, receive_interrupt_work);
 	INIT_WORK(&ppd->qsfp_info.qsfp_work, qsfp_event);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
