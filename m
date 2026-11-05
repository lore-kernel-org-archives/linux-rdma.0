Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873210;
	b=AQCvv0qzcrhIm1bm5Zdc7Z8y/R+lsj2U+peYUxTKHpw/Qifyt/U00MFf66wGGiPZYK59
	 isVWlEJEzlcuiliyUap4umni+JYQr9rEcHQLLvJYkd8Q/jsJAAklLOXFZ/GoOU/Oiy88i
	 y2N58fvUhxguW9j1Xe1ataLFiz2+WR/liSB/5l16YPdSY0WiO4e7FlGOR5378nDFQjBY5
	 6OP/LR3DCujiu5mc/P9mT4h8dj9tBMcIA1a++GymefaUGbi0aEz7EOnFkjklIeQqiahvw
	 mbY7M6cR1ed/NW9m2GeHeOIvRjczZ4GgkMGrm9R1ccJJe8lgJ6IORvb4LrvFDE1/+dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=tM3Q0QpoJtOrTMy6TxwfMypLdCyXApEGJuNVmH6YXaQ=;
	b=B+v1w2T4TVTr01Tf9KFuYuUubETZXRANk4FyK5WuRmKflBlLw1wmHZkkJtiAC9WpO8yg
	 D6Vr/cvrBCE08tqTAfK/b4SDuWYUhp6fw3C0/LvjvfW0Bd18JwKXb37rL2SyyyzCyWuBR
	 SN1YNMGZQJGUGZasLXxWISjJSYuRGzlz+0Y+ewA7u1XvgXu/N5mbk47y6LSFxro62+ifu
	 VTbgxrVTp1jT7uuvEX1kYS5jWn/keGUWH92ie4+U6MB3G961eRKF81kZe8pSeHUOOCs46
	 P+ZBZVbA0YFHgSsZdA3QrMO2e/fhQMqr1vnV8Es+4L64vnhaBgMl9aFRJiyZm0AvTtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fX7c3CIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD8606EEB6;
	Thu,  5 Nov 2026 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fX7c3CIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3514B1F00919;
	Thu,  5 Nov 2026 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873210;
	bh=tM3Q0QpoJtOrTMy6TxwfMypLdCyXApEGJuNVmH6YXaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX7c3CIVQLv4i8A0BLIaP5NSVgX+fmY/JHF0hWy8sLB8fNldMp/p2Ng0nmIgJWeoP
	 U1fdbIRsUJlVXd4zxc//nuU+pd/dO0mmAg6kAsVHv7D2kQGp8McLf0hMzQfFDU1X/2
	 gYeRtlOzBr+Bb5D7LFFIa4fUpuMWVw0eL7io2ZpwEmPDpw9yEMAv2Ko/67YNk/BRvE
	 /t1u3PBMWeOqfgrqM5icvQJ5DNsSZCk/m/Sy64DCIC0Vwcn4Xkj663uKroLF/uBvSL
	 ebuXLn6gvgHIgc9nnrlDMfdv3VzZfZiipfdE2gYTP5pQmV7c0CZaIGDlntn8+5Klis
	 XenmERTj079AA==
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
Subject: [PATCH v13 15/19] PCI: Add KUnit coverage for ACS isolation checks
Date: Thu,  5 Nov 2026 12:04:46 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-15-3dd065907c3b@nvidia.com>
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

Direct Translated P2P does not weaken IOMMU isolation because a Translated
Request carries an address supplied by the IOMMU. Config-space reads that
fail or return all ones, however, leave ACS state unknown and must not
report isolation.

Exercise both cases with fake config-space operations. Also cover missing
and unrequested controls and a missing ACS capability.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/pci.c          |   4 +-
 drivers/pci/pci.h          |   1 +
 drivers/pci/pci_acs_test.c | 126 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d677695c0f57..930c35fcca695 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3611,7 +3611,8 @@ void pci_configure_ari(struct pci_dev *dev)
 	}
 }
 
-static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
+VISIBLE_IF_KUNIT
+bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 {
 	int pos;
 	u16 ctrl;
@@ -3632,6 +3633,7 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 		return false;
 	return (ctrl & acs_flags) == acs_flags;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_flags_enabled);
 
 /**
  * pci_acs_enabled - test ACS against required flags for a given device
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 37db2d3111cca..f76e4dbacae13 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1135,6 +1135,7 @@ enum pci_acs_p2pdma_state {
 };
 
 #if IS_ENABLED(CONFIG_KUNIT)
+bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags);
 enum pci_acs_p2pdma_state pci_acs_p2pdma_request(u16 ctrl,
 						unsigned int tlp_flags);
 enum pci_acs_p2pdma_state pci_acs_p2pdma_completion(u16 ctrl,
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
index f8fbeac7d2c0e..f6eb7dea7d8cd 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -103,10 +103,132 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
 			c->expect);
 }
 
+/* Flags an IOMMU asks for; see REQ_ACS_FLAGS in drivers/iommu/iommu.c. */
+#define ACS_REQ_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 #define ACS_ALL_CAPS	(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR | \
 			 PCI_ACS_UF | PCI_ACS_DT)
 #define ACS_TEST_CAP	0x100
 
+struct acs_ctrl_cfg {
+	unsigned int devfn;
+	u16 cap;	/* Offset where the ACS capability responds */
+	u16 ctrl;
+	bool fail_read;
+};
+
+static int acs_ctrl_read(struct pci_bus *bus, unsigned int devfn,
+			 int where, int size, u32 *val)
+{
+	struct acs_ctrl_cfg *cfg = bus->sysdata;
+
+	*val = 0;
+	if (cfg->fail_read)
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	if (devfn == cfg->devfn && size == 2 &&
+	    where == cfg->cap + PCI_ACS_CTRL)
+		*val = cfg->ctrl;
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int acs_ctrl_write(struct pci_bus *bus, unsigned int devfn,
+			  int where, int size, u32 val)
+{
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops acs_ctrl_ops = {
+	.read	= acs_ctrl_read,
+	.write	= acs_ctrl_write,
+};
+
+struct acs_isolation_case {
+	const char *desc;
+	u16 ctrl;
+	u16 req;
+	bool expect;
+};
+
+static const struct acs_isolation_case acs_isolation_cases[] = {
+	{ "all_enabled", ACS_REQ_FLAGS, ACS_REQ_FLAGS, true },
+	/* Translated Requests remain isolated by their IOMMU translation. */
+	{ "dt", ACS_REQ_FLAGS | PCI_ACS_DT, ACS_REQ_FLAGS, true },
+	{ "rr_not_enabled", PCI_ACS_SV | PCI_ACS_CR | PCI_ACS_UF,
+	  ACS_REQ_FLAGS, false },
+	{ "rr_not_required", PCI_ACS_SV | PCI_ACS_CR | PCI_ACS_UF,
+	  PCI_ACS_SV | PCI_ACS_CR | PCI_ACS_UF, true },
+};
+
+static void acs_isolation_desc(const struct acs_isolation_case *c, char *desc)
+{
+	strscpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(acs_isolation, acs_isolation_cases, acs_isolation_desc);
+
+static bool acs_isolated(struct kunit *test, struct acs_ctrl_cfg *cfg,
+			 u16 acs_flags)
+{
+	struct pci_bus *bus = kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
+	struct pci_dev *pdev = kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, bus);
+	KUNIT_ASSERT_NOT_NULL(test, pdev);
+
+	bus->ops = &acs_ctrl_ops;
+	bus->sysdata = cfg;
+
+	pdev->bus = bus;
+	pdev->devfn = cfg->devfn;
+	pdev->acs_cap = cfg->cap;
+	pdev->acs_capabilities = ACS_ALL_CAPS;
+
+	return pci_acs_flags_enabled(pdev, acs_flags);
+}
+
+static void pci_acs_flags_enabled_test(struct kunit *test)
+{
+	const struct acs_isolation_case *c = test->param_value;
+	struct acs_ctrl_cfg cfg = {
+		.devfn = PCI_DEVFN(0, 0),
+		.cap = ACS_TEST_CAP,
+		.ctrl = c->ctrl,
+	};
+
+	KUNIT_EXPECT_EQ(test, acs_isolated(test, &cfg, c->req), c->expect);
+}
+
+static void pci_acs_flags_no_cap_test(struct kunit *test)
+{
+	struct acs_ctrl_cfg cfg = {
+		.devfn = PCI_DEVFN(0, 0),
+		.cap = 0,
+		.ctrl = ACS_REQ_FLAGS,
+	};
+
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, ACS_REQ_FLAGS));
+}
+
+static void pci_acs_flags_read_fails_test(struct kunit *test)
+{
+	u16 no_rr = ACS_REQ_FLAGS & ~PCI_ACS_RR;
+	struct acs_ctrl_cfg cfg = {
+		.devfn = PCI_DEVFN(0, 0),
+		.cap = ACS_TEST_CAP,
+		.ctrl = ACS_REQ_FLAGS,
+	};
+
+	KUNIT_EXPECT_TRUE(test, acs_isolated(test, &cfg, no_rr));
+
+	cfg.fail_read = true;
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, no_rr));
+
+	/* A device that does not answer reads as all ones, without an error */
+	cfg.fail_read = false;
+	cfg.ctrl = 0xffff;
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, no_rr));
+}
+
 /*
  * Drive calc_map_type_and_dist() over a fabricated PCIe fabric matching the
  * canonical topology of two devices below one switch:
@@ -1111,6 +1233,10 @@ static struct kunit_case pci_acs_test_cases[] = {
 			 acs_request_gen_params),
 	KUNIT_CASE_PARAM(pci_acs_p2pdma_completion_test,
 			 acs_completion_gen_params),
+	KUNIT_CASE_PARAM(pci_acs_flags_enabled_test,
+			 acs_isolation_gen_params),
+	KUNIT_CASE(pci_acs_flags_no_cap_test),
+	KUNIT_CASE(pci_acs_flags_read_fails_test),
 	KUNIT_CASE(acs_walk_bus_addr_test),
 	KUNIT_CASE(acs_walk_request_redirect_test),
 	KUNIT_CASE(acs_walk_completion_redirect_test),

-- 
2.56.0

