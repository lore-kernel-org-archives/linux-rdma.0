From: Betty Dall <betty.dall-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH] [Trivial] qib: fix an incorrect message
Date: Thu, 19 Jul 2012 13:34:19 -0600
Message-ID: <1342726459-2199-1-git-send-email-betty.dall@hp.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Betty Dall <betty.dall-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a cut and paste typo in the function qib_pci_slot_reset() where
it prints that the "link_reset" function is called rather than the
"slot_reset" function. This makes the message misleading.

Signed-off-by: Betty Dall <betty.dall-VXdhtT5mjnY@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 790646e..4f9d918 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -725,7 +725,7 @@ qib_pci_mmio_enabled(struct pci_dev *pdev)
 static pci_ers_result_t
 qib_pci_slot_reset(struct pci_dev *pdev)
 {
-	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
+	qib_devinfo(pdev, "QIB slot_reset function called, ignored\n");
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
