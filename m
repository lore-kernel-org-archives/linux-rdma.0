Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F46F425872;
	Sun, 20 Sep 2026 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904555; cv=none; b=pwnCGgfXJPS957QdNKcCHIEcNA8/vTpyl8s5oOPnMaPN202pZj/av6dUlYUSWcbEa6MqlVgVpwhphDbJq7bxNZ5TuqyqhuWynpU9TFxwqOU5hQJGv5wLk3pPKHhQ2+jgwTPe9UsqTrEWzwEX3jNjiIguqlpy/hz5cjrCOfbkpGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904555; c=relaxed/simple;
	bh=mP9GY8zvg3XC9BdD97szM1l9xD9j4HHCg9TdANMh88c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aytVq4FPMnz1DqvtRNJXV6kEvCkaDdyx1kKqm3NOZfNtq0Sj7NPZP9DB59rLLB1glxOH9sbZreQnN+pTm+QFOnign1OdlXKJqEODN580D2Z3KBYJvDjIIn/TZlCxpVBczltA2OW6p8Jhwzym/Oad5u6piQJOXF1F6cX5kr2gRcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kOdos1s6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kOdos1s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25401F00898;
	Sun, 20 Sep 2026 11:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904552;
	bh=87lhp9r4MoscZ3UnJr1MzYAOKK3ZWyNcgC1BxUkuEiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOdos1s6LyBPEdVA2Z+gKZbhkw7PruJwGnjWLn6w6YF+OpIgJk1S3GhLiYQ5MjDNg
	 fIBsLlwSKPxvbZbl/ZDlFWfaenzEFpmD7gb5MJdGvoTtB+dJz2pDpoaaEJMpMSjt22
	 czytU/1Ypc5s2nYMTVL2r6RdWIq9jFsxZW4EW0qH7RNzTBPkF1v5hvrz2GvWKXtn0I
	 I7EvIEPdO9d+ZfHE1RkcVtDy0e7FM0xtg+GKkBGAGMsJ9X/4d5tci65Bg31EaBtkSh
	 gAQityVVNC1URilwHh2/nZdnqMQNMWU2PWk4G90MubhUUyTfk78enNPoLRfHDF88Qf
	 83ixL5RoyCCaA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 09/19] PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
Date: Sun, 20 Sep 2026 14:41:21 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-9-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
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

A Downstream Port with ACS Translation Blocking enabled treats every
Upstream Memory Request whose Address Type is not Untranslated as an ACS
Violation, ahead of "any applicable ACS P2P control mechanisms" per PCIe
r7.0 sec 6.12.1.1. P2PDMA never looks at that bit, so it reports a
bus-addressable path where an ATS client's Requests would be rejected.

Add PCI_ACS_P2PDMA_BLOCKED, and because blocking is not a routing control,
scan the path for it rather than the divergence port alone. A blocked
Request has no host bridge fallback, since the Address Type is rejected
wherever the Request is addressed.

The two routes do not pass the same ports, so scan them separately. A
direct route turns around at the divergence and only passes the ports
below it, while the host bridge route keeps climbing and passes that port
and everything above it as well.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 112 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 3e5262a5265a..839285b77b62 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -496,11 +496,12 @@ enum pci_acs_p2pdma_state {
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
@@ -510,6 +511,18 @@ enum pci_acs_p2pdma_state {
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
@@ -549,6 +562,39 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 	return !pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
 }
 
+/*
+ * Report whether any port between @client and @common rejects Translated
+ * addresses. @common is NULL to walk every port up to the host bridge. A port
+ * whose ACS Control cannot be read counts as blocking, which withdraws only
+ * the Translated classes because an Untranslated Request is routed by the
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
@@ -567,14 +613,42 @@ static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
  *		than upstream, so it is where the Request controls apply.
  * @cpl_ctrl:	ACS Control of the provider-side divergence port, likewise for
  *		the Completions travelling back.
+ * @tb_on_path:	A port below the divergence blocks Translated addresses.
+ *		Every route out of @client passes those, so none carries them.
+ * @tb_above_divergence: A port at or above the divergence blocks Translated
+ *		addresses. Only a Request continuing to the host bridge passes
+ *		those, so a direct route is still open to them.
+ * @no_common_bridge: The two paths share no upstream bridge, so no direct
+ *		route exists for ACS to gate.
  * @unreadable:	First port whose ACS Control could not be read, if any.
  */
 struct pci_p2pdma_acs_path {
 	u16 req_ctrl;
 	u16 cpl_ctrl;
+	bool tb_on_path;
+	bool tb_above_divergence;
+	bool no_common_bridge;
 	struct pci_dev *unreadable;
 };
 
+/*
+ * ACS Translation Blocking is not a routing control, so unlike the redirect
+ * controls it is not decided at the divergence alone. PCIe r7.0 sec 6.12.1.1
+ * has every Downstream Port check the Address Type of each Upstream Memory
+ * Request it receives, ahead of "any applicable ACS P2P control mechanisms".
+ * A port below the divergence cannot redirect the Request anywhere it was not
+ * already going, but it can still reject a Translated address.
+ */
+static enum pci_acs_p2pdma_state
+pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
+			 unsigned int tlp_flags)
+{
+	if (tlp_flags & PCI_P2PDMA_TLP_TRANSLATED && path->tb_on_path)
+		return PCI_ACS_P2PDMA_BLOCKED;
+
+	return pci_acs_p2pdma_request(path->req_ctrl, tlp_flags);
+}
+
 /*
  * Combine both directions into a mapping type. Only a path that routes the
  * Request and the Completions it generates directly can be programmed with
@@ -584,15 +658,35 @@ static enum pci_p2pdma_map_type
 pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
 		 unsigned int tlp_flags)
 {
+	enum pci_acs_p2pdma_state req;
+
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_acs_p2pdma_request(path->req_ctrl, tlp_flags) ==
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
 	    pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags) ==
 		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
 
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
 
@@ -841,8 +935,11 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * redirection setting of the ports along the path.
  *
  * The client initiates Requests to provider memory. At the path divergence,
- * check Request Redirect and Egress Control on the client-side port, and
- * Completion Redirect for read Completions on the provider-side port.
+ * check Request Redirect, Egress Control, Translation Blocking and Direct
+ * Translated P2P on the client-side port, and Completion Redirect for read
+ * Completions on the provider-side port. Translation Blocking is checked on
+ * every client-side port instead, because it rejects a Request rather than
+ * routing it.
  *
  * Those controls apply to different TLPs, so every class named by &enum
  * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
@@ -850,8 +947,8 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
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
@@ -904,8 +1001,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -924,6 +1023,11 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 			path.unreadable = b_child;
 	}
 
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a);
+	if (b_child)
+		path.tb_above_divergence =
+			pci_p2pdma_path_blocks_translation(b_child, NULL);
+
 	/*
 	 * The walk and the config reads above serve every class; only the
 	 * decision below depends on the kind of TLP being routed.

-- 
2.55.0

