From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-next 1/3] RDMA/hns: Fix the Oops during rmmod or insmod ko when reset occurs
Date: Sat, 19 Jan 2019 11:36:05 +0800
Message-ID: <1547868967-115951-2-git-send-email-xavier.huwei@huawei.com>
References: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547868967-115951-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

In the reset process, the hns3 NIC driver notifies the RoCE driver
to perform reset related processing by calling the .reset_notify()
interface registered by the RoCE driver in hip08 SoC.

In the current version, if a reset occurs simultaneously during
the execution of rmmod or insmod ko, there may be Oops error as below:

[  650.375307] Internal error: Oops: 86000007 [#1] PREEMPT SMP
[  650.381223] Modules linked in: hns_roce(O) hns3(O) hclge(O) hnae3(O) [last unloaded: hns_roce_hw_v2]
[  650.391279] CPU: 0 PID: 14 Comm: kworker/0:1 Tainted: G           O      4.19.0-ge00d540 #1
[  650.399875] Hardware name: Huawei Technologies Co., Ltd.
[  650.411393] Workqueue: events hclge_reset_service_task [hclge]
[  650.417576] pstate: 60c00009 (nZCv daif +PAN +UAO)
[  650.422618] pc : 0xffff00000100b0b8
[  650.426282] lr : 0xffff00000100aea0
[  650.429914] sp : ffff000009afbab0
[  650.433388] x29: ffff000009afbab0 x28: 0000000000000800
[  650.439012] x27: 0000000000007ff0 x26: ffff80002f90c004
[  650.444599] x25: 00000000000007ff x24: ffff000008f97000
[  650.450165] x23: ffff80003efee0a8 x22: 0000000000001000
[  650.455730] x21: ffff80002f917ff0 x20: ffff8000286ea070
[  650.461289] x19: 0000000000000800 x18: 0000000000000400
[  650.466868] x17: 00000000c4d3225d x16: 00000000000021b8
[  650.472423] x15: 0000000000000400 x14: 0000000000000400
[  650.477990] x13: 0000000000000000 x12: ffff80003fac6e30
[  650.483552] x11: 0000800036303000 x10: 0000000000000001
[  650.489103] x9 : 0000000000000000 x8 : ffff80003016d000
[  650.494662] x7 : 0000000000000000 x6 : 000000000000003f
[  650.500218] x5 : 0000000000000040 x4 : 0000000000000000
[  650.505783] x3 : 0000000000000004 x2 : 00000000000007ff
[  650.511349] x1 : 0000000000000000 x0 : 0000000000000000
[  650.517002] Process kworker/0:1 (pid: 14, stack limit = 0x00000000af8f0ad9)
[  650.524164] Call trace:
[  650.526814]  0xffff00000100b0b8
[  650.530108]  0xffff00000100b3a0
[  650.534336]  hns_roce_init+0x624/0xc88 [hns_roce]
[  650.539196]  0xffff000001002df8
[  650.542488]  0xffff000001006960
[  650.546032]  hclge_notify_roce_client+0x74/0xe0 [hclge]
[  650.551637]  hclge_reset_service_task+0xa58/0xbc0 [hclge]
[  650.557479]  process_one_work+0x1e4/0x458
[  650.561738]  worker_thread+0x40/0x450
[  650.565662]  kthread+0x12c/0x130
[  650.569247]  ret_from_fork+0x10/0x18
[  650.573235] Code: bad PC value
[  650.576663] ---[ end trace 97e6a2fe783337a8 ]---

In the reset process, we will release the resources firstly,
and after the hardware reset is completed, we will reapply
resources and reconfigure the hardware.

We can solve this problem by modifying both the NIC and the
RoCE driver. We can modify the concurrent processing in the
NIC driver to avoid calling the .reset_notify and
.uninit_instance ops at the same time. And we need to modify
the RoCE driver to record the reset stage and the driver's
init/uninit state, and check the state in the .reset_notify,
.init_instance. and uninit_instance functions to avoid NULL
pointer operation.

Fixes: cb7a94c9c808 ("RDMA/hns: Add reset process for RoCE in hip08")
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
v1->v2: Delete checking whether in the reset state and waiting
	for the reset to complete in hns_roce_hw_v2_uninit_instance
	function to address Jason's comments. The related link:
	https://lkml.org/lkml/2019/1/11/1338
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  21 ++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 103 ++++++++++++++++++++++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   1 +
 3 files changed, 112 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 6fde434..0f3fe90 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -217,6 +217,26 @@ enum {
 	HNS_ROCE_DB_PER_PAGE = PAGE_SIZE / 4
 };
 
+enum hns_roce_reset_stage {
+	HNS_ROCE_STATE_NON_RST,
+	HNS_ROCE_STATE_RST_BEF_DOWN,
+	HNS_ROCE_STATE_RST_DOWN,
+	HNS_ROCE_STATE_RST_UNINIT,
+	HNS_ROCE_STATE_RST_INIT,
+	HNS_ROCE_STATE_RST_INITED,
+};
+
+enum hns_roce_instance_state {
+	HNS_ROCE_STATE_NON_INIT,
+	HNS_ROCE_STATE_INIT,
+	HNS_ROCE_STATE_INITED,
+	HNS_ROCE_STATE_UNINIT,
+};
+
+enum {
+	HNS_ROCE_RST_DIRECT_RETURN		= 0,
+};
+
 #define HNS_ROCE_CMD_SUCCESS			1
 
 #define HNS_ROCE_PORT_DOWN			0
@@ -920,6 +940,7 @@ struct hns_roce_dev {
 	spinlock_t		bt_cmd_lock;
 	bool			active;
 	bool			is_reset;
+	unsigned long		reset_cnt;
 	struct hns_roce_ib_iboe iboe;
 
 	struct list_head        pgdir_list;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d63dd15..575a233 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6021,6 +6021,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 				  struct hnae3_handle *handle)
 {
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	const struct pci_device_id *id;
 	int i;
 
@@ -6051,10 +6052,13 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 	hr_dev->cmd_mod = 1;
 	hr_dev->loop_idc = 0;
 
+	hr_dev->reset_cnt = handle->ae_algo->ops->ae_dev_reset_cnt(handle);
+	priv->handle = handle;
+
 	return 0;
 }
 
-static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
+static int __hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 {
 	struct hns_roce_dev *hr_dev;
 	int ret;
@@ -6071,7 +6075,6 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 
 	hr_dev->pci_dev = handle->pdev;
 	hr_dev->dev = &handle->pdev->dev;
-	handle->priv = hr_dev;
 
 	ret = hns_roce_hw_v2_get_cfg(hr_dev, handle);
 	if (ret) {
@@ -6085,6 +6088,8 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 		goto error_failed_get_cfg;
 	}
 
+	handle->priv = hr_dev;
+
 	return 0;
 
 error_failed_get_cfg:
@@ -6096,7 +6101,7 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 	return ret;
 }
 
-static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
+static void __hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 					   bool reset)
 {
 	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
@@ -6104,24 +6109,78 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 	if (!hr_dev)
 		return;
 
+	handle->priv = NULL;
 	hns_roce_exit(hr_dev);
 	kfree(hr_dev->priv);
 	ib_dealloc_device(&hr_dev->ib_dev);
 }
 
+static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
+{
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	struct device *dev = &handle->pdev->dev;
+	int ret;
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_INIT;
+
+	if (ops->ae_dev_resetting(handle) || ops->get_hw_reset_stat(handle)) {
+		handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+		goto reset_chk_err;
+	}
+
+	ret = __hns_roce_hw_v2_init_instance(handle);
+	if (ret) {
+		handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+		dev_err(dev, "RoCE instance init failed! ret = %d\n", ret);
+		if (ops->ae_dev_resetting(handle) ||
+		    ops->get_hw_reset_stat(handle))
+			goto reset_chk_err;
+		else
+			return ret;
+	}
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_INITED;
+
+
+	return 0;
+
+reset_chk_err:
+	dev_err(dev, "Device is busy in resetting state.\n"
+		     "please retry later.\n");
+
+	return -EBUSY;
+}
+
+static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
+					   bool reset)
+{
+	if (handle->rinfo.instance_state != HNS_ROCE_STATE_INITED)
+		return;
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_UNINIT;
+
+	__hns_roce_hw_v2_uninit_instance(handle, reset);
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+}
 static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 {
-	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
+	struct hns_roce_dev *hr_dev;
 	struct ib_event event;
 
-	if (!hr_dev) {
-		dev_err(&handle->pdev->dev,
-			"Input parameter handle->priv is NULL!\n");
-		return -EINVAL;
+	if (handle->rinfo.instance_state != HNS_ROCE_STATE_INITED) {
+		set_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state);
+		return 0;
 	}
 
+	handle->rinfo.reset_state = HNS_ROCE_STATE_RST_DOWN;
+	clear_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state);
+
+	hr_dev = (struct hns_roce_dev *)handle->priv;
+	if (!hr_dev)
+		return 0;
+
 	hr_dev->active = false;
-	hr_dev->is_reset = true;
 
 	event.event = IB_EVENT_DEVICE_FATAL;
 	event.device = &hr_dev->ib_dev;
@@ -6133,17 +6192,29 @@ static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 
 static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
 {
+	struct device *dev = &handle->pdev->dev;
 	int ret;
 
-	ret = hns_roce_hw_v2_init_instance(handle);
+	if (test_and_clear_bit(HNS_ROCE_RST_DIRECT_RETURN,
+			       &handle->rinfo.state)) {
+		handle->rinfo.reset_state = HNS_ROCE_STATE_RST_INITED;
+		return 0;
+	}
+
+	handle->rinfo.reset_state = HNS_ROCE_STATE_RST_INIT;
+
+	dev_info(&handle->pdev->dev, "In reset process RoCE client reinit.\n");
+	ret = __hns_roce_hw_v2_init_instance(handle);
 	if (ret) {
 		/* when reset notify type is HNAE3_INIT_CLIENT In reset notify
 		 * callback function, RoCE Engine reinitialize. If RoCE reinit
 		 * failed, we should inform NIC driver.
 		 */
 		handle->priv = NULL;
-		dev_err(&handle->pdev->dev,
-			"In reset process RoCE reinit failed %d.\n", ret);
+		dev_err(dev, "In reset process RoCE reinit failed %d.\n", ret);
+	} else {
+		handle->rinfo.reset_state = HNS_ROCE_STATE_RST_INITED;
+		dev_info(dev, "Reset done, RoCE client reinit finished.\n");
 	}
 
 	return ret;
@@ -6151,8 +6222,14 @@ static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
 
 static int hns_roce_hw_v2_reset_notify_uninit(struct hnae3_handle *handle)
 {
+	if (test_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state))
+		return 0;
+
+	handle->rinfo.reset_state = HNS_ROCE_STATE_RST_UNINIT;
+	dev_info(&handle->pdev->dev, "In reset process RoCE client uninit.\n");
 	msleep(100);
-	hns_roce_hw_v2_uninit_instance(handle, false);
+	__hns_roce_hw_v2_uninit_instance(handle, false);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 242eeae..938d36a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1602,6 +1602,7 @@ struct hns_roce_link_table_entry {
 #define HNS_ROCE_LINK_TABLE_NXT_PTR_M GENMASK(31, 20)
 
 struct hns_roce_v2_priv {
+	struct hnae3_handle *handle;
 	struct hns_roce_v2_cmq cmq;
 	struct hns_roce_link_table tsq;
 	struct hns_roce_link_table tpq;
-- 
1.9.1
