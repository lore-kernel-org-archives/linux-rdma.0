From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] [IB/QIB] Fix failure to load driver if PCI error
 reporting	doesn't enable
Date: Fri, 22 Oct 2010 14:28:54 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A488873ABE076D@AVEXMB1.qlogic.org>
References: <20101022204245.GC30241@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101022204245.GC30241-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm not sure this is the right change. I agree there are a lot of clean up on error
bugs. pci_set_consistent_dma_mask() isn't optional because the chip doesn't
support 32-bit PCIe addressing.
I'll look it over and try to come up with something better.

I'll submit a patch for the CONFIG_PCI_MSI not set case.
________________________________________
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe [jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
Sent: Friday, October 22, 2010 1:42 PM
To: Ralph Campbell; RDMA list
Subject: [PATCH] [IB/QIB] Fix failure to load driver if PCI error reporting     doesn't enable

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
+       ret = 0;
        goto done;

 bail:
--
1.6.0.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
