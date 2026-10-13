Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA91F5172D9;
	Tue, 13 Oct 2026 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901604; cv=none; b=rTQxnxc43Aun0RgyErl6Xu8bCPEJDA1qykwkuX7k6nGl3X6gzRP/0Dy1i8Jr/hwJw2FjYXOtlxKZt3FJyeKINrX8TaiLveosgTyrWVc5k2R87OWufQ7+QdM8LwfIk9KH1GnRfptnW/DtMyw93o8udLDJAQL6XlrRZo9fsm2KJZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901604; c=relaxed/simple;
	bh=z5qgsyfwEppvMh+L8jAPZNd/f5fLcIIC/ZbeSVdfHfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQRuml6gGHz2V3BSAu2+qn/ygmpmS9byVNexTyfnmqMLHKNfegpz54Bo1Fkxo3P6Bl+0m5aLqR77FCDZXp3xnEIb7PT6Ij/wUrBdDaa0dIo1rGhog+JT3spzUTLDW4P12SLJniuRrMfY9e9XNtqfeRcWdSsjjzfLj5Jju+P/s28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAALQ1RV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAALQ1RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC701F000FF;
	Tue, 13 Oct 2026 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901602;
	bh=lXnbDQMIe65nig4QUpHjAIbQDXx7h0WMsGKBGXtMSEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAALQ1RVKKu5maDZbCWOW8DbI8mAIWVZH/j9mTMLBMc87yx1VnCxUrhSIWLRgfK94
	 VHhuuCXBbicY8oZikShEmq4eww5aNmNnaasQEktDbvMNEdvCKHhq4Vq2qWXSDvIbbf
	 Yb65CNlmsPcYYK1kDYyfyCi+zbpW1geECRpHJR29I/UGWSq9AVXKjD91lFak7Argvt
	 8gXDJvXHk0+cRX+qyK1GoqdHbjsjn6xr+ImTnBjyldJjxoPc7J20OmeSe/Kz6Vd2MD
	 FZ08rKAfBtSrqc+zoeahxl0WOhTllsanViB5/e3GUlsrOlmAshuhyvOrfVSqXwIsqi
	 X6p8gfGrOTsjg==
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
Subject: [PATCH v11 18/19] PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
Date: Tue, 13 Oct 2026 17:25:26 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-18-72cf8c96e617@nvidia.com>
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
2.55.0

