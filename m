Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873189;
	b=i4NcSGCFYEZ5ZCT6w5Fa+/KrmcpF+40Tv5G1M+cIC1MwtF8Ptqc1rB9r43XEABL6VQAI
	 X15Dkcs+jd0qDWg0oGNhPGYTW9Kl0Cs5oGXDFL62B2tPRl2pElZ6cwgVxAEOYEJLtpsTT
	 jAQEvMY5rDbehqJAlq8aeGGch2ZGWne1/kqM2xwyDJmScy6p27ofzMiyYDf50WA2Twdom
	 hlTm0yw94Nzz9c2JMRBrhOFH7pAjT0k4G40NUPpniGx7BsBPVzkX9jHKuuziWXFGT4bPJ
	 h2NrVYQinQ/kt2zTmB06a2drs2sTNDe8UiWV0otTB+IhdskX6cCoBM2wrTQjHFvkPaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=Drz9faF5WcfDoxOCQvGdy6W0yxhjA4NXoy4Z7HTZ4VA=;
	b=19Kvx7qhdCgKKeOCPoYuRtHMFn5CVW3i9lmkExpnIaGtoXRQw/slDyZO5FilGWA49nvg
	 vg4kgIWvmdJrKCFRXjee+e+qh7zlNvVpu4fx0NO08nogUh/NoeQwt6yfd9xHnVxpmyp0p
	 vtT6ScJjpS3vbUyjRCKlFhJvkypoCcUiHXMw2lN4AoAkQ9U6CUxnw2ItcNwx5LhNB5GuY
	 sn3dmdyPB7gUBoOvdvYINPFYTo5vXxsJYStZUInrBRKDdPtA9EhFIi1rh0nptH2fVAic1
	 JW8ZyLB7tzrJSflZ8FXHee52GXluN29IAy24/BlHh5Eg8ToIM73ymF8P6xKPji4U1wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8IUeGX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7760A2633;
	Thu,  5 Nov 2026 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8IUeGX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8C31F0093A;
	Thu,  5 Nov 2026 10:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873188;
	bh=Drz9faF5WcfDoxOCQvGdy6W0yxhjA4NXoy4Z7HTZ4VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8IUeGX61458EIiB1Zn2Cyz2vWZhoLUlNHmAUwV7rTsuLdSqCZfj62Uw+yugBA2f5
	 m2Z/tOI1tE0fdE3L2pIGr1FFObfMr4yFbDQXVaer/n1GYOfCt8SoDnPoOwM4gNauCp
	 YCUah3Ok78+cMfZkqe1i+tTIFIPWl1LoGNX+XLgSdhiSFl8MfFNz/6+WkOfHjK0+KZ
	 usZIA7Mz3LD5CCjV7IOONm/+EYtAlBrb0shh4Tw2IDcbC5Ph1KlTJ9NrqvLkxBjYwf
	 Pp9IqZhuIZR7U1NAYiuKufd82sasqOolQvoYF5KSNPJuJ78O3KGAacC5ZerMBZW/8K
	 mzajOhkO/OtGg==
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
Subject: [PATCH v13 12/19] PCI/P2PDMA: Log detailed ACS routing diagnostics
Date: Thu,  5 Nov 2026 12:04:43 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-12-3dd065907c3b@nvidia.com>
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

When P2PDMA rejects a mapping, existing warnings identify only the final
ACS or host-bridge result. They omit topology, live controls, divergence
ports, cache state, and intermediate routing decisions.

Emit debug-level messages for verbose calculations and cache lookups.
Report both paths, decoded ACS controls, directional decisions, host
fallback, and the final mapping. The messages stay silent until enabled,
and the existing warnings are unchanged.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 214 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 194 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index f4ef51e10d79c..1f00371d9f757 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -615,6 +615,40 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
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
  * Read @pdev's ACS Control register, with Request and Completion Redirect
  * taken from its ACS quirk if it has one. A device with neither has no
@@ -623,12 +657,16 @@ pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
  * reads as all ones, which is what a device that does not answer returns;
  * @ctrl is then meaningless.
  */
-static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
+static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, const char *what,
+				u16 *ctrl, bool verbose)
 {
 	int pos, ret;
 
 	pos = pdev->acs_cap;
 	if (!pos) {
+		if (verbose)
+			pci_dbg(pdev,
+				"P2PDMA ACS: %s has no ACS capability\n", what);
 		*ctrl = pci_acs_p2pdma_quirk_redirect(pdev, 0);
 		return true;
 	}
@@ -636,10 +674,27 @@ static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
 	ret = pci_dev_specific_read_acs_ctrl(pdev, ctrl);
 	if (ret == -ENOTTY)
 		ret = pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
-	if (ret || PCI_POSSIBLE_ERROR(*ctrl))
+	if (ret || PCI_POSSIBLE_ERROR(*ctrl)) {
+		if (verbose)
+			pci_dbg(pdev,
+				"P2PDMA ACS: %s ACS Control read failed: cap=%#x status=%#x value=%#06x\n",
+				 what, pos, ret, *ctrl);
 		return false;
+	}
 
 	*ctrl = pci_acs_p2pdma_quirk_redirect(pdev, *ctrl);
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
 	return true;
 }
 
@@ -677,7 +732,7 @@ static bool pci_acs_p2pdma_no_internal_route(struct pci_dev *pdev, u16 flag)
  */
 static struct pci_dev *
 pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
-				    struct pci_dev **unreadable)
+				    struct pci_dev **unreadable, bool verbose)
 {
 	struct pci_dev *pdev;
 	u16 ctrl;
@@ -686,7 +741,8 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
 		if (!pci_acs_p2pdma_downstream_port(pdev))
 			continue;
 
-		if (!pci_acs_p2pdma_ctrl(pdev, &ctrl)) {
+		if (!pci_acs_p2pdma_ctrl(pdev, "upstream forwarding", &ctrl,
+					 verbose)) {
 			*unreadable = pdev;
 			return NULL;
 		}
@@ -705,6 +761,30 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
 	return NULL;
 }
 
+static void pci_p2pdma_log_path(const char *name, struct pci_dev *start,
+				struct pci_dev *common)
+{
+	struct pci_dev *pdev, *upstream;
+	int hop = 0, type;
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
+		/* Cached state only: the routing logs the ACS Control it reads. */
+		if (pdev->acs_cap)
+			pci_dbg(pdev, "P2PDMA ACS: ACS cap=%#x caps=%#06x\n",
+				 pdev->acs_cap, pdev->acs_capabilities);
+		else
+			pci_dbg(pdev, "P2PDMA ACS: ACS capability absent\n");
+	}
+}
+
 /*
  * Report whether any port between @client and @common rejects Translated
  * addresses. If @common is NULL, every port up to the host bridge is walked.
@@ -713,7 +793,8 @@ pci_acs_p2pdma_no_upstream_forwarding(struct pci_dev *common,
  * redirect controls instead.
  */
 static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
-					       struct pci_dev *common)
+					       struct pci_dev *common,
+					       bool verbose)
 {
 	struct pci_dev *pdev;
 	u16 ctrl;
@@ -728,11 +809,15 @@ static bool pci_p2pdma_path_blocks_translation(struct pci_dev *client,
 
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
@@ -1199,13 +1284,22 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
+	void *old;
+
+	if (verbose)
+		pci_dbg(client,
+			"P2PDMA ACS: begin provider=%s client=%s cache-index=%#lx\n",
+			 pci_name(provider), pci_name(client),
+			 map_types_idx(client));
 
 	/*
 	 * Note, we don't need to take references to devices returned by
@@ -1237,14 +1331,32 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -1252,11 +1364,12 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * branch is upstream, so redirect controls do not affect the path.
 	 */
 	if (a_child && b_child) {
-		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
+		if (!pci_acs_p2pdma_ctrl(a_child, "completion", &path.cpl_ctrl,
+					 verbose))
 			path.unreadable = a_child;
 		path.cpl_quirk = pci_acs_p2pdma_quirk(a_child, PCI_ACS_CR);
-		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
-		    !path.unreadable)
+		if (!pci_acs_p2pdma_ctrl(b_child, "request", &path.req_ctrl,
+					 verbose) && !path.unreadable)
 			path.unreadable = b_child;
 		/*
 		 * Two children of one Downstream or Root Port share a link.
@@ -1269,12 +1382,26 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 			path.cpl_upstream =
 				pci_acs_p2pdma_no_internal_route(a_child, PCI_ACS_CR);
 		}
+		if (verbose && !path.unreadable)
+			pci_dbg(client,
+				"P2PDMA ACS: class=strict request=%s at %s completion=%s at %s\n",
+				 pci_acs_p2pdma_state_name(
+					 pci_p2pdma_request_state(&path, 0)),
+				 pci_name(b_child),
+				 pci_acs_p2pdma_state_name(
+					 pci_p2pdma_completion_state(&path, 0)),
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
 
 	/* Shared ports need forwarding only for classes using the host bridge. */
 	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++) {
@@ -1282,7 +1409,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		    PCI_P2PDMA_MAP_THRU_HOST_BRIDGE)
 			continue;
 		path.uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a,
-						&path.uf_unreadable);
+						&path.uf_unreadable, verbose);
 		break;
 	}
 
@@ -1313,6 +1440,19 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -1324,11 +1464,32 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 done:
 	rcu_read_lock();
 	p2pdma = rcu_dereference(provider->p2pdma);
-	if (p2pdma)
-		xa_store(&p2pdma->map_types, map_types_idx(client),
-			 xa_mk_value(pci_p2pdma_map_types_pack(map_type)),
-			 GFP_ATOMIC);
+	if (p2pdma) {
+		old = xa_store(&p2pdma->map_types, map_types_idx(client),
+			       xa_mk_value(pci_p2pdma_map_types_pack(map_type)),
+			       GFP_ATOMIC);
+		cache_store = !xa_is_err(old);
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
 
@@ -1659,13 +1820,21 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
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
@@ -1676,8 +1845,13 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
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
2.56.0

