From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 2/2] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Mon, 06 Feb 2017 11:15:33 -0800
Message-ID: <148640853387.13713.5705865367460168894.stgit@tstruk-mobl1.ra.intel.com>
References: <148640852878.13713.11121939459524566022.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148640852878.13713.11121939459524566022.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: jgunthorpe@obsidianresearch.com, tadeusz.struk@intel.com, linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, dledford@redhat.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

Some hardware has multiple HFIs within the same ASIC, each one on a
sepatate bus number. In some devices the numbers labeled on the
faceplate of the device don't match the PCI bus order, and the result
is that the devices (ports) are probed in the opposite order of their
port numbers. The result is IB device unit numbers are in reverse order
from the faceplate numbering. This leads to confusion, and errors.
Use EPROBE_DEFER error code to enforce correct port order.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/infiniband/hw/hfi1/chip.c |   95 ++++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/chip.h |    2 -
 drivers/infiniband/hw/hfi1/init.c |    1 
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ef72bc2..45beeae 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14365,6 +14365,79 @@ static int check_int_registers(struct hfi1_devdata *dd)
 	return -EINVAL;
 }
 
+struct deferred_dev {
+	struct list_head list;
+	u64 guid;
+	u32 bdf;
+	bool deferred;
+};
+
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_list_lock); /* protects device_list */
+#define HFI_ASIC_GUID(guid) ((guid) & ~(1ULL << GUID_HFI_INDEX_SHIFT))
+
+static int hfi1_need_defer(struct hfi1_devdata *dd)
+{
+	struct deferred_dev *def_dev = NULL;
+	struct pci_dev *pdev = dd->pcidev;
+	static bool deferred;
+	static u64 deferred_guid;
+	bool found_deferred = false;
+
+	mutex_lock(&device_list_lock);
+	/* Try to find an re-probed device first based on the BDF address */
+	list_for_each_entry(def_dev, &device_list, list) {
+		if (def_dev->bdf == (pdev->bus->number << 8 | pdev->devfn)) {
+			found_deferred = true;
+			break;
+		}
+	}
+
+	/* If not found then allocate one */
+	if (!found_deferred) {
+		def_dev = kzalloc(sizeof(*def_dev), GFP_KERNEL);
+
+		if (!def_dev) {
+			mutex_unlock(&device_list_lock);
+			return -ENOMEM;
+		}
+
+		def_dev->guid = dd->base_guid;
+		def_dev->bdf = pdev->bus->number << 8 | pdev->devfn;
+		def_dev->deferred = false;
+		list_add_tail(&def_dev->list, &device_list);
+	}
+
+	/*
+	 * If device has been already deferred we need to wait for the other
+	 * port and defer other devices until we get to the other port or
+	 * back the same device
+	 */
+	if (deferred && (HFI_ASIC_GUID(deferred_guid) != dd->base_guid) &&
+	    !def_dev->deferred) {
+		def_dev->deferred = true;
+		mutex_unlock(&device_list_lock);
+		return -EPROBE_DEFER;
+	} else if (!deferred && ((dd->base_guid >> GUID_HFI_INDEX_SHIFT) & 1)) {
+		/*
+		 * If no device is currently deferred check by guid if we need
+		 * to defer this one and if so store the deferred guid to find
+		 * the sister port by the guid
+		 */
+		deferred = true;
+		def_dev->deferred = true;
+		deferred_guid = dd->base_guid;
+		mutex_unlock(&device_list_lock);
+		return -EPROBE_DEFER;
+	}
+
+	deferred = false;
+	def_dev->deferred = false;
+	mutex_unlock(&device_list_lock);
+
+	return 0;
+}
+
 /**
  * Allocate and initialize the device structure for the hfi.
  * @dev: the pci_dev for hfi1_ib device
@@ -14456,6 +14529,13 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret < 0)
 		goto bail_free;
 
+	/* needs to be done before we look for the peer device */
+	read_guid(dd);
+
+	ret = hfi1_need_defer(dd);
+	if (ret)
+		goto bail_cleanup;
+
 	/* verify that reads actually work, save revision for reset check */
 	dd->revision = read_csr(dd, CCE_REVISION);
 	if (dd->revision == ~(u64)0) {
@@ -14539,9 +14619,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	else if (dd->rcv_intr_timeout_csr == 0 && rcv_intr_timeout)
 		dd->rcv_intr_timeout_csr = 1;
 
-	/* needs to be done before we look for the peer device */
-	read_guid(dd);
-
 	/* set up shared ASIC data with peer device */
 	ret = init_asic_data(dd);
 	if (ret)
@@ -14702,6 +14779,18 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	return dd;
 }
 
+void hfi1_device_list_cleanup(void)
+{
+	struct deferred_dev *dev, *tmp;
+
+	mutex_lock(&device_list_lock);
+	list_for_each_entry_safe(dev, tmp, &device_list, list) {
+		list_del(&dev->list);
+		kfree(dev);
+	}
+	mutex_unlock(&device_list_lock);
+}
+
 static u16 delay_cycles(struct hfi1_pportdata *ppd, u32 desired_egress_rate,
 			u32 dw_len)
 {
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 043fd21..3971b6d 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1358,7 +1358,7 @@ int hfi1_clear_ctxt_jkey(struct hfi1_devdata *dd, unsigned ctxt);
 int hfi1_set_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt, u16 pkey);
 int hfi1_clear_ctxt_pkey(struct hfi1_devdata *dd, unsigned ctxt);
 void hfi1_read_link_quality(struct hfi1_devdata *dd, u8 *link_quality);
-
+void hfi1_device_list_cleanup(void);
 /*
  * Interrupt source table.
  *
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e3b5bc9..ae6160d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1298,6 +1298,7 @@ static void __exit hfi1_mod_cleanup(void)
 	idr_destroy(&hfi1_unit_table);
 	dispose_firmware();	/* asymmetric with obtain_firmware() */
 	dev_cleanup();
+	hfi1_device_list_cleanup();
 }
 
 module_exit(hfi1_mod_cleanup);
