Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694669;
	b=CQ52j8+e75EWESoyVLjxRq+p3k55uk+FtliKAeKDO2nCkdWUzAmTs1hyKOFHDNzi+Yad
	 QJ5z+ElN3GMvCYfD8M/Dtv9+coNQKdZqOF20SccsLAV4tHz9v3HutKXlHK8XTEhiIwTyX
	 HFzO1EVHCm9TRnoUV8HVbhQwzR1DXXDGnVk4EvtoMJcCVXJ3KRexCGirJBHk2IrEXLd2x
	 gJHx0F78F2tYbAHnmuJuCmqPWYq7XO7425O+34YbTe7dIspSM7a4XxlmWiLuAffXPqS3U
	 /lTIiqe4DnzGyukk8r1pKTaZLjTxIFMo2RleY70Rx+WeRsR2uOoJi9ERGzqENlR59og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=iXAsA4acO94QS42kh3VYh4FOfBVOAs2xWKCo/zdX/J4=;
	b=x8q1RL80Fz933JezgVHM77tRYzHlmPUbsAT1m065hLxlfzorsLo5BJpahaU/jRUl75Ff
	 dJ+oTIHx61kMXzWvcphVoeyJUwa9+gvf/3qf3Z0fWqVj/w4E+W2K28XlcIWftAmz9LJmn
	 Ja61+1NwRyc5XUeiXQNUhus2cvfLJ7hy/0/lE9lmEMQGJgHG2CQB3M9IXkodkCJu7eJtp
	 UUJPaXcHgZqVlEmtBbATWXoYxwTiG5cigFwsnYJnaCES/TRI60QwncXgqlpG7A9dgOzvk
	 HdrqksWkvjoG3JzUGzHcewxo7hWBAV2rWV1SAkor1XpozaVArSIg1Jp4LTgsdS96k1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AfJFTLxv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2120606A94B;
	Tue,  3 Nov 2026 08:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AfJFTLxv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC5C1F00A1A;
	Tue,  3 Nov 2026 08:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694668;
	bh=iXAsA4acO94QS42kh3VYh4FOfBVOAs2xWKCo/zdX/J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfJFTLxv6XhNPeP+XU/3K26Ttx5SBjOD0VWiWhdh2E3RF2CVpx6ZyEMFkZTSpl8IS
	 oHqoL2iIKv5Bjo39aHYJS7sOa9JPrAVz4rHP0yAs4gy8Z8RHKKrLBYq/j3AJrVMpsR
	 SK2klYssy3QMXxXUwQ4NuRdvVu5M2E17NgR1qPiCierIxmHRyq+FP0G7HMgpLk0frp
	 dNv3TTIGS4yFUYvsOFassbUl7FaWW9+fMtwjunxj9riq1eZWhj30aV/H1dat1d/mxK
	 N6N2UJpgKsFFOHIj91AY6ycQ8GU1vTxQcGq9w+HYJsz5w8yYHkSrYSLoADodnHptuh
	 BrzUohD/WNbsw==
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
Subject: [PATCH v12 18/19] PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
Date: Tue,  3 Nov 2026 10:29:57 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-18-912101f93517@nvidia.com>
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
index 05f896a0814b..c004b6dc028f 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -62,6 +62,14 @@ P2PDMA therefore decides each class of traffic separately, and
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
index 144314ab5fae..a81cd37a1834 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1448,6 +1448,59 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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
@@ -1463,15 +1516,19 @@ EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
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
@@ -1486,8 +1543,18 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
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
 
@@ -1794,6 +1861,11 @@ EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
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
@@ -1805,6 +1877,7 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 	struct pci_p2pdma *p2pdma;
 	struct pci_dev *client;
 	bool provider_state;
+	bool per_mapping;
 	int dist;
 
 	if (!pdev->p2pdma) {
@@ -1822,6 +1895,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
 
 	client = to_pci_dev(dev);
 	cache_index = map_types_idx(client);
+	per_mapping = pci_p2pdma_client_per_mapping(client);
+	if (!per_mapping)
+		tlp_flags = pci_p2pdma_client_tlp_flags(client, tlp_flags);
 
 	rcu_read_lock();
 	p2pdma = rcu_dereference(pdev->p2pdma);
@@ -1838,10 +1914,11 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
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
@@ -1850,7 +1927,8 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
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

