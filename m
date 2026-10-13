Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF62511E9B;
	Tue, 13 Oct 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901590; cv=none; b=sen8onWpT8h+gICtbWAHZ5MhPwUO7r0THnVKdfu9EGJvcxVn2CpPe5bP0JTCHtXxJAxyMgXNUvkktODa/GmMDNcnm0NlN9AqvLZY2arrkf4zIvzzFvRAQmzZjzlEbo+rPe7SruKUzV6BtSpvmddrsrWISKlY8RJSmz+6KwbXJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901590; c=relaxed/simple;
	bh=19AsBxWXcbz/eyVwsmQ5wkknc63tiYdx3Y8RlQSWcbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ektA0LkxKdXRrijDfHDwzLA9JGqdvWwJsUcfQljOWTxLyGrEQAtWqlZ92AuWxAEIzPT7H6TlxVBbKeHHQYyLaXdngJBDiXY0J30gx6b4Qoc2i3eyR3+5HzPJCjMi+yK/KpKAB5DLZ4kd7gCtL8dmSuS0k2OPuWToD+N5PbG3Mz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ja7IcXOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ja7IcXOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB8A1F00899;
	Tue, 13 Oct 2026 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901588;
	bh=M9OUV4A6ML92iDUfamzUNB1+HBbWhvVjsGsmccB6l8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ja7IcXOb7/8rRwDD9MX/cxiyVeFYV8KXB+uUBS3PFdaTRoIvYKnN5RhqqQXvSDJlW
	 gYyKrwv/u5Sfwf/K1iE2D2ozocpGxc7VrcCz1jBUD1kv75No167DpRCTr2L7yVUE+K
	 blaHyP/8wLmKc0WkWcjYFbe/5a9Nxhc9QZjXkDTBSjr1uEQIjTnr6dOqXTDkmUnd1g
	 YMtof7e/NgWmeYzmc7r+sQ6JydGtdnddVGbHksPzZYFnk2f0De7D884MrL+CqKah2r
	 M4d3HtrxO9+H5xWgbAUlijqdz/25FNqY5fhi7eAmeUXeQ05z4sSlbC4W3bjL1tjiMZ
	 n0v0r8gmWODCQ==
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
Subject: [PATCH v11 14/19] PCI/P2PDMA: Test the ACS P2P routing walk
Date: Tue, 13 Oct 2026 17:25:22 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-14-72cf8c96e617@nvidia.com>
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

Routing depends on which ports share each path, not just individual ACS
registers. Sibling functions without internal peer routes must use the host
bridge even when redirect controls read as zero.

Drive the walk over fabricated switch and multifunction topologies with
fake configuration space. Cover directional controls, nested ports, TLP
attributes, hardwired isolation, ARI, PF/VF paths, forwarding failures,
translation blocking, host allowlisting and packed cache values. Keep
external peers and self-DMA independent of sibling routing restrictions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       |   9 +-
 drivers/pci/pci.h          |   9 +
 drivers/pci/pci_acs_test.c | 841 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 856 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 340f149a4d88..6a05a5019daf 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -1170,7 +1170,7 @@ static unsigned long map_types_idx(struct pci_dev *client)
  */
 static_assert(PCI_P2PDMA_MAP_THRU_HOST_BRIDGE < 16);
 
-static unsigned long
+VISIBLE_IF_KUNIT unsigned long
 pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type)
 {
 	unsigned long val = 0;
@@ -1181,12 +1181,14 @@ pci_p2pdma_map_types_pack(const enum pci_p2pdma_map_type *type)
 
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
@@ -1236,7 +1238,7 @@ pci_p2pdma_map_types_unpack(unsigned long val, unsigned int tlp_flags)
  * ports per above. If the device is not in the whitelist, return
  * PCI_P2PDMA_MAP_NOT_SUPPORTED.
  */
-static enum pci_p2pdma_map_type
+VISIBLE_IF_KUNIT enum pci_p2pdma_map_type
 calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		int *dist, unsigned int tlp_flags, bool verbose)
 {
@@ -1443,6 +1445,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 	return map_type[tlp_flags];
 }
+EXPORT_SYMBOL_IF_KUNIT(calc_map_type_and_dist);
 
 /**
  * pci_p2pdma_distance_many - Determine the cumulative distance between
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 302b79d3977f..b9b983ad6c34 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -7,6 +7,7 @@
 #include <linux/align.h>
 #include <linux/bitfield.h>
 #include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 #include <trace/events/pci.h>
 
 struct pcie_tlp_log;
@@ -1132,6 +1133,14 @@ enum pci_acs_p2pdma_state pci_acs_p2pdma_request(u16 ctrl,
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
index 18bcc4b8e758..18c697226762 100644
--- a/drivers/pci/pci_acs_test.c
+++ b/drivers/pci/pci_acs_test.c
@@ -103,11 +103,852 @@ static void pci_acs_p2pdma_completion_test(struct kunit *test)
 			c->expect);
 }
 
+#define ACS_ALL_CAPS	(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR | \
+			 PCI_ACS_UF | PCI_ACS_DT)
+#define ACS_TEST_CAP	0x100
+
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
+	struct pci_dev *rootport;
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
+	struct acs_port_cfg rootport_cfg;
+	struct acs_port_cfg provider_cfg;
+	struct acs_port_cfg client_cfg;
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
+	if (bus == f->provider->bus && devfn == f->provider->devfn)
+		return acs_port_read(f->provider, &f->provider_cfg,
+				     where, size, val);
+	if (bus == f->client->bus && devfn == f->client->devfn)
+		return acs_port_read(f->client, &f->client_cfg,
+				     where, size, val);
+	if (bus == f->rootport->bus && devfn == f->rootport->devfn)
+		return acs_port_read(f->rootport, &f->rootport_cfg,
+				     where, size, val);
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
+	if (pcie_type != PCI_EXP_TYPE_ENDPOINT)
+		dev->hdr_type = PCI_HEADER_TYPE_BRIDGE;
+	list_add_tail(&dev->bus_list, &bus->devices);
+	return dev;
+}
+
+static void acs_build_fabric(struct kunit *test, struct acs_fabric *f)
+{
+	struct pci_bus *bus0, *bus1, *bus2, *bus3, *bus4, *bus5, *bus6;
+	struct pci_bus *bus7, *bus8;
+	struct pci_dev *swup, *provider_swup, *client_swup;
+	struct pci_dev *rootport;
+	struct pci_host_bridge *host;
+
+	host = kunit_kzalloc(test, sizeof(*host), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, host);
+
+	bus0 = acs_add_bus(test, NULL, NULL, 0, f);
+	/* The Root Port doubles as the whitelisted host-bridge device. */
+	rootport = acs_add_dev(test, bus0, PCI_DEVFN(0, 0),
+			       PCI_EXP_TYPE_ROOT_PORT);
+	f->rootport = rootport;
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
+/*
+ * Zhaoxin Downstream Ports that lack an ACS capability redirect through a
+ * quirk, which covers every class, Relaxed Ordering Completions included.
+ * A Zhaoxin port the quirk does not know keeps its own ACS controls.
+ */
+static void acs_walk_quirk_redirect_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	if (!IS_ENABLED(CONFIG_PCI_QUIRKS))
+		kunit_skip(test, "needs CONFIG_PCI_QUIRKS");
+
+	acs_build_fabric(test, &f);
+	f.dn0->vendor = PCI_VENDOR_ID_ZHAOXIN;
+	f.dn0->device = 0x0710;
+
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_RELAXED_CPL),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	f.dn0->device = 0x0700;
+	f.dn1->vendor = PCI_VENDOR_ID_ZHAOXIN;
+	f.dn1->device = 0x0700;
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_RR;
+	f.dn1_cfg.ctrl = PCI_ACS_RR;
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
+static void acs_enable_forwarding(struct pci_dev *port,
+				  struct acs_port_cfg *cfg)
+{
+	port->acs_cap = ACS_TEST_CAP;
+	port->acs_capabilities = PCI_ACS_UF;
+	cfg->ctrl = PCI_ACS_UF;
+}
+
+/*
+ * Put both functions on one downstream link. Like the Intel E810, each
+ * advertises ACS with neither Request nor Completion Redirect support,
+ * indicating that there is no internal peer path. The shared Downstream
+ * Port and its ancestors forward traffic upstream towards the host.
+ */
+static void acs_build_mf_fabric(struct kunit *test, struct acs_fabric *f)
+{
+	acs_build_fabric(test, f);
+	f->client->bus = f->provider->bus;
+	f->client->devfn = PCI_DEVFN(0, 1);
+	list_move_tail(&f->client->bus_list, &f->provider->bus->devices);
+	f->provider->multifunction = 1;
+	f->client->multifunction = 1;
+	f->provider->acs_cap = ACS_TEST_CAP;
+	f->client->acs_cap = ACS_TEST_CAP;
+	acs_enable_forwarding(f->provider_leaf, &f->provider_leaf_cfg);
+	acs_enable_forwarding(f->dn0, &f->dn0_cfg);
+	acs_enable_forwarding(f->rootport, &f->rootport_cfg);
+}
+
+static void acs_expect_classes(struct kunit *test, struct acs_fabric *f,
+			       enum pci_p2pdma_map_type expect)
+{
+	unsigned int flags;
+
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		KUNIT_EXPECT_EQ_MSG(test, acs_walk_map(f, flags), expect,
+				    "TLP flags %#x", flags);
+}
+
+static void acs_walk_mf_isolation_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_mf_quirk_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	if (!IS_ENABLED(CONFIG_PCI_QUIRKS))
+		kunit_skip(test, "needs CONFIG_PCI_QUIRKS");
+
+	acs_build_mf_fabric(test, &f);
+	f.provider->acs_cap = 0;
+	f.client->acs_cap = 0;
+	f.provider->vendor = PCI_VENDOR_ID_WANGXUN;
+	f.client->vendor = PCI_VENDOR_ID_WANGXUN;
+	f.provider->device = 0x0100;
+	f.client->device = 0x0100;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	/* A port quirk can also establish hardwired Upstream Forwarding. */
+	f.provider_leaf->acs_cap = 0;
+	f.provider_leaf->vendor = PCI_VENDOR_ID_ZHAOXIN;
+	f.provider_leaf->device = 0x0710;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	/* An unknown device must keep its own programmable ACS controls. */
+	f.provider->device = 0xffff;
+	f.client->device = 0xffff;
+	f.provider->acs_cap = ACS_TEST_CAP;
+	f.client->acs_cap = ACS_TEST_CAP;
+	f.provider->acs_capabilities = ACS_ALL_CAPS;
+	f.client->acs_capabilities = ACS_ALL_CAPS;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+/* DT and Relaxed Ordering cannot create a missing internal peer path. */
+static void acs_walk_mf_direction_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	f.provider->acs_capabilities = ACS_ALL_CAPS;
+	f.client->acs_capabilities = ACS_ALL_CAPS & ~PCI_ACS_RR;
+	f.client_cfg.ctrl = PCI_ACS_DT;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	f.provider->acs_capabilities = ACS_ALL_CAPS & ~PCI_ACS_CR;
+	f.client->acs_capabilities = ACS_ALL_CAPS;
+	f.client_cfg.ctrl = 0;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_mf_programmable_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	f.provider->acs_capabilities = ACS_ALL_CAPS;
+	f.client->acs_capabilities = ACS_ALL_CAPS;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_BUS_ADDR);
+
+	f.provider_cfg.ctrl = PCI_ACS_CR;
+	f.client_cfg.ctrl = PCI_ACS_RR | PCI_ACS_DT;
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_TRANSLATED),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, PCI_P2PDMA_TLP_RELAXED_CPL),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test,
+			acs_walk_map(&f, PCI_P2PDMA_TLP_TRANSLATED |
+				     PCI_P2PDMA_TLP_RELAXED_CPL),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+
+	/* A route that stays within the device does not need forwarding. */
+	f.provider_leaf_cfg.ctrl = 0;
+	KUNIT_EXPECT_EQ(test, acs_walk_map(&f, 0),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+	KUNIT_EXPECT_EQ(test,
+			acs_walk_map(&f, PCI_P2PDMA_TLP_TRANSLATED |
+				     PCI_P2PDMA_TLP_RELAXED_CPL),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+struct acs_forwarding_case {
+	const char *desc;
+	u16 cap;
+	u16 capabilities;
+	u16 ctrl;
+	bool fail_read;
+};
+
+static const struct acs_forwarding_case acs_forwarding_cases[] = {
+	{ "disabled", ACS_TEST_CAP, PCI_ACS_UF, 0, false },
+	{ "unsupported", ACS_TEST_CAP, 0, 0, false },
+	{ "absent_acs", 0, 0, 0, false },
+	{ "read_error", ACS_TEST_CAP, PCI_ACS_UF, PCI_ACS_UF, true },
+	{ "all_ones", ACS_TEST_CAP, PCI_ACS_UF, 0xffff, false },
+};
+
+static void acs_forwarding_desc(const struct acs_forwarding_case *c,
+				char *desc)
+{
+	strscpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(acs_forwarding, acs_forwarding_cases, acs_forwarding_desc);
+
+static void acs_walk_mf_forwarding_test(struct kunit *test)
+{
+	const struct acs_forwarding_case *c = test->param_value;
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	f.provider_leaf->acs_cap = c->cap;
+	f.provider_leaf->acs_capabilities = c->capabilities;
+	f.provider_leaf_cfg.ctrl = c->ctrl;
+	f.provider_leaf_cfg.fail_read = c->fail_read;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+static void acs_walk_mf_upstream_forwarding_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	f.dn0_cfg.ctrl = 0;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_NOT_SUPPORTED);
+
+	f.dn0_cfg.ctrl = PCI_ACS_UF;
+	f.rootport_cfg.ctrl = 0;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+static void acs_walk_mf_translation_blocking_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+	unsigned int flags;
+
+	acs_build_mf_fabric(test, &f);
+	f.provider_leaf->acs_capabilities |= PCI_ACS_TB;
+	f.provider_leaf_cfg.ctrl |= PCI_ACS_TB;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++)
+		KUNIT_EXPECT_EQ_MSG(test, acs_walk_map(&f, flags),
+				    flags & PCI_P2PDMA_TLP_TRANSLATED ?
+				    PCI_P2PDMA_MAP_NOT_SUPPORTED :
+				    PCI_P2PDMA_MAP_THRU_HOST_BRIDGE,
+				    "TLP flags %#x", flags);
+}
+
+static void acs_walk_mf_unlisted_host_test(struct kunit *test)
+{
+	struct acs_fabric f = {}, g = {};
+	int dist;
+
+	acs_build_mf_fabric(test, &f);
+	acs_build_fabric(test, &g);
+	f.rootport->vendor = 0;
+	g.rootport->vendor = 0;
+	/* Some CPUs permit host routing regardless of the host allowlist. */
+	if (calc_map_type_and_dist(f.provider, g.client, &dist, 0, false) ==
+	    PCI_P2PDMA_MAP_THRU_HOST_BRIDGE)
+		kunit_skip(test, "CPU supports P2PDMA on unlisted hosts");
+
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+static void acs_walk_mf_ari_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_mf_fabric(test, &f);
+	f.provider->bus->self->ari_enabled = 1;
+	f.client->devfn = 8;
+	f.client->multifunction = 0;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	/* The same shared-link topology can be directly below a Root Port. */
+	f.provider->bus->parent = f.rootport->bus;
+	f.provider->bus->self = f.rootport;
+	f.rootport->ari_enabled = 1;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+}
+
+static void acs_walk_mf_vf_test(struct kunit *test)
+{
+#ifdef CONFIG_PCI_IOV
+	struct acs_fabric f = {};
+	struct pci_dev *physfn;
+
+	acs_build_mf_fabric(test, &f);
+	physfn = acs_add_dev(test, f.provider->bus, PCI_DEVFN(0, 0),
+			     PCI_EXP_TYPE_ENDPOINT);
+	physfn->is_physfn = 1;
+	physfn->acs_cap = ACS_TEST_CAP;
+	physfn->acs_capabilities = ACS_ALL_CAPS;
+	f.provider->devfn = 1;
+	f.client->devfn = 8;
+	f.provider->bus->self->ari_enabled = 1;
+	f.provider->multifunction = 0;
+	f.client->multifunction = 0;
+	f.provider->is_virtfn = 1;
+	f.client->is_virtfn = 1;
+	f.provider->physfn = physfn;
+	f.client->physfn = physfn;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	/* SR-IOV functions without ACS cannot route internally either. */
+	f.provider->acs_cap = 0;
+	f.client->acs_cap = 0;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+
+	/* Check the physical function as the peer of one of its VFs. */
+	f.provider->is_virtfn = 0;
+	f.provider->physfn = NULL;
+	f.provider->is_physfn = 1;
+	f.client->physfn = f.provider;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+#else
+	kunit_skip(test, "needs CONFIG_PCI_IOV");
+#endif
+}
+
+static void acs_walk_mf_external_peer_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+
+	acs_build_fabric(test, &f);
+	f.provider->multifunction = 1;
+	f.client->multifunction = 1;
+	f.provider->acs_cap = ACS_TEST_CAP;
+	f.client->acs_cap = ACS_TEST_CAP;
+	acs_expect_classes(test, &f, PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+static void acs_walk_mf_self_dma_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+	unsigned int flags;
+	int dist;
+
+	acs_build_mf_fabric(test, &f);
+	f.provider_leaf->acs_capabilities = PCI_ACS_TB;
+	f.provider_leaf_cfg.ctrl = PCI_ACS_TB;
+	for (flags = 0; flags < PCI_P2PDMA_TLP_CLASSES; flags++) {
+		KUNIT_EXPECT_EQ(test,
+				calc_map_type_and_dist(f.client, f.client, &dist,
+						       flags, false),
+				PCI_P2PDMA_MAP_BUS_ADDR);
+		KUNIT_EXPECT_EQ(test, dist, 0);
+	}
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
+/*
+ * The provider can be an ancestor of the client, which leaves no divergence
+ * to evaluate. Translation Blocking still applies to every port the Request
+ * passes on its way up.
+ */
+static void acs_walk_ancestor_provider_tb_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+	int dist;
+
+	acs_build_fabric(test, &f);
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.dn1, f.client, &dist, 0,
+					       false),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.dn1, f.client, &dist,
+					       PCI_P2PDMA_TLP_TRANSLATED,
+					       false),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+/*
+ * Without a common upstream bridge the Request still climbs towards the host
+ * bridge, so Translation Blocking on the way withdraws the Translated classes
+ * there too.
+ */
+static void acs_walk_no_common_bridge_tb_test(struct kunit *test)
+{
+	struct acs_fabric f = {}, g = {};
+	int dist;
+
+	acs_build_fabric(test, &f);
+	acs_build_fabric(test, &g);
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(g.provider, f.client, &dist, 0,
+					       false),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(g.provider, f.client, &dist,
+					       PCI_P2PDMA_TLP_TRANSLATED,
+					       false),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
+}
+
+/*
+ * A Request between the client and itself never leaves the device, so no port
+ * is in a position to inspect its Address Type. Translation Blocking directly
+ * above the client must not withdraw the Translated classes.
+ */
+static void acs_walk_self_dma_tb_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+	int dist;
+
+	acs_build_fabric(test, &f);
+	f.client_leaf->acs_cap = 0x100;
+	f.client_leaf->acs_capabilities = PCI_ACS_TB;
+	f.client_leaf_cfg.ctrl = PCI_ACS_TB;
+
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.client, f.client, &dist, 0,
+					       false),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.client, f.client, &dist,
+					       PCI_P2PDMA_TLP_TRANSLATED,
+					       false),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+}
+
+/*
+ * A direct route turns around at the divergence, so Translation Blocking above
+ * it does not touch one. The host bridge route keeps climbing past that port,
+ * and the Translated classes have to go without it.
+ */
+static void acs_walk_tb_above_divergence_test(struct kunit *test)
+{
+	struct acs_fabric f = {};
+	int dist;
+
+	acs_build_fabric(test, &f);
+	f.rootport->acs_cap = 0x100;
+	f.rootport->acs_capabilities = PCI_ACS_TB;
+	f.rootport_cfg.ctrl = PCI_ACS_TB;
+
+	/* Nothing redirects yet, so the Request never reaches the Root Port. */
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.provider, f.client, &dist,
+					       PCI_P2PDMA_TLP_TRANSLATED,
+					       false),
+			PCI_P2PDMA_MAP_BUS_ADDR);
+
+	/* Request Redirect sends it up past the Root Port instead. */
+	f.dn1->acs_cap = 0x100;
+	f.dn1->acs_capabilities = PCI_ACS_RR;
+	f.dn1_cfg.ctrl = PCI_ACS_RR;
+
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.provider, f.client, &dist, 0,
+					       false),
+			PCI_P2PDMA_MAP_THRU_HOST_BRIDGE);
+	KUNIT_EXPECT_EQ(test,
+			calc_map_type_and_dist(f.provider, f.client, &dist,
+					       PCI_P2PDMA_TLP_TRANSLATED,
+					       false),
+			PCI_P2PDMA_MAP_NOT_SUPPORTED);
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
+
+	/* A port that does not answer reads as all ones, without an error */
+	f.dn1_cfg.fail_read = false;
+	f.dn1_cfg.ctrl = 0xffff;
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
+	KUNIT_CASE(acs_walk_quirk_redirect_test),
+	KUNIT_CASE(acs_walk_asymmetric_direct_test),
+	KUNIT_CASE(acs_walk_nested_completion_redirect_test),
+	KUNIT_CASE(acs_walk_nested_request_redirect_test),
+	KUNIT_CASE(acs_walk_translation_blocking_test),
+	KUNIT_CASE(acs_walk_ancestor_provider_tb_test),
+	KUNIT_CASE(acs_walk_no_common_bridge_tb_test),
+	KUNIT_CASE(acs_walk_self_dma_tb_test),
+	KUNIT_CASE(acs_walk_relaxed_completion_test),
+	KUNIT_CASE(acs_walk_direct_translated_test),
+	KUNIT_CASE(acs_walk_mf_isolation_test),
+	KUNIT_CASE(acs_walk_mf_quirk_test),
+	KUNIT_CASE(acs_walk_mf_direction_test),
+	KUNIT_CASE(acs_walk_mf_programmable_test),
+	KUNIT_CASE_PARAM(acs_walk_mf_forwarding_test, acs_forwarding_gen_params),
+	KUNIT_CASE(acs_walk_mf_upstream_forwarding_test),
+	KUNIT_CASE(acs_walk_mf_translation_blocking_test),
+	KUNIT_CASE(acs_walk_mf_unlisted_host_test),
+	KUNIT_CASE(acs_walk_mf_ari_test),
+	KUNIT_CASE(acs_walk_mf_vf_test),
+	KUNIT_CASE(acs_walk_mf_external_peer_test),
+	KUNIT_CASE(acs_walk_mf_self_dma_test),
+	KUNIT_CASE(acs_walk_tb_above_divergence_test),
+	KUNIT_CASE(acs_walk_unreadable_control_test),
+	KUNIT_CASE(acs_map_types_pack_test),
 	{}
 };
 

-- 
2.55.0

