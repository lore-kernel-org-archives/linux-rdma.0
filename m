Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873214;
	b=Gqzo3P9Ec4azs7CtZn0UiwsepDFfcZFcLIw9i14+FP+M/2DR5F2uvEIOpj3L3zyt3mVz
	 8yBE7hC20emXOImpJtBZCRK2LwOYv+g2ncYmdHBtPoBuYValrewrwowPu+EU9KmVfKeAt
	 hHJeHurLHC4KwaiHpHabuiMlQL6ox2voP1B2J1k0dRokdutTI8pkCFo/pofkKbSXChgt/
	 PR+UD4+R0OPSu8L1wNHxoGly2bQ3slyqkn4YslbPLPXTgr0AHZnUO8oTela0PTUVKuK/P
	 R5SEv4+uEMNTGvawxV9UmwJJuV6k0LL/gNNVJzNpEh0f+7bH7zPhj3e3op1JSiAWUfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=9BGHeEqsZBNWD7BKZDY0/4hwsn2XtiJTrpSYVG/bHg8=;
	b=k87HCu8X1m0R/mrEJk8CYO3W/ZqGYLROK+Qyc4L5bwi+fIioPZ83iQoZ/A6oVrQN9rPO
	 qjtcMDEu3B6OsKX+RlKVLfzdjfBEziUx7ImeJo5tj6jpQShgeO2chFLT8M3EGzrjIgOFz
	 ScPjBeU6h+8EJ1J3aywodYjvH3jZfr/cLkqwVSr5ZNSKI4ISe/sJTco4fJViBGwAuCDKr
	 1MS8kC/p+o4qU3JpeTTf56VFigxQY8WpaDbtpsl62LMYiaOqCmUbKjTA73PfZ1xcMSDeV
	 vVo0/S7S0aycRugauLRoNfRZCEu9gnYnMjXOLVBxrGLJegyzbr/GCuUtEt86ZLVgbhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rnu5vY9X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D878C606B8DA;
	Thu,  5 Nov 2026 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rnu5vY9X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93571F00A1C;
	Thu,  5 Nov 2026 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873213;
	bh=9BGHeEqsZBNWD7BKZDY0/4hwsn2XtiJTrpSYVG/bHg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rnu5vY9XrXaTVjmyGzhUzRbJglj9Yi9qg61UDGhF2YQTCtejcbDmZv0xdTYl/IVYw
	 B8JEk9FZFft6FsLFFjETvCR62qRqlsJQle4T7E/T8JgrAavraVkkBN43ZMj3PSfn43
	 8No1vzlSxiAwUnq4paR/zatj2J58DxOAzLNHScPiZY7ql7FYo6GjU7cVNV7XKRNPdN
	 GNIHn1CKWtQsFUb9INiJsfCRTOVMxJuvWLLULzub34QoPHCouaEJm/AKbZaNOoIo+x
	 J7N7OrIbUFgQH7Do1dF2BqS6Z78FC6APzY3VC4ydxpU+xp+I33sRTUP1a52eKXqofu
	 +ePGAtcbdpqDA==
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
Subject: [PATCH v13 18/19] PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
Date: Thu,  5 Nov 2026 12:04:49 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-18-3dd065907c3b@nvidia.com>
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

P2PDMA assumes every client issues Untranslated Requests. A device with
ATS enabled may translate any address it is handed, including a bus
address, and Translation Blocking can reject its Translated Requests on
a route the Untranslated answer called usable.

Unless the client declared per-mapping ATS, take the Address Type from
its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
survives translation, and whatever it issues untranslated goes through
the host bridge, whose route must therefore be usable. Apply this after
the topology-only cache, and in pci_p2pdma_distance_many() too, so that
provider selection agrees with the mapping.

Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst |  8 +++
 drivers/pci/p2pdma.c                    | 92 ++++++++++++++++++++++++++++++---
 2 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index ff7f619616e8e..7760ff64ed05b 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -63,6 +63,14 @@ P2PDMA therefore decides each class of traffic separately, and
 ``pci_p2pdma_map_type()`` answers for the one a DMA mapping is built for:
 strictly ordered Requests carrying an Untranslated address.
 
+The PCIe ATS Enable bit covers the whole device, and most devices translate
+any address they are handed once it is set. Unless a driver has declared with
+``pcim_p2pdma_set_ats_per_mapping()`` that its device chooses ATS per mapping,
+that bit decides which Address Type P2PDMA assumes, and a client with ATS
+enabled is never handed a bus address, which it would translate as though it
+were an IOVA. Its Translated Requests may still route directly, but anything
+it issues untranslated reaches the host bridge, so that route has to work too.
+
 The two directions are decided independently. Translation Blocking (TB),
 Direct Translated P2P (DT), Request Redirect (RR) and Egress Control (EC) on
 the Requester-side port decide the Request:
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index df66aa056dec8..e81b9070bb4ef 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1467,6 +1467,59 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 }
 EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
 
+static unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
+						unsigned int tlp_flags)
+{
+	if (client->ats_enabled)
+		return tlp_flags | PCI_P2PDMA_TLP_TRANSLATED;
+
+	return tlp_flags & ~PCI_P2PDMA_TLP_TRANSLATED;
+}
+
+/*
+ * A client that translates every address it is handed cannot be handed a bus
+ * address, which it would translate as though it were an IOVA. Its Translated
+ * Requests may still route directly, but a Request it issues without a
+ * translation carries the IOVA to the host bridge, so that route has to work
+ * as well.
+ *
+ * Take the Address Type from @tlp_flags rather than reading the ATS Enable
+ * bit again, so the policy and the class it applies to always agree.
+ */
+static enum pci_p2pdma_map_type
+pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
+			   bool per_mapping, unsigned int tlp_flags,
+			   enum pci_p2pdma_map_type type)
+{
+	if (per_mapping || !(tlp_flags & PCI_P2PDMA_TLP_TRANSLATED) ||
+	    type != PCI_P2PDMA_MAP_BUS_ADDR)
+		return type;
+
+	pci_dbg(client,
+		"P2PDMA ACS: provider=%s bus address withheld; ATS is enabled for the whole client\n",
+		 pci_name(provider));
+
+	if (cpu_supports_p2pdma() ||
+	    host_bridge_whitelist(provider, client, false))
+		return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
+
+	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
+}
+
+/* Whether the driver of @client called pcim_p2pdma_set_ats_per_mapping(). */
+static bool pci_p2pdma_client_per_mapping(struct pci_dev *client)
+{
+	struct pci_p2pdma *p2pdma;
+	bool per_mapping;
+
+	rcu_read_lock();
+	p2pdma = rcu_dereference(client->p2pdma);
+	per_mapping = p2pdma && p2pdma->ats_per_mapping;
+	rcu_read_unlock();
+
+	return per_mapping;
+}
+
 /**
  * pci_p2pdma_distance_many - Determine the cumulative distance between
  *	a p2pdma provider and the clients in use.
@@ -1482,15 +1535,19 @@ EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
  *
  * "compatible" means the provider and the clients are either all behind
  * the same PCI root port or the host bridges connected to each of the devices
- * are listed in the 'pci_p2pdma_whitelist'.
+ * are listed in the 'pci_p2pdma_whitelist'. Each client is judged the way
+ * pci_p2pdma_map_type() maps it, so one with ATS enabled for the whole device
+ * also needs a host bridge that supports peer-to-peer DMA.
  */
 int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			     int num_clients, bool verbose)
 {
-	enum pci_p2pdma_map_type map;
+	enum pci_p2pdma_map_type map, type;
 	bool not_supported = false;
 	struct pci_dev *pci_client;
+	unsigned int tlp_flags;
 	int total_dist = 0;
+	bool per_mapping;
 	int i, distance;
 
 	if (num_clients == 0)
@@ -1505,8 +1562,18 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			return -1;
 		}
 
-		map = calc_map_type_and_dist(provider, pci_client, &distance, 0,
-					     verbose);
+		per_mapping = pci_p2pdma_client_per_mapping(pci_client);
+		tlp_flags = per_mapping ? 0 :
+			    pci_p2pdma_client_tlp_flags(pci_client, 0);
+		type = calc_map_type_and_dist(provider, pci_client, &distance,
+					      tlp_flags, verbose);
+		map = pci_p2pdma_client_map_type(provider, pci_client,
+						 per_mapping, tlp_flags, type);
+		if (verbose && map != type &&
+		    map == PCI_P2PDMA_MAP_NOT_SUPPORTED)
+			pci_warn(pci_client,
+				 "cannot be used for peer-to-peer DMA with %s: ATS is enabled for the whole device and the host bridge is not whitelisted\n",
+				 pci_name(provider));
 
 		pci_dev_put(pci_client);
 
@@ -1813,6 +1880,11 @@ EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
  * ACS routes a peer-to-peer transaction by the attributes its TLPs carry, so
  * the answer depends on @tlp_flags. A caller that passes flags its traffic
  * does not match gets a mapping the fabric will not deliver.
+ *
+ * Only a client whose driver called pcim_p2pdma_set_ats_per_mapping() takes
+ * the Address Type from @tlp_flags. For any other client its ATS Enable bit
+ * decides, and a client that translates every address it is handed never gets
+ * %PCI_P2PDMA_MAP_BUS_ADDR.
  */
 static enum pci_p2pdma_map_type
 pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
@@ -1824,6 +1896,7 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	struct pci_p2pdma *p2pdma;
 	struct pci_dev *client;
 	bool provider_state;
+	bool per_mapping;
 	int dist;
 
 	if (!pdev->p2pdma) {
@@ -1841,6 +1914,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 
 	client = to_pci_dev(dev);
 	cache_index = map_types_idx(client);
+	per_mapping = pci_p2pdma_client_per_mapping(client);
+	if (!per_mapping)
+		tlp_flags = pci_p2pdma_client_tlp_flags(client, tlp_flags);
 
 	rcu_read_lock();
 	p2pdma = rcu_dereference(pdev->p2pdma);
@@ -1857,10 +1933,11 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 		 pci_p2pdma_map_type_name(type), type, provider_state);
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
+		type = calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
 					      true);
 
-	return type;
+	return pci_p2pdma_client_map_type(pdev, client, per_mapping, tlp_flags,
+					  type);
 }
 
 /**
@@ -1869,7 +1946,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
  * @dev: Client device that initiates the transfer
  *
  * Same as pci_p2pdma_map_type_tlp() for a client issuing strictly ordered
- * Requests that carry an Untranslated address.
+ * Requests. Their Address Type is Untranslated unless the client enables ATS
+ * for the whole device.
  */
 enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
 					     struct device *dev)

-- 
2.56.0

