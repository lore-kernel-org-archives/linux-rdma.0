From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 07/20] IB/hns: Fix bug of clear hem
Date: Fri, 9 Sep 2016 18:30:38 +0800
Message-ID: <1473417051-99560-8-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>

In hip06, there's no interface to release hem memory. So, hardware can't
identify whether hem memory released or not.
If all context in a hem memory released, the related hem memory will be
released by driver and reused by others. But, hardware don't know that
this memory can't be used already.

In order to fix this bug, hns roce driver reserved 128K memory for each
type of hem(QPC/CQC/MTPT). While unmap hem memory, hns roce driver will
write base address of reserved memory according to hem type.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    2 +
 drivers/infiniband/hw/hns/hns_roce_hem.c    |   76 +--------------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |    4 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  140 +++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |    9 ++
 5 files changed, 157 insertions(+), 74 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1c32e9a..f01cc2f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -505,6 +505,8 @@ struct hns_roce_hw {
 	void (*write_cqc)(struct hns_roce_dev *hr_dev,
 			  struct hns_roce_cq *hr_cq, void *mb_buf, u64 *mtts,
 			  dma_addr_t dma_handle, int nent, u32 vector);
+	int (*clear_hem)(struct hns_roce_dev *hr_dev,
+			 struct hns_roce_hem_table *table, int obj);
 	int (*query_qp)(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 			int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
 	int (*modify_qp)(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index d53d643..250d8f2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -36,14 +36,10 @@
 #include "hns_roce_hem.h"
 #include "hns_roce_common.h"
 
-#define HW_SYNC_TIMEOUT_MSECS		500
-#define HW_SYNC_SLEEP_TIME_INTERVAL	20
-
 #define HNS_ROCE_HEM_ALLOC_SIZE		(1 << 17)
 #define HNS_ROCE_TABLE_CHUNK_SIZE	(1 << 17)
 
 #define DMA_ADDR_T_SHIFT		12
-#define BT_CMD_SYNC_SHIFT		31
 #define BT_BA_SHIFT			32
 
 struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev, int npages,
@@ -213,74 +209,6 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-static int hns_roce_clear_hem(struct hns_roce_dev *hr_dev,
-			      struct hns_roce_hem_table *table,
-			      unsigned long obj)
-{
-	struct device *dev = &hr_dev->pdev->dev;
-	unsigned long end = 0;
-	unsigned long flags;
-	void __iomem *bt_cmd;
-	uint32_t bt_cmd_val[2];
-	u32 bt_cmd_h_val = 0;
-	int ret = 0;
-
-	switch (table->type) {
-	case HEM_TYPE_QPC:
-		roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
-			       ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S, HEM_TYPE_QPC);
-		break;
-	case HEM_TYPE_MTPT:
-		roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
-			       ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S,
-			       HEM_TYPE_MTPT);
-		break;
-	case HEM_TYPE_CQC:
-		roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
-			       ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S, HEM_TYPE_CQC);
-		break;
-	case HEM_TYPE_SRQC:
-		roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
-			       ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S,
-			       HEM_TYPE_SRQC);
-		break;
-	default:
-		return ret;
-	}
-	roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_IN_MDF_M,
-		       ROCEE_BT_CMD_H_ROCEE_BT_CMD_IN_MDF_S, obj);
-	roce_set_bit(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_S, 0);
-	roce_set_bit(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_HW_SYNS_S, 1);
-	roce_set_field(bt_cmd_h_val, ROCEE_BT_CMD_H_ROCEE_BT_CMD_BA_H_M,
-		       ROCEE_BT_CMD_H_ROCEE_BT_CMD_BA_H_S, 0);
-
-	spin_lock_irqsave(&hr_dev->bt_cmd_lock, flags);
-
-	bt_cmd = hr_dev->reg_base + ROCEE_BT_CMD_H_REG;
-
-	end = msecs_to_jiffies(HW_SYNC_TIMEOUT_MSECS) + jiffies;
-	while (1) {
-		if (readl(bt_cmd) >> BT_CMD_SYNC_SHIFT) {
-			if (!(time_before(jiffies, end))) {
-				dev_err(dev, "Write bt_cmd err,hw_sync is not zero.\n");
-				spin_unlock_irqrestore(&hr_dev->bt_cmd_lock,
-						       flags);
-				return -EBUSY;
-			}
-		} else {
-			break;
-		}
-		msleep(HW_SYNC_SLEEP_TIME_INTERVAL);
-	}
-
-	bt_cmd_val[0] = 0;
-	bt_cmd_val[1] = bt_cmd_h_val;
-	hns_roce_write64_k(bt_cmd_val, hr_dev->reg_base + ROCEE_BT_CMD_L_REG);
-	spin_unlock_irqrestore(&hr_dev->bt_cmd_lock, flags);
-
-	return ret;
-}
-
 int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 		       struct hns_roce_hem_table *table, unsigned long obj)
 {
@@ -333,7 +261,7 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 
 	if (--table->hem[i]->refcount == 0) {
 		/* Clear HEM base address */
-		if (hns_roce_clear_hem(hr_dev, table, obj))
+		if (hr_dev->hw->clear_hem(hr_dev, table, obj))
 			dev_warn(dev, "Clear HEM base address failed.\n");
 
 		hns_roce_free_hem(hr_dev, table->hem[i]);
@@ -456,7 +384,7 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 
 	for (i = 0; i < table->num_hem; ++i)
 		if (table->hem[i]) {
-			if (hns_roce_clear_hem(hr_dev, table,
+			if (hr_dev->hw->clear_hem(hr_dev, table,
 			    i * HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size))
 				dev_err(dev, "Clear HEM base address failed.\n");
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index ad66175..4357488 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -34,6 +34,10 @@
 #ifndef _HNS_ROCE_HEM_H
 #define _HNS_ROCE_HEM_H
 
+#define HW_SYNC_TIMEOUT_MSECS		500
+#define HW_SYNC_SLEEP_TIME_INTERVAL	20
+#define BT_CMD_SYNC_SHIFT		31
+
 enum {
 	/* MAP HEM(Hardware Entry Memory) */
 	HEM_TYPE_QPC = 0,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index ea47ec4..f6bb88c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -792,6 +792,66 @@ static void hns_roce_port_enable(struct hns_roce_dev *hr_dev, int enable_flag)
 	}
 }
 
+static int hns_roce_bt_init(struct hns_roce_dev *hr_dev)
+{
+	struct device *dev = &hr_dev->pdev->dev;
+	struct hns_roce_v1_priv *priv;
+	int ret;
+
+	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+
+	priv->bt_table.qpc_buf.buf = dma_alloc_coherent(dev,
+		HNS_ROCE_BT_RSV_BUF_SIZE, &priv->bt_table.qpc_buf.map,
+		GFP_KERNEL);
+	if (!priv->bt_table.qpc_buf.buf)
+		return -ENOMEM;
+
+	priv->bt_table.mtpt_buf.buf = dma_alloc_coherent(dev,
+		HNS_ROCE_BT_RSV_BUF_SIZE, &priv->bt_table.mtpt_buf.map,
+		GFP_KERNEL);
+	if (!priv->bt_table.mtpt_buf.buf) {
+		ret = -ENOMEM;
+		goto err_failed_alloc_mtpt_buf;
+	}
+
+	priv->bt_table.cqc_buf.buf = dma_alloc_coherent(dev,
+		HNS_ROCE_BT_RSV_BUF_SIZE, &priv->bt_table.cqc_buf.map,
+		GFP_KERNEL);
+	if (!priv->bt_table.cqc_buf.buf) {
+		ret = -ENOMEM;
+		goto err_failed_alloc_cqc_buf;
+	}
+
+	return 0;
+
+err_failed_alloc_cqc_buf:
+	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
+		priv->bt_table.mtpt_buf.buf, priv->bt_table.mtpt_buf.map);
+
+err_failed_alloc_mtpt_buf:
+	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
+		priv->bt_table.qpc_buf.buf, priv->bt_table.qpc_buf.map);
+
+	return ret;
+}
+
+static void hns_roce_bt_free(struct hns_roce_dev *hr_dev)
+{
+	struct device *dev = &hr_dev->pdev->dev;
+	struct hns_roce_v1_priv *priv;
+
+	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+
+	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
+		priv->bt_table.cqc_buf.buf, priv->bt_table.cqc_buf.map);
+
+	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
+		priv->bt_table.mtpt_buf.buf, priv->bt_table.mtpt_buf.map);
+
+	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
+		priv->bt_table.qpc_buf.buf, priv->bt_table.qpc_buf.map);
+}
+
 /**
  * hns_roce_v1_reset - reset RoCE
  * @hr_dev: RoCE device struct pointer
@@ -947,8 +1007,18 @@ int hns_roce_v1_init(struct hns_roce_dev *hr_dev)
 
 	hns_roce_port_enable(hr_dev, HNS_ROCE_PORT_UP);
 
+	ret = hns_roce_bt_init(hr_dev);
+	if (ret) {
+		dev_err(dev, "bt init failed!\n");
+		goto error_failed_bt_init;
+	}
+
 	return 0;
 
+error_failed_bt_init:
+	hns_roce_port_enable(hr_dev, HNS_ROCE_PORT_DOWN);
+	hns_roce_raq_free(hr_dev);
+
 error_failed_raq_init:
 	hns_roce_db_free(hr_dev);
 	return ret;
@@ -956,6 +1026,7 @@ error_failed_raq_init:
 
 void hns_roce_v1_exit(struct hns_roce_dev *hr_dev)
 {
+	hns_roce_bt_free(hr_dev);
 	hns_roce_port_enable(hr_dev, HNS_ROCE_PORT_DOWN);
 	hns_roce_raq_free(hr_dev);
 	hns_roce_db_free(hr_dev);
@@ -1602,6 +1673,74 @@ int hns_roce_v1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		return ret;
 }
 
+int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
+		struct hns_roce_hem_table *table, int obj)
+{
+	struct device *dev = &hr_dev->pdev->dev;
+	struct hns_roce_v1_priv *priv;
+	unsigned long end = 0, flags = 0;
+	uint32_t bt_cmd_val[2] = {0};
+	void __iomem *bt_cmd;
+	u64 bt_ba = 0;
+
+	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+
+	switch (table->type) {
+	case HEM_TYPE_QPC:
+		roce_set_field(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
+			ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S, HEM_TYPE_QPC);
+		bt_ba = priv->bt_table.qpc_buf.map >> 12;
+		break;
+	case HEM_TYPE_MTPT:
+		roce_set_field(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
+			ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S, HEM_TYPE_MTPT);
+		bt_ba = priv->bt_table.mtpt_buf.map >> 12;
+		break;
+	case HEM_TYPE_CQC:
+		roce_set_field(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_M,
+			ROCEE_BT_CMD_H_ROCEE_BT_CMD_MDF_S, HEM_TYPE_CQC);
+		bt_ba = priv->bt_table.cqc_buf.map >> 12;
+		break;
+	case HEM_TYPE_SRQC:
+		dev_dbg(dev, "HEM_TYPE_SRQC not support.\n");
+		return -EINVAL;
+	default:
+		return 0;
+	}
+	roce_set_field(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_IN_MDF_M,
+		ROCEE_BT_CMD_H_ROCEE_BT_CMD_IN_MDF_S, obj);
+	roce_set_bit(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_S, 0);
+	roce_set_bit(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_HW_SYNS_S, 1);
+
+	spin_lock_irqsave(&hr_dev->bt_cmd_lock, flags);
+
+	bt_cmd = hr_dev->reg_base + ROCEE_BT_CMD_H_REG;
+
+	end = msecs_to_jiffies(HW_SYNC_TIMEOUT_MSECS) + jiffies;
+	while (1) {
+		if (readl(bt_cmd) >> BT_CMD_SYNC_SHIFT) {
+			if (!(time_before(jiffies, end))) {
+				dev_err(dev, "Write bt_cmd err,hw_sync is not zero.\n");
+				spin_unlock_irqrestore(&hr_dev->bt_cmd_lock,
+					flags);
+				return -EBUSY;
+			}
+		} else {
+			break;
+		}
+		msleep(HW_SYNC_SLEEP_TIME_INTERVAL);
+	}
+
+	bt_cmd_val[0] = (uint32_t)bt_ba;
+	roce_set_field(bt_cmd_val[1], ROCEE_BT_CMD_H_ROCEE_BT_CMD_BA_H_M,
+		ROCEE_BT_CMD_H_ROCEE_BT_CMD_BA_H_S, bt_ba >> 32);
+	hns_roce_write64_k(bt_cmd_val, hr_dev->reg_base + ROCEE_BT_CMD_L_REG);
+
+	spin_unlock_irqrestore(&hr_dev->bt_cmd_lock, flags);
+
+	return 0;
+}
+
 static int hns_roce_v1_qp_modify(struct hns_roce_dev *hr_dev,
 				 struct hns_roce_mtt *mtt,
 				 enum hns_roce_qp_state cur_state,
@@ -2774,6 +2913,7 @@ struct hns_roce_hw hns_roce_hw_v1 = {
 	.set_mtu = hns_roce_v1_set_mtu,
 	.write_mtpt = hns_roce_v1_write_mtpt,
 	.write_cqc = hns_roce_v1_write_cqc,
+	.clear_hem = hns_roce_v1_clear_hem,
 	.modify_qp = hns_roce_v1_modify_qp,
 	.query_qp = hns_roce_v1_query_qp,
 	.destroy_qp = hns_roce_v1_destroy_qp,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.h b/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
index 316b592..539b0a3b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.h
@@ -102,6 +102,8 @@
 #define HNS_ROCE_V1_EXT_ODB_ALFUL	\
 	(HNS_ROCE_V1_EXT_ODB_DEPTH - HNS_ROCE_V1_DB_RSVD)
 
+#define HNS_ROCE_BT_RSV_BUF_SIZE			(1 << 17)
+
 #define HNS_ROCE_ODB_POLL_MODE				0
 
 #define HNS_ROCE_SDB_NORMAL_MODE			0
@@ -971,9 +973,16 @@ struct hns_roce_db_table {
 	struct hns_roce_ext_db *ext_db;
 };
 
+struct hns_roce_bt_table {
+	struct hns_roce_buf_list qpc_buf;
+	struct hns_roce_buf_list mtpt_buf;
+	struct hns_roce_buf_list cqc_buf;
+};
+
 struct hns_roce_v1_priv {
 	struct hns_roce_db_table  db_table;
 	struct hns_roce_raq_table raq_table;
+	struct hns_roce_bt_table  bt_table;
 };
 
 int hns_dsaf_roce_reset(struct fwnode_handle *dsaf_fwnode, bool dereset);
-- 
1.7.9.5
