From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced error
	reporting fails
Date: Fri, 22 Oct 2010 15:29:54 -0700
Message-ID: <20101022222951.28161.23347.stgit@chromite.mv.qlogic.com>
References: <20101022222937.28161.50341.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101022222937.28161.50341.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some PCIe root complex chip sets don't support advanced error reporting.
Allow the driver to load OK if pci_enable_pcie_error_reporting() fails.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_pcie.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 7fa6e55..8a64426 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -109,10 +109,12 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	ret = pci_enable_pcie_error_reporting(pdev);
-	if (ret)
+	if (ret) {
 		qib_early_err(&pdev->dev,
 			      "Unable to enable pcie error reporting: %d\n",
 			      ret);
+		ret = 0;
+	}
 	goto done;
 
 bail:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
