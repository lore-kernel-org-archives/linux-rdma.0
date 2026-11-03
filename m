Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694671;
	b=BeVQiDjVjlPudZBJN+RMs3Cb44HhmyA7bR8q7Li1IE8vq1BC2hKAZY1HUXjezs0ynvay
	 GZQ4FbmJEX4ESiGQSJv0flA9g+ND2LdvllilVgnsP3a/khHqcxXxwsMTVf0n7HY+n7XAa
	 WrAW5s4nxaxdgxlGbMS8LX4S6NlL7ixe7pL1RRFeMcNz0Z+Wahax7QZyECwhY9Afi8m1E
	 0bE8xUtWz9Cl2lGmfIy+mIDcuiVGIB/9W9KVTd+zDmWtmZm9okV7XHywd/nwQC9+zVOrR
	 4B5nScGqgIH1+CRPvogJkl/DuALB5jDg9oxmI74W/ubwlT+Ev9OCaoWRy0ucAauvvUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=wXnkAnSkUB8TU0mCqEFR7BMJkIEXE+o6O4ozAYMG584=;
	b=HtQwMWr0hvAzGMp1yoJqkLiSlzX2Ebklvx9seW/HV4kCE+AMtcDP6ncmLoon0wen1PAe
	 DJt4HSysfAeNyA9z1CniZfJWloqf5JIp9x7CAizMvb2BNAhwBW8ADKJUIBMKfzgFbzWjh
	 eGemSAlM2FlxSZirYVw5vXpW58J9ECemACBl3TFJOIzyees119dnf6EyV5vhHiqOuyrHU
	 ouAGE3vWokjPHu4FnahZcEbwSN8wFYfvZnfBThFDTIjPXbni8xW36GwVwZN5ZOs239Rec
	 5mu5dfvoEHdxkZGlJwbW62wfqE2ZrDE292XKgEy3wOcDSux0f6DysCD6n2Xoud/aefw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGIS9tEj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581F606A975;
	Tue,  3 Nov 2026 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGIS9tEj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F631F000C1;
	Tue,  3 Nov 2026 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694671;
	bh=wXnkAnSkUB8TU0mCqEFR7BMJkIEXE+o6O4ozAYMG584=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGIS9tEjNU8j5P24esA/Gk9o0DsShHtWsm+AkwecP5QD6LPP1v27fQPRIU3HJa1Q9
	 BPuaICsHQlXm8N8h/Z8yNdQLkLMLSQNM0D+usAqjWeTcQKVyjY/m85nvzIyVA32fRB
	 6FE2lP/ld9taIYmV2NpUsXoi0vcOvX0obXIEQEtocv/ZlasybyPp1iZ4Le+bvoszcO
	 c6YJqQGK/GLbzzyezFe9Ckrotkco9VWSjrk2k8f9pHRabeRDax2pjH2K/4LhpjK9Ck
	 4c9ttE7vBdN+FbjHVBkEXTPvv4hdYPmBRMd8VHlbGmDhtOy3dxX2BiYDALpjC1HP5a
	 EZ1u/5AMQ0ktg==
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
Subject: [PATCH v12 19/19] PCI/P2PDMA: Test the routing of clients with ATS enabled
Date: Tue,  3 Nov 2026 10:29:58 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-19-912101f93517@nvidia.com>
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

A client that enables ATS for the whole device must never be handed a
bus address, and Translation Blocking must reject its peer-to-peer
traffic even when the caller asks for the default class. That has to
hold for answers taken from the cache as well.

Cover those on the fabricated fabric, together with a client that
declared per-mapping ATS keeping the per-class answers and a client
without ATS answering for the Untranslated Requests it will issue.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       |   8 +--
 drivers/pci/pci.h          |   6 +++
 drivers/pci/pci_acs_test.c | 123 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index a81cd37a1834..df664d43c502 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1448,14 +1448,15 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 }
 EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
 
-static unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
-						unsigned int tlp_flags)
+VISIBLE_IF_KUNIT unsigned int
+pci_p2pdma_client_tlp_flags(struct pci_dev *client, unsigned int tlp_flags)
 {
 	if (client->ats_enabled)
 		return tlp_flags | PCI_P2PDMA_TLP_TRANSLATED;
 
 	return tlp_flags & ~PCI_P2PDMA_TLP_TRANSLATED;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_p2pdma_client_tlp_flags);
 
 /*
  * A client that translates every address it is handed cannot be handed a bus
@@ -1467,7 +1468,7 @@ static unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
  * Take the Address Type from @tlp_flags rather than reading the ATS Enable
  * bit again, so the policy and the class it applies to always agree.
  */
-static enum pci_p2pdma_map_type
+VISIBLE_IF_KUNIT enum pci_p2pdma_map_type
 pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
 			   bool per_mapping, unsigned int tlp_flags,
 			   enum pci_p2pdma_map_type type)
@@ -1486,6 +1487,7 @@ pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
 
 	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_p2pdma_client_map_type);
 
 /* Whether the driver of @client called pcim_p2pdma_set_ats_per_mapping(). */
 static bool pci_p2pdma_client_per_mapping(struct pci_dev *client)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 8c38817c967e..49a487e8a989 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1148,6 +1148,12 @@ enum pci_p2pdma_map_type calc_map_type_and_dist(struct pci_dev *provider,
 						int *dist,
 						unsigned int tlp_flags,
 						bool verbose);
+unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
+					 unsigned int tlp_flags);
+enum pci_p2pdma_map_type
+pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
+			   bool per_mapping, unsigned int tlp_flags,
+			   enum pci_p2pdma_map_type type);
 #endif
 
 #ifdef CONFIG_PCI_QUIRKS
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
index 369444d2a04a..11c86949c3d1 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -1050,6 +1050,125 @@ static void acs_walk_unreadable_control_test(struct kunit *test)
 			PCI_P2PDMA_MAP_NOT_SUPPORTED);
 }
 
+/*
+ * Route the way pci_p2pdma_map_type_tlp() does once it has a client: the
+ * client decides which flags apply, and the answer is then checked against
+ * what the client can be handed.
+ */
+static enum pci_p2pdma_map_type acs_client_map(struct acs_fabric *f,
+					       bool per_mapping,
+					       unsigned int tlp_flags)
+{
+	enum pci_p2pdma_map_type type;
+	int dist;
+
+	if (!per_mapping)
+		tlp_flags = pci_p2pdma_client_tlp_flags(f->client, tlp_flags);
+	type = calc_map_type_and_dist(f->provider, f->client, &dist, tlp_flags,
+				      false);
+	return pci_p2pdma_client_map_type(f->provider, f->client, per_mapping,
+					  tlp_flags, type);
+}
+
+/*
+ * A client with ATS enabled for the whole device translates whatever it is
+ * handed, so it never gets bus addresses even on a direct route, and
+ * Translation Blocking rejects it even when its caller asks for the default
+ * class.
+ */
+static void acs_client_ats_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.client->ats_enabled = 1;
+
+	KUNIT_EXPECT_EQ(test, acs_client_map(&f, false, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	KUNIT_EXPECT_EQ(test, acs_client_map(&f, false, 0),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+/*
+ * The cache holds what the topology allows, filled when the client first
+ * asked. A client whose ATS was enabled after that must still be kept off the
+ * bus addresses the cache recorded.
+ */
+static void acs_client_ats_cached_test(struct kunit *test)
+{
+	enum pci_p2pdma_map_type type[PCI_P2PDMA_TLP_CLASSES], hit;
+	struct acs_fabric f = {};
+	unsigned long cached;
+	unsigned int flags;
+	int dist;
+
+	acs_build_fabric(test, &f);
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		type[flags] = calc_map_type_and_dist(f.provider, f.client,
+						     &dist, flags, false);
+	cached = pci_p2pdma_map_types_pack(type);
+
+	f.client->ats_enabled = 1;
+	flags = pci_p2pdma_client_tlp_flags(f.client, 0);
+	hit = pci_p2pdma_map_types_unpack(cached, flags);
+
+	KUNIT_EXPECT_EQ(test,
+			pci_p2pdma_client_map_type(f.provider, f.client, false,
+						   flags, hit),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+/*
+ * A client that declared per-mapping ATS picks the Address Type per mapping,
+ * so it keeps the per-class answers even with ATS enabled.
+ */
+static void acs_client_ats_per_mapping_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.client->ats_enabled = 1;
+
+	KUNIT_EXPECT_EQ(test, acs_client_map(&f, true, 0),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+	KUNIT_EXPECT_EQ(test,
+			acs_client_map(&f, true, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	KUNIT_EXPECT_EQ(test, acs_client_map(&f, true, 0),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+	KUNIT_EXPECT_EQ(test,
+			acs_client_map(&f, true, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+/*
+ * A client with ATS disabled cannot issue Translated Requests, so a caller
+ * asking about them gets the answer for the Untranslated ones it will issue.
+ */
+static void acs_client_no_ats_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_RR | PCI_ACS_DT;
+	f.dn1_cfg.ctrl = PCI_ACS_RR | PCI_ACS_DT;
+
+	KUNIT_EXPECT_EQ(test,
+			acs_client_map(&f, false, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
 static struct kunit_case pci_acs_test_cases[] = {
 	KUNIT_CASE_PARAM(pci_acs_p2pdma_request_test,
 			 acs_request_gen_params),
@@ -1088,6 +1207,10 @@ static struct kunit_case pci_acs_test_cases[] = {
 	KUNIT_CASE(acs_walk_tb_above_divergence_test),
 	KUNIT_CASE(acs_walk_unreadable_control_test),
 	KUNIT_CASE(acs_map_types_pack_test),
+	KUNIT_CASE(acs_client_ats_test),
+	KUNIT_CASE(acs_client_ats_cached_test),
+	KUNIT_CASE(acs_client_ats_per_mapping_test),
+	KUNIT_CASE(acs_client_no_ats_test),
 	{}
 };
 

-- 
2.56.0

