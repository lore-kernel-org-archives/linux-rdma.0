Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694659;
	b=LGBENannGktmGgUUtNWBK6X3foqVK0E7WKmg0M3EvmmtRXFG/kQH1RYrxmsDE2hwT/rP
	 u6s6FL68VUJSJz+shLqtfS9pBbhKBjBSrJ3q+Kvgj4Cib2c2xYfbfLKstcOjrd0DWbKR9
	 ZOb66Lr4PBKtpvcywXpXMUxr0UTJVh/htBTkhJFNNCjp7hiD74aA9tE4IlcHvuZEaT+V0
	 BApHHbm6E8W44g00c5n7zuaNmxaVrG33GL/BGKVa/k1Fb08AKp5rf1+Ck4VG6g91WwjTF
	 zmpKb302NFw43SivZ6ZGqAh2ux5n3d2MzNCEyzv1323Kf9IFuLd6dHKG+uG+euMWwbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=8ywQjiRQCWSFq2yn68/Xx90X0KCg7x7eO8tTr0XOneg=;
	b=Z77cflATRWDAVWQXhBdRmbG73lQ1Fy1ieKiGxu9FYJxinRChBvJgYCANyAhs9PayCvGe
	 bJUn7G6YWjzOhQxGhh9OSyL5HtewXlf0yrIrKtakIZsfo422DtGowDRJS/mG9OZ7W8GM8
	 LCIAkqElWsJE3how3HJ3+5Q6/a8BrRsPCWxARmVgiWYN7nyisPuR910PT0UdcZV3+9gF+
	 ERMmCaG3aQ/aKReNYssFY9S3GQR8Vd/SNl8TZ7mwPZ1NqiwCZ1SjRmdG5/nIuW1q5iFYn
	 P0qZhF/BU3Oa8NbPfkSbK/F4wUG5AK1LsmCM4DPYJPb7jPurd3jG5rt+CHjZMyGdsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUM+JcLy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED9B60A383D;
	Tue,  3 Nov 2026 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUM+JcLy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4581F00A15;
	Tue,  3 Nov 2026 08:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694659;
	bh=8ywQjiRQCWSFq2yn68/Xx90X0KCg7x7eO8tTr0XOneg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUM+JcLyNxf8QV+iEKhqZwjAsx8uEhjGAMwKvDwHpaU6nWCj50+BG18cZ6/jzgTNp
	 HFD7IssKjtU2XMl/y3D4KGxETAV1403Gy9oFts/Pdfxg87HomgZYu+xq0an4ZErK7t
	 Wm/cbQ1tow2b2FWOhjTm69KN6OmR+qHji428a1klgiGTL93/59SRd3fOEsABGY8nrr
	 UVYYeUO7qFY3tosOBNm3xuqIv+ZxEYQEcAFXgocQV6p62I8c02Kmoo9SdLvUdevR+y
	 K6RUPUQHCSsEGPZWicUmTAuD5CUnAM7Gvs7atCrqDXO+9xE5s3XwDaugNCnmX0KJKu
	 pbIPJBfpW5/Qw==
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
Subject: [PATCH v12 15/19] PCI: Add KUnit coverage for ACS isolation checks
Date: Tue,  3 Nov 2026 10:29:54 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-15-912101f93517@nvidia.com>
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
 drivers/pci/pci_acs_test.c | 139 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d677695c0f5..930c35fcca69 100644
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
index 2dc394722d8f..8c38817c967e 100644
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
index 18c697226762..369444d2a04a 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -103,10 +103,145 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
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
+static void pci_acs_flags_enabled_test(struct kunit *test)
+{
+	const struct acs_isolation_case *c = test->param_value;
+	struct acs_ctrl_cfg cfg = {
+		.devfn = PCI_DEVFN(0, 0),
+		.cap = ACS_TEST_CAP,
+		.ctrl = c->ctrl,
+	};
+	struct pci_bus *bus = kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
+	struct pci_dev *pdev = kunit_kzalloc(test, sizeof(*pdev), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, bus);
+	KUNIT_ASSERT_NOT_NULL(test, pdev);
+
+	bus->ops = &acs_ctrl_ops;
+	bus->sysdata = &cfg;
+
+	pdev->bus = bus;
+	pdev->devfn = cfg.devfn;
+	pdev->acs_cap = ACS_TEST_CAP;
+	pdev->acs_capabilities = ACS_ALL_CAPS;
+
+	KUNIT_EXPECT_EQ(test, pci_acs_flags_enabled(pdev, c->req), c->expect);
+}
+
+static bool acs_isolated(struct kunit *test, struct acs_ctrl_cfg *cfg,
+			 u16 acs_cap, u16 acs_flags)
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
+	pdev->acs_cap = acs_cap;
+	pdev->acs_capabilities = ACS_ALL_CAPS;
+
+	return pci_acs_flags_enabled(pdev, acs_flags);
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
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, 0, ACS_REQ_FLAGS));
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
+	KUNIT_EXPECT_TRUE(test, acs_isolated(test, &cfg, ACS_TEST_CAP, no_rr));
+
+	cfg.fail_read = true;
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, ACS_TEST_CAP, no_rr));
+
+	/* A device that does not answer reads as all ones, without an error */
+	cfg.fail_read = false;
+	cfg.ctrl = 0xffff;
+	KUNIT_EXPECT_FALSE(test, acs_isolated(test, &cfg, ACS_TEST_CAP, no_rr));
+}
+
 /*
  * Drive calc_map_type_and_dist() over a fabricated PCIe fabric matching the
  * canonical topology of two devices below one switch:
@@ -920,6 +1055,10 @@ static struct kunit_case pci_acs_test_cases[] = {
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

