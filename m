From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 1/3] RDMA/hns: Add support for reset and loading or unloading driver occur simultaneously
Date: Fri, 23 Nov 2018 23:14:23 +0800
Message-ID: <1542986065-44265-2-git-send-email-xavier.huwei@huawei.com>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

This patch adds support for reset and loading or unloading driver
occur simultaneously.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  21 ++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 151 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   7 ++
 3 files changed, 169 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 9518615..d0d03a6 100644
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
@@ -932,6 +952,7 @@ struct hns_roce_dev {
 	spinlock_t		bt_cmd_lock;
 	bool			active;
 	bool			is_reset;
+	unsigned long		reset_cnt;
 	struct hns_roce_ib_iboe iboe;
 
 	struct list_head        pgdir_list;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 84b0245..896dd59 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5933,6 +5933,7 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 				  struct hnae3_handle *handle)
 {
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	const struct pci_device_id *id;
 	int i;
 
@@ -5963,10 +5964,13 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
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
@@ -5983,7 +5987,6 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 
 	hr_dev->pci_dev = handle->pdev;
 	hr_dev->dev = &handle->pdev->dev;
-	handle->priv = hr_dev;
 
 	ret = hns_roce_hw_v2_get_cfg(hr_dev, handle);
 	if (ret) {
@@ -5997,6 +6000,8 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 		goto error_failed_get_cfg;
 	}
 
+	handle->priv = hr_dev;
+
 	return 0;
 
 error_failed_get_cfg:
@@ -6008,7 +6013,7 @@ static int hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 	return ret;
 }
 
-static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
+static void __hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 					   bool reset)
 {
 	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
@@ -6016,24 +6021,132 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
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
+	struct hns_roce_dev *hr_dev;
+	unsigned long end;
+	int ret;
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_INIT;
+
+	if (ops->ae_dev_resetting(handle) || ops->get_hw_reset_stat(handle)) {
+		handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+		goto head_chk_err;
+	}
+
+	ret = __hns_roce_hw_v2_init_instance(handle);
+	if (ret) {
+		handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+		dev_err(&handle->pdev->dev,
+			"RoCE instance init failed! ret = %d\n", ret);
+		if (ops->ae_dev_resetting(handle) ||
+		    ops->get_hw_reset_stat(handle))
+			goto head_chk_err;
+		else
+			return ret;
+	}
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_INITED;
+
+	hr_dev = (struct hns_roce_dev *)handle->priv;
+	if (ops->ae_dev_resetting(handle) || ops->get_hw_reset_stat(handle) ||
+	    hr_dev->reset_cnt != ops->ae_dev_reset_cnt(handle)) {
+		handle->rinfo.instance_state = HNS_ROCE_STATE_INIT;
+		goto tail_chk_err;
+	}
+
+	return 0;
+
+tail_chk_err:
+	/* Wait until software reset process finished, in order to ensure that
+	 * reset process and this function will not call
+	 * __hns_roce_hw_v2_uninit_instance at the same time.
+	 * If a timeout occurs, it indicates that the network subsystem has
+	 * encountered a serious error and cannot be recovered from the reset
+	 * processing.
+	 */
+	end = msecs_to_jiffies(HNS_ROCE_V2_RST_PRC_MAX_TIME) + jiffies;
+	while (ops->ae_dev_resetting(handle) && time_before(jiffies, end))
+		msleep(20);
+
+	if (!ops->ae_dev_resetting(handle))
+		dev_warn(&handle->pdev->dev, "Device completed reset.\n");
+	else
+		dev_warn(&handle->pdev->dev,
+			 "Device is still resetting! timeout!\n");
+
+	__hns_roce_hw_v2_uninit_instance(handle, false);
+	handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+
+head_chk_err:
+	dev_err(&handle->pdev->dev, "Device is busy in resetting state.\n"
+				    "please retry later.\n");
+
+	return -EBUSY;
+}
+
+static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
+					   bool reset)
+{
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	unsigned long end;
+
+	if (handle->rinfo.instance_state != HNS_ROCE_STATE_INITED)
+		return;
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_UNINIT;
+
+	/* Check the status of the current software reset process, if in
+	 * software reset process, wait until software reset process finished,
+	 * in order to ensure that reset process and this function will not call
+	 * __hns_roce_hw_v2_uninit_instance at the same time.
+	 * If a timeout occurs, it indicates that the network subsystem has
+	 * encountered a serious error and cannot be recovered from the reset
+	 * processing.
+	 */
+	if (ops->ae_dev_resetting(handle)) {
+		dev_warn(&handle->pdev->dev,
+			 "Device is busy in resetting state. waiting.\n");
+		end = msecs_to_jiffies(HNS_ROCE_V2_RST_PRC_MAX_TIME) + jiffies;
+		while (ops->ae_dev_resetting(handle) &&
+		       time_before(jiffies, end))
+			msleep(20);
+
+		if (!ops->ae_dev_resetting(handle))
+			dev_warn(&handle->pdev->dev,
+				 "Device completed reset.\n");
+		else
+			dev_warn(&handle->pdev->dev,
+				 "Device is still resetting! timeout!\n");
+	}
+
+	__hns_roce_hw_v2_uninit_instance(handle, reset);
+
+	handle->rinfo.instance_state = HNS_ROCE_STATE_NON_INIT;
+}
 static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
 {
 	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
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
+	if (!hr_dev)
+		return 0;
+
 	hr_dev->active = false;
-	hr_dev->is_reset = true;
 
 	event.event = IB_EVENT_DEVICE_FATAL;
 	event.device = &hr_dev->ib_dev;
@@ -6047,7 +6160,16 @@ static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
 {
 	int ret;
 
-	ret = hns_roce_hw_v2_init_instance(handle);
+	if (test_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state)) {
+		clear_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state);
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
@@ -6056,6 +6178,10 @@ static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
 		handle->priv = NULL;
 		dev_err(&handle->pdev->dev,
 			"In reset process RoCE reinit failed %d.\n", ret);
+	} else {
+		handle->rinfo.reset_state = HNS_ROCE_STATE_RST_INITED;
+		dev_info(&handle->pdev->dev,
+			 "Reset done, RoCE client reinit finished.\n");
 	}
 
 	return ret;
@@ -6063,8 +6189,13 @@ static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
 
 static int hns_roce_hw_v2_reset_notify_uninit(struct hnae3_handle *handle)
 {
+	if (test_bit(HNS_ROCE_RST_DIRECT_RETURN, &handle->rinfo.state))
+		return 0;
+
+	handle->rinfo.reset_state = HNS_ROCE_STATE_RST_UNINIT;
 	msleep(100);
-	hns_roce_hw_v2_uninit_instance(handle, false);
+	__hns_roce_hw_v2_uninit_instance(handle, false);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 1ad6bf1..2857669 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -95,6 +95,12 @@
 #define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 #define HNS_ROCE_V2_RSV_QPS			8
 
+/* The longest time for software reset process in NIC subsystem, if a timeout
+ * occurs, it indicates that the network subsystem has encountered a serious
+ * error and cannot be recovered from the reset processing.
+ */
+#define HNS_ROCE_V2_RST_PRC_MAX_TIME		300000
+
 #define HNS_ROCE_CONTEXT_HOP_NUM		1
 #define HNS_ROCE_SCC_CTX_HOP_NUM		1
 #define HNS_ROCE_MTT_HOP_NUM			1
@@ -1594,6 +1600,7 @@ struct hns_roce_link_table_entry {
 #define HNS_ROCE_LINK_TABLE_NXT_PTR_M GENMASK(31, 20)
 
 struct hns_roce_v2_priv {
+	struct hnae3_handle *handle;
 	struct hns_roce_v2_cmq cmq;
 	struct hns_roce_link_table tsq;
 	struct hns_roce_link_table tpq;
-- 
1.9.1
