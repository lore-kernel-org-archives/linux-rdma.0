From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V3 rdma-next 1/4] RDMA/hns: Add reset process for RoCE in hip08
Date: Sat, 26 May 2018 16:41:44 +0800
Message-ID: <1527324107-56593-2-git-send-email-xavier.huwei@huawei.com>
References: <1527324107-56593-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527324107-56593-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, linux-kernel@vger.kernel.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

This patch added reset process for RoCE in hip08.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>

--
v2->v3: no change.
v1->v2: 1.Delete handle->priv = NULL in hns_roce_hw_v2_uninit_instance.
	2.Add hns_roce_hw_v2_reset_notify_init callback function,
	  When RoCE reinit failed in this function, inform NIC driver.
	The related link of Jason's commets:
	https://www.spinics.net/lists/linux-rdma/msg65009.html
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c    |  3 ++
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 76 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_main.c   |  7 +++
 4 files changed, 88 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 9ebe839..a0ba19d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -176,6 +176,9 @@ int hns_roce_cmd_mbox(struct hns_roce_dev *hr_dev, u64 in_param, u64 out_param,
 		      unsigned long in_modifier, u8 op_modifier, u16 op,
 		      unsigned long timeout)
 {
+	if (hr_dev->is_reset)
+		return 0;
+
 	if (hr_dev->cmd.use_events)
 		return hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
 					      in_modifier, op_modifier, op,
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 412297d4..da8512b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -774,6 +774,8 @@ struct hns_roce_dev {
 	const char		*irq_names[HNS_ROCE_MAX_IRQ_NUM];
 	spinlock_t		sm_lock;
 	spinlock_t		bt_cmd_lock;
+	bool			active;
+	bool			is_reset;
 	struct hns_roce_ib_iboe iboe;
 
 	struct list_head        pgdir_list;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a25c3da..368f682 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -768,6 +768,9 @@ static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	int ntc;
 
+	if (hr_dev->is_reset)
+		return 0;
+
 	spin_lock_bh(&csq->lock);
 
 	if (num > hns_roce_cmq_space(csq)) {
@@ -4790,14 +4793,87 @@ static void hns_roce_hw_v2_uninit_instance(struct hnae3_handle *handle,
 {
 	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
 
+	if (!hr_dev)
+		return;
+
 	hns_roce_exit(hr_dev);
 	kfree(hr_dev->priv);
 	ib_dealloc_device(&hr_dev->ib_dev);
 }
 
+static int hns_roce_hw_v2_reset_notify_down(struct hnae3_handle *handle)
+{
+	struct hns_roce_dev *hr_dev = (struct hns_roce_dev *)handle->priv;
+	struct ib_event event;
+
+	if (!hr_dev) {
+		dev_err(&handle->pdev->dev,
+			"Input parameter handle->priv is NULL!\n");
+		return -EINVAL;
+	}
+
+	hr_dev->active = false;
+	hr_dev->is_reset = true;
+
+	event.event = IB_EVENT_DEVICE_FATAL;
+	event.device = &hr_dev->ib_dev;
+	event.element.port_num = 1;
+	ib_dispatch_event(&event);
+
+	return 0;
+}
+
+static int hns_roce_hw_v2_reset_notify_init(struct hnae3_handle *handle)
+{
+	int ret;
+
+	ret = hns_roce_hw_v2_init_instance(handle);
+	if (ret) {
+		/* when reset notify type is HNAE3_INIT_CLIENT In reset notify
+		 * callback function, RoCE Engine reinitialize. If RoCE reinit
+		 * failed, we should inform NIC driver.
+		 */
+		handle->priv = NULL;
+		dev_err(&handle->pdev->dev,
+			"In reset process RoCE reinit failed %d.\n", ret);
+	}
+
+	return ret;
+}
+
+static int hns_roce_hw_v2_reset_notify_uninit(struct hnae3_handle *handle)
+{
+	msleep(100);
+	hns_roce_hw_v2_uninit_instance(handle, false);
+	return 0;
+}
+
+static int hns_roce_hw_v2_reset_notify(struct hnae3_handle *handle,
+				       enum hnae3_reset_notify_type type)
+{
+	int ret = 0;
+
+	switch (type) {
+	case HNAE3_DOWN_CLIENT:
+		ret = hns_roce_hw_v2_reset_notify_down(handle);
+		break;
+	case HNAE3_INIT_CLIENT:
+		ret = hns_roce_hw_v2_reset_notify_init(handle);
+		break;
+	case HNAE3_UNINIT_CLIENT:
+		ret = hns_roce_hw_v2_reset_notify_uninit(handle);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 static const struct hnae3_client_ops hns_roce_hw_v2_ops = {
 	.init_instance = hns_roce_hw_v2_init_instance,
 	.uninit_instance = hns_roce_hw_v2_uninit_instance,
+	.reset_notify = hns_roce_hw_v2_reset_notify,
 };
 
 static struct hnae3_client hns_roce_hw_v2_client = {
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 1b79a38..ac51372 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -332,6 +332,9 @@ static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
 	struct hns_roce_ib_alloc_ucontext_resp resp = {};
 	struct hns_roce_dev *hr_dev = to_hr_dev(ib_dev);
 
+	if (!hr_dev->active)
+		return ERR_PTR(-EAGAIN);
+
 	resp.qp_tab_size = hr_dev->caps.num_qps;
 
 	context = kmalloc(sizeof(*context), GFP_KERNEL);
@@ -425,6 +428,7 @@ static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_ib_iboe *iboe = &hr_dev->iboe;
 
+	hr_dev->active = false;
 	unregister_netdevice_notifier(&iboe->nb);
 	ib_unregister_device(&hr_dev->ib_dev);
 }
@@ -536,6 +540,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		goto error_failed_setup_mtu_mac;
 	}
 
+	hr_dev->active = true;
 	return 0;
 
 error_failed_setup_mtu_mac:
@@ -728,6 +733,7 @@ int hns_roce_init(struct hns_roce_dev *hr_dev)
 			return ret;
 		}
 	}
+	hr_dev->is_reset = false;
 
 	if (hr_dev->hw->cmq_init) {
 		ret = hr_dev->hw->cmq_init(hr_dev);
@@ -827,6 +833,7 @@ int hns_roce_init(struct hns_roce_dev *hr_dev)
 void hns_roce_exit(struct hns_roce_dev *hr_dev)
 {
 	hns_roce_unregister_device(hr_dev);
+
 	if (hr_dev->hw->hw_exit)
 		hr_dev->hw->hw_exit(hr_dev);
 	hns_roce_cleanup_bitmap(hr_dev);
-- 
1.9.1
