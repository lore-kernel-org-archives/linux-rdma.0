Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DAD442FC2;
	Mon, 14 Sep 2026 11:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385019; cv=none; b=N0wkcPbMdnL61yGYk1N6R0voJMoaeWysOnfLtwTC61ZUGhA6f7FNNgpyJy6w4r3bI1IP+8KZYL9i1xvgCyPBi+5zVgkw7nojUeUGzG+YylhJulOV6MLTHmR+5HWpiaa6KCllF+9nH4vbaKsFx2kyNsUFzOTJxjDuKPNEUNpFR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385019; c=relaxed/simple;
	bh=IsGvpzHxKgGZ1avS9Y2ZIY62aFibIVbZXXmCdjyKlyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txXz9loe8wo0I31vBEaAXSxRvS9vdrOJgv5NJkr/72wgFJfrhmTlGL6DZx8CmS9i5fx3rOmkT9nwugDL3Fe7xjvQ6taHnv2EvY9yJGp4zpnSHPA/AogUy5SlZbapDBx3uoQFenyqpmF/CpYFzDie2Am7QvOwfw03KLWxP05pH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZuZYeb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZuZYeb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9B01F00898;
	Mon, 14 Sep 2026 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385017;
	bh=0kbSch0SERCu06PJMYS0TfO7WiOJ0Ulzs7nJ+u2rzoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZuZYeb63yQGPDpjd5Jy1VKwkGAYAlmHAfCH0Vot7o67Cw62yaCoLjUqKcNUBl47e
	 ui98IRxZV0bV6lDTMpieL69aFfbAwjAyTiNYhZkicNGQ+8YEPkXlR7fESullt9gFd6
	 +96K7p8VFoAJOi50qsViSZ86DhMHuMdqw2GlC1qOX9ufpQrJqbxuf1Hcprry3ZqaGq
	 HcQoItNe6xam/XL3uWlVQAc31NhR0APHtzejiC+jkChPXPcWYj/u5y9gOQJhn6cX6l
	 wDL2PpnJGSQEGgyfUrrRjRpreeNNJ4WLkF/hoBxETKVWPfrxrzscNc2M3ANLBaZMe6
	 fwqmvyxuvbH8Q==
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
Subject: [PATCH v6 14/18] PCI/P2PDMA: Test the ACS P2P routing walk
Date: Mon, 14 Sep 2026 14:22:47 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-14-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

calc_map_type_and_dist() decides which ports along a path carry the
routing controls, and holds every class's answer in one cache entry.
Neither depends on a single register, so a table of them cannot reach the
walk itself.

Drive the walk over a fabricated fabric of two devices below a switch,
with fake config space supplying the ACS Control registers. Cover the
ports below the divergence, the three cases where two classes of one path
disagree, and the packed cache, which the fabric has no provider state to
exercise indirectly.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       |   9 +-
 drivers/pci/pci.h          |   9 ++
 drivers/pci/pci_acs_test.c | 350 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 365 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 955e3b41ec1f..e522be1372f7 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1016,7 +1016,7 @@ static unsigned long map_types_idx(struct pci_dev *client)
  */
 static_assert(PCI_P2PDMA_MAP_THRU_HOST_BRIDGE < 16);
 
-static unsigned long
+VISIBLE_IF_KUNIT unsigned long
 pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type)
 {
 	unsigned long val = 0;
@@ -1027,12 +1027,14 @@ pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type)
 
 	return val;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_p2pdma_map_types_pack);
 
-static enum pci_p2pdma_map_type
+VISIBLE_IF_KUNIT enum pci_p2pdma_map_type
 pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
 {
 	return (val >> (tlp_flags * 4)) & 0xf;
 }
+EXPORT_SYMBOL_IF_KUNIT(pci_p2pdma_map_types_unpack);
 
 /*
  * Calculate the P2PDMA mapping type and distance between two PCI devices.
@@ -1081,7 +1083,7 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * ports per above. If the device is not in the whitelist, return
  * PCI_P2PDMA_MAP_NOT_SUPPORTED.
  */
-static enum pci_p2pdma_map_type
+VISIBLE_IF_KUNIT enum pci_p2pdma_map_type
 calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, unsigned int tlp_flags, bool verbose)
 {
@@ -1267,6 +1269,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 	return map_type[tlp_flags];
 }
+EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
 
 /**
  * pci_p2pdma_distance_many - Determine the cumulative distance between
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index c0d2711d73f9..56f821e40637 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -7,6 +7,7 @@
 #include <linux/align.h>
 #include <linux/bitfield.h>
 #include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 #include <trace/events/pci.h>
 
 struct pcie_tlp_log;
@@ -1107,6 +1108,14 @@ enum pci_acs_p2pdma_state pci_acs_p2pdma_request(u16 ctrl,
 						unsigned int tlp_flags);
 enum pci_acs_p2pdma_state pci_acs_p2pdma_completion(u16 ctrl,
 						    unsigned int tlp_flags);
+unsigned long pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type);
+enum pci_p2pdma_map_type pci_p2pdma_map_types_unpack(unsigned long val,
+						     unsigned int tlp_flags);
+enum pci_p2pdma_map_type calc_map_type_and_dist(struct pci_dev *provider,
+						struct pci_dev *client,
+						int *dist,
+						unsigned int tlp_flags,
+						bool verbose);
 #endif
 
 #ifdef CONFIG_PCI_QUIRKS
diff --git a/drivers/pci/pci_acs_test.c b/drivers/pci/pci_acs_test.c
index ce6b9375da36..28eced6dd672 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -102,11 +102,361 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
 			c->expect);
 }
 
+/*
+ * Drive calc_map_type_and_dist() over a fabricated PCIe fabric matching the
+ * canonical topology of two devices below one switch:
+ *
+ *   host bridge / root bus
+ *     Root Port
+ *       Switch Upstream Port
+ *         Switch Downstream Port 0
+ *           Nested Switch -- provider
+ *         Switch Downstream Port 1
+ *           Nested Switch -- client
+ *
+ * Fake config-space operations supply the ACS Control registers. This lets
+ * the cases vary both divergence ports and controls below the divergence
+ * without depending on real hardware.
+ */
+struct acs_port_cfg {
+	u16 ctrl;
+	bool fail_read;
+};
+
+struct acs_fabric {
+	struct pci_dev *provider;
+	struct pci_dev *client;
+	struct pci_dev *dn0;	/* Downstream Port 0 (provider side) */
+	struct pci_dev *dn1;	/* Downstream Port 1 (client side) */
+	struct pci_dev *provider_leaf;
+	struct pci_dev *client_leaf;
+	struct acs_port_cfg dn0_cfg;
+	struct acs_port_cfg dn1_cfg;
+	struct acs_port_cfg provider_leaf_cfg;
+	struct acs_port_cfg client_leaf_cfg;
+};
+
+static int acs_port_read(struct pci_dev *port, struct acs_port_cfg *cfg,
+			 int where, int size, u32 *val)
+{
+	if (port->acs_cap && size == 2 &&
+	    where == port->acs_cap + PCI_ACS_CTRL) {
+		if (cfg->fail_read)
+			return PCIBIOS_DEVICE_NOT_FOUND;
+		*val = cfg->ctrl;
+	}
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int acs_fabric_read(struct pci_bus *bus, unsigned int devfn,
+			   int where, int size, u32 *val)
+{
+	struct acs_fabric *f = bus->sysdata;
+
+	*val = 0;
+	if (bus == f->dn0->bus && devfn == f->dn0->devfn)
+		return acs_port_read(f->dn0, &f->dn0_cfg, where, size, val);
+	if (bus == f->dn1->bus && devfn == f->dn1->devfn)
+		return acs_port_read(f->dn1, &f->dn1_cfg, where, size, val);
+	if (bus == f->provider_leaf->bus &&
+	    devfn == f->provider_leaf->devfn)
+		return acs_port_read(f->provider_leaf, &f->provider_leaf_cfg,
+				     where, size, val);
+	if (bus == f->client_leaf->bus && devfn == f->client_leaf->devfn)
+		return acs_port_read(f->client_leaf, &f->client_leaf_cfg,
+				     where, size, val);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int acs_fabric_write(struct pci_bus *bus, unsigned int devfn,
+			    int where, int size, u32 val)
+{
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops acs_fabric_ops = {
+	.read	= acs_fabric_read,
+	.write	= acs_fabric_write,
+};
+
+static struct pci_bus *acs_add_bus(struct kunit *test, struct pci_bus *parent,
+				   struct pci_dev *self, u8 nr, void *sysdata)
+{
+	struct pci_bus *bus = kunit_kzalloc(test, sizeof(*bus), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, bus);
+	bus->parent = parent;
+	bus->self = self;
+	bus->number = nr;
+	bus->ops = &acs_fabric_ops;
+	bus->sysdata = sysdata;
+	INIT_LIST_HEAD(&bus->devices);
+	return bus;
+}
+
+static struct pci_dev *acs_add_dev(struct kunit *test, struct pci_bus *bus,
+				   unsigned int devfn, int pcie_type)
+{
+	struct pci_dev *dev = kunit_kzalloc(test, sizeof(*dev), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, dev);
+	dev->bus = bus;
+	dev->devfn = devfn;
+	dev->pcie_cap = 0x40;
+	dev->pcie_flags_reg = (pcie_type << 4) | 0x2;
+	list_add_tail(&dev->bus_list, &bus->devices);
+	return dev;
+}
+
+static void acs_build_fabric(struct kunit *test, struct acs_fabric *f)
+{
+	struct pci_bus *bus0, *bus1, *bus2, *bus3, *bus4, *bus5, *bus6;
+	struct pci_bus *bus7, *bus8;
+	struct pci_dev *rootport, *swup, *provider_swup, *client_swup;
+	struct pci_host_bridge *host;
+
+	host = kunit_kzalloc(test, sizeof(*host), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, host);
+
+	bus0 = acs_add_bus(test, NULL, NULL, 0, f);
+	/* The Root Port doubles as the whitelisted host-bridge device. */
+	rootport = acs_add_dev(test, bus0, PCI_DEVFN(0, 0),
+			       PCI_EXP_TYPE_ROOT_PORT);
+	rootport->vendor = PCI_VENDOR_ID_GOOGLE;
+	rootport->device = 0x1234;
+	host->bus = bus0;
+	bus0->bridge = &host->dev;
+
+	bus1 = acs_add_bus(test, bus0, rootport, 1, f);
+	swup = acs_add_dev(test, bus1, PCI_DEVFN(0, 0),
+			   PCI_EXP_TYPE_UPSTREAM);
+
+	bus2 = acs_add_bus(test, bus1, swup, 2, f);
+	f->dn0 = acs_add_dev(test, bus2, PCI_DEVFN(0, 0),
+			     PCI_EXP_TYPE_DOWNSTREAM);
+	f->dn1 = acs_add_dev(test, bus2, PCI_DEVFN(1, 0),
+			     PCI_EXP_TYPE_DOWNSTREAM);
+
+	bus3 = acs_add_bus(test, bus2, f->dn0, 3, f);
+	provider_swup = acs_add_dev(test, bus3, PCI_DEVFN(0, 0),
+				    PCI_EXP_TYPE_UPSTREAM);
+	bus5 = acs_add_bus(test, bus3, provider_swup, 5, f);
+	f->provider_leaf = acs_add_dev(test, bus5, PCI_DEVFN(0, 0),
+				       PCI_EXP_TYPE_DOWNSTREAM);
+	bus7 = acs_add_bus(test, bus5, f->provider_leaf, 7, f);
+	f->provider = acs_add_dev(test, bus7, PCI_DEVFN(0, 0),
+				  PCI_EXP_TYPE_ENDPOINT);
+
+	bus4 = acs_add_bus(test, bus2, f->dn1, 4, f);
+	client_swup = acs_add_dev(test, bus4, PCI_DEVFN(0, 0),
+				  PCI_EXP_TYPE_UPSTREAM);
+	bus6 = acs_add_bus(test, bus4, client_swup, 6, f);
+	f->client_leaf = acs_add_dev(test, bus6, PCI_DEVFN(0, 0),
+				     PCI_EXP_TYPE_DOWNSTREAM);
+	bus8 = acs_add_bus(test, bus6, f->client_leaf, 8, f);
+	f->client = acs_add_dev(test, bus8, PCI_DEVFN(0, 0),
+				PCI_EXP_TYPE_ENDPOINT);
+}
+
+static enum pci_p2pdma_map_type acs_walk_map(struct acs_fabric *f,
+					     unsigned int tlp_flags)
+{
+	int dist;
+
+	return calc_map_type_and_dist(f->provider, f->client, &dist, tlp_flags,
+				      false);
+}
+
+static void acs_walk_bus_addr_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0), PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_request_redirect_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_RR;
+	f.dn1_cfg.ctrl = PCI_ACS_RR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_completion_redirect_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn0->acs_cap = 0x100;
+	f.dn0->acs_capabilities = PCI_ACS_CR;
+	f.dn0_cfg.ctrl = PCI_ACS_CR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_egress_control_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_EC;
+	f.dn1_cfg.ctrl = PCI_ACS_EC;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_asymmetric_direct_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	/* These controls affect only the reverse transaction directions. */
+	f.dn0->acs_cap = 0x100;
+	f.dn0->acs_capabilities = PCI_ACS_RR | PCI_ACS_EC;
+	f.dn0_cfg.ctrl = PCI_ACS_RR | PCI_ACS_EC;
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_CR;
+	f.dn1_cfg.ctrl = PCI_ACS_CR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0), PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_nested_completion_redirect_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.provider_leaf->acs_cap = 0x100;
+	f.provider_leaf->acs_capabilities = PCI_ACS_CR;
+	f.provider_leaf_cfg.ctrl = PCI_ACS_CR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0), PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_nested_request_redirect_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_RR;
+	f.client_leaf_cfg.ctrl = PCI_ACS_RR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0), PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_translation_blocking_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	/* Untranslated Requests are unaffected by Translation Blocking. */
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0), PCI_P2PDMA_MAP_BUS_ADDR);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+static void acs_walk_relaxed_completion_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn0->acs_cap = 0x100;
+	f.dn0->acs_capabilities = PCI_ACS_CR;
+	f.dn0_cfg.ctrl = PCI_ACS_CR;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_RELAXED_CPL),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_direct_translated_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_RR | PCI_ACS_DT;
+	f.dn1_cfg.ctrl = PCI_ACS_RR | PCI_ACS_DT;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+/*
+ * The cache stores one packed value per client, so every class has to come
+ * back out under the flags that selected it.
+ */
+static void acs_map_types_pack_test(struct kunit *test)
+{
+	static const enum pci_p2pdma_map_type type[PCI_P2PDMA_TLP_CLASSES] = {
+		[0] = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
+		[PCI_P2PDMA_TLP_TRANSLATED] = PCI_P2PDMA_MAP_NOT_SUPPORTED,
+		[PCI_P2PDMA_TLP_RELAXED_CPL] = PCI_P2PDMA_MAP_BUS_ADDR,
+		[PCI_P2PDMA_TLP_TRANSLATED | PCI_P2PDMA_TLP_RELAXED_CPL] =
+			PCI_P2PDMA_MAP_UNKNOWN,
+	};
+	unsigned long packed = pci_p2pdma_map_types_pack(type);
+	unsigned int flags;
+
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		KUNIT_EXPECT_EQ(test,
+				pci_p2pdma_map_types_unpack(packed, flags),
+				type[flags]);
+
+	/* An absent cache entry reads back as unknown in every class. */
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		KUNIT_EXPECT_EQ(test, pci_p2pdma_map_types_unpack(0, flags),
+				PCI_P2PDMA_MAP_UNKNOWN);
+}
+
+static void acs_walk_unreadable_control_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.dn1->acs_cap = 0x100;
+	f.dn1_cfg.fail_read = true;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
 static struct kunit_case pci_acs_test_cases[] = {
 	KUNIT_CASE_PARAM(pci_acs_p2pdma_request_test,
 			 acs_request_gen_params),
 	KUNIT_CASE_PARAM(pci_acs_p2pdma_completion_test,
 			 acs_completion_gen_params),
+	KUNIT_CASE(acs_walk_bus_addr_test),
+	KUNIT_CASE(acs_walk_request_redirect_test),
+	KUNIT_CASE(acs_walk_completion_redirect_test),
+	KUNIT_CASE(acs_walk_egress_control_test),
+	KUNIT_CASE(acs_walk_asymmetric_direct_test),
+	KUNIT_CASE(acs_walk_nested_completion_redirect_test),
+	KUNIT_CASE(acs_walk_nested_request_redirect_test),
+	KUNIT_CASE(acs_walk_translation_blocking_test),
+	KUNIT_CASE(acs_walk_relaxed_completion_test),
+	KUNIT_CASE(acs_walk_direct_translated_test),
+	KUNIT_CASE(acs_walk_unreadable_control_test),
+	KUNIT_CASE(acs_map_types_pack_test),
 	{}
 };
 

-- 
2.55.0

