From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced
	error reporting fails
Date: Fri, 22 Oct 2010 16:57:10 -0600
Message-ID: <20101022225710.GD15514@obsidianresearch.com>
References: <20101022222937.28161.50341.stgit@chromite.mv.qlogic.com> <20101022222951.28161.23347.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101022222951.28161.23347.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 22, 2010 at 03:29:54PM -0700, Ralph Campbell wrote:
> Some PCIe root complex chip sets don't support advanced error reporting.
> Allow the driver to load OK if pci_enable_pcie_error_reporting() fails.

Thanks

If you use this solution you'll want this hunk as well to avoid a leak:

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 16ce9e7..2913af2 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -103,9 +103,11 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
                ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
        } else
                ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-       if (ret)
+       if (ret) {
                qib_early_err(&pdev->dev,
                              "Unable to set DMA consistent mask: %d\n", ret);
+               goto bail;
+       }
 
        pci_set_master(pdev);
        ret = pci_enable_pcie_error_reporting(pdev);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
