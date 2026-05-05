Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9F240DFDA;
	Tue,  5 May 2026 00:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939428; cv=none; b=cLYFXx+onbDMxR8gMXodrm+Fdw73iOs13wpNNfmYssESfTwU3lq1dNgr/3FbGrFAewOXAtqueTVXSyu7r3blU0FGgVjpjWTU2u+rElhO8zz+mfrEyn+REq1/PM6qjfy6HjHIP7cC+6NLaOX5n9xTm4P0FhedOUfsqMw8RVKg1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939428; c=relaxed/simple;
	bh=px/8GFAzdk8jkuSUualcaZDsIBX2i3S5hcIxDgVDBtY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rAACQNAS2WsbLJ65XsAgoD805/Xd9nicv3VMvJF7duwOqB7SXbYtnqOcJiuUW5ty4XW1mPORWQUrzgpL70tJMAjxDMR0uPP7FMhMFqom4k06YrMhBrp39dkFx6T9C1T1EZR1bF5vU/1+zeYoVw3YuYiHymZG/chfq9HlQiddP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 4376F92009D; Tue,  5 May 2026 02:03:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 3D6C192009C;
	Tue,  5 May 2026 01:03:46 +0100 (BST)
Date: Tue, 5 May 2026 01:03:46 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <bhelgaas@google.com>, 
    Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
cc: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
    linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] IB/hfi1: Remove pci_parent_bus_reset() duplication
In-Reply-To: <alpine.DEB.2.21.2605050042390.46195@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2605050058450.46195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2605050042390.46195@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Call pci_parent_bus_reset() rather than duplicating it in trigger_sbr().
There are extra preparatory checks made by the former function, but they 
are supposed to be neutral to the HFI1 device.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
No change from v1, 
<https://lore.kernel.org/r/alpine.DEB.2.21.2306200235510.14084@angie.orcam.me.uk/>.
---
 drivers/infiniband/hw/hfi1/pcie.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

linux-ib-hfi1-pcie-sbr-parent-bus-reset.diff
Index: linux-macro/drivers/infiniband/hw/hfi1/pcie.c
===================================================================
--- linux-macro.orig/drivers/infiniband/hw/hfi1/pcie.c
+++ linux-macro/drivers/infiniband/hw/hfi1/pcie.c
@@ -791,35 +791,13 @@ static void pcie_post_steps(struct hfi1_
 /*
  * Trigger a secondary bus reset (SBR) on ourselves using our parent.
  *
- * Based on pci_parent_bus_reset() which is not exported by the
- * kernel core.
+ * This is an end around to do an SBR during probe time.  A new API
+ * needs to be implemented to have cleaner interface but this fixes
+ * the current brokenness.
  */
 static int trigger_sbr(struct hfi1_devdata *dd)
 {
-	struct pci_dev *dev = dd->pcidev;
-	struct pci_dev *pdev;
-
-	/* need a parent */
-	if (!dev->bus->self) {
-		dd_dev_err(dd, "%s: no parent device\n", __func__);
-		return -ENOTTY;
-	}
-
-	/* should not be anyone else on the bus */
-	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
-		if (pdev != dev) {
-			dd_dev_err(dd,
-				   "%s: another device is on the same bus\n",
-				   __func__);
-			return -ENOTTY;
-		}
-
-	/*
-	 * This is an end around to do an SBR during probe time. A new API needs
-	 * to be implemented to have cleaner interface but this fixes the
-	 * current brokenness
-	 */
-	return pci_bridge_secondary_bus_reset(dev->bus->self);
+	return pci_parent_bus_reset(dd->pcidev, PCI_RESET_DO_RESET);
 }
 
 /*
