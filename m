From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport device
Date: Tue, 10 Jan 2017 15:57:52 -0800
Message-ID: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com, tadeusz.struk@intel.com
List-Id: linux-rdma@vger.kernel.org

Some hardware have multiple HFIs within the same ASIC. In some devices the
numbers labeled on the faceplate of the device don't match the PCI bus
order, and the result is that the devices (ports) are probed in the opposite
order of their port numbers. The result is IB device unit numbers are in
reverse order from the faceplate numbering. This leads to confusion, and
errors.
We can fix this by enforcing the correct port order at module load time.
To reorder the ports to match the numbering labels on the back of the
device we need to delay registering devices with the ib_core until we
receive a probe for the affected devices, reorder them and start
initialization in the correct order later. We use a timer with 1 second
timeout. On hfi1 probes devices are ordered and stored in a list.
Each hfi1 probe updates the timer. When the timer timeouts all devices are
initialized and registered with ib_core in the right order.
When there will more than one second time gap between hfi1 probes,
the timer will be update in each call so there is no danger that a device
will be "missed".

A new module param called port_reorder is introduced to cover users, who
already prewired their clusters in the 'invalid' order. The default
behavior does not change and results in devices ordered in the PCI bus
order. Port_reorder=1 is used to apply special reordering to these devices.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/infiniband/hw/hfi1/chip.c |    3 -
 drivers/infiniband/hw/hfi1/chip.h |    4 +
 drivers/infiniband/hw/hfi1/init.c |  170 +++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ef72bc2..d9aadac 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -129,9 +129,6 @@ struct flag_table {
 #define NUM_MAP_ENTRIES		256
 #define NUM_MAP_REGS             32
 
-/* Bit offset into the GUID which carries HFI id information */
-#define GUID_HFI_INDEX_SHIFT     39
-
 /* extract the emulation revision */
 #define emulator_rev(dd) ((dd)->irev >> 8)
 /* parallel and serial emulation versions are 3 and 4 respectively */
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 043fd21..aa322b0 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -575,6 +575,10 @@ enum {
 #define LOOPBACK_LCB	2
 #define LOOPBACK_CABLE	3	/* external cable */
 
+/* Bit offset into the GUID which carries HFI id information */
+#define GUID_HFI_INDEX_SHIFT     39
+#define HFI_ASIC_GUID(guid) ((guid) & ~(1ULL << GUID_HFI_INDEX_SHIFT))
+
 /* read and write hardware registers */
 u64 read_csr(const struct hfi1_devdata *dd, u32 offset);
 void write_csr(const struct hfi1_devdata *dd, u32 offset, u64 value);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e3b5bc9..93436bd 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -116,12 +116,29 @@ unsigned int user_credit_return_threshold = 33;	/* default is 33% */
 module_param(user_credit_return_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(user_credit_return_threshold, "Credit return threshold for user send contexts, return when unreturned credits passes this many blocks (in percent of allocated blocks, 0 is off)");
 
+static bool port_reorder;
+module_param(port_reorder, bool, S_IRUGO);
+MODULE_PARM_DESC(port_reorder, "Device port reorder: 1 - order HFIs on the same ASIC in increasing port order, or 0 - order exactly as the kernel enumerates (default)");
+
 static inline u64 encode_rcv_header_entry_size(u16);
 
 static struct idr hfi1_unit_table;
 u32 hfi1_cpulist_count;
 unsigned long *hfi1_cpulist;
 
+struct hfi1_init_dev {
+	struct list_head list;
+	struct pci_dev *pdev;
+	const struct pci_device_id *ent;
+	u64 guid;
+};
+
+static struct timer_list init_timer;
+static LIST_HEAD(init_list);
+static DEFINE_MUTEX(init_mutex); /* protects init_list */
+static struct workqueue_struct *hfi1_init_wq;
+static void hfi1_deferred_init(struct work_struct *work);
+
 /*
  * Common code for creating the receive context array.
  */
@@ -1165,6 +1182,7 @@ void hfi1_disable_after_error(struct hfi1_devdata *dd)
 
 static void remove_one(struct pci_dev *);
 static int init_one(struct pci_dev *, const struct pci_device_id *);
+static void hfi1_probe_done(unsigned long data);
 
 #define DRIVER_LOAD_MSG "Intel " DRIVER_NAME " loaded: "
 #define PFX DRIVER_NAME ": "
@@ -1209,6 +1227,16 @@ static int __init hfi1_mod_init(void)
 	if (ret)
 		goto bail;
 
+	if (port_reorder) {
+		hfi1_init_wq = alloc_workqueue("hfi1_init_wq", WQ_MEM_RECLAIM,
+					       0);
+		if (!hfi1_init_wq) {
+			pr_err("Failed to create deffered dev init wq\n");
+			ret = -ENOMEM;
+			goto bail;
+		}
+	}
+
 	/* validate max MTU before any devices start */
 	if (!valid_opa_max_mtu(hfi1_max_mtu)) {
 		pr_err("Invalid max_mtu 0x%x, using 0x%x instead\n",
@@ -1264,6 +1292,9 @@ static int __init hfi1_mod_init(void)
 	ret = hfi1_wss_init();
 	if (ret < 0)
 		goto bail_wss;
+
+	setup_timer(&init_timer, hfi1_probe_done, 0);
+
 	ret = pci_register_driver(&hfi1_pci_driver);
 	if (ret < 0) {
 		pr_err("Unable to register driver: error %d\n", -ret);
@@ -1288,6 +1319,8 @@ module_init(hfi1_mod_init);
  */
 static void __exit hfi1_mod_cleanup(void)
 {
+	struct hfi1_init_dev *pos, *tmp;
+
 	pci_unregister_driver(&hfi1_pci_driver);
 	node_affinity_destroy();
 	hfi1_wss_exit();
@@ -1298,6 +1331,18 @@ static void __exit hfi1_mod_cleanup(void)
 	idr_destroy(&hfi1_unit_table);
 	dispose_firmware();	/* asymmetric with obtain_firmware() */
 	dev_cleanup();
+
+	mutex_lock(&init_mutex);
+	list_for_each_entry_safe(pos, tmp, &init_list, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+	mutex_unlock(&init_mutex);
+	del_timer(&init_timer);
+	if (hfi1_init_wq) {
+		destroy_workqueue(hfi1_init_wq);
+		hfi1_init_wq = NULL;
+	}
 }
 
 module_exit(hfi1_mod_cleanup);
@@ -1415,7 +1460,7 @@ static int init_validate_rcvhdrcnt(struct device *dev, uint thecnt)
 	return 0;
 }
 
-static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int do_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret = 0, j, pidx, initfail;
 	struct hfi1_devdata *dd;
@@ -1545,6 +1590,129 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 }
 
+static void hfi1_deferred_init(struct work_struct *work)
+{
+	struct hfi1_init_dev *pos, *tmp;
+	int ret;
+
+	mutex_lock(&init_mutex);
+	list_for_each_entry_safe(pos, tmp, &init_list, list) {
+		ret = do_init_one(pos->pdev, pos->ent);
+		if (ret)
+			hfi1_early_err(&pos->pdev->dev, "%s: dev init failed, err %d\n",
+				       __func__, ret);
+
+		list_del(&pos->list);
+		kfree(pos);
+	}
+	mutex_unlock(&init_mutex);
+	kfree(work);
+}
+
+static void hfi1_probe_done(unsigned long data)
+{
+	struct work_struct *work;
+
+	if (!hfi1_init_wq)
+		return;
+
+	/* Got probe for all devices. Now invoke hfi1_deferred_init */
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return;
+
+	INIT_WORK(work, hfi1_deferred_init);
+	queue_work(hfi1_init_wq, work);
+}
+
+static int get_guid(struct pci_dev *pdev, u64 *guid)
+{
+	void __iomem *bar;
+
+	bar = ioremap_nocache(pci_resource_start(pdev, 0),
+			      DC_DC8051_CFG_LOCAL_GUID + 8);
+	if (!bar) {
+		hfi1_early_err(&pdev->dev, "%s: unable to ioremap bar\n",
+			       __func__);
+		return -ENOMEM;
+	}
+	/* make sure the DC is not in reset so the GUID is readable */
+	writeq(0ull, bar + CCE_DC_CTRL);
+	(void)readq(bar + CCE_DC_CTRL); /* force the write */
+
+	/* read device guid */
+	*guid = readq(bar + DC_DC8051_CFG_LOCAL_GUID);
+	iounmap(bar);
+	return 0;
+}
+
+static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct hfi1_init_dev *probed_pdev;
+	struct hfi1_init_dev *pos;
+	u64 guid;
+	int ret;
+
+	if (!port_reorder)
+		return do_init_one(pdev, ent);
+
+	probed_pdev = kzalloc(sizeof(*probed_pdev), GFP_KERNEL);
+	if (!probed_pdev)
+		return -ENOMEM;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		hfi1_early_err(&pdev->dev, "%s: cannot enable device, err %d\n",
+			       __func__, ret);
+		goto fail;
+	}
+
+	ret = get_guid(pdev, &guid);
+	if (ret)
+		goto fail_get_guid;
+
+	probed_pdev->pdev = pdev;
+	probed_pdev->ent = ent;
+	probed_pdev->guid = guid;
+
+	mutex_lock(&init_mutex);
+	if (list_empty(&init_list)) {
+		list_add_tail(&probed_pdev->list, &init_list);
+	} else {
+		list_for_each_entry(pos, &init_list, list)
+			if (HFI_ASIC_GUID(pos->guid) == HFI_ASIC_GUID(guid))
+				break;
+
+		/* Match found, pos and entry are valid */
+		if (pos->guid == probed_pdev->guid) {
+			/* Something wrong - same hardware id */
+			hfi1_early_err(&pdev->dev, "%s: duplicate guid 0x%llx\n",
+				       __func__, guid);
+			mutex_unlock(&init_mutex);
+			goto fail_get_guid;
+		}
+
+		/*
+		 * Order around the first of the pair that was enumerated.
+		 * Insert before or after the one already in the list.
+		 */
+		if ((pos->guid >> GUID_HFI_INDEX_SHIFT) & 1)
+			list_add_tail(&probed_pdev->list, &pos->list);
+		else
+			list_add(&probed_pdev->list, &pos->list);
+	}
+	mutex_unlock(&init_mutex);
+	mod_timer(&init_timer, jiffies + msecs_to_jiffies(1000));
+	pci_disable_device(pdev);
+	return 0;
+
+fail_get_guid:
+	pci_disable_device(pdev);
+fail:
+	kfree(probed_pdev);
+	return ret;
+}
+
 static void wait_for_clients(struct hfi1_devdata *dd)
 {
 	/*
