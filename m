From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/11] IB/hfi1: Destroy link_wq workqueue after
 free_irq()
Date: Mon, 18 Dec 2017 19:56:16 -0800
Message-ID: <20171219035612.2126.10447.stgit@scvm10.sc.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219034753.2126.78386.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A sporadic crash occurs when handle_8051_interrupt handler is invoked
while doing rmmod. Actually, handler is invoked after all workqueue
related resources are freed which results into crash.

Call Trace:
 queue_work_on+0x27/0x40
 handle_8051_interrupt+0x417/0x710 [hfi1]
 ? handle_dcc_err+0x212/0x660 [hfi1]
 ? check_preempt_wakeup+0x119/0x250
 ? tracing_is_on+0x15/0x30
 ? tracing_record_taskinfo_skip+0x1e/0x40
 ? radix_tree_next_chunk+0x10b/0x2e0
 ? __slab_free+0x9b/0x2c0
 interrupt_clear_down+0x43/0x120 [hfi1]
 is_dc_int+0x2f/0xa0 [hfi1]
 general_interrupt+0x18c/0x1f0 [hfi1]
 __free_irq+0x1b3/0x2d0
 free_irq+0x35/0x70
 pci_free_irq+0x1c/0x30
 clean_up_interrupts+0x53/0xf0 [hfi1]
 hfi1_start_cleanup+0x122/0x190 [hfi1]
 postinit_cleanup+0x1d/0x280 [hfi1]
 remove_one+0x233/0x250 [hfi1]
 pci_device_remove+0x39/0xc0

When kernel is built with CONFIG_DEBUG_SHIRQ config flag, an extra call
to IRQ handler is made from _free_irq() function. The driver should be
prepared for this fake call.

Adding a mechanism which detects whether handler is invoked after
disabling interrupts. hfi_intr_mask field is added to hfi1_devdata
structure which is replica of interrupt mask register of hfi device.
The field is updated while writing a value to register.

Destroying link_wq workqueue after calling free_irq. This will make sure
that if interrupt handler is invoked before or while calling free_irq
then workqueue is destroyed after interrupt is handled.

Fixes: 05cb18fda926 ("IB/hfi1: Update HFI to use the latest PCI API")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    8 +++++++-
 drivers/infiniband/hw/hfi1/hfi.h  |    4 ++++
 drivers/infiniband/hw/hfi1/init.c |   31 ++++++++++++++++++++++---------
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 4f057e8..87748a6 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8224,6 +8224,8 @@ static irqreturn_t general_interrupt(int irq, void *data)
 		/* only clear if anything is set */
 		if (regs[i])
 			write_csr(dd, CCE_INT_CLEAR + (8 * i), regs[i]);
+
+		regs[i] &= dd->hfi_intr_mask[i];
 	}
 
 	/* phase 2: call the appropriate handler */
@@ -12942,12 +12944,15 @@ void set_intr_state(struct hfi1_devdata *dd, u32 enable)
 			u64 mask = get_int_mask(dd, i);
 
 			write_csr(dd, CCE_INT_MASK + (8 * i), mask);
+			dd->hfi_intr_mask[i] = mask;
 		}
 
 		init_qsfp_int(dd);
 	} else {
-		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
+		for (i = 0; i < CCE_NUM_INT_CSRS; i++) {
 			write_csr(dd, CCE_INT_MASK + (8 * i), 0ull);
+			dd->hfi_intr_mask[i] =  0ull;
+		}
 	}
 }
 
@@ -14773,6 +14778,7 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd)
 	free_cntrs(dd);
 	free_rcverr(dd);
 	clean_up_interrupts(dd);
+	clean_up_workqueues(dd);
 	finish_chip_resources(dd);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 4a9b4d7..e12a80b 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1188,6 +1188,9 @@ struct hfi1_devdata {
 	/* INTx information */
 	u32 requested_intx_irq;		/* did we request one? */
 
+	/* copy of interrupt mask register */
+	u64 hfi_intr_mask[CCE_NUM_INT_CSRS];
+
 	/* general interrupt: mask of handled interrupts */
 	u64 gi_mask[CCE_NUM_INT_CSRS];
 
@@ -1993,6 +1996,7 @@ static inline void flush_wc(void)
 int kdeth_process_eager(struct hfi1_packet *packet);
 int process_receive_invalid(struct hfi1_packet *packet);
 void seqfile_dump_rcd(struct seq_file *s, struct hfi1_ctxtdata *rcd);
+void clean_up_workqueues(struct hfi1_devdata *dd);
 
 /* global module parameter variables */
 extern unsigned int hfi1_max_mtu;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8e3b3e7..c84af52 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -823,6 +823,28 @@ static int create_workqueues(struct hfi1_devdata *dd)
 }
 
 /**
+ * clean_up_workqueues - destroys hfi1_wq and link_wq workqueues
+ * @dd: the hfi1_ib device
+ */
+void clean_up_workqueues(struct hfi1_devdata *dd)
+{
+	int pidx;
+	struct hfi1_pportdata *ppd;
+
+	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
+		ppd = dd->pport + pidx;
+		if (ppd->hfi1_wq) {
+			destroy_workqueue(ppd->hfi1_wq);
+			ppd->hfi1_wq = NULL;
+		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
+	}
+}
+
+/**
  * hfi1_init - do the actual initialization sequence on the chip
  * @dd: the hfi1_ib device
  * @reinit: re-initializing, so don't allocate new memory
@@ -1102,15 +1124,6 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		 * We can't count on interrupts since we are stopping.
 		 */
 		hfi1_quiet_serdes(ppd);
-
-		if (ppd->hfi1_wq) {
-			destroy_workqueue(ppd->hfi1_wq);
-			ppd->hfi1_wq = NULL;
-		}
-		if (ppd->link_wq) {
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
 	}
 	sdma_exit(dd);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
