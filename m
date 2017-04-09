From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/20] IB/hfi1: Fix softlockup issue
Date: Sun, 09 Apr 2017 10:16:41 -0700
Message-ID: <20170409171640.10579.33680.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Soft lockups can occur because the mad processing on different CPUs acquire
the spin lock dc8051_lock:

[534552.835870]  [<ffffffffa026f993>] ? read_dev_port_cntr.isra.37+0x23/0x160 [hfi1]
[534552.835880]  [<ffffffffa02775af>] read_dev_cntr+0x4f/0x60 [hfi1]
[534552.835893]  [<ffffffffa028d7cd>] pma_get_opa_portstatus+0x64d/0x8c0 [hfi1]
[534552.835904]  [<ffffffffa0290e7d>] hfi1_process_mad+0x48d/0x18c0 [hfi1]
[534552.835908]  [<ffffffff811dc1f1>] ? __slab_free+0x81/0x2f0
[534552.835936]  [<ffffffffa024c34e>] ? ib_mad_recv_done+0x21e/0xa30 [ib_core]
[534552.835939]  [<ffffffff811dd153>] ? __kmalloc+0x1f3/0x240
[534552.835947]  [<ffffffffa024c3fb>] ib_mad_recv_done+0x2cb/0xa30 [ib_core]
[534552.835955]  [<ffffffffa0237c85>] __ib_process_cq+0x55/0xd0 [ib_core]
[534552.835962]  [<ffffffffa0237d70>] ib_cq_poll_work+0x20/0x60 [ib_core]
[534552.835964]  [<ffffffff810a7f3b>] process_one_work+0x17b/0x470
[534552.835966]  [<ffffffff810a8d76>] worker_thread+0x126/0x410
[534552.835969]  [<ffffffff810a8c50>] ? rescuer_thread+0x460/0x460
[534552.835971]  [<ffffffff810b052f>] kthread+0xcf/0xe0
[534552.835974]  [<ffffffff810b0460>] ? kthread_create_on_node+0x140/0x140
[534552.835977]  [<ffffffff81696418>] ret_from_fork+0x58/0x90
[534552.835980]  [<ffffffff810b0460>] ? kthread_create_on_node+0x140/0x140

This issue is made worse when the 8051 is busy and the reads take longer.
Fix by using a non-spinning lock procure.

Reviewed-by: Mike Marciszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   63 +++++++++++++++++++------------------
 drivers/infiniband/hw/hfi1/hfi.h  |    3 +-
 drivers/infiniband/hw/hfi1/init.c |    2 +
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 79a316a..c904c29 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6381,18 +6381,17 @@ static void lcb_shutdown(struct hfi1_devdata *dd, int abort)
  *
  * The expectation is that the caller of this routine would have taken
  * care of properly transitioning the link into the correct state.
+ * NOTE: the caller needs to acquire the dd->dc8051_lock lock
+ *       before calling this function.
  */
-static void dc_shutdown(struct hfi1_devdata *dd)
+static void _dc_shutdown(struct hfi1_devdata *dd)
 {
-	unsigned long flags;
+	lockdep_assert_held(&dd->dc8051_lock);
 
-	spin_lock_irqsave(&dd->dc8051_lock, flags);
-	if (dd->dc_shutdown) {
-		spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+	if (dd->dc_shutdown)
 		return;
-	}
+
 	dd->dc_shutdown = 1;
-	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
 	/* Shutdown the LCB */
 	lcb_shutdown(dd, 1);
 	/*
@@ -6403,35 +6402,45 @@ static void dc_shutdown(struct hfi1_devdata *dd)
 	write_csr(dd, DC_DC8051_CFG_RST, 0x1);
 }
 
+static void dc_shutdown(struct hfi1_devdata *dd)
+{
+	mutex_lock(&dd->dc8051_lock);
+	_dc_shutdown(dd);
+	mutex_unlock(&dd->dc8051_lock);
+}
+
 /*
  * Calling this after the DC has been brought out of reset should not
  * do any damage.
+ * NOTE: the caller needs to acquire the dd->dc8051_lock lock
+ *       before calling this function.
  */
-static void dc_start(struct hfi1_devdata *dd)
+static void _dc_start(struct hfi1_devdata *dd)
 {
-	unsigned long flags;
-	int ret;
+	lockdep_assert_held(&dd->dc8051_lock);
 
-	spin_lock_irqsave(&dd->dc8051_lock, flags);
 	if (!dd->dc_shutdown)
-		goto done;
-	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+		return;
+
 	/* Take the 8051 out of reset */
 	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
 	/* Wait until 8051 is ready */
-	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
-	if (ret) {
+	if (wait_fm_ready(dd, TIMEOUT_8051_START))
 		dd_dev_err(dd, "%s: timeout starting 8051 firmware\n",
 			   __func__);
-	}
+
 	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
 	write_csr(dd, DCC_CFG_RESET, 0x10);
 	/* lcb_shutdown() with abort=1 does not restore these */
 	write_csr(dd, DC_LCB_ERR_EN, dd->lcb_err_en);
-	spin_lock_irqsave(&dd->dc8051_lock, flags);
 	dd->dc_shutdown = 0;
-done:
-	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
+}
+
+static void dc_start(struct hfi1_devdata *dd)
+{
+	mutex_lock(&dd->dc8051_lock);
+	_dc_start(dd);
+	mutex_unlock(&dd->dc8051_lock);
 }
 
 /*
@@ -8475,16 +8484,11 @@ static int do_8051_command(
 {
 	u64 reg, completed;
 	int return_code;
-	unsigned long flags;
 	unsigned long timeout;
 
 	hfi1_cdbg(DC8051, "type %d, data 0x%012llx", type, in_data);
 
-	/*
-	 * Alternative to holding the lock for a long time:
-	 * - keep busy wait - have other users bounce off
-	 */
-	spin_lock_irqsave(&dd->dc8051_lock, flags);
+	mutex_lock(&dd->dc8051_lock);
 
 	/* We can't send any commands to the 8051 if it's in reset */
 	if (dd->dc_shutdown) {
@@ -8510,10 +8514,8 @@ static int do_8051_command(
 			return_code = -ENXIO;
 			goto fail;
 		}
-		spin_unlock_irqrestore(&dd->dc8051_lock, flags);
-		dc_shutdown(dd);
-		dc_start(dd);
-		spin_lock_irqsave(&dd->dc8051_lock, flags);
+		_dc_shutdown(dd);
+		_dc_start(dd);
 	}
 
 	/*
@@ -8594,8 +8596,7 @@ static int do_8051_command(
 	write_csr(dd, DC_DC8051_CFG_HOST_CMD_0, 0);
 
 fail:
-	spin_unlock_irqrestore(&dd->dc8051_lock, flags);
-
+	mutex_unlock(&dd->dc8051_lock);
 	return return_code;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 79c4289..f44513c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -926,8 +926,7 @@ struct hfi1_devdata {
 	spinlock_t rcvctrl_lock; /* protect changes to RcvCtrl */
 	/* around rcd and (user ctxts) ctxt_cnt use (intr vs free) */
 	spinlock_t uctxt_lock; /* rcd and user context changes */
-	/* exclusive access to 8051 */
-	spinlock_t dc8051_lock;
+	struct mutex dc8051_lock; /* exclusive access to 8051 */
 	/* exclusive access to 8051 memory */
 	spinlock_t dc8051_memlock;
 	int dc8051_timed_out;	/* remember if the 8051 timed out */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 9bfb8eb..55a11a6 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1078,11 +1078,11 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	spin_lock_init(&dd->uctxt_lock);
 	spin_lock_init(&dd->hfi1_diag_trans_lock);
 	spin_lock_init(&dd->sc_init_lock);
-	spin_lock_init(&dd->dc8051_lock);
 	spin_lock_init(&dd->dc8051_memlock);
 	seqlock_init(&dd->sc2vl_lock);
 	spin_lock_init(&dd->sde_map_lock);
 	spin_lock_init(&dd->pio_map_lock);
+	mutex_init(&dd->dc8051_lock);
 	init_waitqueue_head(&dd->event_queue);
 
 	dd->int_counter = alloc_percpu(u64);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
