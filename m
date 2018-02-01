From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/hfi1: Re-order IRQ cleanup to address
 driver cleanup race
Date: Thu, 01 Feb 2018 10:43:42 -0800
Message-ID: <20180201184338.5205.21740.stgit@scvm10.sc.intel.com>
References: <20180201184229.5205.6194.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201184229.5205.6194.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The pci_request_irq() interfaces always adds the IRQF_SHARED bit to
all IRQ requests.

When the kernel is built with CONFIG_DEBUG_SHIRQ config flag, if the
IRQF_SHARED bit is set, a call to the IRQ handler is made from the
__free_irq() function. This is testing a race condition between the
IRQ cleanup and an IRQ racing the cleanup.  The HFI driver should be
able to handle this race, but does not.

This race can cause traces that start with this footprint:

BUG: unable to handle kernel NULL pointer dereference at   (null)
Call Trace:
 <hfi1 irq handler>
 ...
 __free_irq+0x1b3/0x2d0
 free_irq+0x35/0x70
 pci_free_irq+0x1c/0x30
 clean_up_interrupts+0x53/0xf0 [hfi1]
 hfi1_start_cleanup+0x122/0x190 [hfi1]
 postinit_cleanup+0x1d/0x280 [hfi1]
 remove_one+0x233/0x250 [hfi1]
 pci_device_remove+0x39/0xc0

Export IRQ cleanup function so it can be called from other modules.

Using the exported cleanup function:

  Re-order the driver cleanup code to clean up IRQ resources before
  other resources, eliminating the race.

  Re-order error path for init so that the race does not occur.

Reduce severity on spurious error message for SDMA IRQs to info.

Reviewed-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   18 ++++++++++++------
 drivers/infiniband/hw/hfi1/hfi.h  |    1 +
 drivers/infiniband/hw/hfi1/init.c |    4 +++-
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 6660f92..57f0df2 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8264,8 +8264,8 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 		/* handle the interrupt(s) */
 		sdma_engine_interrupt(sde, status);
 	} else {
-		dd_dev_err_ratelimited(dd, "SDMA engine %u interrupt, but no status bits set\n",
-				       sde->this_idx);
+		dd_dev_info_ratelimited(dd, "SDMA engine %u interrupt, but no status bits set\n",
+					sde->this_idx);
 	}
 	return IRQ_HANDLED;
 }
@@ -12960,7 +12960,14 @@ static void disable_intx(struct pci_dev *pdev)
 	pci_intx(pdev, 0);
 }
 
-static void clean_up_interrupts(struct hfi1_devdata *dd)
+/**
+ * hfi1_clean_up_interrupts() - Free all IRQ resources
+ * @dd: valid device data data structure
+ *
+ * Free the MSI or INTx IRQs and assoicated PCI resources,
+ * if they have been allocated.
+ */
+void hfi1_clean_up_interrupts(struct hfi1_devdata *dd)
 {
 	int i;
 
@@ -13321,7 +13328,7 @@ static int set_up_interrupts(struct hfi1_devdata *dd)
 	return 0;
 
 fail:
-	clean_up_interrupts(dd);
+	hfi1_clean_up_interrupts(dd);
 	return ret;
 }
 
@@ -14748,7 +14755,6 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd)
 	aspm_exit(dd);
 	free_cntrs(dd);
 	free_rcverr(dd);
-	clean_up_interrupts(dd);
 	finish_chip_resources(dd);
 }
 
@@ -15204,7 +15210,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 bail_free_cntrs:
 	free_cntrs(dd);
 bail_clear_intr:
-	clean_up_interrupts(dd);
+	hfi1_clean_up_interrupts(dd);
 bail_cleanup:
 	hfi1_pcie_ddcleanup(dd);
 bail_free:
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index b42c222..5757d0e 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1957,6 +1957,7 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len);
 
 int hfi1_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent);
+void hfi1_clean_up_interrupts(struct hfi1_devdata *dd);
 void hfi1_pcie_cleanup(struct pci_dev *pdev);
 int hfi1_pcie_ddinit(struct hfi1_devdata *dd, struct pci_dev *pdev);
 void hfi1_pcie_ddcleanup(struct hfi1_devdata *);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 9b12826..c676d1c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1058,8 +1058,9 @@ static void shutdown_device(struct hfi1_devdata *dd)
 	}
 	dd->flags &= ~HFI1_INITTED;
 
-	/* mask interrupts, but not errors */
+	/* mask and clean up interrupts, but not errors */
 	set_intr_state(dd, 0);
+	hfi1_clean_up_interrupts(dd);
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
@@ -1704,6 +1705,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dd_dev_err(dd, "Failed to create /dev devices: %d\n", -j);
 
 	if (initfail || ret) {
+		hfi1_clean_up_interrupts(dd);
 		stop_timers(dd);
 		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
