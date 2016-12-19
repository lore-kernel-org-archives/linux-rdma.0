From: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] infiniband/hfil: drop pci_link_reset()
Date: Mon, 19 Dec 2016 14:46:36 +0800
Message-ID: <1482129996-19255-2-git-send-email-caoj.fnst@cn.fujitsu.com>
References: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482129996-19255-1-git-send-email-caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In AER recovery, pci_error_handlers.link_reset() is never called,
drop it now.

Signed-off-by: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 89c68da1c273..8aed2a8a378b 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -599,15 +599,6 @@ pci_slot_reset(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static pci_ers_result_t
-pci_link_reset(struct pci_dev *pdev)
-{
-	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
-
-	dd_dev_info(dd, "HFI1 link_reset function called, ignored\n");
-	return PCI_ERS_RESULT_CAN_RECOVER;
-}
-
 static void
 pci_resume(struct pci_dev *pdev)
 {
@@ -626,7 +617,6 @@ pci_resume(struct pci_dev *pdev)
 const struct pci_error_handlers hfi1_pci_err_handler = {
 	.error_detected = pci_error_detected,
 	.mmio_enabled = pci_mmio_enabled,
-	.link_reset = pci_link_reset,
 	.slot_reset = pci_slot_reset,
 	.resume = pci_resume,
 };
-- 
2.1.0



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
