Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FA94C150C;
	Thu,  1 Oct 2026 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855822; cv=none; b=rdaN1VeRDQl7btq50/o5nlXMBaBEs66zHITQZmk0dpg/3wDYuggHMPPqhD5yZ1inFpp+YwIY0IsouBNgJZ8Y4ecnW7RHhbh0UIvDSYIb21hmWX2O4pWjTGSebi5YyPpJpLUWjdhZj8lLrpHjC5o7qBMyB6YufCV+u0Nk+Qtl/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855822; c=relaxed/simple;
	bh=qMFDGWO8T8rFnlZH5zEdWBCmQ3eAYnLT2YaeHu0sank=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XQZzQUdegnkM5CvRQTmWwhVPA7NUlVBSI15JIiBHSNjQAtdo12nmgQt8w+/nYaGJItCY3I4mYNY4PyRv6LJ9Bohr2gtSL296L3Ct0tXiTKlC5Cb6OjxRz2KE2rnTqd3LA5+mhxPpZxyG3x6kC3xYt7A+eMjYoi+bgZntUHspk1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnX/q5ZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnX/q5ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6631F00899;
	Thu,  1 Oct 2026 11:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855816;
	bh=b8xMLV7p9JhteAfTAaXYXGWAPPpzeBoIObqNjYHNZZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnX/q5ZGh9QvoKViirbZ+0zoCYxQCU+qGhCAeUJMpcagryn+sDJAnarzkPMf6klND
	 fw2oxioFH3OspfgLXlsNrqSPhEv/28440YQT1iM/XZJD1BGZ2OW4JfuwgYjsBFGAQC
	 n5qNwrPFqG8Hq5Eamz3XDh2hnRqkdb7Lyce917X6CQUyGn/foj5YIX2CjbWznsIuqb
	 Qicl+1f7WYFxwI9V9IrAB7d9Xazllb1otM2X3UCzVSvYGDHqtmJfb1PAM8Zontty0e
	 /wLhGtBmaFrt4Q8KGKXOwavjBWGTlYfKOGJM/QJvhBack0KE6VMIWmNCy1+3wVpBIf
	 GAnVID1Z9H5fg==
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
Subject: [PATCH v9 18/18] PCI/P2PDMA: Test the routing of clients with ATS enabled
Date: Thu,  1 Oct 2026 14:55:26 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-18-1a8e0f50ddd9@nvidia.com>
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
 drivers/pci/pci.h          |   5 ++
 drivers/pci/pci_acs_test.c | 123 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 9d17a3d2bf1f..38c712d77f15 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1595,14 +1595,15 @@ void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
 
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
@@ -1611,7 +1612,7 @@ static unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
  * translation carries the IOVA to the host bridge, so that route has to work
  * as well.
  */
-static enum pci_p2pdma_map_type
+VISIBLE_IF_KUNIT enum pci_p2pdma_map_type
 pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
 			   bool per_mapping, enum pci_p2pdma_map_type type)
 {
@@ -1629,6 +1630,7 @@ pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
 
 	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_p2pdma_client_map_type);
 
 /**
  * pci_p2pdma_map_type_tlp - Determine the mapping type for P2PDMA transfers
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a4a07f31f744..8b10965ab536 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1144,6 +1144,11 @@ enum pci_p2pdma_map_type calc_map_type_and_dist(struct pci_dev *provider,
 						int *dist,
 						unsigned int tlp_flags,
 						bool verbose);
+unsigned int pci_p2pdma_client_tlp_flags(struct pci_dev *client,
+					 unsigned int tlp_flags);
+enum pci_p2pdma_map_type
+pci_p2pdma_client_map_type(struct pci_dev *provider, struct pci_dev *client,
+			   bool per_mapping, enum pci_p2pdma_map_type type);
 #endif
 
 #ifdef CONFIG_PCI_QUIRKS
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
index 6a2cd38d968f..a9a3b80ea0ac 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -698,6 +698,125 @@ static void acs_walk_unreadable_control_test(struct kunit *test)
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
+					  type);
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
+						   hit),
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
@@ -723,6 +842,10 @@ static struct kunit_case pci_acs_test_cases[] = {
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
2.55.0

