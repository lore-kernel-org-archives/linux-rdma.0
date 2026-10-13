Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DD25013B9;
	Tue, 13 Oct 2026 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901563; cv=none; b=CTFlZqplU0GeXJn+8WZIBhs6eHUcTwcDxyJwNQwqj/kyQcUmEAwNwRfks4aAkE/ze58wRFFXu7tcNSxzo8a6qaTFW6LhlterfejbGqZB7z+TDI2TviYoUY4okR4+IDzqLHcg6ZYy0uTumKDqRCxYkk6Cz0hXo2TTD7lkgO2aMx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901563; c=relaxed/simple;
	bh=gy1tczsq76Bi16fV4ny3Ix84Hu0O2SgJpSeabntIKIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TurjmKKSBU4v1YCssLqtLNdYZgyd2AflW7sAK9ql7qm1sI7N/IVeRKsUx3xRgZzW7li+vfto8kyi12YylgTHG+S7no0GHoeFMK5zm6Ulc7pS6maX8Vx2aYiXZms53Fe68pZ2/wQmlWOaRJbV6L/TZKX/CY+lKHv4M6SKY/Rt0o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW7dMsIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW7dMsIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1371F000FF;
	Tue, 13 Oct 2026 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901561;
	bh=Rgvg84cs9nC9M4tSegD6eY/N8g0vQlrqXE8pIpXm5g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QW7dMsIhcyJOlIrkaoYosuzWmzY9xOXmJbDZoGURKu+bPalDZQF5OOZBijFp5d0qz
	 jSbi//UcOCo5rEkSAtRwFgz71c5VLv6gOJuGov6+mQmr6VXDHRiMjkA3Gjt4TEg8hi
	 n5187u70JhuLfIDkF2vEHizaow7qB1M6rTHmIs1AzpfVdli06+lfP0ZUvc7x780Sjk
	 4pR1fyXGY4cfVh3ABv6vr1c6DAiyKb80vR3eudYhCN7puBH9+0HDqwh9tAGclu5paZ
	 DJwv31EEHXdAJQ9OoJjrWAsjWQXBuqjgWVirLjoQnRuKCERpjPhoNLzGLaBofHABNB
	 8TzJSIEuDA+uw==
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
Subject: [PATCH v11 07/19] PCI/P2PDMA: Collect the path's ACS controls before deciding
Date: Tue, 13 Oct 2026 17:25:15 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-7-72cf8c96e617@nvidia.com>
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

calc_map_type_and_dist() combines ACS reads, routing decisions and
diagnostics. Adding decisions for different TLP attributes would duplicate
the walk or thread each attribute through its counters.

Collect the divergence controls, internal-route restrictions and upstream
forwarding state in struct pci_p2pdma_acs_path, then decide each direction
from it. Keep the existing rule that both directions must route directly
for bus addressing, and reject unusable upstream forwarding before
considering the host bridge.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 194 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 133 insertions(+), 61 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 8ca0c9ba87c2..c643f275890c 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -702,6 +702,113 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
 			 seq_buf_str(acs_list));
 }
 
+/*
+ * What the topology walk found out about one provider/client path. Producing
+ * this costs a walk and config reads, none of which depends on the TLP being
+ * routed.
+ *
+ * @req_ctrl:	ACS Control of the Requester-side divergence port. That is the
+ *		first port at which a Request can route toward the peer rather
+ *		than upstream, so it is where the Request controls apply.
+ * @cpl_ctrl:	ACS Control of the Completer-side divergence port, likewise for
+ *		the Completions travelling back.
+ * @req_upstream: The Requester has no internal route to its sibling.
+ * @cpl_upstream: The Completer has no internal route to its sibling.
+ * @unreadable:	First port whose ACS Control could not be read, if any.
+ * @uf_blocked:	First shared port without usable Upstream Forwarding, if any.
+ */
+struct pci_p2pdma_acs_path {
+	u16 req_ctrl;
+	u16 cpl_ctrl;
+	bool req_upstream;
+	bool cpl_upstream;
+	struct pci_dev *unreadable;
+	struct pci_dev *uf_blocked;
+};
+
+static enum pci_acs_p2pdma_state
+pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path)
+{
+	if (path->req_upstream)
+		return PCI_ACS_P2PDMA_REDIRECT;
+
+	return pci_acs_p2pdma_request(path->req_ctrl);
+}
+
+static enum pci_acs_p2pdma_state
+pci_p2pdma_completion_state(const struct pci_p2pdma_acs_path *path)
+{
+	if (path->cpl_upstream)
+		return PCI_ACS_P2PDMA_REDIRECT;
+
+	return pci_acs_p2pdma_completion(path->cpl_ctrl);
+}
+
+/*
+ * Combine both directions into a mapping type. Only a path that routes the
+ * Request and the Completions it generates directly can be programmed with
+ * the peer's bus addresses.
+ */
+static enum pci_p2pdma_map_type
+pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
+{
+	if (path->unreadable)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
+	if (pci_p2pdma_request_state(path) == PCI_ACS_P2PDMA_DIRECT &&
+	    pci_p2pdma_completion_state(path) == PCI_ACS_P2PDMA_DIRECT)
+		return PCI_P2PDMA_MAP_BUS_ADDR;
+
+	if (path->uf_blocked)
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
+	return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+}
+
+/*
+ * Name the ports that keep this path off a direct route, so that the admin
+ * can hand them to pci=disable_acs_redir=.
+ */
+static void pci_p2pdma_warn_path(struct pci_dev *client,
+				 struct pci_dev *provider,
+				 const struct pci_p2pdma_acs_path *path,
+				 struct pci_dev *a_child,
+				 struct pci_dev *b_child)
+{
+	struct seq_buf acs_list, quirk_list;
+	char buf[128], quirk_buf[64];
+
+	if (path->unreadable) {
+		pci_warn(client,
+			 "ACS Control is unreadable for provider %s at %s\n",
+			 pci_name(provider), pci_name(path->unreadable));
+		return;
+	}
+
+	if (path->uf_blocked) {
+		pci_warn(client,
+			 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
+			 pci_name(provider), pci_name(path->uf_blocked));
+		return;
+	}
+
+	if (path->req_upstream || path->cpl_upstream) {
+		pci_warn(client,
+			 "peer-to-peer DMA with provider %s requires the host bridge; no internal route between functions\n",
+			 pci_name(provider));
+		return;
+	}
+
+	seq_buf_init(&acs_list, buf, sizeof(buf));
+	seq_buf_init(&quirk_list, quirk_buf, sizeof(quirk_buf));
+	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+		pci_p2pdma_list_redir(&acs_list, &quirk_list, a_child);
+	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+		pci_p2pdma_list_redir(&acs_list, &quirk_list, b_child);
+
+	pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
+}
+
 static bool cpu_supports_p2pdma(void)
 {
 #ifdef CONFIG_X86
@@ -908,22 +1015,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, bool verbose)
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
-	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
 	struct pci_dev *a = provider, *b = client, *bb;
 	struct pci_dev *a_child = NULL, *b_child = NULL;
-	struct pci_dev *acs_unreadable = NULL;
-	struct pci_dev *uf_blocked = NULL;
+	struct pci_p2pdma_acs_path path = {};
 	struct pci_p2pdma *p2pdma;
-	struct seq_buf acs_list, quirk_list;
-	bool req_upstream = false, cpl_upstream = false;
-	int acs_redirect_cnt = 0;
+	bool cpu_p2pdma, host_whitelisted = false;
 	int dist_a = 0;
 	int dist_b = 0;
-	char buf[128], quirk_buf[64];
-	u16 ctrl;
-
-	seq_buf_init(&acs_list, buf, sizeof(buf));
-	seq_buf_init(&quirk_list, quirk_buf, sizeof(quirk_buf));
 
 	/*
 	 * Note, we don't need to take references to devices returned by
@@ -966,37 +1064,23 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * branch is upstream, so redirect controls do not affect the path.
 	 */
 	if (a_child && b_child) {
-		if (pci_acs_p2pdma_ctrl(a_child, &ctrl))
-			state = pci_acs_p2pdma_completion(ctrl);
-		if (state != PCI_ACS_P2PDMA_DIRECT) {
-			pci_p2pdma_list_redir(&acs_list, &quirk_list, a_child);
-			if (state == PCI_ACS_P2PDMA_REDIRECT)
-				acs_redirect_cnt++;
-			else if (!acs_unreadable)
-				acs_unreadable = a_child;
-		}
-
-		state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
-		if (pci_acs_p2pdma_ctrl(b_child, &ctrl))
-			state = pci_acs_p2pdma_request(ctrl);
-		if (state != PCI_ACS_P2PDMA_DIRECT) {
-			pci_p2pdma_list_redir(&acs_list, &quirk_list, b_child);
-			if (state == PCI_ACS_P2PDMA_REDIRECT)
-				acs_redirect_cnt++;
-			else if (!acs_unreadable)
-				acs_unreadable = b_child;
-		}
+		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
+			path.unreadable = a_child;
+		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
+		    !path.unreadable)
+			path.unreadable = b_child;
 		/*
 		 * Two children of one Downstream or Root Port share a link.
 		 * Use topology rather than slot numbers or the multifunction
 		 * bit, since ARI functions and VFs need not share those.
 		 */
 		if (pci_acs_p2pdma_downstream_port(a)) {
-			req_upstream =
+			path.req_upstream =
 				pci_acs_p2pdma_no_internal_route(b_child, PCI_ACS_RR);
-			cpl_upstream =
+			path.cpl_upstream =
 				pci_acs_p2pdma_no_internal_route(a_child, PCI_ACS_CR);
-			uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a);
+			path.uf_blocked =
+				pci_acs_p2pdma_no_upstream_forwarding(a);
 		}
 	}
 
@@ -1004,38 +1088,24 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * Below a shared upstream bridge, a path whose divergence ports do not
 	 * redirect routes the request directly.
 	 */
-	if (!acs_unreadable && !acs_redirect_cnt &&
-	    !req_upstream && !cpl_upstream) {
-		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
+	map_type = pci_p2pdma_route(&path);
+	if (map_type == PCI_P2PDMA_MAP_BUS_ADDR)
 		goto done;
-	}
 
-	if (verbose) {
-		if (acs_unreadable)
-			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
-				 pci_name(provider), pci_name(acs_unreadable));
-		else if (uf_blocked)
-			pci_warn(client,
-				 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
-				 pci_name(provider), pci_name(uf_blocked));
-		else if (req_upstream || cpl_upstream)
-			pci_warn(client,
-				 "peer-to-peer DMA with provider %s requires the host bridge; no internal route between functions\n",
-				 pci_name(provider));
-		else
-			pci_p2pdma_warn_redir(client, provider, &acs_list,
-					      &quirk_list);
-	}
+	if (verbose)
+		pci_p2pdma_warn_path(client, provider, &path, a_child, b_child);
 
 	/* An unreadable control or unusable forwarding leaves no route. */
-	if (acs_unreadable || uf_blocked) {
-		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+	if (map_type == PCI_P2PDMA_MAP_NOT_SUPPORTED)
 		goto done;
-	}
 
 map_through_host_bridge:
-	if (!cpu_supports_p2pdma() &&
-	    !host_bridge_whitelist(provider, client, verbose)) {
+	cpu_p2pdma = cpu_supports_p2pdma();
+	if (!cpu_p2pdma)
+		host_whitelisted = host_bridge_whitelist(provider, client,
+							  verbose);
+
+	if (!cpu_p2pdma && !host_whitelisted) {
 		if (verbose)
 			pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider (%s) do not share an upstream bridge or whitelisted host bridge\n",
 				 pci_name(provider));
@@ -1369,8 +1439,9 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *pdev = to_pci_dev(provider->owner);
-	struct pci_dev *client;
 	struct pci_p2pdma *p2pdma;
+	unsigned long cache_index;
+	struct pci_dev *client;
 	int dist;
 
 	if (!pdev->p2pdma)
@@ -1380,13 +1451,14 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
 	client = to_pci_dev(dev);
+	cache_index = map_types_idx(client);
 
 	rcu_read_lock();
 	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
 		type = xa_to_value(xa_load(&p2pdma->map_types,
-					   map_types_idx(client)));
+					   cache_index));
 	rcu_read_unlock();
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)

-- 
2.55.0

