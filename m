From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] staging/rdma/hfi1: Check interrupt registers mapping
Date: Fri, 26 Feb 2016 13:33:23 -0800
Message-ID: <20160226213323.16535.980.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch tests the interrupt registers when the driver has no access to
its upstream component. In this case, it is highly likely that it is
running in a virtual machine (eg, Qemu-kvm guest). If the interrupt
registers are not mapped properly by the virtual machine monitor, an
error message will be printed and the probing will be terminated. This
will help the user identify the issue. On the other hand, if the driver
is running in a host or has access to its upstream component in some
other VM, it will do nothing.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   56 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index fe73ebf..7799652 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -13943,6 +13943,50 @@ static int obtain_boardname(struct hfi1_devdata *dd)
 	return 0;
 }
 
+/*
+ * Check the interrupt registers to make sure that they are mapped correctly.
+ * It is intended to help user identify any mismapping by VMM when the driver
+ * is running in a VM. This function should only be called before interrupt
+ * is set up properly.
+ *
+ * Return 0 on success, -EINVAL on failure.
+ */
+static int check_int_registers(struct hfi1_devdata *dd)
+{
+	u64 reg;
+	u64 all_bits = ~(u64)0;
+	u64 mask;
+
+	/* Clear CceIntMask[0] to avoid raising any interrupts */
+	mask = read_csr(dd, CCE_INT_MASK);
+	write_csr(dd, CCE_INT_MASK, 0ull);
+	reg = read_csr(dd, CCE_INT_MASK);
+	if (reg)
+		goto err_exit;
+
+	/* Clear all interrupt status bits */
+	write_csr(dd, CCE_INT_CLEAR, all_bits);
+	reg = read_csr(dd, CCE_INT_STATUS);
+	if (reg)
+		goto err_exit;
+
+	/* Set all interrupt status bits */
+	write_csr(dd, CCE_INT_FORCE, all_bits);
+	reg = read_csr(dd, CCE_INT_STATUS);
+	if (reg != all_bits)
+		goto err_exit;
+
+	/* Restore the interrupt mask */
+	write_csr(dd, CCE_INT_CLEAR, all_bits);
+	write_csr(dd, CCE_INT_MASK, mask);
+
+	return 0;
+err_exit:
+	write_csr(dd, CCE_INT_MASK, mask);
+	dd_dev_err(dd, "Interrupt registers not properly mapped by VMM\n");
+	return -EINVAL;
+}
+
 /**
  * Allocate and initialize the device structure for the hfi.
  * @dev: the pci_dev for hfi1_ib device
@@ -13967,6 +14011,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		"RTL FPGA emulation",
 		"Functional simulator"
 	};
+	struct pci_dev *parent = pdev->bus->self;
 
 	dd = hfi1_alloc_devdata(pdev, NUM_IB_PORTS *
 				sizeof(struct hfi1_pportdata));
@@ -14046,6 +14091,17 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 			& CCE_REVISION_CHIP_REV_MINOR_MASK;
 
 	/*
+	 * Check interrupt registers mapping if the driver has no access to
+	 * the upstream component. In this case, it is likely that the driver
+	 * is running in a VM.
+	 */
+	if (!parent) {
+		ret = check_int_registers(dd);
+		if (ret)
+			goto bail_cleanup;
+	}
+
+	/*
 	 * obtain the hardware ID - NOT related to unit, which is a
 	 * software enumeration
 	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
