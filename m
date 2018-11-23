From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH rdma-next 3/3] RDMA/hns: Modify hns RoCE device's name
Date: Fri, 23 Nov 2018 23:14:25 +0800
Message-ID: <1542986065-44265-4-git-send-email-xavier.huwei@huawei.com>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org

This patch modifies the name of hns RoCE device's name in order
to ensure that the name is consistent before and after reset.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3 +++
 drivers/infiniband/hw/hns/hns_roce_main.c   | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 259977b..a8cfe76 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -954,6 +954,7 @@ struct hns_roce_dev {
 	struct pci_dev		*pci_dev;
 	struct device		*dev;
 	struct hns_roce_uar     priv_uar;
+	char			name[IB_DEVICE_NAME_MAX];
 	const char		*irq_names[HNS_ROCE_MAX_IRQ_NUM];
 	spinlock_t		sm_lock;
 	spinlock_t		bt_cmd_lock;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1d639a0..678c7ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6110,6 +6110,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
 						i + handle->rinfo.base_vector);
 
+	snprintf(hr_dev->name, IB_DEVICE_NAME_MAX, "hns%s",
+		 handle->rinfo.netdev->name);
+
 	/* cmd issue mode: 0 is poll, 1 is event */
 	hr_dev->cmd_mod = 1;
 	hr_dev->loop_idc = 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 68f22b8..8bbb1ef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -456,6 +456,8 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	spin_lock_init(&iboe->lock);
 
 	ib_dev = &hr_dev->ib_dev;
+	if (!strlen(hr_dev->name))
+		strlcpy(hr_dev->name, "hns_%d", IB_DEVICE_NAME_MAX);
 
 	ib_dev->owner			= THIS_MODULE;
 	ib_dev->node_type		= RDMA_NODE_IB_CA;
@@ -566,7 +568,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	ib_dev->disassociate_ucontext	= hns_roce_disassociate_ucontext;
 
 	ib_dev->driver_id = RDMA_DRIVER_HNS;
-	ret = ib_register_device(ib_dev, "hns_%d", NULL);
+	ret = ib_register_device(ib_dev, hr_dev->name, NULL);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
 		return ret;
-- 
1.9.1
