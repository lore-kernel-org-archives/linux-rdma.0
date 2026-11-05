Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873171;
	b=gNMaePjJt1msXL4hLoga87WX6ix5FT+PWZpl0IVoFZKacmCLGDhUZqXWMI3J5+8bRzEU
	 PtWNiuPJH0HRvUvjrPY00vHfh4bHRfpw8Yp5WBcEzKQzrLq2yixQ+i3PNtHX+TX0qmXHL
	 yoZTY1qWY52qYpiw4sb+/A+RjBdFYBsD66O+eDfnj+pVIFOTwW5YklKSkYFEJHvolkCSY
	 GUHUrhMFnYKXjmFjFXki+Sgh8zYr9MDOSbhHyyb1PomF/DOXd0/Rue/dzTZ4r0ZS5tiaH
	 x2kNsgKty6lb+HbBdEruI5Iu3qfHgYb4wObPqZXWEodyKSvZ9z3ZMjrcIS0fYzepyEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=JHroYZpv0z6ORbM1EgYK4wFNCYo8RcXq1AFGff7bz0g=;
	b=xTD8d0r2RafHsrMUSseIYL8iSXoK4dhvnj+vwyZqVtFpq198fql/mFROMQ3b7TVHkcmH
	 RSv77WjEn4N31rGlw5xa33m3aimdDbHGT3DzoTdwBqYMOHz5jAlKoHVciCGhXLNH3vM5v
	 x8Pz+Z5HilxN0QWarWlLBVis87RcmHdmP6BnLNRazjWGKDubDU7QXr8t+sIjyuJAC5CX7
	 ZFzlUX5roJYPdBUtfL29RuAh00TKcQ2l6SIyqj+Z/fvx9lOjjglKruvMF6e7EoU15Q0oR
	 DmILm/BhWnsKTOKRJW6Y6CP3FNdv79/tcNnPwxo0cZYzeL6ulcTnTelhUO0SWevc9oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kz+jQlsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1696D606D824;
	Thu,  5 Nov 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kz+jQlsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0A11F00A18;
	Thu,  5 Nov 2026 10:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873170;
	bh=JHroYZpv0z6ORbM1EgYK4wFNCYo8RcXq1AFGff7bz0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kz+jQlsWt3cWbol/mr2YjfRcaEcorfhdFrWjpBGhfRiGLnmWA8hknc564T4IuMpD4
	 HeFZ23/U5jCM1lWa1K7Py2BK1peeZEAhM+4N8UNjig0Pvz0R948AOPZI/LXy0RJNlu
	 8YjUEqXLPJv7Wzd+CP6XQjGnVHfOHgmMXrR5dP0kd6exiroH2BluEv4UZ/MGucb/Yr
	 Atdw7cfftyPOKgaN6wt5v3BH0vuU5WiVlmJa3rMCOqsdg8CyLDkbayrjHUiWv23nQQ
	 V7zx8Bkrd6s1MuC2ppXyrCzU3Ej7DIynOHFWM9o4Z1SZY5u2dzafzFleLCWPZWmnJI
	 +D5lyj5E1xiFA==
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
Subject: [PATCH v13 07/19] PCI/P2PDMA: Collect the path's ACS controls before deciding
Date: Thu,  5 Nov 2026 12:04:38 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-7-3dd065907c3b@nvidia.com>
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

calc_map_type_and_dist() combines ACS reads, routing decisions and
diagnostics. Adding decisions for different TLP attributes would duplicate
the walk or thread each attribute through its counters.

Collect the divergence controls, internal-route restrictions and upstream
forwarding state in struct pci_p2pdma_acs_path, then decide each direction
from it. Check shared forwarding ports only when a host route is needed,
and keep forwarding read failures separate so they do not suppress
redirect advice.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 210 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 142 insertions(+), 68 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index abc26749eb5c6..7cf585c80d51d 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -705,6 +705,119 @@ static void pci_p2pdma_warn_redir(struct pci_dev *client,
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
+ * @uf_unreadable: Shared port whose forwarding control could not be read.
+ */
+struct pci_p2pdma_acs_path {
+	u16 req_ctrl;
+	u16 cpl_ctrl;
+	bool req_upstream;
+	bool cpl_upstream;
+	struct pci_dev *unreadable;
+	struct pci_dev *uf_blocked;
+	struct pci_dev *uf_unreadable;
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
+	if (path->uf_blocked || path->uf_unreadable)
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
+	if (path->uf_unreadable) {
+		pci_warn(client,
+			 "ACS Control is unreadable for provider %s at %s\n",
+			 pci_name(provider), pci_name(path->uf_unreadable));
+	} else if (path->uf_blocked) {
+		pci_warn(client,
+			 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
+			 pci_name(provider), pci_name(path->uf_blocked));
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
+	if (seq_buf_used(&acs_list) || seq_buf_used(&quirk_list))
+		pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
+}
+
 static bool cpu_supports_p2pdma(void)
 {
 #ifdef CONFIG_X86
@@ -911,23 +1024,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, bool verbose)
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
-	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
 	struct pci_dev *a = provider, *b = client, *bb;
 	struct pci_dev *a_child = NULL, *b_child = NULL;
-	struct pci_dev *acs_unreadable = NULL;
-	struct pci_dev *uf_blocked = NULL;
-	struct pci_dev *uf_unreadable = NULL;
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
@@ -970,35 +1073,20 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
 		}
 	}
@@ -1007,45 +1095,29 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * Below a shared upstream bridge, a path whose divergence ports do not
 	 * redirect routes the request directly.
 	 */
-	if (!acs_unreadable && !acs_redirect_cnt &&
-	    !req_upstream && !cpl_upstream) {
-		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
-		goto done;
+	map_type = pci_p2pdma_route(&path);
+	if (map_type == PCI_P2PDMA_MAP_THRU_HOST_BRIDGE) {
+		path.uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a,
+							      &path.uf_unreadable);
+		map_type = pci_p2pdma_route(&path);
 	}
+	if (map_type == PCI_P2PDMA_MAP_BUS_ADDR)
+		goto done;
 
-	if (!acs_unreadable)
-		uf_blocked = pci_acs_p2pdma_no_upstream_forwarding(a,
-							      &uf_unreadable);
-
-	if (verbose) {
-		if (acs_unreadable)
-			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
-				 pci_name(provider), pci_name(acs_unreadable));
-		else if (uf_unreadable)
-			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
-				 pci_name(provider), pci_name(uf_unreadable));
-		else if (uf_blocked)
-			pci_warn(client,
-				 "cannot forward peer-to-peer DMA for provider %s upstream at %s\n",
-				 pci_name(provider), pci_name(uf_blocked));
-		if (!acs_unreadable && (req_upstream || cpl_upstream))
-			pci_warn(client,
-				 "peer-to-peer DMA with provider %s requires the host bridge; no internal route between functions\n",
-				 pci_name(provider));
-		else if (!acs_unreadable && acs_redirect_cnt)
-			pci_p2pdma_warn_redir(client, provider, &acs_list,
-					      &quirk_list);
-	}
+	if (verbose)
+		pci_p2pdma_warn_path(client, provider, &path, a_child, b_child);
 
 	/* An unreadable control or unusable forwarding leaves no route. */
-	if (acs_unreadable || uf_blocked || uf_unreadable) {
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
@@ -1379,8 +1451,9 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *pdev = to_pci_dev(provider->owner);
-	struct pci_dev *client;
 	struct pci_p2pdma *p2pdma;
+	unsigned long cache_index;
+	struct pci_dev *client;
 	int dist;
 
 	if (!pdev->p2pdma)
@@ -1390,13 +1463,14 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
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
2.56.0

