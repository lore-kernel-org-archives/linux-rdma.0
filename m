Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46584480962;
	Thu, 10 Sep 2026 11:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039991; cv=none; b=hTrW4mt7KLAiaQoSFIuFt+mO9G9ZTxDJgh0bMk+lNzzZo2LA8npWg+HfAeyxoLOLymFQXMB3pkjT5oXUul/R9k6vAouY9ly7BC/CctZVWydCMHeqeY++K5y9qHrWe3kgbYQnLpW5PX7c0tprS78gPT9gGGORGRHN47CDGSI/rZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039991; c=relaxed/simple;
	bh=0K5rUpBpGWQFTY3uzLBKiWWTUeOLwszMt+xh11hdHPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I6zjvlp+cvppz1GbZYVuc+pO+QFYrJulTnmE83lAA0/5jdIu3lbcqJBfSp5y/ce/wTUn/XbCcXbPva0OH6krzwwM2ELeVOpZlbA6TXOIVz1u9oGJW9P0iu2EKpTPTb1IaiA0Px5J7WCTS75UaYCuNkvv9cJG4FBLJJq5MaWEOvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/Yf24Jp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/Yf24Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358971F0089A;
	Thu, 10 Sep 2026 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039988;
	bh=ezjTrl262v9AlY/XGNLFM9lj31ECNwVLoicbe3EAPpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/Yf24JpSkv1iNBpprcI6ILu+GMcaZ6rb0ZzfjHxP7UPTP1eYU3alkHH+c1H//Ny5
	 nmFEbIXMhczAQO6KfVyB1RmfmUIxxnt7wG3GNs9HnN4ua+sWo63ZTD9Jf+vlMQxfqI
	 GcaoKRDwQ7V2A3mXwRx5ZIR7LiCCZ5FczMge9l+2TT1lL0UQCMUzvqahaRjercBVho
	 iBrWvuNBHfQYpAnbHjvqkorEQtqkc3Z594aZsWSyBe1SPbc60RzshkKUECzDk5Ai+8
	 iXR5Eqgg1ntr8nJ7DWiaskUPu2VLor1AlKVqrMyvwbzrT2DrUUEahwrZ5+p9iHFClt
	 Mfjlw6+CEJVZw==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v5 15/18] PCI: Add KUnit coverage for ACS isolation checks
Date: Thu, 10 Sep 2026 14:32:10 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-15-856087f63c0d@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
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

Direct Translated P2P does not weaken IOMMU isolation because a Translated
Request carries an address supplied by the IOMMU. Config-space read
failures, however, leave ACS state unknown and must not report isolation.

Exercise both cases with fake config-space operations. Also cover missing
and unrequested controls and a missing ACS capability.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/pci.c          |   4 +-
 drivers/pci/pci.h          |   1 +
 drivers/pci/pci_acs_test.c | 138 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f7d94ecf9157..4a9ab3882aac 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3578,7 +3578,8 @@ void pci_configure_ari(struct pci_dev *dev)
 	}
 }
 
-static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
+VISIBLE_IF_KUNIT
+bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 {
 	int pos;
 	u16 ctrl;
@@ -3598,6 +3599,7 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 		return false;
 	return (ctrl & acs_flags) == acs_flags;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_acs_flags_enabled);
 
 /**
  * pci_acs_enabled - test ACS against required flags for a given device
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 56f821e40637..5bc703ff0c86 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1104,6 +1104,7 @@ enum pci_acs_p2pdma_state {
 };
 
 #if IS_ENABLED(CONFIG_KUNIT)
+bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags);
 enum pci_acs_p2pdma_state pci_acs_p2pdma_request(u16 ctrl,
 						unsigned int tlp_flags);
 enum pci_acs_p2pdma_state pci_acs_p2pdma_completion(u16 ctrl,
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
index 28eced6dd672..880fc810080a 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -102,6 +102,140 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
 			c->expect);
 }
 
+/* Flags an IOMMU asks for; see REQ_ACS_FLAGS in drivers/iommu/iommu.c. */
+#define ACS_REQ_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+#define ACS_ALL_CAPS	(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR | \
+			 PCI_ACS_UF | PCI_ACS_DT)
+#define ACS_TEST_CAP	0x100
+
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
+}
+
 /*
  * Drive calc_map_type_and_dist() over a fabricated PCIe fabric matching the
  * canonical topology of two devices below one switch:
@@ -445,6 +579,10 @@ static struct kunit_case pci_acs_test_cases[] = {
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
2.55.0

