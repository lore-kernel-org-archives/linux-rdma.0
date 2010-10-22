From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] [IB/QIB] Fix failure to load driver if PCI error reporting
	doesn't enable
Date: Fri, 22 Oct 2010 14:42:45 -0600
Message-ID: <20101022204245.GC30241@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This seems to be the intention of the code, since the jump to bail
is missing. PCI-E advanced error reporting seems optional, but
I wonder if pci_set_consistent_dma_mask is also optional?

This also fixes one case where the PCI region is leaked during
device startup. qib_init_one assumes that qib_pcie_init cleans up if
it fails.

Note: There appear to be several other leaks of the PCI region in
qib_init_one between qib_pcie_init and qib_init that I did not attempt
to fix, and a null pointer de-reference if CONFIG_PCI_MSI is not set
for 6120.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 7fa6e55..16ce9e7 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -113,6 +113,7 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		qib_early_err(&pdev->dev,
 			      "Unable to enable pcie error reporting: %d\n",
 			      ret);
+	ret = 0;
 	goto done;
 
 bail:
-- 
1.6.0.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
