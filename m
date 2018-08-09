From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 8/9] net/mlx5: Do not call pcie_print_link_status()
Date: Thu, 9 Aug 2018 09:02:55 -0500
Message-ID: <20180809140255.GG49411@bhelgaas-glaptop.roam.corp.google.com>
References: <CAErSpo4PK+SQLNfdkLNt9eLc7bpbxbkZCsa8T-tQpid601n0SQ@mail.gmail.com>
 <20180806232600.25694-1-mr.nuke.me@gmail.com>
 <20180806232600.25694-8-mr.nuke.me@gmail.com>
 <20180808060848.GQ13378@mtr-leonro.mtl.com>
 <05056a70-ee78-ea3c-0b9b-6d64a8663b11@mellanox.com>
 <20180808154142.GZ13378@mtr-leonro.mtl.com>
 <5578cd9a-e4f0-85ab-4a86-bfa23eec136c@mellanox.com>
 <79264a38-e3e4-d270-95df-a09047f7a15e@gmail.com>
 <20180808172736.GB13378@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180808172736.GB13378@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "Alex G." <mr.nuke.me@gmail.com>, Tal Gilboa <talgi@mellanox.com>, linux-pci@vger.kernel.org, bhelgaas@google.com, jakub.kicinski@netronome.com, keith.busch@intel.com, alex_gagniuc@dellteam.com, austin_bolen@dell.com, shyam_iyer@dell.com, Ariel Elior <ariel.elior@cavium.com>, everest-linux-l2@cavium.com, "David S. Miller" <davem@davemloft.net>, Michael Chan <michael.chan@broadcom.com>, Ganesh Goudar <ganeshgr@chelsio.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 08, 2018 at 08:27:36PM +0300, Leon Romanovsky wrote:
> On Wed, Aug 08, 2018 at 11:33:51AM -0500, Alex G. wrote:
> >
> >
> > On 08/08/2018 10:56 AM, Tal Gilboa wrote:
> > > On 8/8/2018 6:41 PM, Leon Romanovsky wrote:
> > > > On Wed, Aug 08, 2018 at 05:23:12PM +0300, Tal Gilboa wrote:
> > > > > On 8/8/2018 9:08 AM, Leon Romanovsky wrote:
> > > > > > On Mon, Aug 06, 2018 at 06:25:42PM -0500, Alexandru Gagniuc wrote:
> > > > > > > This is now done by the PCI core to warn of sub-optimal bandwidth.
> > > > > > >
> > > > > > > Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
> > > > > > > ---
> > > > > > >    drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
> > > > > > >    1 file changed, 4 deletions(-)
> > > > > > >
> > > > > >
> > > > > > Thanks,
> > > > > > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> > > > > >
> > > > >
> > > > > Alex,
> > > > > I loaded mlx5 driver with and without these series. The report
> > > > > in dmesg is
> > > > > now missing. From what I understood, the status should be
> > > > > reported at least
> > > > > once, even if everything is in order.
> > > >
> > > > It is not what this series is doing and it removes prints completely if
> > > > fabric can deliver more than card is capable.
> > > >
> > > > > We need this functionality to stay.
> > > >
> > > > I'm not sure that you need this information in driver's dmesg output,
> > > > but most probably something globally visible and accessible per-pci
> > > > device.
> > >
> > > Currently we have users that look for it. If we remove the dmesg print
> > > we need this to be reported elsewhere. Adding it to sysfs for example
> > > should be a valid solution for our case.
> >
> > I think a stop-gap measure is to leave the pcie_print_link_status() call in
> > drivers that really need it for whatever reason. Implementing a reliable
> > reporting through sysfs might take some tinkering, and I don't think it's a
> > sufficient reason to block the heart of this series -- being able to detect
> > bottlenecks and link downtraining.
> 
> IMHO, you did right change and it is better to replace this print to some
> more generic solution now while you are doing it and don't leave leftovers.

I'd like to make forward progress on this, so I propose we merge only
the PCI core change (patch 1/9) and drop the individual driver
changes.  That would mean:

  - We'll get a message from every NIC driver that calls
    pcie_print_link_status() as before.

  - We'll get a new message from the core for every downtrained link.

  - If a link leading to the NIC is downtrained, there will be
    duplicate messages.  Maybe that's overkill but it's not terrible.

I provisionally put the patch below on my pci/enumeration branch.
Objections?


commit c870cc8cbc4d79014f3daa74d1e412f32e42bf1b
Author: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Date:   Mon Aug 6 18:25:35 2018 -0500

    PCI: Check for PCIe Link downtraining
    
    When both ends of a PCIe Link are capable of a higher bandwidth than is
    currently in use, the Link is said to be "downtrained".  A downtrained Link
    may indicate hardware or configuration problems in the system, but it's
    hard to identify such Links from userspace.
    
    Refactor pcie_print_link_status() so it continues to always print PCIe
    bandwidth information, as several NIC drivers desire.
    
    Add a new internal __pcie_print_link_status() to emit a message only when a
    device's bandwidth is constrained by the fabric and call it from the PCI
    core for all devices, which identifies all downtrained Links.  It also
    emits messages for a few cases that are technically not downtrained, such
    as a x4 device in an open-ended x1 slot.
    
    Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
    [bhelgaas: changelog, move __pcie_print_link_status() declaration to
    drivers/pci/, rename pcie_check_upstream_link() to
    pcie_report_downtraining()]
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 97acba712e4e..a84d341504a5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5264,14 +5264,16 @@ u32 pcie_bandwidth_capable(struct pci_dev *dev, enum pci_bus_speed *speed,
 }
 
 /**
- * pcie_print_link_status - Report the PCI device's link speed and width
+ * __pcie_print_link_status - Report the PCI device's link speed and width
  * @dev: PCI device to query
+ * @verbose: Print info even when enough bandwidth is available
  *
- * Report the available bandwidth at the device.  If this is less than the
- * device is capable of, report the device's maximum possible bandwidth and
- * the upstream link that limits its performance to less than that.
+ * If the available bandwidth at the device is less than the device is
+ * capable of, report the device's maximum possible bandwidth and the
+ * upstream link that limits its performance.  If @verbose, always print
+ * the available bandwidth, even if the device isn't constrained.
  */
-void pcie_print_link_status(struct pci_dev *dev)
+void __pcie_print_link_status(struct pci_dev *dev, bool verbose)
 {
 	enum pcie_link_width width, width_cap;
 	enum pci_bus_speed speed, speed_cap;
@@ -5281,11 +5283,11 @@ void pcie_print_link_status(struct pci_dev *dev)
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
@@ -5293,6 +5295,17 @@ void pcie_print_link_status(struct pci_dev *dev)
 			 bw_cap / 1000, bw_cap % 1000,
 			 PCIE_SPEED2STR(speed_cap), width_cap);
 }
+
+/**
+ * pcie_print_link_status - Report the PCI device's link speed and width
+ * @dev: PCI device to query
+ *
+ * Report the available bandwidth at the device.
+ */
+void pcie_print_link_status(struct pci_dev *dev)
+{
+	__pcie_print_link_status(dev, true);
+}
 EXPORT_SYMBOL(pcie_print_link_status);
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 70808c168fb9..ce880dab5bc8 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -263,6 +263,7 @@ enum pci_bus_speed pcie_get_speed_cap(struct pci_dev *dev);
 enum pcie_link_width pcie_get_width_cap(struct pci_dev *dev);
 u32 pcie_bandwidth_capable(struct pci_dev *dev, enum pci_bus_speed *speed,
 			   enum pcie_link_width *width);
+void __pcie_print_link_status(struct pci_dev *dev, bool verbose);
 
 /* Single Root I/O Virtualization */
 struct pci_sriov {
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bc147c586643..387fc8ac54ec 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2231,6 +2231,25 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	return dev;
 }
 
+static void pcie_report_downtraining(struct pci_dev *dev)
+{
+	if (!pci_is_pcie(dev))
+		return;
+
+	/* Look from the device up to avoid downstream ports with no devices */
+	if ((pci_pcie_type(dev) != PCI_EXP_TYPE_ENDPOINT) &&
+	    (pci_pcie_type(dev) != PCI_EXP_TYPE_LEG_END) &&
+	    (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM))
+		return;
+
+	/* Multi-function PCIe devices share the same link/status */
+	if (PCI_FUNC(dev->devfn) != 0 || dev->is_virtfn)
+		return;
+
+	/* Print link status only if the device is constrained by the fabric */
+	__pcie_print_link_status(dev, false);
+}
+
 static void pci_init_capabilities(struct pci_dev *dev)
 {
 	/* Enhanced Allocation */
@@ -2266,6 +2285,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	/* Advanced Error Reporting */
 	pci_aer_init(dev);
 
+	pcie_report_downtraining(dev);
+
 	if (pci_probe_reset_function(dev) == 0)
 		dev->reset_fn = 1;
 }
