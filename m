Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C44B4B1D0A;
	Mon, 28 Sep 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594458; cv=none; b=qIYQefu5REXHGvPfDvOGAOUrD288FVoObiwadlJT/Fa/CcO7cgfLHqNye8dMnDkXoMd4BjZYZkA6jEPQ0uUNcoYwnazLdeG9S/GtTOdSpC0GyLPSedkBlPqIIB5N+J/vTCXUJquKgHmNXn3mnR+TPF90L8p8BwUikZxeVFWAn8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594458; c=relaxed/simple;
	bh=94/6lDrR08Gl1Jyc1Ge2RiRrh6W2hLjkzbv9UupqQEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSHimC5DNCrN/8fgne8MOW5ibFcZQNWlSutrwCjChxTYxOpduwX/mKDPTU3W2gjRWmVS1aMj75oDTPgtkgoXrT6O/JYdU0wVe0tlFZGu0si9yBaVHfZaxQHuRn1eoT1oBBeBXTv4qUjmN6BMK8g/h08FqRPvsKvWrYj/e3Pxh1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1dfTC29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1dfTC29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E98F1F000FF;
	Mon, 28 Sep 2026 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594456;
	bh=7soDfBPqqfvr89StAnu/erguwTkeZ0vwie+s/Fk8P/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1dfTC29lL94Lvjs9Ec6yquEXWZxoA4SP0OVHHGvlQFh8SnzhpaJQINjWFGNyNU3/
	 P3+LTe6FItKm4o2otU/VGTYoDIw6ZtHG0Nj7IYfQrdqIT5sazLor6o8Op7zL0lcnPa
	 K7ReNXDhtJBd1Cz7pnEhzYznFCAY8oHRRdtEFFc3tgcdwmYLg0EQV2pm8G0S2EMIwz
	 Dmsm27Yqy1il8mpNd0L/6YaUc/SbGBfeV+pJ4CRcPXdiMiz1cTi++8oG1fh9/NkVJ6
	 p5oK8t9TVYvNuKt0WnGYcAxO0zDNmkYqER3xmS6CEjE3E806PEj9KQQRhCOUUBPk9L
	 1ThZlE92cES9g==
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
Subject: [PATCH v8 22/23] PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
Date: Mon, 28 Sep 2026 14:19:26 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-22-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
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

P2PDMA assumes every client issues Untranslated Requests. A device with
ATS enabled may translate any address it is handed, including a bus
address, and Translation Blocking can reject its Translated Requests on
a route the Untranslated answer called usable.

Unless the client declared per-mapping ATS, take the Address Type from
its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
survives translation, and whatever it issues untranslated goes through
the host bridge, whose route must therefore be usable. Apply this after
the cache, which keeps holding answers that depend only on the topology.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst |  8 ++++++
 drivers/pci/p2pdma.c                    | 50 +++++++++++++++++++++++++++++++--
 include/linux/pci-p2pdma.h              |  3 +-
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 7a7f29f455b0..bf9f96c07b58 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -40,6 +40,14 @@ A client therefore describes its traffic with ``enum pci_p2pdma_tlp_flags``
 and asks ``pci_p2pdma_map_type_tlp()``. ``pci_p2pdma_map_type()`` answers for
 the default: strictly ordered Requests carrying an Untranslated address.
 
+The PCIe ATS Enable bit covers the whole device, and most devices translate
+any address they are handed once it is set. Unless a driver has declared with
+``pcim_p2pdma_set_ats_per_mapping()`` that its device chooses ATS per mapping,
+that bit rather than the flags decides the Address Type, and a client with ATS
+enabled is never handed a bus address, which it would translate as though it
+were an IOVA. Its Translated Requests may still route directly, but anything
+it issues untranslated reaches the host bridge, so that route has to work too.
+
 The two directions are decided independently. Translation Blocking (TB),
 Direct Translated P2P (DT), Request Redirect (RR) and Egress Control (EC) on
 the client-side port decide the Request:
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index ae676509f9f3..ca79af2e64c7 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1595,6 +1595,41 @@ void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
 
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
+ */
+static enum pci_p2pdma_map_type
+pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
+			   bool per_mapping, enum pci_p2pdma_map_type type)
+{
+	if (per_mapping || !client->ats_enabled ||
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
 /**
  * pci_p2pdma_map_type_tlp - Determine the mapping type for P2PDMA transfers
  * @provider: P2PDMA provider structure
@@ -1609,6 +1644,11 @@ EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
  * ACS routes a peer-to-peer transaction by the attributes its TLPs carry, so
  * the answer depends on @tlp_flags. A caller that passes flags its traffic
  * does not match gets a mapping the fabric will not deliver.
+ *
+ * Only a client whose driver called pcim_p2pdma_set_ats_per_mapping() takes
+ * the Address Type from @tlp_flags. For any other client its ATS Enable bit
+ * decides, and a client that translates every address it is handed never gets
+ * %PCI_P2PDMA_MAP_BUS_ADDR.
  */
 enum pci_p2pdma_map_type
 pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
@@ -1620,6 +1660,7 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	struct pci_p2pdma *p2pdma;
 	struct pci_dev *client;
 	bool provider_state;
+	bool per_mapping;
 	int dist;
 
 	if (!pdev->p2pdma) {
@@ -1639,6 +1680,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	cache_index = map_types_idx(client);
 
 	rcu_read_lock();
+	/* The declaration belongs to the client, the cache to the provider. */
+	p2pdma = rcu_dereference(client->p2pdma);
+	per_mapping = p2pdma && p2pdma->ats_per_mapping;
 	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
@@ -1646,6 +1690,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 					     cache_index));
 	provider_state = !!p2pdma;
 	rcu_read_unlock();
+	if (!per_mapping)
+		tlp_flags = pci_p2pdma_client_tlp_flags(client, tlp_flags);
 	type = pci_p2pdma_map_types_unpack(cached, tlp_flags);
 	pci_dbg(client,
 		 "P2PDMA ACS: map lookup provider=%s index=%#lx tlp-flags=%#x cached=%s(%d) provider-state=%u\n",
@@ -1653,10 +1699,10 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 		 pci_p2pdma_map_type_name(type), type, provider_state);
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
+		type = calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
 					      true);
 
-	return type;
+	return pci_p2pdma_client_map_type(pdev, client, per_mapping, type);
 }
 
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 543a09426a11..8d96659df9df 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -207,7 +207,8 @@ static inline struct pci_dev *pci_p2pmem_find(struct device *client)
  * @dev: Client device that initiates the transfer
  *
  * Same as pci_p2pdma_map_type_tlp() for a client issuing strictly ordered
- * Requests that carry an Untranslated address.
+ * Requests. Their Address Type is Untranslated unless the client enables ATS
+ * for the whole device.
  */
 static inline enum pci_p2pdma_map_type
 pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)

-- 
2.55.0

