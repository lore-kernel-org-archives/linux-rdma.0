Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EACA4ABBD0;
	Mon, 12 Oct 2026 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810560; cv=none; b=ngyOq6uVOSuhnR4Kv0Hezyi8MqtSQCp8IU0O2XvPZAUsRg5HObQprzln03yCqtHArPz33bXF2zaIeyYlxbcFb8sre6BNYoCxm0EhU9i7RHgndf1up5LT1QzdYd8JbjJ+C6Dg9hCJqpHbhNtSWF6VdrGi22k81zADPXjU/caEVv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810560; c=relaxed/simple;
	bh=f0HBW+3bS35Lhqm2afogYDGV9hYQQMdHZAdr1LJ5NpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyjvWqTq2ABNLNcrUsLFzcAbEeoyZiR+s/4hzfZyqiZ+a3Gl3tfCgS2l3UelCzRaBHmZOoCOlRfP2SdbBr+hPD+l9t20/nJJvrcl9Cw9o6hP0isxvjnhGUB78K2s18u5BwwhoxEoN5pnCLedAEknN4VM/2SyTHkzfZa/4SRhA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6zfMWMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6zfMWMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9258E1F0089D;
	Mon, 12 Oct 2026 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810559;
	bh=+jKubj65uWHyHuhINmm8dX2L5FXFqCsatavlO4ZKmv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6zfMWMdNdHOHkTQiXHRVg7jsoJXweWa7R4P95wOfh7A8fr0X+hHRC7CqpX/5kNtt
	 tNNRfmNPnmMPM4F8y9SwKioOmH08XeC7wd4NxXcTBTNSs6q/yVaCSgIJaLbIkMQ5z7
	 m79JK//BHacnYSsYuV9HCyOfBitsI8t1CxfAq/0/+ujk1WCDBnvVwYf7BlXDT8r+Nw
	 waT/1NSV+u6c8ema/VO0o8Xoz4TkrEA+2c0xMirBbRcoJ8rWEj8P+FuCik0WnVFsXc
	 T2B9MJHenYdRYJSjxQbta5OefQJi0cHQYF+smKife7ViI8m/JxcbI+5okOTeGo9NA3
	 342xebs6t40tg==
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
Subject: [PATCH v10 17/18] PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
Date: Mon, 12 Oct 2026 16:07:54 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-17-6ffe7b7a4517@nvidia.com>
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

P2PDMA assumes every client issues Untranslated Requests. A device with
ATS enabled may translate any address it is handed, including a bus
address, and Translation Blocking can reject its Translated Requests on
a route the Untranslated answer called usable.

Unless the client declared per-mapping ATS, take the Address Type from
its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
survives translation, and whatever it issues untranslated goes through
the host bridge, whose route must therefore be usable. Apply this after
the cache, which keeps holding answers that depend only on the topology.

Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/driver-api/pci/p2pdma.rst |  8 +++++
 drivers/pci/p2pdma.c                    | 53 +++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 52725e58f656..72ef2df3340a 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -46,6 +46,14 @@ P2PDMA therefore decides each class of traffic separately, and
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
index e38081f79761..a5fc622e3114 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1602,6 +1602,41 @@ void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
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
@@ -1616,6 +1651,11 @@ EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
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
@@ -1627,6 +1667,7 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	struct pci_p2pdma *p2pdma;
 	struct pci_dev *client;
 	bool provider_state;
+	bool per_mapping;
 	int dist;
 
 	if (!pdev->p2pdma) {
@@ -1646,6 +1687,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	cache_index = map_types_idx(client);
 
 	rcu_read_lock();
+	/* The declaration belongs to the client, the cache to the provider. */
+	p2pdma = rcu_dereference(client->p2pdma);
+	per_mapping = p2pdma && p2pdma->ats_per_mapping;
 	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
@@ -1653,6 +1697,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 					     cache_index));
 	provider_state = !!p2pdma;
 	rcu_read_unlock();
+	if (!per_mapping)
+		tlp_flags = pci_p2pdma_client_tlp_flags(client, tlp_flags);
 	type = pci_p2pdma_map_types_unpack(cached, tlp_flags);
 	pci_dbg(client,
 		 "P2PDMA ACS: map lookup provider=%s index=%#lx tlp-flags=%#x cached=%s(%d) provider-state=%u\n",
@@ -1660,10 +1706,10 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 		 pci_p2pdma_map_type_name(type), type, provider_state);
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
+		type = calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
 					      true);
 
-	return type;
+	return pci_p2pdma_client_map_type(pdev, client, per_mapping, type);
 }
 
 /**
@@ -1672,7 +1718,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
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
2.55.0

