Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873182;
	b=rS0v0tUt1Drotnh4tkPGx6vAIDyqge0qU+zh9KAUu79MqPntWBu8MLqEVC7HFxwE+ck9
	 VQR6RC+/O62FbJ/ItlG7Z1YVYI0QTyWLvw2Z24Q+/gNITwXYrw9cdfVGsg2oXs2/zZHC7
	 fy60ba3neMCeicaYiy6xi+u36vyx2e0KWd0kmJ4fsyabuWAjXn8DujOxxD2bWZSVS/7+r
	 tQD0HlGTQpbrF3DpXu43OebbfbPeO3h+bFQ6NytKbnDa/xmTOqUBzxI3GTBrXKjkXTTPy
	 AMyEDrbOgOumUp2mabGNE7OG+R5FOcjHDHIjp0vhn30G1vQ9tFbMlh6H39gXjDyBFNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=wJ1CNWj0LiiyGELFascJFSnwbI0N85hr19rMZ2bWFT0=;
	b=ZEdA9/9iALPpmixsWTuV1EF5n5ANqbNfBq/XvHE/JZCaA3CweRX6ERKtRpB5IQ416DCz
	 gCkSxt/DcGi8WmDTcfVJfiAUOdG2av3qBCijsAKNn1PR80/TfMOdEbBkyzQ2Kb6nA5lvS
	 s/jlx9O4PK+li7z4nXOcoP0/gT4iQriQ1V752AQ8o+/gMRm+q3r+D3BUvx4XCiy5zQZgg
	 h1ygmmhqLuh/BFD7/uqVahk99XgHx2XfRvK2LEpJluWBsHqq0KIHc1w64K3s7TctrhzXj
	 mKFH7MJk+DddEj/Z7JliR8Ls7z502bQYg6aVrloPCYfVq7sV+CbSH7tcD20tH5DwChw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kaWJnkkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F723606A335;
	Thu,  5 Nov 2026 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kaWJnkkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EACA1F00A18;
	Thu,  5 Nov 2026 10:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873181;
	bh=wJ1CNWj0LiiyGELFascJFSnwbI0N85hr19rMZ2bWFT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaWJnkklAwrvnAo1+LJUNyEo0FoI15GlWlEIF1UBl0I/gwjk3idcVB7r7JaPRh1+h
	 NmL3Xevho9LyX962SKN63jLLUkq6jRkQRLjdp+Uh94eMxgC2FKVO9l5I5CJR2rv/rq
	 JYrzipmBXRiD29g6Eg2qKiSzSYgJNqdNZgzmMHuZ3rFgsbquQmePMuedFz0P3pR3MP
	 zPmgtEdYzh77SUZzzRLhISKaeOmAbFOJQ15sNeCyIu4Hu6/n/vj4Jx2fOUt/Sb31gE
	 U7LSvZZ5Bvl6zTUfPKKrHlPbA387a0kF/D+HjrDmWNoNB3IGhhL/zHRn8pJQwL5Fuu
	 LDYSQkt+KadaA==
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
Subject: [PATCH v13 10/19] PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
Date: Thu,  5 Nov 2026 12:04:41 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-10-3dd065907c3b@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
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

ACS Translation Blocking rejects upstream Memory Requests with a Translated
address before peer-routing controls apply. Ignoring it can report routes
that reject the Requester's address type. Intel SPT PCH Root Ports store
ACS Control at a nonstandard dword offset, so a standard word read also
misses Translation Blocking.

Scan every port traversed by each route and reject blocked Translated
classes without host-bridge fallback. Read the Intel control dword through
a device-specific accessor, preserving rejection of unreadable controls.
Direct routes remain usable when only ports above the divergence block
Translated Requests.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/pci/pci.h    |   6 +++
 drivers/pci/quirks.c |  15 +++++++
 3 files changed, 128 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 2d5a9488da41b..0203ef86fa86a 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -559,11 +559,12 @@ enum pci_acs_p2pdma_state {
 	PCI_ACS_P2PDMA_NOT_SUPPORTED,
 	PCI_ACS_P2PDMA_DIRECT,
 	PCI_ACS_P2PDMA_REDIRECT,
+	PCI_ACS_P2PDMA_BLOCKED,
 };
 
 /*
  * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
- * from that port's ACS Control register.
+ * from that port's ACS Control register and the Request's Address Type.
  *
  * Linux does not read the Egress Control Vector, so Egress Control is treated
  * conservatively as a redirect. Per PCIe r7.0 Table 6-11 the outcomes it
@@ -573,6 +574,18 @@ enum pci_acs_p2pdma_state {
 static enum pci_acs_p2pdma_state
 pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED) {
+		/*
+		 * PCIe r7.0 sec 6.12.1.1: Translation Blocking makes every
+		 * Upstream Memory Request whose Address Type is not
+		 * Untranslated an ACS Violation, taking precedence over the
+		 * P2P controls. Sec 7.7.12.5: Direct Translated P2P "is
+		 * ignored if ACS Translation Blocking Enable is 1b".
+		 */
+		if (ctrl & PCI_ACS_TB)
+			return PCI_ACS_P2PDMA_BLOCKED;
+	}
+
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
 }
@@ -603,7 +616,7 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
  */
 static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 {
-	int pos;
+	int pos, ret;
 
 	pos = pdev->acs_cap;
 	if (!pos) {
@@ -611,8 +624,10 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 		return true;
 	}
 
-	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl) ||
-	    PCI_POSSIBLE_ERROR(*ctrl))
+	ret = pci_dev_specific_read_acs_ctrl(pdev, ctrl);
+	if (ret == -ENOTTY)
+		ret = pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
+	if (ret || PCI_POSSIBLE_ERROR(*ctrl))
 		return false;
 
 	*ctrl = pci_acs_p2pdma_quirk_redirect(pdev, *ctrl);
@@ -681,6 +696,39 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
 	return NULL;
 }
 
+/*
+ * Report whether any port between @client and @common rejects Translated
+ * addresses. If @common is NULL, every port up to the host bridge is walked.
+ * A port whose ACS Control cannot be read counts as blocking, which withdraws
+ * only the Translated classes because an Untranslated Request is routed by the
+ * redirect controls instead.
+ */
+static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
+					       struct pci_dev *common)
+{
+	struct pci_dev *pdev;
+	u16 ctrl;
+
+	/*
+	 * @common is @client itself when the provider is the client or sits
+	 * below it. The Request never travels upstream then, so no port sees
+	 * it and none can reject its Address Type.
+	 */
+	if (client == common)
+		return false;
+
+	for (pdev = pci_upstream_bridge(client); pdev && pdev != common;
+	     pdev = pci_upstream_bridge(pdev)) {
+		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl))
+			return true;
+
+		if (ctrl & PCI_ACS_TB)
+			return true;
+	}
+
+	return false;
+}
+
 static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
 {
 	if (!buf)
@@ -747,6 +795,13 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
  * @cpl_quirk:	A device quirk reports Completion Redirect at that port.
  * @req_upstream: The Requester has no internal route to its sibling.
  * @cpl_upstream: The Completer has no internal route to its sibling.
+ * @tb_on_path:	A port below the divergence blocks Translated addresses.
+ *		Every route out of @client passes those, so none carries them.
+ * @tb_above_divergence: A port at or above the divergence blocks Translated
+ *		addresses. Only a Request continuing to the host bridge passes
+ *		those, so a direct route is still open to them.
+ * @no_common_bridge: The two paths share no upstream bridge, so no direct
+ *		route exists for ACS to gate.
  * @unreadable:	First port whose ACS Control could not be read, if any.
  * @uf_blocked:	First shared port without usable Upstream Forwarding, if any.
  * @uf_unreadable: Shared port whose forwarding control could not be read.
@@ -757,15 +812,29 @@ struct pci_p2pdma_acs_path {
 	bool cpl_quirk;
 	bool req_upstream;
 	bool cpl_upstream;
+	bool tb_on_path;
+	bool tb_above_divergence;
+	bool no_common_bridge;
 	struct pci_dev *unreadable;
 	struct pci_dev *uf_blocked;
 	struct pci_dev *uf_unreadable;
 };
 
+/*
+ * ACS Translation Blocking is not a routing control, so unlike the redirect
+ * controls it is not decided at the divergence alone. PCIe r7.0 sec 6.12.1.1
+ * has every Downstream Port check the Address Type of each Upstream Memory
+ * Request it receives, ahead of "any applicable ACS P2P control mechanisms".
+ * A port below the divergence cannot redirect the Request anywhere it was not
+ * already going, but it can still reject a Translated address.
+ */
 static enum pci_acs_p2pdma_state
 pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
 			 unsigned int tlp_flags)
 {
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_on_path)
+		return PCI_ACS_P2PDMA_BLOCKED;
+
 	if (path->req_upstream)
 		return PCI_ACS_P2PDMA_REDIRECT;
 
@@ -796,11 +865,23 @@ static enum pci_p2pdma_map_type
 pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 		 unsigned int tlp_flags)
 {
+	enum pci_acs_p2pdma_state req;
+
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_p2pdma_request_state(path, tlp_flags) ==
-		    PCI_ACS_P2PDMA_DIRECT &&
+	req = pci_p2pdma_request_state(path, tlp_flags);
+
+	/*
+	 * Translation Blocking rejects the Address Type rather than the
+	 * target, so a blocked Request stays blocked however it is addressed.
+	 * No host bridge fallback keeps a Translated address working; the
+	 * caller has to issue a different kind of Request instead.
+	 */
+	if (req == PCI_ACS_P2PDMA_BLOCKED)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
+	if (!path->no_common_bridge && req == PCI_ACS_P2PDMA_DIRECT &&
 	    pci_p2pdma_completion_state(path, tlp_flags) ==
 		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
@@ -808,6 +889,14 @@ pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 	if (path->uf_blocked || path->uf_unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
+	/*
+	 * A Request that turns around at the divergence never reaches the
+	 * ports above it, but one that keeps climbing to the host bridge
+	 * does, so that route has to clear their Translation Blocking too.
+	 */
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_above_divergence)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
 	return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 }
 
@@ -1075,7 +1164,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * The client is the Requester and the provider the Completer. At the path
  * divergence, check Request Redirect and Egress Control on the Requester-side
  * port, and Completion Redirect for read Completions on the Completer-side
- * port.
+ * port. Translation Blocking is checked on every port the Request passes
+ * instead, because it rejects a Request rather than routing it.
  *
  * Those controls apply to different TLPs, so every class named by &enum
  * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
@@ -1083,8 +1173,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  *
  * If ACS redirects traffic at either divergence port, return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
- * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
- * PCI_P2PDMA_MAP_BUS_ADDR.
+ * read, or Translation Blocking rejects the class being asked about, return
+ * PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return PCI_P2PDMA_MAP_BUS_ADDR.
  *
  * Any two devices that have a data path that goes through the host bridge
  * will consult a whitelist. If the host bridge is in the whitelist, return
@@ -1137,8 +1227,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	path.no_common_bridge = true;
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, NULL);
 	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
-		map_type[flags] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+		map_type[flags] = pci_p2pdma_route(&path, flags);
 	goto map_through_host_bridge;
 
 check_paths_acs:
@@ -1169,6 +1261,11 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		}
 	}
 
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a);
+	if (b_child)
+		path.tb_above_divergence =
+			pci_p2pdma_path_blocks_translation(b_child, NULL);
+
 	/* Shared ports need forwarding only for classes using the host bridge. */
 	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++) {
 		if (pci_p2pdma_route(&path, flags) !=
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 77efa4c5c960e..f800308d198f6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1100,12 +1100,18 @@ resource_size_t pci_min_window_alignment(struct pci_bus *bus,
 void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
+int pci_dev_specific_read_acs_ctrl(struct pci_dev *dev, u16 *ctrl);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
 int pcie_failed_link_retrain(struct pci_dev *dev);
 #else
+static inline int pci_dev_specific_read_acs_ctrl(struct pci_dev *dev, u16 *ctrl)
+{
+	return -ENOTTY;
+}
+
 static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 					       u16 acs_flags)
 {
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 05605c3afe08f..4b6e868722280 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5132,6 +5132,21 @@ static bool pci_quirk_intel_spt_pch_acs_match(struct pci_dev *dev)
 
 #define INTEL_SPT_ACS_CTRL (PCI_ACS_CAP + 4)
 
+int pci_dev_specific_read_acs_ctrl(struct pci_dev *dev, u16 *ctrl)
+{
+	u32 val = ~0;
+	int ret;
+
+	if (dev->vendor != PCI_VENDOR_ID_INTEL || !dev->acs_cap ||
+	    !pci_quirk_intel_spt_pch_acs_match(dev))
+		return -ENOTTY;
+
+	ret = pci_read_config_dword(dev, dev->acs_cap + INTEL_SPT_ACS_CTRL,
+				   &val);
+	*ctrl = val;
+	return ret;
+}
+
 static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	int pos;

-- 
2.56.0

