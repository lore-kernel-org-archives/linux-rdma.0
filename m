From: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] infiniband/qib: drop qib_pci_link_reset()
Date: Mon, 19 Dec 2016 14:46:35 +0800
Message-ID: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In AER recovery, pci_error_handlers.link_reset() is never called,
drop it now.

Signed-off-by: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 6abe1c621aa4..c379b8342a09 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -682,13 +682,6 @@ qib_pci_slot_reset(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-static pci_ers_result_t
-qib_pci_link_reset(struct pci_dev *pdev)
-{
-	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
-	return PCI_ERS_RESULT_CAN_RECOVER;
-}
-
 static void
 qib_pci_resume(struct pci_dev *pdev)
 {
@@ -707,7 +700,6 @@ qib_pci_resume(struct pci_dev *pdev)
 const struct pci_error_handlers qib_pci_err_handler = {
 	.error_detected = qib_pci_error_detected,
 	.mmio_enabled = qib_pci_mmio_enabled,
-	.link_reset = qib_pci_link_reset,
 	.slot_reset = qib_pci_slot_reset,
 	.resume = qib_pci_resume,
 };
-- 
2.1.0



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
