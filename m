Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F2132570D;
	Mon, 12 Oct 2026 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810535; cv=none; b=IekQ1qu2t8J8guwCfjVSCriQFHB4f7rKetlk68/im0QamjkR+7TbMMpgQxvvQI7spOXkfM7U8kdIiG8Uqk3d1ek24Eq0qYRMTnIkavKsE9XnbnopXOzcUJ6cIU0VWPYB8Leq7p3L6JIuGb7pBLCZqREtSj9Gf5Hp4RwldpD5nM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810535; c=relaxed/simple;
	bh=phfisTHBBTYtnHC3tWyKHGnJw5Qua5vNfofzDV5WPf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eInuIMUTFT/oO1gc0tqKX+zTWGHQntTFTK3fgT+tDdQLcNQTTGwGozxVJjqM6XObDuFMufxXS04eJi/QZSLQZpxHM4a33hDm1TqXPtkotcEmby29FS0xwc5nKTgorHj4AwiUtWDZR82aCHYlV+DQKvN+9P1q2oI4+I18l1oiN0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBXgjH43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBXgjH43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354071F0089E;
	Mon, 12 Oct 2026 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810533;
	bh=m03xtngBa0dulAEpc1nuUZBNlKNNDwWlwZq6QyrR/bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBXgjH43DPMM813erED6g8Mq380StgULfvNshEQWvII9kEe+HfX41QQVCllNh7MZ8
	 v/IxEG1BEaRGTQsEuKBRSUPa1lcVXo5vfVMgiID4/csXb9SfUnyW7nhiaWHz82sdeU
	 K6Cm7YfzEEbUh3NjBBRF8QxogjKkBpEgQ7CvvV7AVgF8X1uV0IsqY6l2nDdTm5g7HP
	 4ErTYL0VsGq7f6qZEEsiCHfadn1i3R2SnF4v0QufY13H5bUPG242f1oNbW6gLb8wwN
	 dl2T+0oOCRNU5FgBZ0u83fgNBRpNLO2y0e280OFLIqSLf0SYfJVS6TTM1q5CJB6A4N
	 f+FD1q2wnpS7Q==
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
Subject: [PATCH v10 11/18] PCI/P2PDMA: Log detailed ACS routing diagnostics
Date: Mon, 12 Oct 2026 16:07:48 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-11-6ffe7b7a4517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
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

When P2PDMA rejects a mapping, existing warnings identify only the final
ACS or host-bridge result. They omit topology, live controls, divergence
ports, cache state, and intermediate routing decisions.

Emit debug-level messages for verbose calculations and cache lookups.
Report both paths, decoded ACS controls, directional decisions, host
fallback, and the final mapping. This keeps incidental unsupported probes
quiet while allowing the diagnostics to be enabled when needed.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 232 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 215 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index ebc34aae03a1..46f7927968ff 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -577,23 +577,128 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 				   PCI_ACS_P2PDMA_DIRECT;
 }
 
+static const char *pci_acs_p2pdma_state_name(enum pci_acs_p2pdma_state state)
+{
+	switch (state) {
+	case PCI_ACS_P2PDMA_DIRECT:
+		return "direct";
+	case PCI_ACS_P2PDMA_REDIRECT:
+		return "redirect";
+	case PCI_ACS_P2PDMA_BLOCKED:
+		return "blocked";
+	case PCI_ACS_P2PDMA_NOT_SUPPORTED:
+		return "not-supported";
+	}
+
+	return "invalid";
+}
+
+static const char *pci_p2pdma_map_type_name(enum pci_p2pdma_map_type type)
+{
+	switch (type) {
+	case PCI_P2PDMA_MAP_UNKNOWN:
+		return "unknown";
+	case PCI_P2PDMA_MAP_NONE:
+		return "none";
+	case PCI_P2PDMA_MAP_NOT_SUPPORTED:
+		return "not-supported";
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		return "bus-address";
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		return "through-host-bridge";
+	}
+
+	return "invalid";
+}
+
 /*
  * Read @pdev's ACS Control register. A device without an ACS capability has
  * no peer-to-peer controls at all, which routes the same as having them all
  * clear. Returns false when the register is present but cannot be read; @ctrl
  * is then meaningless.
  */
-static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
+static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, const char *what,
+				u16 *ctrl, bool verbose)
 {
-	int pos;
+	int pos, ret;
 
 	pos = pdev->acs_cap;
 	if (!pos) {
+		if (verbose)
+			pci_dbg(pdev,
+				"P2PDMA ACS: %s has no ACS capability\n", what);
 		*ctrl = 0;
 		return true;
 	}
 
-	return !pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
+	ret = pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
+	if (ret) {
+		if (verbose)
+			pci_dbg(pdev,
+				"P2PDMA ACS: %s ACS Control read failed at %#x: %#x\n",
+				 what, pos + PCI_ACS_CTRL, ret);
+		return false;
+	}
+
+	if (verbose) {
+		pci_dbg(pdev,
+			 "P2PDMA ACS: %s cap=%#x caps=%#06x ctrl=%#06x\n",
+			 what, pos, pdev->acs_capabilities, *ctrl);
+		pci_dbg(pdev,
+			 "P2PDMA ACS: control bits SV=%u TB=%u RR=%u CR=%u UF=%u EC=%u DT=%u\n",
+			 !!(*ctrl & PCI_ACS_SV), !!(*ctrl & PCI_ACS_TB),
+			 !!(*ctrl & PCI_ACS_RR), !!(*ctrl & PCI_ACS_CR),
+			 !!(*ctrl & PCI_ACS_UF), !!(*ctrl & PCI_ACS_EC),
+			 !!(*ctrl & PCI_ACS_DT));
+	}
+
+	return true;
+}
+
+static void pci_p2pdma_log_path(const char *name, struct pci_dev *start,
+				struct pci_dev *common)
+{
+	struct pci_dev *pdev, *upstream;
+	int hop = 0, ret, type;
+	u16 ctrl;
+
+	for (pdev = start; pdev; pdev = upstream, hop++) {
+		upstream = pci_upstream_bridge(pdev);
+		type = pci_is_pcie(pdev) ? pci_pcie_type(pdev) : -1;
+		pci_dbg(pdev,
+			 "P2PDMA ACS: %s path hop=%d common=%u pcie=%u type=%d class=%#08x vendor=%04x device=%04x upstream=%s\n",
+			 name, hop, pdev == common, pci_is_pcie(pdev), type,
+			 pdev->class, pdev->vendor, pdev->device,
+			 upstream ? pci_name(upstream) : "<none>");
+
+		if (pdev->subordinate)
+			pci_dbg(pdev,
+				"P2PDMA ACS: bridge bus range=%02llx-%02llx\n",
+				 (unsigned long long)pdev->subordinate->busn_res.start,
+				 (unsigned long long)pdev->subordinate->busn_res.end);
+
+		if (!pdev->acs_cap) {
+			pci_dbg(pdev, "P2PDMA ACS: ACS capability absent\n");
+			continue;
+		}
+
+		ret = pci_read_config_word(pdev, pdev->acs_cap + PCI_ACS_CTRL,
+					   &ctrl);
+		if (ret) {
+			pci_dbg(pdev,
+				"P2PDMA ACS: ACS cap=%#x caps=%#06x Control read failed: %#x\n",
+				 pdev->acs_cap, pdev->acs_capabilities, ret);
+			continue;
+		}
+
+		pci_dbg(pdev,
+			"P2PDMA ACS: ACS cap=%#x caps=%#06x ctrl=%#06x SV=%u TB=%u RR=%u CR=%u UF=%u EC=%u DT=%u\n",
+			 pdev->acs_cap, pdev->acs_capabilities, ctrl,
+			 !!(ctrl & PCI_ACS_SV), !!(ctrl & PCI_ACS_TB),
+			 !!(ctrl & PCI_ACS_RR), !!(ctrl & PCI_ACS_CR),
+			 !!(ctrl & PCI_ACS_UF), !!(ctrl & PCI_ACS_EC),
+			 !!(ctrl & PCI_ACS_DT));
+	}
 }
 
 /*
@@ -604,7 +709,8 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
  * redirect controls instead.
  */
 static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
-					       struct pci_dev *common)
+					       struct pci_dev *common,
+					       bool verbose)
 {
 	struct pci_dev *pdev;
 	u16 ctrl;
@@ -619,11 +725,15 @@ static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
 
 	for (pdev = pci_upstream_bridge(client); pdev && pdev != common;
 	     pdev = pci_upstream_bridge(pdev)) {
-		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl))
+		if (!pci_acs_p2pdma_ctrl(pdev, "path hop", &ctrl, verbose))
 			return true;
 
-		if (ctrl & PCI_ACS_TB)
+		if (ctrl & PCI_ACS_TB) {
+			if (verbose)
+				pci_dbg(pdev,
+					"P2PDMA ACS: Translation Blocking rejects Translated Requests on this path\n");
 			return true;
+		}
 	}
 
 	return false;
@@ -1003,14 +1113,22 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	enum pci_p2pdma_map_type map_type[PCI_P2PDMA_TLP_CLASSES];
 	struct pci_dev *a = provider, *b = client, *bb;
 	struct pci_dev *a_child = NULL, *b_child = NULL;
+	struct pci_host_bridge *provider_host, *client_host;
 	struct pci_p2pdma_acs_path path = {};
 	struct pci_p2pdma *p2pdma;
 	bool cpu_p2pdma, host_whitelisted = false;
+	bool cache_store = false;
 	bool host_fallback = false;
 	unsigned int flags;
 	int dist_a = 0;
 	int dist_b = 0;
 
+	if (verbose)
+		pci_dbg(client,
+			"P2PDMA ACS: begin provider=%s client=%s cache-index=%#lx\n",
+			 pci_name(provider), pci_name(client),
+			 map_types_idx(client));
+
 	/*
 	 * Note, we don't need to take references to devices returned by
 	 * pci_upstream_bridge() seeing we hold a reference to a child
@@ -1041,14 +1159,32 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	if (verbose) {
+		pci_dbg(client,
+			"P2PDMA ACS: no common upstream bridge provider-distance=%d client-distance=%d total=%d\n",
+			 dist_a, dist_b, *dist);
+		pci_p2pdma_log_path("provider", provider, NULL);
+		pci_p2pdma_log_path("client", client, NULL);
+	}
 	path.no_common_bridge = true;
-	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, NULL);
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, NULL,
+							     verbose);
 	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
 		map_type[flags] = pci_p2pdma_route(&path, flags);
 	goto map_through_host_bridge;
 
 check_paths_acs:
 	*dist = dist_a + dist_b;
+	if (verbose) {
+		pci_dbg(client,
+			"P2PDMA ACS: common=%s provider-divergence=%s client-divergence=%s provider-distance=%d client-distance=%d total=%d\n",
+			 pci_name(a),
+			 a_child ? pci_name(a_child) : "<none>",
+			 b_child ? pci_name(b_child) : "<none>",
+			 dist_a, dist_b, *dist);
+		pci_p2pdma_log_path("provider", provider, a);
+		pci_p2pdma_log_path("client", client, a);
+	}
 
 	/*
 	 * ACS P2P routing controls apply where a TLP can route toward the peer
@@ -1056,17 +1192,33 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * branch is upstream, so redirect controls do not affect the path.
 	 */
 	if (a_child && b_child) {
-		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
+		if (!pci_acs_p2pdma_ctrl(a_child, "completion", &path.cpl_ctrl,
+					 verbose))
 			path.unreadable = a_child;
-		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
-		    !path.unreadable)
+		if (!pci_acs_p2pdma_ctrl(b_child, "request", &path.req_ctrl,
+					 verbose) && !path.unreadable)
 			path.unreadable = b_child;
+		if (verbose && !path.unreadable)
+			pci_dbg(client,
+				"P2PDMA ACS: request=%s at %s completion=%s at %s\n",
+				 pci_acs_p2pdma_state_name(
+					 pci_p2pdma_request_state(&path, 0)),
+				 pci_name(b_child),
+				 pci_acs_p2pdma_state_name(
+					 pci_acs_p2pdma_completion(path.cpl_ctrl,
+								   0)),
+				 pci_name(a_child));
+	} else if (verbose) {
+		pci_dbg(client,
+			"P2PDMA ACS: peer divergence is incomplete; no ACS peer-routing controls evaluated\n");
 	}
 
-	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a);
+	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a,
+							     verbose);
 	if (b_child)
 		path.tb_above_divergence =
-			pci_p2pdma_path_blocks_translation(b_child, NULL);
+			pci_p2pdma_path_blocks_translation(b_child, NULL,
+							   verbose);
 
 	/*
 	 * The walk and the config reads above serve every class; only the
@@ -1095,6 +1247,19 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		host_whitelisted = host_bridge_whitelist(provider, client,
 							  verbose);
 
+	if (verbose) {
+		provider_host = pci_find_host_bridge(provider->bus);
+		client_host = pci_find_host_bridge(client->bus);
+		pci_dbg(client,
+			"P2PDMA ACS: host fallback cpu-support=%u whitelist=%s provider-host=%s client-host=%s same-host=%u\n",
+			 cpu_p2pdma,
+			 cpu_p2pdma ? "not-consulted" :
+					(host_whitelisted ? "yes" : "no"),
+			 provider_host ? dev_name(&provider_host->dev) : "<none>",
+			 client_host ? dev_name(&client_host->dev) : "<none>",
+			 provider_host && provider_host == client_host);
+	}
+
 	if (!cpu_p2pdma && !host_whitelisted) {
 		if (verbose)
 			pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider (%s) do not share an upstream bridge or whitelisted host bridge\n",
@@ -1106,11 +1271,31 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 done:
 	rcu_read_lock();
 	p2pdma = rcu_dereference(provider->p2pdma);
-	if (p2pdma)
+	if (p2pdma) {
 		xa_store(&p2pdma->map_types, map_types_idx(client),
-			 xa_mk_value(pci_p2pdma_map_types_pack(map_type)),
-			 GFP_ATOMIC);
+			 xa_mk_value(pci_p2pdma_map_types_pack(map_type)), GFP_ATOMIC);
+		cache_store = true;
+	}
 	rcu_read_unlock();
+	if (verbose) {
+		pci_dbg(client,
+			"P2PDMA ACS: final provider=%s result=%s(%d) tlp-flags=%#x distance=%d unreadable=%s cache-store=%u index=%#lx\n",
+			 pci_name(provider),
+			 pci_p2pdma_map_type_name(map_type[tlp_flags]),
+			 map_type[tlp_flags], tlp_flags, *dist,
+			 path.unreadable ? pci_name(path.unreadable) : "<none>",
+			 cache_store, map_types_idx(client));
+		pci_dbg(client,
+			"P2PDMA ACS: classes strict=%s relaxed=%s translated=%s translated+relaxed=%s\n",
+			 pci_p2pdma_map_type_name(map_type[0]),
+			 pci_p2pdma_map_type_name(
+				 map_type[PCI_P2PDMA_TLP_RELAXED_CPL]),
+			 pci_p2pdma_map_type_name(
+				 map_type[PCI_P2PDMA_TLP_TRANSLATED]),
+			 pci_p2pdma_map_type_name(
+				 map_type[PCI_P2PDMA_TLP_TRANSLATED |
+					  PCI_P2PDMA_TLP_RELAXED_CPL]));
+	}
 	return map_type[tlp_flags];
 }
 
@@ -1441,13 +1626,21 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	enum pci_p2pdma_map_type type;
 	struct pci_p2pdma *p2pdma;
 	struct pci_dev *client;
+	bool provider_state;
 	int dist;
 
-	if (!pdev->p2pdma)
+	if (!pdev->p2pdma) {
+		pci_dbg(pdev,
+			"P2PDMA ACS: map lookup rejected; provider state is absent\n");
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+	}
 
-	if (!dev_is_pci(dev))
+	if (!dev_is_pci(dev)) {
+		dev_dbg(dev,
+			"P2PDMA ACS: provider=%s map lookup rejected; client is not PCI\n",
+			 pci_name(pdev));
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+	}
 
 	client = to_pci_dev(dev);
 	cache_index = map_types_idx(client);
@@ -1458,8 +1651,13 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	if (p2pdma)
 		cached = xa_to_value(xa_load(&p2pdma->map_types,
 					     cache_index));
+	provider_state = !!p2pdma;
 	rcu_read_unlock();
 	type = pci_p2pdma_map_types_unpack(cached, tlp_flags);
+	pci_dbg(client,
+		 "P2PDMA ACS: map lookup provider=%s index=%#lx tlp-flags=%#x cached=%s(%d) provider-state=%u\n",
+		 pci_name(pdev), cache_index, tlp_flags,
+		 pci_p2pdma_map_type_name(type), type, provider_state);
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
 		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,

-- 
2.55.0

