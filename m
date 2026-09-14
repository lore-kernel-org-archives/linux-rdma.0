Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44724443C39;
	Mon, 14 Sep 2026 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385001; cv=none; b=HqoYVnh1Ikki9ARPy7VhbrqHpO300FPjntuK5G+jmJ8ZMURrS2AfapyJdz/RTBRJg1rHlDy5SQxCP2nzt0iLrD4dXg/y2NcUBQLA7BisKOPuMjK/+kM6sM5FroPPCcqG57rM1Dq9omgk9XQ5RSOY37f7e7KFDqLLAhWdgHmRbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385001; c=relaxed/simple;
	bh=J3hnBZTraVcqUV0dnkw2YKaSom0sgsYElIGHb5wOQOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTaCJW7Ri3bR5w9c+YiYqyBVm6om6vZUWr/EylzC3iYDHRABIv5Ai3wTtyKq9A89bJrb2cEwVJAB96/5mU7pyS4uzrWmrPJk6hEX+E1TZDcJ7bTwgbCLvah03npD9rVjWpzeZAZFXXcYtIdoO8KbkK1sOy0JJNM7P9e6KcSSbV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPfnrpYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPfnrpYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4044F1F000FF;
	Mon, 14 Sep 2026 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384999;
	bh=ARRhQFUHv0KrZ0GZtzk706qAcJDNAlE6Cjev/pw1Dbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPfnrpYequ+3XasChfCJAsXfzKg4LCYnWpbGEgmANc5y+sIPIo4MVuKnFn61tPdIK
	 qRT1H7Ao20u8s4xZ/d9lexzpE9IkekVPSZwhPRSasD/N82D2d5dZK9qRT2paQg5Dg3
	 Md853zT4EA2+I991e93fbOaHyoin1p81wtCNBrAj8YUNhx+Z21qyZvd34zXji8+yAY
	 IupVB/GYQQgOCVASiwbzkAxpTZoF0DFwmx4qCHwMB6tTy88OaHN2BaoWd/+CI7lMG6
	 qlkpJMWe6OQg7XIBAwR3NOMyOak0o6ZokZrsAJcgYc1/doY2bJW/P5DBKV3DwHQnJs
	 Q/0kIfF4iq9bw==
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
Subject: [PATCH v6 08/18] PCI/P2PDMA: Answer routing per TLP class
Date: Mon, 14 Sep 2026 14:22:41 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-8-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 121 +++++++++++++++++++++++++++++++++------------
 include/linux/pci-p2pdma.h |  49 ++++++++++++++++--
 2 files changed, 136 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 3a14abf5fe84..fac765d0a16f 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -531,7 +531,7 @@ enum pci_acs_p2pdma_state {
  * bus addressing be assumed.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_request(u16 ctrl)
+pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
@@ -543,7 +543,7 @@ pci_acs_p2pdma_request(u16 ctrl)
  * affects a Completion.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_completion(u16 ctrl)
+pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
@@ -600,13 +600,16 @@ struct pci_p2pdma_acs_path {
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
@@ -620,7 +623,8 @@ static void pci_p2pdma_warn_path(struct pci_dev *client,
 				 struct pci_dev *provider,
 				 const struct pci_p2pdma_acs_path *path,
 				 struct pci_dev *a_child,
-				 struct pci_dev *b_child)
+				 struct pci_dev *b_child,
+				 unsigned int tlp_flags)
 {
 	struct seq_buf acs_list;
 	char buf[128];
@@ -633,9 +637,11 @@ static void pci_p2pdma_warn_path(struct pci_dev *client,
 	}
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
-	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags) !=
+	    PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, a_child);
-	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_request(path->req_ctrl, tlp_flags) !=
+	    PCI_ACS_P2PDMA_DIRECT)
 		seq_buf_print_bus_devfn(&acs_list, b_child);
 
 	/* Drop the final semicolon; the list is not empty here. */
@@ -803,6 +809,31 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
@@ -832,6 +863,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
@@ -845,14 +880,16 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
 
@@ -886,6 +923,8 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		map_type[flags] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	goto map_through_host_bridge;
 
 check_paths_acs:
@@ -905,18 +944,24 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
+				     b_child, 0);
 
-	/* An unreadable control does not establish an upstream redirect. */
-	if (path.unreadable)
+	/*
+	 * Nothing needs the host bridge: the classes that did not get a direct
+	 * route have no fallback that would use it.
+	 */
+	if (!host_fallback)
 		goto done;
 
 map_through_host_bridge:
@@ -929,16 +974,19 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -979,7 +1027,7 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			return -1;
 		}
 
-		map = calc_map_type_and_dist(provider, pci_client, &distance,
+		map = calc_map_type_and_dist(provider, pci_client, &distance, 0,
 					     verbose);
 
 		pci_dev_put(pci_client);
@@ -1244,25 +1292,34 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
+enum pci_p2pdma_map_type
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
 
+	if (WARN_ON_ONCE(tlp_flags >= PCI_P2PDMA_TLP_CLASSES))
+		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
 	if (!pdev->p2pdma)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
@@ -1276,12 +1333,14 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
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
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index dd17501ba1b6..36045b1b730c 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -28,6 +28,33 @@ struct p2pdma_provider {
 	u64 bus_offset;
 };
 
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
 enum pci_p2pdma_map_type {
 	/*
 	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
@@ -86,8 +113,9 @@ int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
 			       bool use_p2pdma);
-enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
-					     struct device *dev);
+enum pci_p2pdma_map_type
+pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
+			unsigned int tlp_flags);
 #else /* CONFIG_PCI_P2PDMA */
 static inline int pcim_p2pdma_init(struct pci_dev *pdev)
 {
@@ -150,7 +178,8 @@ static inline ssize_t pci_p2pdma_enable_show(char *page,
 	return sprintf(page, "none\n");
 }
 static inline enum pci_p2pdma_map_type
-pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
+			unsigned int tlp_flags)
 {
 	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 }
@@ -168,6 +197,20 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
 	return pci_p2pmem_find_many(&client, 1);
 }
 
+/**
+ * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
+ * @provider: P2PDMA provider structure
+ * @dev: Client device that initiates the transfer
+ *
+ * Same as pci_p2pdma_map_type_tlp() for a client issuing strictly ordered
+ * Requests that carry an Untranslated address.
+ */
+static inline enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
+{
+	return pci_p2pdma_map_type_tlp(provider, dev, 0);
+}
+
 struct pci_p2pdma_map_state {
 	struct p2pdma_provider *mem;
 	enum pci_p2pdma_map_type map;

-- 
2.55.0

