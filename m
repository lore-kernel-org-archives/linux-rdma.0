Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694649;
	b=V3Ib1/bGCEIhY0EGu4ic6V6SekztzHplCjowZzfzdF2DdamtPL8XnXMMUjfSVvQScE5c
	 +b85HzhYrS7BxIKH+hd+xhh4ku3uvGe8uG7ad2lD5qIUWTmSuZsAovIO03fe66rEOLePr
	 VnvbHpwJ3wStVvfQlh7OgsxGMghYpP4u7hpvVmyfgVsHQcMufBf3tAxMXwvsLXfVZjTPH
	 2rQWwyR1EEMSlO7M7/NaIyboRoxOOUPQqzlSLRoRpdeigStQZEsEWi0+C9eb+jNLsk92y
	 5GMcm73AfMMdZnvHy/w9MEP2vSa1OanlgJ1lCgTTeFIiiNl065aop6zxsMUkENWkWmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=zou+KVsm2n9nqlMfRGiAQzjZcxVzPW1ERt8vMIU0ka0=;
	b=FmPW02nWFqrrcTXaSJ9lJ0nG16xvPiXj5mu5j95rd7xzvwoGHaEvAavOqDrGCGjoPcXE
	 iVr3J0hn9pFnlMZRlCDeIReT2iD7v9WpickRxOjStsYf5t2WJddrGTJJHKLmOhce2q6ja
	 vtaLJ/BLVPcXpD82A76IFcrN6MKM7TEKnyBu1pMPMBu55YVyR8vkhX3Zz8sUiunlqyc4v
	 +Zcc7uGay5UkZvVLaqbIa9AIs5TLloDMTRkvkl+TFxXv40QT1/ImzZYTVFRgyvMII8yOl
	 fZf4Ol0slVba+eNmkew0mXT6w5A5vH6KcC2TYHSIYGL4qu8GFjyfCp4YUc4cZdMNn3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLHimlxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B0B606D838;
	Tue,  3 Nov 2026 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLHimlxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450251F00A1B;
	Tue,  3 Nov 2026 08:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694649;
	bh=zou+KVsm2n9nqlMfRGiAQzjZcxVzPW1ERt8vMIU0ka0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLHimlxCefo/k2EjvP9GldR2G+4iyoRNoluNqhtvtS5SVhTYC0+zwp3Vn9NSc8nUC
	 bArX/UP+xVzwRva+W7VBtBKT4JK7kvO+gOfEVoFVpPhzUdsVDo04W2f0YVsPUHLM0J
	 YkPUIu5ZlOcuw0LOVZF+g2409Fv2ruuZAaEzNAHcEjafcG9pWZXja4J37adWHSRq1n
	 KsjxCbV/EIYhrgc4UUxn6jS6gssB+z4oVgEfUNnKWSjYxqNFTo7uu6JTfo0AZtuWGe
	 ZlD8IA0mKHJ5+AEGTSwr9k2BeOQfMnI8rCJ+f36TVlHCY2GNS5V9BVnnvw92f4p4qb
	 VppiWTvDWOhOQ==
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
Subject: [PATCH v12 08/19] PCI/P2PDMA: Answer routing per TLP class
Date: Tue,  3 Nov 2026 10:29:47 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-8-912101f93517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
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
 drivers/pci/p2pdma.c | 167 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 132 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index c643f275890c..9d416329aa4b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -530,6 +530,31 @@ static u16 pci_acs_p2pdma_quirk_redirect(struct pci_dev *pdev, u16 ctrl)
 	return ctrl;
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
+ * @PCI_P2PDMA_TLP_RELAXED_CPL: Non-Posted Requests carry the Relaxed
+ *	Ordering attribute, and PCIe r7.0 sec 2.2.9.1 requires the Completer to
+ *	return it in their Completions. Sec 6.12.1.1 never redirects those, so
+ *	ACS P2P Completion Redirect does not gate the path.
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
@@ -546,7 +571,7 @@ enum pci_acs_p2pdma_state {
  * bus addressing be assumed.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_request(u16 ctrl)
+pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
 		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
@@ -558,7 +583,7 @@ pci_acs_p2pdma_request(u16 ctrl)
  * affects a Completion.
  */
 static enum pci_acs_p2pdma_state
-pci_acs_p2pdma_completion(u16 ctrl)
+pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
 {
 	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
 				   PCI_ACS_P2PDMA_DIRECT;
@@ -727,21 +752,23 @@ struct pci_p2pdma_acs_path {
 };
 
 static enum pci_acs_p2pdma_state
-pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path)
+pci_p2pdma_request_state(const struct pci_p2pdma_acs_path *path,
+			 unsigned int tlp_flags)
 {
 	if (path->req_upstream)
 		return PCI_ACS_P2PDMA_REDIRECT;
 
-	return pci_acs_p2pdma_request(path->req_ctrl);
+	return pci_acs_p2pdma_request(path->req_ctrl, tlp_flags);
 }
 
 static enum pci_acs_p2pdma_state
-pci_p2pdma_completion_state(const struct pci_p2pdma_acs_path *path)
+pci_p2pdma_completion_state(const struct pci_p2pdma_acs_path *path,
+			    unsigned int tlp_flags)
 {
 	if (path->cpl_upstream)
 		return PCI_ACS_P2PDMA_REDIRECT;
 
-	return pci_acs_p2pdma_completion(path->cpl_ctrl);
+	return pci_acs_p2pdma_completion(path->cpl_ctrl, tlp_flags);
 }
 
 /*
@@ -750,13 +777,16 @@ pci_p2pdma_completion_state(const struct pci_p2pdma_acs_path *path)
  * the peer's bus addresses.
  */
 static enum pci_p2pdma_map_type
-pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
+pci_p2pdma_route(const struct pci_p2pdma_acs_path *path,
+		 unsigned int tlp_flags)
 {
 	if (path->unreadable)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
-	if (pci_p2pdma_request_state(path) == PCI_ACS_P2PDMA_DIRECT &&
-	    pci_p2pdma_completion_state(path) == PCI_ACS_P2PDMA_DIRECT)
+	if (pci_p2pdma_request_state(path, tlp_flags) ==
+		    PCI_ACS_P2PDMA_DIRECT &&
+	    pci_p2pdma_completion_state(path, tlp_flags) ==
+		    PCI_ACS_P2PDMA_DIRECT)
 		return PCI_P2PDMA_MAP_BUS_ADDR;
 
 	if (path->uf_blocked)
@@ -767,7 +797,9 @@ pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
 
 /*
  * Name the ports that keep this path off a direct route, so that the admin
- * can hand them to pci=disable_acs_redir=.
+ * can hand them to pci=disable_acs_redir=. That parameter clears the
+ * redirect controls, which decide the default class, so that is the class
+ * this reports on.
  */
 static void pci_p2pdma_warn_path(struct pci_dev *client,
 				 struct pci_dev *provider,
@@ -801,9 +833,10 @@ static void pci_p2pdma_warn_path(struct pci_dev *client,
 
 	seq_buf_init(&acs_list, buf, sizeof(buf));
 	seq_buf_init(&quirk_list, quirk_buf, sizeof(quirk_buf));
-	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_completion(path->cpl_ctrl, 0) !=
+	    PCI_ACS_P2PDMA_DIRECT)
 		pci_p2pdma_list_redir(&acs_list, &quirk_list, a_child);
-	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
+	if (pci_acs_p2pdma_request(path->req_ctrl, 0) != PCI_ACS_P2PDMA_DIRECT)
 		pci_p2pdma_list_redir(&acs_list, &quirk_list, b_child);
 
 	pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
@@ -968,6 +1001,31 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
@@ -999,6 +1057,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
  * port, and Completion Redirect for read Completions on the Completer-side
  * port.
  *
+ * Those controls apply to different TLPs, so every class named by &enum
+ * pci_p2pdma_tlp_flags is decided from the one walk and cached together;
+ * @tlp_flags selects which one is returned.
+ *
  * If ACS redirects traffic at either divergence port, return
  * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
  * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
@@ -1012,14 +1074,16 @@ static unsigned long map_types_idx(struct pci_dev *client)
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
 
@@ -1053,6 +1117,8 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	 * request can only get to the peer through the host bridge.
 	 */
 	*dist = dist_a + dist_b;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		map_type[flags] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	goto map_through_host_bridge;
 
 check_paths_acs:
@@ -1085,18 +1151,24 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
 
-	/* An unreadable control or unusable forwarding leaves no route. */
-	if (map_type == PCI_P2PDMA_MAP_NOT_SUPPORTED)
+	/*
+	 * Nothing needs the host bridge: the classes that did not get a direct
+	 * route have no fallback that would use it.
+	 */
+	if (!host_fallback)
 		goto done;
 
 map_through_host_bridge:
@@ -1109,16 +1181,19 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -1159,7 +1234,7 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			return -1;
 		}
 
-		map = calc_map_type_and_dist(provider, pci_client, &distance,
+		map = calc_map_type_and_dist(provider, pci_client, &distance, 0,
 					     verbose);
 
 		pci_dev_put(pci_client);
@@ -1425,22 +1500,28 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
 
@@ -1457,16 +1538,32 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
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
2.56.0

