From: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Subject: [PATCH v6 1/9] PCI: Check for PCIe downtraining conditions
Date: Mon,  6 Aug 2018 18:25:35 -0500
Message-ID: <20180806232600.25694-1-mr.nuke.me@gmail.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com
Cc: keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Alexandru Gagniuc <mr.nuke.me@gmail.com>, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

PCIe downtraining happens when both the device and PCIe port are
capable of a larger bus width or higher speed than negotiated.
Downtraining might be indicative of other problems in the system, and
identifying this from userspace is neither intuitive, nor
straightforward.

The easiest way to detect this is with pcie_print_link_status(),
since the bottleneck is usually the link that is downtrained. It's not
a perfect solution, but it works extremely well in most cases.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
---
 drivers/pci/pci.c   | 22 ++++++++++++++++++----
 drivers/pci/probe.c | 21 +++++++++++++++++++++
 include/linux/pci.h |  1 +
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 316496e99da9..414ad7b3abdb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5302,14 +5302,15 @@ u32 pcie_bandwidth_capable(struct pci_dev *dev, enum pci_bus_speed *speed,
 }
 
 /**
- * pcie_print_link_status - Report the PCI device's link speed and width
+ * __pcie_print_link_status - Report the PCI device's link speed and width
  * @dev: PCI device to query
+ * @verbose: Be verbose -- print info even when enough bandwidth is available.
  *
  * Report the available bandwidth at the device.  If this is less than the
  * device is capable of, report the device's maximum possible bandwidth and
  * the upstream link that limits its performance to less than that.
  */
-void pcie_print_link_status(struct pci_dev *dev)
+void __pcie_print_link_status(struct pci_dev *dev, bool verbose)
 {
 	enum pcie_link_width width, width_cap;
 	enum pci_bus_speed speed, speed_cap;
@@ -5319,11 +5320,11 @@ void pcie_print_link_status(struct pci_dev *dev)
 	bw_cap = pcie_bandwidth_capable(dev, &speed_cap, &width_cap);
 	bw_avail = pcie_bandwidth_available(dev, &limiting_dev, &speed, &width);
 
-	if (bw_avail >= bw_cap)
+	if (bw_avail >= bw_cap && verbose)
 		pci_info(dev, "%u.%03u Gb/s available PCIe bandwidth (%s x%d link)\n",
 			 bw_cap / 1000, bw_cap % 1000,
 			 PCIE_SPEED2STR(speed_cap), width_cap);
-	else
+	else if (bw_avail < bw_cap)
 		pci_info(dev, "%u.%03u Gb/s available PCIe bandwidth, limited by %s x%d link at %s (capable of %u.%03u Gb/s with %s x%d link)\n",
 			 bw_avail / 1000, bw_avail % 1000,
 			 PCIE_SPEED2STR(speed), width,
@@ -5331,6 +5332,19 @@ void pcie_print_link_status(struct pci_dev *dev)
 			 bw_cap / 1000, bw_cap % 1000,
 			 PCIE_SPEED2STR(speed_cap), width_cap);
 }
+
+/**
+ * pcie_print_link_status - Report the PCI device's link speed and width
+ * @dev: PCI device to query
+ *
+ * Report the available bandwidth at the device.  If this is less than the
+ * device is capable of, report the device's maximum possible bandwidth and
+ * the upstream link that limits its performance to less than that.
+ */
+void pcie_print_link_status(struct pci_dev *dev)
+{
+	__pcie_print_link_status(dev, true);
+}
 EXPORT_SYMBOL(pcie_print_link_status);
 
 /**
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 611adcd9c169..1c8c26dd2cb2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2205,6 +2205,24 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	return dev;
 }
 
+static void pcie_check_upstream_link(struct pci_dev *dev)
+{
+	if (!pci_is_pcie(dev))
+		return;
+
+	/* Look from the device up to avoid downstream ports with no devices. */
+	if ((pci_pcie_type(dev) != PCI_EXP_TYPE_ENDPOINT) &&
+	    (pci_pcie_type(dev) != PCI_EXP_TYPE_LEG_END) &&
+	    (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM))
+		return;
+
+	/* Multi-function PCIe share the same link/status. */
+	if (PCI_FUNC(dev->devfn) != 0 || dev->is_virtfn)
+		return;
+
+	__pcie_print_link_status(dev, false);
+}
+
 static void pci_init_capabilities(struct pci_dev *dev)
 {
 	/* Enhanced Allocation */
@@ -2240,6 +2258,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	/* Advanced Error Reporting */
 	pci_aer_init(dev);
 
+	/* Check link and detect downtrain errors */
+	pcie_check_upstream_link(dev);
+
 	if (pci_probe_reset_function(dev) == 0)
 		dev->reset_fn = 1;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c133ccfa002e..d212de231259 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1087,6 +1087,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
 u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
 			     enum pci_bus_speed *speed,
 			     enum pcie_link_width *width);
+void __pcie_print_link_status(struct pci_dev *dev, bool verbose);
 void pcie_print_link_status(struct pci_dev *dev);
 int pcie_flr(struct pci_dev *dev);
 int __pci_reset_function_locked(struct pci_dev *dev);
-- 
2.17.1
