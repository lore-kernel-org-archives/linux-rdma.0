From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: clean up properly if pci_set_consistent_dma_mask()
	fails
Date: Fri, 22 Oct 2010 17:09:30 -0700
Message-ID: <20101023000925.30641.2559.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Clean up properly if pci_set_consistent_dma_mask() fails.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_pcie.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 8a64426..48b6674 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -103,9 +103,11 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	} else
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (ret)
+	if (ret) {
 		qib_early_err(&pdev->dev,
 			      "Unable to set DMA consistent mask: %d\n", ret);
+		goto bail;
+	}
 
 	pci_set_master(pdev);
 	ret = pci_enable_pcie_error_reporting(pdev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
