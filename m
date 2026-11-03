Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694634;
	b=VcHi8XNj4OW3b956CD4CYZtw11zq/SKt/T3K7w62N3xCMioy0yRy0YvxbT1PQIU/crKJ
	 Hcp+mmN621YctFAjow8f+kffAruyzpsdteaXmj07usHMQOZpfHQ+pvl53GpzTG28gZeXu
	 wS9UPLqQiI6F21PPi6zsHC7uw5O1IdF0L3tSeRFlJ5PQ8QX2MFUYuJt85GMVrjn82XOxw
	 y8Gl/ndixnBJ5OvtcbzVrRY1rxs/lmk4yaS9VjEYVOdXjt1gHhTlOA8Xlte1L6qa2+6SF
	 JTGL2oLwJfVly9Ddimdz24LuN6q0TzS0o2y0wY3BXyvQKL7ymbFOZayGjA1c5lEE+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=pwecAy2BcLwV4pfRU/77y+zylhTmj6/YAVqJfbxc4Jk=;
	b=rsb0WRgaDATBAFzBPvkRIFZ9/MVvCt3cJFaPEn4lYAIOpeWEdoYLNgIYqe2Dx8Juy8ma
	 KAvNgVomhp0Lo9yD7nmBudirf4bsJsF0ehxVUKhHFqkpgPcN6ffT1cGEAFLRERLBrrYLK
	 Eu0+GNL434FSxKznOVmMBr1bLTFmuSaYhOGiBFsbJqHCvk8u492I2SzNYKmF7BdaRsuBC
	 jhqKWVmar64f3wNkXnmQhnqTuwpjfZmYETovicVuamZ0TV4rAmgGzqDEcuVFLVZbgEsJz
	 C//WMFJKLiiiBlTtaDL4w9qDTo7Ov6n5Uc3YIWp2Lci87b0BgrJl5xqxHZIXn+Hs/0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nGv/Zd9z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E18606A335;
	Tue,  3 Nov 2026 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGv/Zd9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC4F1F00A1C;
	Tue,  3 Nov 2026 08:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694634;
	bh=pwecAy2BcLwV4pfRU/77y+zylhTmj6/YAVqJfbxc4Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGv/Zd9zLTdnh/A6jS0mEA11pFVsvi4RwkpdatbtGjisU8QLB+I6Up+0dlawYF359
	 +0rCQOlFInWGw2qaYeKnYNkuo6IH/d6yfU6VeUJUgqD3icKM8gMvPvBdJIG9piSbtE
	 KXpYKe4BRaqEhzP3J1cSo+QwSeB6PYuGporpaKLrVm5/uALUMxIL8gv2f5gIZMt23+
	 kDj6JU5o81LBPOHKa1H12avuNmm1eY5CtZfyaumxtjggN/uQtkL55dP+SllirKIlWY
	 MNC2GWdu2dfqVdXWdcVxM93FsFadjfFiAsy/kpqLTYBHXaSQ4ekh/NgP1wE+9Waz69
	 tzm2DcrJokadQ==
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
Subject: [PATCH v12 03/19] PCI/P2PDMA: Derive routing from directional ACS controls
Date: Tue,  3 Nov 2026 10:29:42 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-3-912101f93517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
2.56.0

