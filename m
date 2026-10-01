Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB1D494800;
	Thu,  1 Oct 2026 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855775; cv=none; b=iVT8BEHQQQv37qKH8G25qM2HxsNjoCT3cOR2dlFqkgctGRil19mkXLRkwL4S/MooviN2UpTd4fvZiudPLJYA3zQQkPSr3UYnYaBq/JQpNn330OEwmLPSSmvx3ZoaUCAff+46ORqPTgzGiKq+bczY1oC5C2LaIC1vAOOJ/WHncmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855775; c=relaxed/simple;
	bh=ZsWYleWQ6hkg4Owp6AosSFOPhBZs5Wi+sBxZwI1uFjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hb9kEk97ysOR2eoVqBn363ydwkcrpJQJ622QKw7wFSoWYM0pb2o1I3YrCe/mSmNhMs2Fz/9r+m+96hJAcrwG50lK1uskc0+SDTzqGlnU0/VNeiXZCm4+JaIEC6S/bT/1fD3Ipx7/GTJdfZYWLss+8Ihg0nThB9kyOVsqpz8L/98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMjcECNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMjcECNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04141F000FF;
	Thu,  1 Oct 2026 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855763;
	bh=Lq+2xAOYG5VWAVn4vxD89MmHuob7HzQqke1/L4svC9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMjcECNYY6kZNMllazAB2MIgtVCdMcc6KYKrTcTv7eF12HOBPeqAb1WXhXqUyjjQf
	 i7TrUxQVVP+BOPqDUirpSJmehvO2o71Z/NR/Rc2CpQOIlwkAO+a4qoarKK9XW72K5d
	 E5Hr3jEYIhr/UUAkJI1sqL5eXby8MBF1mhtoOYA448ULCQ06GGRrggYokYNDawUNcP
	 wvSGiBUJnzJblgoDTELJf3SoPhtrPTwThFDcNuQGnjRVqPAHbJwZJOvfumtCZ/FXAz
	 uFODy7WG/mQyX+p83FWj2sx6d5gorv3nI+j0cA0PobToTajlbrQYbzq2OhGhFnc/hC
	 19jhPkK4aKaFA==
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
Subject: [PATCH v9 07/18] PCI/P2PDMA: Answer routing per TLP class
Date: Thu,  1 Oct 2026 14:55:15 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-7-1a8e0f50ddd9@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
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

calc_map_type_and_dist() returns one mapping type per provider and client,
valid only for strictly ordered Requests carrying an Untranslated address.
Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
do with their traffic.

Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp()
to ask about one. The topology walk and the ACS Control reads do not depend
on the class, so decide all of them from the one walk and cache them
together, four bits each. Every class still answers alike; the controls
that tell them apart come next.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c | 159 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 128 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 841c86be31bb..43e225cc5735 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -492,6 +492,33 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
 	return NULL;
 }
 
+/**
+ * enum pci_p2pdma_tlp_flags - Properties of the TLPs a client will issue
+ *
+ * These describe the traffic rather than the topology, and select which ACS
+ * controls apply along the peer-to-peer path. A value of 0 means strictly
+ * ordered Requests carrying an Untranslated address.
+ *
+ * @PCI_P2PDMA_TLP_TRANSLATED: Requests carry an ATS Translated address. PCIe
+ *	r7.0 sec 6.12.3 routes those to the peer regardless of ACS P2P Request
+ *	Redirect and ACS P2P Egress Control wherever ACS Direct Translated P2P
+ *	is enabled.
+ * @PCI_P2PDMA_TLP_RELAXED_CPL: The provider returns Completions with the
+ *	Relaxed Ordering attribute set. PCIe r7.0 sec 6.12.1.1 never redirects
+ *	those, so ACS P2P Completion Redirect does not gate the path. The
+ *	Completer chooses this attribute and the specification does not require
+ *	it to copy Relaxed Ordering from the Request into the Completion, so a
+ *	caller passing this flag asserts that its provider does.
+ */
+enum pci_p2pdma_tlp_flags {
+	PCI_P2PDMA_TLP_TRANSLATED	= 1 << 0,
+	PCI_P2PDMA_TLP_RELAXED_CPL	= 1 << 1,
+};
+
+/* Every combination of the flags above selects one routing class. */
+#define PCI_P2PDMA_TLP_CLASSES \
+	((PCI_P2PDMA_TLP_TRANSLATED | PCI_P2PDMA_TLP_RELAXED_CPL) + 1)
+
 enum pci_acs_p2pdma_state {
 	PCI_ACS_P2PDMA_NOT_SUPPORTED,
 	PCI_ACS_P2PDMA_DIRECT,
@@ -508,7 +535,7 @@ enum pci_acs_p2pdma_state {
  * bus addressing be assumed.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_request(u16 ctrl)
+pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
@@ -520,7 +547,7 @@ pci_acs_p2pdma_request(u16 ctrl)
  * affects a Completion.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_completion(u16 ctrl)
+pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
@@ -577,13 +604,16 @@ struct pci_p2pdma_acs_path {
  * the peer's bus addresses.
  */
 static enum pci_p2pdma_map_type
-pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
+pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
+		 unsigned int tlp_flags)
 {
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_acs_p2pdma_request(path->req_ctrl) == PCI_ACS_P2PDMA_DIRECT &&
-	    pci_acs_p2pdma_completion(path->cpl_ctrl) == PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_request(path->req_ctrl, tlp_flags) ==
+		    PCI_ACS_P2PDMA_DIRECT &&
+	    pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags) ==
+		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
 
 	return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
@@ -591,7 +621,9 @@ pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
 
 /*
  * Name the ports that keep this path off a direct route, so that the admin
- * can hand them to pci=disable_acs_redir=.
+ * can hand them to pci=disable_acs_redir=. That parameter clears the
+ * redirect controls, which decide the default class, so that is the class
+ * this reports on.
  */
 static void pci_p2pdma_warn_path(struct pci_dev *client,
 				 struct pci_dev *provider,
@@ -610,9 +642,10 @@ static void pci_p2pdma_warn_path(struct pci_dev *client,
 	}
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
-	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_completion(path->cpl_ctrl, 0) !=
+	    PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, a_child);
-	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_request(path->req_ctrl, 0) != PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, b_child);
 
 	/* Drop the final semicolon; the list is not empty here. */
@@ -780,6 +813,31 @@ static unsigned long map_types_idx(struct pci_dev *client)
 	return (pci_domain_nr(client->bus) << 16) | pci_dev_id(client);
 }
 
+/*
+ * One cache entry holds the routing of every TLP class, four bits each,
+ * indexed by the &enum pci_p2pdma_tlp_flags combination that selects it. An
+ * absent entry reads back as PCI_P2PDMA_MAP_UNKNOWN in every class.
+ */
+static_assert(PCI_P2PDMA_MAP_THRU_HOST_BRIDGE < 16);
+
+static unsigned long
+pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type)
+{
+	unsigned long val = 0;
+	unsigned int flags;
+
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		val |= (unsigned long)type[flags] << (flags * 4);
+
+	return val;
+}
+
+static enum pci_p2pdma_map_type
+pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
+{
+	return (val >> (tlp_flags * 4)) & 0xf;
+}
+
 /*
  * Calculate the P2PDMA mapping type and distance between two PCI devices.
  *
@@ -809,6 +867,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * check Request Redirect and Egress Control on the client-side port, and
  * Completion Redirect for read Completions on the provider-side port.
  *
+ * Those controls apply to different TLPs, so every class named by &enum
+ * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
+ * @tlp_flags selects which one is returned.
+ *
  * If ACS redirects traffic at either divergence port, return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
  * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
@@ -822,14 +884,16 @@ static unsigned long map_types_idx(struct pci_dev *client)
  */
 static enum pci_p2pdma_map_type
 calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
-		int *dist, bool verbose)
+		int *dist, unsigned int tlp_flags, bool verbose)
 {
-	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+	enum pci_p2pdma_map_type map_type[PCI_P2PDMA_TLP_CLASSES];
 	struct pci_dev *a = provider, *b = client, *bb;
 	struct pci_dev *a_child = NULL, *b_child = NULL;
 	struct pci_p2pdma_acs_path path = {};
 	struct pci_p2pdma *p2pdma;
 	bool cpu_p2pdma, host_whitelisted = false;
+	bool host_fallback = false;
+	unsigned int flags;
 	int dist_a = 0;
 	int dist_b = 0;
 
@@ -863,6 +927,8 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		map_type[flags] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	goto map_through_host_bridge;
 
 check_paths_acs:
@@ -882,18 +948,24 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 
 	/*
-	 * Below a shared upstream bridge, a path whose divergence ports do not
-	 * redirect routes the request directly.
+	 * The walk and the config reads above serve every class; only the
+	 * decision below depends on the kind of TLP being routed.
 	 */
-	map_type = pci_p2pdma_route(&path);
-	if (map_type == PCI_P2PDMA_MAP_BUS_ADDR)
-		goto done;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++) {
+		map_type[flags] = pci_p2pdma_route(&path, flags);
+		if (map_type[flags] == PCI_P2PDMA_MAP_THRU_HOST_BRIDGE)
+			host_fallback = true;
+	}
 
-	if (verbose)
-		pci_p2pdma_warn_path(client, provider, &path, a_child, b_child);
+	if (verbose && map_type[0] != PCI_P2PDMA_MAP_BUS_ADDR)
+		pci_p2pdma_warn_path(client, provider, &path, a_child,
+				     b_child);
 
-	/* An unreadable control does not establish an upstream redirect. */
-	if (path.unreadable)
+	/*
+	 * Nothing needs the host bridge: the classes that did not get a direct
+	 * route have no fallback that would use it.
+	 */
+	if (!host_fallback)
 		goto done;
 
 map_through_host_bridge:
@@ -906,16 +978,19 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		if (verbose)
 			pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider (%s) do not share an upstream bridge or whitelisted host bridge\n",
 				 pci_name(provider));
-		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+		for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+			if (map_type[flags] == PCI_P2PDMA_MAP_THRU_HOST_BRIDGE)
+				map_type[flags] = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	}
 done:
 	rcu_read_lock();
 	p2pdma = rcu_dereference(provider->p2pdma);
 	if (p2pdma)
 		xa_store(&p2pdma->map_types, map_types_idx(client),
-			 xa_mk_value(map_type), GFP_ATOMIC);
+			 xa_mk_value(pci_p2pdma_map_types_pack(map_type)),
+			 GFP_ATOMIC);
 	rcu_read_unlock();
-	return map_type;
+	return map_type[tlp_flags];
 }
 
 /**
@@ -956,7 +1031,7 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			return -1;
 		}
 
-		map = calc_map_type_and_dist(provider, pci_client, &distance,
+		map = calc_map_type_and_dist(provider, pci_client, &distance, 0,
 					     verbose);
 
 		pci_dev_put(pci_client);
@@ -1221,22 +1296,28 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
 /**
- * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
+ * pci_p2pdma_map_type_tlp - Determine the mapping type for P2PDMA transfers
  * @provider: P2PDMA provider structure
  * @dev: Client device that initiates the transfer
+ * @tlp_flags: &enum pci_p2pdma_tlp_flags describing the TLPs @dev will issue
  *
  * Determines how peer-to-peer DMA transfers should be mapped between
  * the provider and the client device. The mapping type indicates whether
  * the transfer can be done directly through PCI switches or must go
  * through the host bridge.
+ *
+ * ACS routes a peer-to-peer transaction by the attributes its TLPs carry, so
+ * the answer depends on @tlp_flags. A caller that passes flags its traffic
+ * does not match gets a mapping the fabric will not deliver.
  */
-enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
-					     struct device *dev)
+static enum pci_p2pdma_map_type
+pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
+			unsigned int tlp_flags)
 {
-	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	struct pci_dev *pdev = to_pci_dev(provider->owner);
+	unsigned long cache_index, cached = 0;
+	enum pci_p2pdma_map_type type;
 	struct pci_p2pdma *p2pdma;
-	unsigned long cache_index;
 	struct pci_dev *client;
 	int dist;
 
@@ -1253,16 +1334,32 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
-		type = xa_to_value(xa_load(&p2pdma->map_types,
-					   cache_index));
+		cached = xa_to_value(xa_load(&p2pdma->map_types,
+					     cache_index));
 	rcu_read_unlock();
+	type = pci_p2pdma_map_types_unpack(cached, tlp_flags);
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(pdev, client, &dist, true);
+		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
+					      true);
 
 	return type;
 }
 
+/**
+ * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
+ * @provider: P2PDMA provider structure
+ * @dev: Client device that initiates the transfer
+ *
+ * Same as pci_p2pdma_map_type_tlp() for a client issuing strictly ordered
+ * Requests that carry an Untranslated address.
+ */
+enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
+					     struct device *dev)
+{
+	return pci_p2pdma_map_type_tlp(provider, dev, 0);
+}
+
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
 {

-- 
2.55.0

