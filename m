Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCBD3F9F25;
	Tue, 13 Oct 2026 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901554; cv=none; b=dTvXnISxLfXOCb+cHdnllnDG+jVkgIXL2bJGEomUQYZTAkQI307+N/IYS1c+5XxmQYuwJ19Q7nN6PzDEXWUAPOzTVUo6zfzrzu0DBmpQg10jzhyCSbuJTDU5ksGDwb/a7rvzdzRwk2iZUwlKvBFc6BCXRcT8AtOBD599NRDiXiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901554; c=relaxed/simple;
	bh=6mortVpp57qdndoqZMS0hNEy1Ay/mHxN9cBSHOilErg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIgpsIMfExRBSaKgvBMPjpaatcDiTzOMnEJjhqFNHMv8CZpLX9XQw8XaEyNYfMeeQGDJG8++8cPkyackuRWwPfyRA3Az/+tqmlDOLDJaUtRlko9Y1W+qy5D3bw1TPuD3A5KP9P4ymdUaBJWbZskV/XStX+VQ/YM3CoiUfzVSzSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATAwBctb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATAwBctb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599241F000FF;
	Tue, 13 Oct 2026 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901553;
	bh=TpcnwG46mQgClsSkImLydQ9tezOpX4iqCLAeVAC1GKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATAwBctbMVpHZwGw4mZ1SP13cdJzqXTq8M751rUPZBmAGLksrpjru3kSLaeGls6C+
	 YkFXWQ9gjByvOiPPkWAHJEQaXdaJf+uP/C4AvnFWViHP4hKizZoIZkgM5iwWf3ub8G
	 C3zmqToOtZGmjvFOajkeMy3Gd2oLtpVHmkQVxhPTpWs8+SYOxd8PjjIC+i1XexMvbj
	 aNJt7MvDZvhunobqg2f/hWrrUVzsbYFM9R+2SsqxjhaYJoJ3ctTI2h+r2Pn0ilM328
	 4NgptRQjz26sygD2UepR7TDD5BM5qG52b5Q7I3+eW3BuDnZ4d2B+SOdi0hftsSW1QD
	 lLBEnQf/KWJjA==
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
Subject: [PATCH v11 05/19] PCI/P2PDMA: Evaluate ACS controls at the path divergence
Date: Tue, 13 Oct 2026 17:25:13 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-5-72cf8c96e617@nvidia.com>
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

ACS redirect controls below the path divergence reject valid nested
topologies, where traffic already has only an upstream route. Sibling
functions can lack an internal peer route even with redirect controls
clear, so ignoring their shared ports can incorrectly permit bus
addressing.

Evaluate directional controls at the divergence and account separately for
unsupported internal routes between functions sharing a PCIe link. Require
usable Upstream Forwarding through their shared ports before considering
the host-bridge route. Reject unreadable ACS controls.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 194 ++++++++++++++++++++++++++++++++++++---------
 include/linux/pci-p2pdma.h |   8 +-
 2 files changed, 159 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index dbab955dcbdb..8ca0c9ba87c2 100644
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
@@ -589,6 +590,65 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
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
+ * Traffic between functions on one link has the same ingress and egress
+ * at every shared Downstream Port. ACS Upstream Forwarding must carry it
+ * toward the host instead of back down that link. Missing UF support does
+ * not establish a forwarding route, even though it satisfies an isolation
+ * query. Return the first port that cannot establish this route.
+ */
+static struct pci_dev *
+pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common)
+{
+	struct pci_dev *pdev;
+	u16 ctrl;
+
+	for (pdev = common; pdev; pdev = pci_upstream_bridge(pdev)) {
+		if (!pci_acs_p2pdma_downstream_port(pdev))
+			continue;
+
+		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl))
+			return pdev;
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
@@ -638,7 +698,7 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
 			 seq_buf_str(quirk_list));
 	if (pci_p2pdma_end_list(acs_list))
 		pci_warn(client,
-			 "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
+			 "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
 			 seq_buf_str(acs_list));
 }
 
@@ -807,9 +867,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
@@ -826,13 +887,14 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
@@ -846,10 +908,15 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, bool verbose)
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
 	struct pci_dev *a = provider, *b = client, *bb;
+	struct pci_dev *a_child = NULL, *b_child = NULL;
+	struct pci_dev *acs_unreadable = NULL;
+	struct pci_dev *uf_blocked = NULL;
 	struct pci_p2pdma *p2pdma;
 	struct seq_buf acs_list, quirk_list;
-	int acs_cnt = 0;
+	bool req_upstream = false, cpl_upstream = false;
+	int acs_redirect_cnt = 0;
 	int dist_a = 0;
 	int dist_b = 0;
 	char buf[128], quirk_buf[64];
@@ -865,57 +932,106 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
+			uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a);
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
+	if (verbose) {
+		if (acs_unreadable)
+			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
+				 pci_name(provider), pci_name(acs_unreadable));
+		else if (uf_blocked)
+			pci_warn(client,
+				 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
+				 pci_name(provider), pci_name(uf_blocked));
+		else if (req_upstream || cpl_upstream)
+			pci_warn(client,
+				 "peer-to-peer DMA with provider %s requires the host bridge; no internal route between functions\n",
+				 pci_name(provider));
+		else
+			pci_p2pdma_warn_redir(client, provider, &acs_list,
+					      &quirk_list);
+	}
+
+	/* An unreadable control or unusable forwarding leaves no route. */
+	if (acs_unreadable || uf_blocked) {
+		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+		goto done;
+	}
 
 map_through_host_bridge:
 	if (!cpu_supports_p2pdma() &&
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 873de20a2247..dd17501ba1b6 100644
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
2.55.0

