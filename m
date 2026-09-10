Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C44749C9;
	Thu, 10 Sep 2026 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039963; cv=none; b=tzXm1Aui78n+zaMb1LnUNs91Fk2XwaCCaXebE1Kb2qMnYuITHnhQpj+716NK4repbLhiDhvJP3gjn6QKdNu15j+0AGUJuWjmXt5JMDgk4j6bj/RtZUM2rs3zLQl7pMDWml/Gn2Earx4qJHS/00hw7HFXmYW62FmcSWOsunxjHJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039963; c=relaxed/simple;
	bh=Uv5KHKoiHDpKGepAN/SRZp2YwTtspNNmDJBxWTGTYuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qowE1p7M/UW8WtpF0Fo754OR1BSkBGHXeMLLOZ0m4G+nETzRusAXpxYYE8q3NlF2aH1AKqB1d6ax9cUW+ULyUvQ5P2YRmqooRPxkX6J02h6sm9uuRNhj3ICnE3Z9MJ5Je4U4CLNd5fzuvrJPl0XA8d66+lp625SZkj7oJlH13ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA7evxfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA7evxfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82FD1F00899;
	Thu, 10 Sep 2026 11:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039960;
	bh=76WYju94Ls/jEg6VJCnypCSeojbnUYpLisq3GOhkJO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gA7evxfJNkAyc9tlZBtOk6Qyh/tlVAaI+ZFNKLG22NH8hwBFohC1vssuByg/qUYrQ
	 iXC1CocluuAWpeNDil5dizPm3lky45QSSuEUfA9BLlBm7mz1Xy5NmRtb4bgwg9R4Hq
	 nfs1uyRHbiipfdpQ1n6bS/SnId2BsegdWeNehWfD11QBAZeyJ0AJwqazM7nTU1urfj
	 UAdoFt7jHMPC2q0s5afSAZ67/GqmiolS1dsEG9412885smE+Y+apMqNo3s8h7auH6J
	 Mp1IEq0tun3dnxiDuy0Z1l0oqSH3/IgOlwSCOcuP7C7R7/R4NRq6SLxQ3RAH4dldJg
	 1DyPV1URoH9LA==
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
Subject: [PATCH v5 07/18] PCI/P2PDMA: Collect the path's ACS controls before deciding
Date: Thu, 10 Sep 2026 14:32:02 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-7-856087f63c0d@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
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

calc_map_type_and_dist() reads each divergence port's ACS Control register
and folds the result into running counters as it goes. Any routing property
that depends on the kind of TLP being routed would have to be threaded
through that code, so there is nowhere to put one without reading the
registers again for each kind.

Collect the two ports' ACS Control values into struct pci_p2pdma_acs_path
first, then decide from it. pci_p2pdma_route() applies the same rule as
before: a path routes directly only when both directions do.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 148 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 96 insertions(+), 52 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 43219a67aaf6..3a14abf5fe84 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -576,6 +576,80 @@ static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
 	seq_buf_printf(buf, "%s;", pci_name(pdev));
 }
 
+/*
+ * What the topology walk found out about one provider/client path. Producing
+ * this costs a walk and one config read per divergence port, none of which
+ * depends on the TLP being routed.
+ *
+ * @req_ctrl:	ACS Control of the client-side divergence port. That is the
+ *		first port at which a Request can route toward the peer rather
+ *		than upstream, so it is where the Request controls apply.
+ * @cpl_ctrl:	ACS Control of the provider-side divergence port, likewise for
+ *		the Completions travelling back.
+ * @unreadable:	First port whose ACS Control could not be read, if any.
+ */
+struct pci_p2pdma_acs_path {
+	u16 req_ctrl;
+	u16 cpl_ctrl;
+	struct pci_dev *unreadable;
+};
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
+	if (pci_acs_p2pdma_request(path->req_ctrl) == PCI_ACS_P2PDMA_DIRECT &&
+	    pci_acs_p2pdma_completion(path->cpl_ctrl) == PCI_ACS_P2PDMA_DIRECT)
+		return PCI_P2PDMA_MAP_BUS_ADDR;
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
+	struct seq_buf acs_list;
+	char buf[128];
+
+	if (path->unreadable) {
+		pci_warn(client,
+			 "ACS Control is unreadable for provider %s at %s\n",
+			 pci_name(provider), pci_name(path->unreadable));
+		return;
+	}
+
+	seq_buf_init(&acs_list, buf, sizeof(buf));
+	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+		seq_buf_print_bus_devfn(&acs_list, a_child);
+	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+		seq_buf_print_bus_devfn(&acs_list, b_child);
+
+	/* Drop the final semicolon; the list is not empty here. */
+	if (!seq_buf_has_overflowed(&acs_list))
+		acs_list.buffer[acs_list.len - 1] = '\0';
+
+	pci_warn(client,
+		 "ACS redirect is set between the client and provider (%s)\n",
+		 pci_name(provider));
+	pci_warn(client,
+		 "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
+		 seq_buf_str(&acs_list));
+}
+
 static bool cpu_supports_p2pdma(void)
 {
 #ifdef CONFIG_X86
@@ -774,19 +848,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, bool verbose)
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
-	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
 	struct pci_dev *a = provider, *b = client, *bb;
 	struct pci_dev *a_child = NULL, *b_child = NULL;
-	struct pci_dev *acs_unreadable = NULL;
+	struct pci_p2pdma_acs_path path = {};
 	struct pci_p2pdma *p2pdma;
-	struct seq_buf acs_list;
-	int acs_redirect_cnt = 0;
+	bool cpu_p2pdma, host_whitelisted = false;
 	int dist_a = 0;
 	int dist_b = 0;
-	char buf[128];
-	u16 ctrl;
-
-	seq_buf_init(&acs_list, buf, sizeof(buf));
 
 	/*
 	 * Note, we don't need to take references to devices returned by
@@ -829,61 +897,35 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * branch is upstream, so redirect controls do not affect the path.
 	 */
 	if (a_child && b_child) {
-		if (pci_acs_p2pdma_ctrl(a_child, &ctrl))
-			state = pci_acs_p2pdma_completion(ctrl);
-		if (state != PCI_ACS_P2PDMA_DIRECT) {
-			seq_buf_print_bus_devfn(&acs_list, a_child);
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
-			seq_buf_print_bus_devfn(&acs_list, b_child);
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
 	}
 
 	/*
 	 * Below a shared upstream bridge, a path whose divergence ports do not
 	 * redirect routes the request directly.
 	 */
-	if (!acs_unreadable && !acs_redirect_cnt) {
-		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
+	map_type = pci_p2pdma_route(&path);
+	if (map_type == PCI_P2PDMA_MAP_BUS_ADDR)
 		goto done;
-	}
 
-	if (verbose) {
-		/* Drop the final semicolon; the list is not empty here. */
-		if (!seq_buf_has_overflowed(&acs_list))
-			acs_list.buffer[acs_list.len - 1] = '\0';
-		if (acs_unreadable)
-			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
-				 pci_name(provider), pci_name(acs_unreadable));
-		else {
-			pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
-				 pci_name(provider));
-			pci_warn(client, "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
-				 seq_buf_str(&acs_list));
-		}
-	}
+	if (verbose)
+		pci_p2pdma_warn_path(client, provider, &path, a_child, b_child);
 
 	/* An unreadable control does not establish an upstream redirect. */
-	if (acs_unreadable) {
-		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+	if (path.unreadable)
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
@@ -1216,8 +1258,9 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *pdev = to_pci_dev(provider->owner);
-	struct pci_dev *client;
 	struct pci_p2pdma *p2pdma;
+	unsigned long cache_index;
+	struct pci_dev *client;
 	int dist;
 
 	if (!pdev->p2pdma)
@@ -1227,13 +1270,14 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
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

