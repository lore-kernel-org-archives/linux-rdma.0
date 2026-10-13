Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429503BCD28;
	Tue, 13 Oct 2026 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901566; cv=none; b=J4DFl/FZ4DaUrC9VoA3NEF2DaegMUN+PK/EMSJqEA+GCbodNfdAcCXwMnHfplng+pxjHChQEbmFGz2hM5b9DqhAF1vqi7HVz8iDJCOspQPjg16+UGRTEaOeyjX44h0awBH3QHAjOXI4w1XFhXQ39TfKXBe/ehrrhZUx2n4FSajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901566; c=relaxed/simple;
	bh=nxYYq8lyEXTs162mJZnFOeAc8qQXDXO53h7iWe2Xk0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaaXPSPCmRhfzLNLcJ41gbxKRzDFESJ5pzOfbglOPbJyGEzYEVpzmLWI1X/ch4p0suNxTF7AI1/unrM577rGYJVQIze/xe4csYYlVzt4Go5DBpgBmEJmCYIRwQfd76YR15ORJPqpLbUD/A+SZ+Cxn+bgeuEbdrSm6R57AntCpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwccTRl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwccTRl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF7B1F000FF;
	Tue, 13 Oct 2026 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901565;
	bh=gWsyXhvcjFiKxlZj7yUReiCWk+TpI2oKdoNKkdeUzio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwccTRl3/RY4Mq7N0K40evI6R9AMG3Jj+7cSWIevtTNe3g7DJ7b25wWXTqMs3Vgqs
	 XQluEH1d5sdlxoBZXyfZDuY+d5oB2sKnO69NNZ994tR4r8l2iuPMyLqgAJcp70Z0PD
	 yUm16U18PIgVvznbNFmRNvyA0SXb3oVepl/vkrGud6yBknf9nGO7WNFKaHO5WcsDA/
	 XyyNFYFn+Q8wq/5QqHZEAMrOMzQl6hfcyIIpPrHxSx84IkIY7rAqgnCfN5DFoFebsa
	 buHYjNWYo2fx+mLgzXRdfzCBkSdji4bSjRO1LtrZi8FITvqu2Buut7LW6IzEGY8zfh
	 JZncDs+yIbvQA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v11 03/19] PCI/P2PDMA: Derive routing from directional ACS controls
Date: Tue, 13 Oct 2026 17:25:11 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-3-72cf8c96e617@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

pci_bridge_has_acs_redir() treats Request and Completion Redirect as
interchangeable. On asymmetric fabrics, a control for only the reverse TLP
direction can unnecessarily force P2PDMA through the host bridge.

Evaluate Request Redirect for the Requester's Requests and Completion
Redirect for the Completer's read Completions. Continue treating enabled
Egress Control conservatively as a Request redirect.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 77 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index ba94b0f33928..dbab955dcbdb 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -530,25 +530,63 @@ static u16 pci_acs_p2pdma_quirk_redirect(struct pci_dev *pdev, u16 ctrl)
 	return ctrl;
 }
 
+enum pci_acs_p2pdma_state {
+	PCI_ACS_P2PDMA_DIRECT,
+	PCI_ACS_P2PDMA_REDIRECT,
+};
+
+/*
+ * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
+ * from that port's ACS Control register.
+ *
+ * Linux does not read the Egress Control Vector, so Egress Control is treated
+ * conservatively as a redirect. Per PCIe r7.0 Table 6-11 the outcomes it
+ * selects are a direct route and an ACS Violation, and neither one lets peer
+ * bus addressing be assumed.
+ */
+static enum pci_acs_p2pdma_state
+pci_acs_p2pdma_request(u16 ctrl)
+{
+	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
+		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
+}
+
 /*
- * Check if a PCI bridge has its ACS redirection bits set to redirect P2P
- * TLPs upstream via ACS. Returns 1 if the packets will be redirected
- * upstream, 0 otherwise.
+ * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
+ * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
+ * affects a Completion.
  */
-static int pci_bridge_has_acs_redir(struct pci_dev *pdev)
+static enum pci_acs_p2pdma_state
+pci_acs_p2pdma_completion(u16 ctrl)
+{
+	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
+				   PCI_ACS_P2PDMA_DIRECT;
+}
+
+/*
+ * Read @pdev's ACS Control register, with Request and Completion Redirect
+ * taken from its ACS quirk if it has one. A device with neither has no
+ * peer-to-peer controls at all, which routes the same as having them all
+ * clear. Returns false when the register is present but cannot be read, or
+ * reads as all ones, which is what a device that does not answer returns;
+ * @ctrl is then meaningless.
+ */
+static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 {
 	int pos;
-	u16 ctrl = 0;
 
 	pos = pdev->acs_cap;
-	if (pos)
-		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	if (!pos) {
+		*ctrl = pci_acs_p2pdma_quirk_redirect(pdev, 0);
+		return true;
+	}
 
-	ctrl = pci_acs_p2pdma_quirk_redirect(pdev, ctrl);
-	if (ctrl & (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC))
-		return 1;
+	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl) ||
+	    PCI_POSSIBLE_ERROR(*ctrl))
+		return false;
 
-	return 0;
+	*ctrl = pci_acs_p2pdma_quirk_redirect(pdev, *ctrl);
+	return true;
 }
 
 static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
@@ -788,6 +826,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * then to Device B. The mapping type returned depends on the ACS
  * redirection setting of the ports along the path.
  *
+ * The client is the Requester and the provider the Completer. Check Request
+ * Redirect on the Requester's path and Completion Redirect for read
+ * Completions on the Completer's path.
+ *
  * If ACS redirect is set on any port in the path, traffic between the
  * devices will go through the host bridge, so return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
@@ -811,6 +853,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	int dist_a = 0;
 	int dist_b = 0;
 	char buf[128], quirk_buf[64];
+	u16 ctrl;
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
 	seq_buf_init(&quirk_list, quirk_buf, sizeof(quirk_buf));
@@ -823,7 +866,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	while (a) {
 		dist_b = 0;
 
-		if (pci_bridge_has_acs_redir(a)) {
+		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
+		    pci_acs_p2pdma_completion(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			pci_p2pdma_list_redir(&acs_list, &quirk_list, a);
 			acs_cnt++;
 		}
@@ -852,7 +897,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		if (a == bb)
 			break;
 
-		if (pci_bridge_has_acs_redir(bb)) {
+		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
+		    pci_acs_p2pdma_request(ctrl) ==
+			    PCI_ACS_P2PDMA_REDIRECT) {
 			pci_p2pdma_list_redir(&acs_list, &quirk_list, bb);
 			acs_cnt++;
 		}
@@ -1194,10 +1241,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 /**
  * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
  * @provider: P2PDMA provider structure
- * @dev: Target device for the transfer
+ * @dev: Client device that initiates the transfer
  *
  * Determines how peer-to-peer DMA transfers should be mapped between
- * the provider and the target device. The mapping type indicates whether
+ * the provider and the client device. The mapping type indicates whether
  * the transfer can be done directly through PCI switches or must go
  * through the host bridge.
  */

-- 
2.55.0

