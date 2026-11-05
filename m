Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873168;
	b=J59UPIl7Lcn6lgbXWBwrM/N+5rOFcl7p/lGsfPq2UCk0VjzPKluliZpn+WXP3UrP07ya
	 lIRiTySq0EW02P6IMQHmoutnMm5OP1n3JNn2SSy0gSDHg7lJsg89ZhrlH1b0I3eY66qQz
	 bp1G1eLwkPimkQsdKZ9p/ZmHfuU/WJ0XWPe+qWzEXKDkRRO1lnkO6VIKYOyVQC9d1NZuo
	 XnxpjWE3ptavDvfRRdKY8MY8tfTyqXCn1NDC+Li4UkjnwD8Frq51BiEEjYiQoKUzPvhKb
	 HiBPyQsTRJiOHNNHdnrjM+56iaZpeVAcBvqFVM1X42ICfW4P5sfFAin6hZFplbXZOoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=nKJwSk/vDIrgiNZ7qnipZOqYuzA86E3ORIiz2b16MoE=;
	b=JhenH+6ldeP3Q8qgq04iWmsPGz8YKjs7Qp5RXBP00CkemfFBeb4mKiqglcoEF54xEWPi
	 BADjzndxS+u3ncaoYvl8IU8GoQ98f32+qPggS5G2pxmNC/Pvs5pPBKst/tz3SY2GU8Gev
	 zZHvfFCfGKYQdHKDEivf9u5v39W2CX+YbNh1ULi6MAE2Brucq0sVt/bn896P2nrYSzZo0
	 egp5IM17u49bXbcIEVzxZVnDZr58zdpeYutiNlA1LQN9TNkIa2BOI7qdwhmel65cT5WWY
	 my+OhN+U2SPNNPZn2jy/gSTuiAICwYPc/d6KXyQBGpzvhrcYW5XcaLxfvdy4rSBLI9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5Stki7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F214606D813;
	Thu,  5 Nov 2026 10:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5Stki7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4922E1F00A1C;
	Thu,  5 Nov 2026 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873163;
	bh=nKJwSk/vDIrgiNZ7qnipZOqYuzA86E3ORIiz2b16MoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5Stki7iYP4jxqqKba2NJT3slr7UbNc+dG1ptFAwiVq+dC4MHPG6BYjHq9I2vppuZ
	 knHcAi8g0KlIQofRS6hJhk2JIH8XCJ5lye4zrQQr8kTeZ5UAYhpeE1OHVllgdA6644
	 7ty6CAEAMz/jWnxSff27ociGmEwwTvKfRjcZOnnRIWhNT27HsumGy0eyqH84iEe5xu
	 NR5a8+M+mnCy0WAafJSFPf3n2OaCtfDGCqE4WAV6FZ1IQd8Q23SebocAkZ2aNWFRZw
	 5T4AMbpyu+OM7uJgf8/yTnjliWyLTwPJmnLu6ATaUlwLLZsHRYGQFtbcbbbbF0T4sq
	 fy2Vlng2VuTrg==
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
Subject: [PATCH v13 05/19] PCI/P2PDMA: Evaluate ACS controls at the path divergence
Date: Thu,  5 Nov 2026 12:04:36 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-5-3dd065907c3b@nvidia.com>
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

ACS redirect controls below the path divergence reject valid nested
topologies, where traffic already has only an upstream route. Sibling
functions can lack an internal peer route even with redirect controls
clear, so ignoring their shared ports can incorrectly permit bus
addressing.

Evaluate directional controls at the divergence and account separately for
unsupported internal routes between functions sharing a PCIe link. Check
Upstream Forwarding at every shared Downstream and Root Port only when a
host route is needed. Reject unreadable controls needed for that route,
and keep redirect advice when clearing controls restores a direct route.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 204 ++++++++++++++++++++++++++++++++++++---------
 include/linux/pci-p2pdma.h |   8 +-
 2 files changed, 169 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index dbab955dcbdbb..abc26749eb5c6 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -531,6 +531,7 @@ static u16 pci_acs_p2pdma_quirk_redirect(struct pci_dev *pdev, u16 ctrl)
 }
 
 enum pci_acs_p2pdma_state {
+	PCI_ACS_P2PDMA_NOT_SUPPORTED,
 	PCI_ACS_P2PDMA_DIRECT,
 	PCI_ACS_P2PDMA_REDIRECT,
 };
@@ -566,8 +567,8 @@ pci_acs_p2pdma_completion(u16 ctrl)
 /*
  * Read @pdev's ACS Control register, with Request and Completion Redirect
  * taken from its ACS quirk if it has one. A device with neither has no
- * peer-to-peer controls at all, which routes the same as having them all
- * clear. Returns false when the register is present but cannot be read, or
+ * peer-to-peer controls at all. Whether functions can route internally is
+ * checked separately. Returns false when the register cannot be read, or
  * reads as all ones, which is what a device that does not answer returns;
  * @ctrl is then meaningless.
  */
@@ -589,6 +590,68 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 	return true;
 }
 
+static bool pci_acs_p2pdma_downstream_port(struct pci_dev *pdev)
+{
+	return pci_is_pcie(pdev) &&
+		(pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
+		 pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM);
+}
+
+/*
+ * Only use this for functions sharing a PCIe link. An absent RR or CR
+ * capability means that the corresponding internal peer route does not
+ * exist, rather than that a programmable redirect is disabled. Likewise,
+ * SR-IOV functions that support internal peer traffic must implement ACS.
+ * Use each VF's own capability, not its PF's.
+ */
+static bool pci_acs_p2pdma_no_internal_route(struct pci_dev *pdev, u16 flag)
+{
+	if (pci_dev_specific_acs_enabled(pdev, flag) > 0)
+		return true;
+
+	if (pdev->acs_cap)
+		return !(pdev->acs_capabilities & flag);
+
+	return pdev->is_physfn || pdev->is_virtfn;
+}
+
+/*
+ * Traffic redirected above the divergence has the same ingress and egress
+ * at every shared Downstream Port. ACS Upstream Forwarding must carry it
+ * toward the host instead of back down that link. Missing UF support does
+ * not establish a forwarding route, even though it satisfies an isolation
+ * query. Report unreadable controls separately from missing forwarding.
+ */
+static struct pci_dev *
+pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
+				    struct pci_dev **unreadable)
+{
+	struct pci_dev *pdev;
+	u16 ctrl;
+
+	for (pdev = common; pdev; pdev = pci_upstream_bridge(pdev)) {
+		if (!pci_acs_p2pdma_downstream_port(pdev))
+			continue;
+
+		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl)) {
+			*unreadable = pdev;
+			return NULL;
+		}
+
+		/*
+		 * Include Root Ports here. The PCIe port type check excludes
+		 * the legacy AMD southbridge quirk, which may sleep.
+		 */
+		if (pci_dev_specific_acs_enabled(pdev, PCI_ACS_UF) > 0)
+			continue;
+
+		if (!(pdev->acs_cap && pdev->acs_capabilities & ctrl & PCI_ACS_UF))
+			return pdev;
+	}
+
+	return NULL;
+}
+
 static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
 {
 	if (!buf)
@@ -638,7 +701,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
 			 seq_buf_str(quirk_list));
 	if (pci_p2pdma_end_list(acs_list))
 		pci_warn(client,
-			 "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
+			 "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
 			 seq_buf_str(acs_list));
 }
 
@@ -807,9 +870,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * If the two devices are the same PCI function, return
  * PCI_P2PDMA_MAP_BUS_ADDR and a distance of 0.
  *
- * If they are two functions of the same device, return
- * PCI_P2PDMA_MAP_BUS_ADDR and a distance of 2 (one hop up to the bridge,
- * then one hop back down to another function of the same device).
+ * If they are two functions of the same device, return a distance of 2.
+ * A bus address requires an internal route between the functions. Otherwise,
+ * Upstream Forwarding must carry the traffic through their shared ports
+ * toward a supported host bridge.
  *
  * In the case where two devices are connected to the same PCIe switch,
  * return a distance of 4. This corresponds to the following PCI tree:
@@ -826,13 +890,14 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * then to Device B. The mapping type returned depends on the ACS
  * redirection setting of the ports along the path.
  *
- * The client is the Requester and the provider the Completer. Check Request
- * Redirect on the Requester's path and Completion Redirect for read
- * Completions on the Completer's path.
+ * The client is the Requester and the provider the Completer. At the path
+ * divergence, check Request Redirect and Egress Control on the Requester-side
+ * port, and Completion Redirect for read Completions on the Completer-side
+ * port.
  *
- * If ACS redirect is set on any port in the path, traffic between the
- * devices will go through the host bridge, so return
- * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
+ * If ACS redirects traffic at either divergence port, return
+ * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
+ * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
  * PCI_P2PDMA_MAP_BUS_ADDR.
  *
  * Any two devices that have a data path that goes through the host bridge
@@ -846,10 +911,16 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, bool verbose)
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
 	struct pci_dev *a = provider, *b = client, *bb;
+	struct pci_dev *a_child = NULL, *b_child = NULL;
+	struct pci_dev *acs_unreadable = NULL;
+	struct pci_dev *uf_blocked = NULL;
+	struct pci_dev *uf_unreadable = NULL;
 	struct pci_p2pdma *p2pdma;
 	struct seq_buf acs_list, quirk_list;
-	int acs_cnt = 0;
+	bool req_upstream = false, cpl_upstream = false;
+	int acs_redirect_cnt = 0;
 	int dist_a = 0;
 	int dist_b = 0;
 	char buf[128], quirk_buf[64];
@@ -865,57 +936,112 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 */
 	while (a) {
 		dist_b = 0;
-
-		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
-		    pci_acs_p2pdma_completion(ctrl) ==
-			    PCI_ACS_P2PDMA_REDIRECT) {
-			pci_p2pdma_list_redir(&acs_list, &quirk_list, a);
-			acs_cnt++;
-		}
-
+		b_child = NULL;
 		bb = b;
 
 		while (bb) {
 			if (a == bb)
-				goto check_b_path_acs;
+				goto check_paths_acs;
 
+			b_child = bb;
 			bb = pci_upstream_bridge(bb);
 			dist_b++;
 		}
 
+		a_child = a;
 		a = pci_upstream_bridge(a);
 		dist_a++;
 	}
 
+	/*
+	 * The paths share no upstream bridge, so there is no direct path for
+	 * ACS to gate: PCI_P2PDMA_MAP_BUS_ADDR is not reachable here and the
+	 * request can only get to the peer through the host bridge.
+	 */
 	*dist = dist_a + dist_b;
 	goto map_through_host_bridge;
 
-check_b_path_acs:
-	bb = b;
-
-	while (bb) {
-		if (a == bb)
-			break;
+check_paths_acs:
+	*dist = dist_a + dist_b;
 
-		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
-		    pci_acs_p2pdma_request(ctrl) ==
-			    PCI_ACS_P2PDMA_REDIRECT) {
-			pci_p2pdma_list_redir(&acs_list, &quirk_list, bb);
-			acs_cnt++;
+	/*
+	 * ACS P2P routing controls apply where a TLP can route toward the peer
+	 * or upstream. Below that divergence, its only route toward the other
+	 * branch is upstream, so redirect controls do not affect the path.
+	 */
+	if (a_child && b_child) {
+		if (pci_acs_p2pdma_ctrl(a_child, &ctrl))
+			state = pci_acs_p2pdma_completion(ctrl);
+		if (state != PCI_ACS_P2PDMA_DIRECT) {
+			pci_p2pdma_list_redir(&acs_list, &quirk_list, a_child);
+			if (state == PCI_ACS_P2PDMA_REDIRECT)
+				acs_redirect_cnt++;
+			else if (!acs_unreadable)
+				acs_unreadable = a_child;
 		}
 
-		bb = pci_upstream_bridge(bb);
+		state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
+		if (pci_acs_p2pdma_ctrl(b_child, &ctrl))
+			state = pci_acs_p2pdma_request(ctrl);
+		if (state != PCI_ACS_P2PDMA_DIRECT) {
+			pci_p2pdma_list_redir(&acs_list, &quirk_list, b_child);
+			if (state == PCI_ACS_P2PDMA_REDIRECT)
+				acs_redirect_cnt++;
+			else if (!acs_unreadable)
+				acs_unreadable = b_child;
+		}
+		/*
+		 * Two children of one Downstream or Root Port share a link.
+		 * Use topology rather than slot numbers or the multifunction
+		 * bit, since ARI functions and VFs need not share those.
+		 */
+		if (pci_acs_p2pdma_downstream_port(a)) {
+			req_upstream =
+				pci_acs_p2pdma_no_internal_route(b_child, PCI_ACS_RR);
+			cpl_upstream =
+				pci_acs_p2pdma_no_internal_route(a_child, PCI_ACS_CR);
+		}
 	}
 
-	*dist = dist_a + dist_b;
-
-	if (!acs_cnt) {
+	/*
+	 * Below a shared upstream bridge, a path whose divergence ports do not
+	 * redirect routes the request directly.
+	 */
+	if (!acs_unreadable && !acs_redirect_cnt &&
+	    !req_upstream && !cpl_upstream) {
 		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
 		goto done;
 	}
 
-	if (verbose)
-		pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
+	if (!acs_unreadable)
+		uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a,
+							      &uf_unreadable);
+
+	if (verbose) {
+		if (acs_unreadable)
+			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
+				 pci_name(provider), pci_name(acs_unreadable));
+		else if (uf_unreadable)
+			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
+				 pci_name(provider), pci_name(uf_unreadable));
+		else if (uf_blocked)
+			pci_warn(client,
+				 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
+				 pci_name(provider), pci_name(uf_blocked));
+		if (!acs_unreadable && (req_upstream || cpl_upstream))
+			pci_warn(client,
+				 "peer-to-peer DMA with provider %s requires the host bridge; no internal route between functions\n",
+				 pci_name(provider));
+		else if (!acs_unreadable && acs_redirect_cnt)
+			pci_p2pdma_warn_redir(client, provider, &acs_list,
+					      &quirk_list);
+	}
+
+	/* An unreadable control or unusable forwarding leaves no route. */
+	if (acs_unreadable || uf_blocked || uf_unreadable) {
+		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+		goto done;
+	}
 
 map_through_host_bridge:
 	if (!cpu_supports_p2pdma() &&
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 873de20a22475..dd17501ba1b6e 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -42,10 +42,10 @@ enum pci_p2pdma_map_type {
 	PCI_P2PDMA_MAP_NONE,
 
 	/*
-	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
-	 * traverse the host bridge and the host bridge is not in the
-	 * allowlist. DMA Mapping routines should return an error when
-	 * this is returned.
+	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates no safe mapping is available,
+	 * for example because ACS blocks the direct path or the required host
+	 * bridge is not in the allowlist. DMA Mapping routines should return an
+	 * error when this is returned.
 	 */
 	PCI_P2PDMA_MAP_NOT_SUPPORTED,
 

-- 
2.56.0

