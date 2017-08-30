From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 08/20] RDMA/hns: Add the interfaces to support multi hop addressing for the contexts in hip08
Date: Wed, 30 Aug 2017 17:23:06 +0800
Message-ID: <1504084998-64397-9-git-send-email-xavier.huwei@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The contexts (QPC/MTPT/CQC/SRQC) in hip08 can support multi hop
addressing. The address of context can be retrieved by the
BT (Base Address Table) with multi hop addressing. The first hop
BT BA can be retrieved from the RAM in the chip by the bt_idx and
bt_num.

This patch is to add the interfaces in HEM to support multi hop
addressing for the contexts.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  23 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 578 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  23 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  13 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   3 +
 6 files changed, 630 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 7c58750..4574a7b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -78,6 +78,8 @@
 #define HNS_ROCE_MAX_GID_NUM			16
 #define HNS_ROCE_GID_SIZE			16
 
+#define HNS_ROCE_HOP_NUM_0			0xff
+
 #define BITMAP_NO_RR				0
 #define BITMAP_RR				1
 
@@ -232,6 +234,10 @@ struct hns_roce_hem_table {
 	int		lowmem;
 	struct mutex	mutex;
 	struct hns_roce_hem **hem;
+	u64		**bt_l1;
+	dma_addr_t	*bt_l1_dma_addr;
+	u64		**bt_l0;
+	dma_addr_t	*bt_l0_dma_addr;
 };
 
 struct hns_roce_mtt {
@@ -507,6 +513,18 @@ struct hns_roce_caps {
 	u32		srqc_bt_num;
 	u32		cqc_bt_num;
 	u32		mpt_bt_num;
+	u32		qpc_ba_pg_sz;
+	u32		qpc_buf_pg_sz;
+	u32		qpc_hop_num;
+	u32		srqc_ba_pg_sz;
+	u32		srqc_buf_pg_sz;
+	u32		srqc_hop_num;
+	u32		cqc_ba_pg_sz;
+	u32		cqc_buf_pg_sz;
+	u32		cqc_hop_num;
+	u32		mpt_ba_pg_sz;
+	u32		mpt_buf_pg_sz;
+	u32		mpt_hop_num;
 };
 
 struct hns_roce_hw {
@@ -530,8 +548,11 @@ struct hns_roce_hw {
 	void (*write_cqc)(struct hns_roce_dev *hr_dev,
 			  struct hns_roce_cq *hr_cq, void *mb_buf, u64 *mtts,
 			  dma_addr_t dma_handle, int nent, u32 vector);
+	int (*set_hem)(struct hns_roce_dev *hr_dev,
+		       struct hns_roce_hem_table *table, int obj, int step_idx);
 	int (*clear_hem)(struct hns_roce_dev *hr_dev,
-			 struct hns_roce_hem_table *table, int obj);
+			 struct hns_roce_hem_table *table, int obj,
+			 int step_idx);
 	int (*query_qp)(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 			int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
 	int (*modify_qp)(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 0ab4912..9bc8c6b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -42,8 +42,140 @@
 #define DMA_ADDR_T_SHIFT		12
 #define BT_BA_SHIFT			32
 
-struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev, int npages,
-					gfp_t gfp_mask)
+bool hns_roce_check_whether_mhop(struct hns_roce_dev *hr_dev, u32 type)
+{
+	if ((hr_dev->caps.qpc_hop_num && type == HEM_TYPE_QPC) ||
+	    (hr_dev->caps.mpt_hop_num && type == HEM_TYPE_MTPT) ||
+	    (hr_dev->caps.cqc_hop_num && type == HEM_TYPE_CQC) ||
+	    (hr_dev->caps.srqc_hop_num && type == HEM_TYPE_SRQC))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(hns_roce_check_whether_mhop);
+
+static bool hns_roce_check_hem_null(struct hns_roce_hem **hem, u64 start_idx,
+			    u32 bt_chunk_num)
+{
+	int i;
+
+	for (i = 0; i < bt_chunk_num; i++)
+		if (hem[start_idx + i])
+			return false;
+
+	return true;
+}
+
+static bool hns_roce_check_bt_null(u64 **bt, u64 start_idx, u32 bt_chunk_num)
+{
+	int i;
+
+	for (i = 0; i < bt_chunk_num; i++)
+		if (bt[start_idx + i])
+			return false;
+
+	return true;
+}
+
+static int hns_roce_get_bt_num(u32 table_type, u32 hop_num)
+{
+	if (check_whether_bt_num_3(table_type, hop_num))
+		return 3;
+	else if (check_whether_bt_num_2(table_type, hop_num))
+		return 2;
+	else if (check_whether_bt_num_1(table_type, hop_num))
+		return 1;
+	else
+		return 0;
+}
+
+int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
+			   struct hns_roce_hem_table *table, unsigned long *obj,
+			   struct hns_roce_hem_mhop *mhop)
+{
+	struct device *dev = hr_dev->dev;
+	u32 chunk_ba_num;
+	u32 table_idx;
+	u32 bt_num;
+	u32 chunk_size;
+
+	switch (table->type) {
+	case HEM_TYPE_QPC:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.qpc_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.qpc_ba_pg_sz
+					     + PAGE_SHIFT);
+		mhop->ba_l0_num = hr_dev->caps.qpc_bt_num;
+		mhop->hop_num = hr_dev->caps.qpc_hop_num;
+		break;
+	case HEM_TYPE_MTPT:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.mpt_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.mpt_ba_pg_sz
+					     + PAGE_SHIFT);
+		mhop->ba_l0_num = hr_dev->caps.mpt_bt_num;
+		mhop->hop_num = hr_dev->caps.mpt_hop_num;
+		break;
+	case HEM_TYPE_CQC:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.cqc_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.cqc_ba_pg_sz
+					    + PAGE_SHIFT);
+		mhop->ba_l0_num = hr_dev->caps.cqc_bt_num;
+		mhop->hop_num = hr_dev->caps.cqc_hop_num;
+		break;
+	case HEM_TYPE_SRQC:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.srqc_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.srqc_ba_pg_sz
+					     + PAGE_SHIFT);
+		mhop->ba_l0_num = hr_dev->caps.srqc_bt_num;
+		mhop->hop_num = hr_dev->caps.srqc_hop_num;
+		break;
+	default:
+		dev_err(dev, "Table %d not support multi-hop addressing!\n",
+			 table->type);
+		return -EINVAL;
+	}
+
+	if (!obj)
+		return 0;
+
+	/* QPC/MTPT/CQC/SRQC alloc hem for buffer pages. */
+	bt_num = hns_roce_get_bt_num(table->type, mhop->hop_num);
+	chunk_ba_num = mhop->bt_chunk_size / 8;
+	chunk_size = mhop->buf_chunk_size;
+	table_idx = (*obj & (table->num_obj - 1)) /
+		     (chunk_size / table->obj_size);
+	switch (bt_num) {
+	case 3:
+		mhop->l2_idx = table_idx & (chunk_ba_num - 1);
+		mhop->l1_idx = table_idx / chunk_ba_num & (chunk_ba_num - 1);
+		mhop->l0_idx = table_idx / chunk_ba_num / chunk_ba_num;
+		break;
+	case 2:
+		mhop->l1_idx = table_idx & (chunk_ba_num - 1);
+		mhop->l0_idx = table_idx / chunk_ba_num;
+		break;
+	case 1:
+		mhop->l0_idx = table_idx;
+		break;
+	default:
+		dev_err(dev, "Table %d not support hop_num = %d!\n",
+			     table->type, mhop->hop_num);
+		return -EINVAL;
+	}
+	if (mhop->l0_idx >= mhop->ba_l0_num)
+		mhop->l0_idx %= mhop->ba_l0_num;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hns_roce_calc_hem_mhop);
+
+static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
+					       int npages,
+					       unsigned long hem_alloc_size,
+					       gfp_t gfp_mask)
 {
 	struct hns_roce_hem_chunk *chunk = NULL;
 	struct hns_roce_hem *hem;
@@ -61,7 +193,7 @@ struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev, int npages,
 	hem->refcount = 0;
 	INIT_LIST_HEAD(&hem->chunk_list);
 
-	order = get_order(HNS_ROCE_HEM_ALLOC_SIZE);
+	order = get_order(hem_alloc_size);
 
 	while (npages > 0) {
 		if (!chunk) {
@@ -209,6 +341,169 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
+			    struct hns_roce_hem_table *table,
+			    unsigned long obj)
+{
+	struct device *dev = hr_dev->dev;
+	struct hns_roce_hem_mhop mhop;
+	struct hns_roce_hem_iter iter;
+	u32 buf_chunk_size;
+	u32 bt_chunk_size;
+	u32 chunk_ba_num;
+	u32 hop_num;
+	u32 size;
+	u32 bt_num;
+	u64 hem_idx;
+	u64 bt_l1_idx = 0;
+	u64 bt_l0_idx = 0;
+	u64 bt_ba;
+	unsigned long mhop_obj = obj;
+	int bt_l1_allocated = 0;
+	int bt_l0_allocated = 0;
+	int step_idx;
+	int ret;
+
+	ret = hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
+	if (ret)
+		return ret;
+
+	buf_chunk_size = mhop.buf_chunk_size;
+	bt_chunk_size = mhop.bt_chunk_size;
+	hop_num = mhop.hop_num;
+	chunk_ba_num = bt_chunk_size / 8;
+
+	bt_num = hns_roce_get_bt_num(table->type, hop_num);
+	switch (bt_num) {
+	case 3:
+		hem_idx = mhop.l0_idx * chunk_ba_num * chunk_ba_num +
+			  mhop.l1_idx * chunk_ba_num + mhop.l2_idx;
+		bt_l1_idx = mhop.l0_idx * chunk_ba_num + mhop.l1_idx;
+		bt_l0_idx = mhop.l0_idx;
+		break;
+	case 2:
+		hem_idx = mhop.l0_idx * chunk_ba_num + mhop.l1_idx;
+		bt_l0_idx = mhop.l0_idx;
+		break;
+	case 1:
+		hem_idx = mhop.l0_idx;
+		break;
+	default:
+		dev_err(dev, "Table %d not support hop_num = %d!\n",
+			     table->type, hop_num);
+		return -EINVAL;
+	}
+
+	mutex_lock(&table->mutex);
+
+	if (table->hem[hem_idx]) {
+		++table->hem[hem_idx]->refcount;
+		goto out;
+	}
+
+	/* alloc L1 BA's chunk */
+	if ((check_whether_bt_num_3(table->type, hop_num) ||
+		check_whether_bt_num_2(table->type, hop_num)) &&
+		!table->bt_l0[bt_l0_idx]) {
+		table->bt_l0[bt_l0_idx] = dma_alloc_coherent(dev, bt_chunk_size,
+					    &(table->bt_l0_dma_addr[bt_l0_idx]),
+					    GFP_KERNEL);
+		if (!table->bt_l0[bt_l0_idx]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		bt_l0_allocated = 1;
+
+		/* set base address to hardware */
+		if (table->type < HEM_TYPE_MTT) {
+			step_idx = 0;
+			if (hr_dev->hw->set_hem(hr_dev, table, obj, step_idx)) {
+				ret = -ENODEV;
+				dev_err(dev, "set HEM base address to HW failed!\n");
+				goto err_dma_alloc_l1;
+			}
+		}
+	}
+
+	/* alloc L2 BA's chunk */
+	if (check_whether_bt_num_3(table->type, hop_num) &&
+	    !table->bt_l1[bt_l1_idx])  {
+		table->bt_l1[bt_l1_idx] = dma_alloc_coherent(dev, bt_chunk_size,
+					    &(table->bt_l1_dma_addr[bt_l1_idx]),
+					    GFP_KERNEL);
+		if (!table->bt_l1[bt_l1_idx]) {
+			ret = -ENOMEM;
+			goto err_dma_alloc_l1;
+		}
+		bt_l1_allocated = 1;
+		*(table->bt_l0[bt_l0_idx] + mhop.l1_idx) =
+					       table->bt_l1_dma_addr[bt_l1_idx];
+
+		/* set base address to hardware */
+		step_idx = 1;
+		if (hr_dev->hw->set_hem(hr_dev, table, obj, step_idx)) {
+			ret = -ENODEV;
+			dev_err(dev, "set HEM base address to HW failed!\n");
+			goto err_alloc_hem_buf;
+		}
+	}
+
+	/* alloc buffer space chunk for QPC/MTPT/CQC/SRQC. */
+	size = buf_chunk_size;
+	table->hem[hem_idx] = hns_roce_alloc_hem(hr_dev,
+						size >> PAGE_SHIFT,
+						size,
+						(table->lowmem ? GFP_KERNEL :
+						GFP_HIGHUSER) | __GFP_NOWARN);
+	if (!table->hem[hem_idx]) {
+		ret = -ENOMEM;
+		goto err_alloc_hem_buf;
+	}
+
+	hns_roce_hem_first(table->hem[hem_idx], &iter);
+	bt_ba = hns_roce_hem_addr(&iter);
+
+	if (table->type < HEM_TYPE_MTT) {
+		if (hop_num == 2) {
+			*(table->bt_l1[bt_l1_idx] + mhop.l2_idx) = bt_ba;
+			step_idx = 2;
+		} else if (hop_num == 1) {
+			*(table->bt_l0[bt_l0_idx] + mhop.l1_idx) = bt_ba;
+			step_idx = 1;
+		} else if (hop_num == HNS_ROCE_HOP_NUM_0) {
+			step_idx = 0;
+		}
+
+		/* set HEM base address to hardware */
+		if (hr_dev->hw->set_hem(hr_dev, table, obj, step_idx)) {
+			ret = -ENODEV;
+			dev_err(dev, "set HEM base address to HW failed!\n");
+			goto err_alloc_hem_buf;
+		}
+	}
+
+	++table->hem[hem_idx]->refcount;
+	goto out;
+
+err_alloc_hem_buf:
+	if (bt_l1_allocated) {
+		dma_free_coherent(dev, bt_chunk_size, table->bt_l1[bt_l1_idx],
+				  table->bt_l1_dma_addr[bt_l1_idx]);
+		table->bt_l1[bt_l1_idx] = NULL;
+	}
+
+err_dma_alloc_l1:
+	if (bt_l0_allocated) {
+		dma_free_coherent(dev, bt_chunk_size, table->bt_l0[bt_l0_idx],
+				  table->bt_l0_dma_addr[bt_l0_idx]);
+		table->bt_l0[bt_l0_idx] = NULL;
+	}
+
+out:
+	mutex_unlock(&table->mutex);
+	return ret;
+}
+
 int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 		       struct hns_roce_hem_table *table, unsigned long obj)
 {
@@ -216,6 +511,9 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	unsigned long i;
 
+	if (hns_roce_check_whether_mhop(hr_dev, table->type))
+		return hns_roce_table_mhop_get(hr_dev, table, obj);
+
 	i = (obj & (table->num_obj - 1)) / (HNS_ROCE_TABLE_CHUNK_SIZE /
 	     table->obj_size);
 
@@ -228,6 +526,7 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 
 	table->hem[i] = hns_roce_alloc_hem(hr_dev,
 				       HNS_ROCE_TABLE_CHUNK_SIZE >> PAGE_SHIFT,
+				       HNS_ROCE_HEM_ALLOC_SIZE,
 				       (table->lowmem ? GFP_KERNEL :
 					GFP_HIGHUSER) | __GFP_NOWARN);
 	if (!table->hem[i]) {
@@ -248,12 +547,128 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
+void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
+			     struct hns_roce_hem_table *table,
+			     unsigned long obj,
+			     int check_refcount)
+{
+	struct device *dev = hr_dev->dev;
+	struct hns_roce_hem_mhop mhop;
+	unsigned long mhop_obj = obj;
+	u32 bt_chunk_size;
+	u32 chunk_ba_num;
+	u32 hop_num;
+	u32 start_idx;
+	u32 bt_num;
+	u64 hem_idx;
+	u64 bt_l1_idx = 0;
+	int ret;
+
+	ret = hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
+	if (ret)
+		return;
+
+	bt_chunk_size = mhop.bt_chunk_size;
+	hop_num = mhop.hop_num;
+	chunk_ba_num = bt_chunk_size / 8;
+
+	bt_num = hns_roce_get_bt_num(table->type, hop_num);
+	switch (bt_num) {
+	case 3:
+		hem_idx = mhop.l0_idx * chunk_ba_num * chunk_ba_num +
+			  mhop.l1_idx * chunk_ba_num + mhop.l2_idx;
+		bt_l1_idx = mhop.l0_idx * chunk_ba_num + mhop.l1_idx;
+		break;
+	case 2:
+		hem_idx = mhop.l0_idx * chunk_ba_num + mhop.l1_idx;
+		break;
+	case 1:
+		hem_idx = mhop.l0_idx;
+		break;
+	default:
+		dev_err(dev, "Table %d not support hop_num = %d!\n",
+			     table->type, hop_num);
+		return;
+	}
+
+	mutex_lock(&table->mutex);
+
+	if (check_refcount && (--table->hem[hem_idx]->refcount > 0)) {
+		mutex_unlock(&table->mutex);
+		return;
+	}
+
+	if (table->type < HEM_TYPE_MTT && hop_num == 1) {
+		if (hr_dev->hw->clear_hem(hr_dev, table, obj, 1))
+			dev_warn(dev, "Clear HEM base address failed.\n");
+	} else if (table->type < HEM_TYPE_MTT && hop_num == 2) {
+		if (hr_dev->hw->clear_hem(hr_dev, table, obj, 2))
+			dev_warn(dev, "Clear HEM base address failed.\n");
+	} else if (table->type < HEM_TYPE_MTT &&
+		   hop_num == HNS_ROCE_HOP_NUM_0) {
+		if (hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
+			dev_warn(dev, "Clear HEM base address failed.\n");
+	}
+
+	/* free buffer space chunk for QPC/MTPT/CQC/SRQC. */
+	hns_roce_free_hem(hr_dev, table->hem[hem_idx]);
+	table->hem[hem_idx] = NULL;
+
+	if (check_whether_bt_num_2(table->type, hop_num)) {
+		start_idx = mhop.l0_idx * chunk_ba_num;
+		if (hns_roce_check_hem_null(table->hem, start_idx,
+					    chunk_ba_num)) {
+			if (table->type < HEM_TYPE_MTT &&
+			    hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
+				dev_warn(dev, "Clear HEM base address failed.\n");
+
+			dma_free_coherent(dev, bt_chunk_size,
+					  table->bt_l0[mhop.l0_idx],
+					  table->bt_l0_dma_addr[mhop.l0_idx]);
+			table->bt_l0[mhop.l0_idx] = NULL;
+		}
+	} else if (check_whether_bt_num_3(table->type, hop_num)) {
+		start_idx = mhop.l0_idx * chunk_ba_num * chunk_ba_num +
+			    mhop.l1_idx * chunk_ba_num;
+		if (hns_roce_check_hem_null(table->hem, start_idx,
+					    chunk_ba_num)) {
+			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 1))
+				dev_warn(dev, "Clear HEM base address failed.\n");
+
+			dma_free_coherent(dev, bt_chunk_size,
+					  table->bt_l1[bt_l1_idx],
+					  table->bt_l1_dma_addr[bt_l1_idx]);
+			table->bt_l1[bt_l1_idx] = NULL;
+
+			start_idx = mhop.l0_idx * chunk_ba_num;
+			if (hns_roce_check_bt_null(table->bt_l1, start_idx,
+						   chunk_ba_num)) {
+				if (hr_dev->hw->clear_hem(hr_dev, table, obj,
+							  0))
+					dev_warn(dev, "Clear HEM base address failed.\n");
+
+				dma_free_coherent(dev, bt_chunk_size,
+					    table->bt_l0[mhop.l0_idx],
+					    table->bt_l0_dma_addr[mhop.l0_idx]);
+				table->bt_l0[mhop.l0_idx] = NULL;
+			}
+		}
+	}
+
+	mutex_unlock(&table->mutex);
+}
+
 void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 			struct hns_roce_hem_table *table, unsigned long obj)
 {
 	struct device *dev = hr_dev->dev;
 	unsigned long i;
 
+	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
+		hns_roce_table_mhop_put(hr_dev, table, obj, 1);
+		return;
+	}
+
 	i = (obj & (table->num_obj - 1)) /
 	    (HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size);
 
@@ -261,7 +676,7 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 
 	if (--table->hem[i]->refcount == 0) {
 		/* Clear HEM base address */
-		if (hr_dev->hw->clear_hem(hr_dev, table, obj))
+		if (hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
 			dev_warn(dev, "Clear HEM base address failed.\n");
 
 		hns_roce_free_hem(hr_dev, table->hem[i]);
@@ -357,15 +772,105 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 			    unsigned long obj_size, unsigned long nobj,
 			    int use_lowmem)
 {
+	struct device *dev = hr_dev->dev;
 	unsigned long obj_per_chunk;
 	unsigned long num_hem;
 
-	obj_per_chunk = HNS_ROCE_TABLE_CHUNK_SIZE / obj_size;
-	num_hem = (nobj + obj_per_chunk - 1) / obj_per_chunk;
+	if (!hns_roce_check_whether_mhop(hr_dev, type)) {
+		obj_per_chunk = HNS_ROCE_TABLE_CHUNK_SIZE / obj_size;
+		num_hem = (nobj + obj_per_chunk - 1) / obj_per_chunk;
+
+		table->hem = kcalloc(num_hem, sizeof(*table->hem), GFP_KERNEL);
+		if (!table->hem)
+			return -ENOMEM;
+	} else {
+		unsigned long buf_chunk_size;
+		unsigned long bt_chunk_size;
+		unsigned long bt_chunk_num;
+		unsigned long num_bt_l0;
+		u32 hop_num;
+
+		switch (type) {
+		case HEM_TYPE_QPC:
+			buf_chunk_size = 1 << (hr_dev->caps.qpc_buf_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = 1 << (hr_dev->caps.qpc_ba_pg_sz
+					+ PAGE_SHIFT);
+			num_bt_l0 = hr_dev->caps.qpc_bt_num;
+			hop_num = hr_dev->caps.qpc_hop_num;
+			break;
+		case HEM_TYPE_MTPT:
+			buf_chunk_size = 1 << (hr_dev->caps.mpt_buf_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = 1 << (hr_dev->caps.mpt_ba_pg_sz
+					+ PAGE_SHIFT);
+			num_bt_l0 = hr_dev->caps.mpt_bt_num;
+			hop_num = hr_dev->caps.mpt_hop_num;
+			break;
+		case HEM_TYPE_CQC:
+			buf_chunk_size = 1 << (hr_dev->caps.cqc_buf_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = 1 << (hr_dev->caps.cqc_ba_pg_sz
+					+ PAGE_SHIFT);
+			num_bt_l0 = hr_dev->caps.cqc_bt_num;
+			hop_num = hr_dev->caps.cqc_hop_num;
+			break;
+		case HEM_TYPE_SRQC:
+			buf_chunk_size = 1 << (hr_dev->caps.srqc_buf_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = 1 << (hr_dev->caps.srqc_ba_pg_sz
+					+ PAGE_SHIFT);
+			num_bt_l0 = hr_dev->caps.srqc_bt_num;
+			hop_num = hr_dev->caps.srqc_hop_num;
+			break;
+		default:
+			dev_err(dev,
+			  "Table %d not support to init hem table here!\n",
+			  type);
+			return -EINVAL;
+		}
+		obj_per_chunk = buf_chunk_size / obj_size;
+		num_hem = (nobj + obj_per_chunk - 1) / obj_per_chunk;
+		bt_chunk_num = bt_chunk_size / 8;
+
+		table->hem = kcalloc(num_hem, sizeof(*table->hem),
+					 GFP_KERNEL);
+		if (!table->hem)
+			goto err_kcalloc_hem_buf;
+
+		if (check_whether_bt_num_3(table->type, hop_num)) {
+			unsigned long num_bt_l1;
+
+			num_bt_l1 = (num_hem + bt_chunk_num - 1) /
+					     bt_chunk_num;
+			table->bt_l1 = kcalloc(num_bt_l1,
+					       sizeof(*table->bt_l1),
+					       GFP_KERNEL);
+			if (!table->bt_l1)
+				goto err_kcalloc_bt_l1;
+
+			table->bt_l1_dma_addr = kcalloc(num_bt_l1,
+						 sizeof(*table->bt_l1_dma_addr),
+						 GFP_KERNEL);
+
+			if (!table->bt_l1_dma_addr)
+				goto err_kcalloc_l1_dma;
+		}
 
-	table->hem = kcalloc(num_hem, sizeof(*table->hem), GFP_KERNEL);
-	if (!table->hem)
-		return -ENOMEM;
+		if (check_whether_bt_num_2(table->type, hop_num) ||
+			check_whether_bt_num_3(table->type, hop_num)) {
+			table->bt_l0 = kcalloc(num_bt_l0, sizeof(*table->bt_l0),
+					       GFP_KERNEL);
+			if (!table->bt_l0)
+				goto err_kcalloc_bt_l0;
+
+			table->bt_l0_dma_addr = kcalloc(num_bt_l0,
+						 sizeof(*table->bt_l0_dma_addr),
+						 GFP_KERNEL);
+			if (!table->bt_l0_dma_addr)
+				goto err_kcalloc_l0_dma;
+		}
+	}
 
 	table->type = type;
 	table->num_hem = num_hem;
@@ -375,6 +880,54 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 	mutex_init(&table->mutex);
 
 	return 0;
+
+err_kcalloc_l0_dma:
+	kfree(table->bt_l0);
+	table->bt_l0 = NULL;
+
+err_kcalloc_bt_l0:
+	kfree(table->bt_l1_dma_addr);
+	table->bt_l1_dma_addr = NULL;
+
+err_kcalloc_l1_dma:
+	kfree(table->bt_l1);
+	table->bt_l1 = NULL;
+
+err_kcalloc_bt_l1:
+	kfree(table->hem);
+	table->hem = NULL;
+
+err_kcalloc_hem_buf:
+	return -ENOMEM;
+}
+
+void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
+				     struct hns_roce_hem_table *table)
+{
+	struct hns_roce_hem_mhop mhop;
+	u32 buf_chunk_size;
+	int i;
+	u64 obj;
+
+	hns_roce_calc_hem_mhop(hr_dev, table, NULL, &mhop);
+	buf_chunk_size = mhop.buf_chunk_size;
+
+	for (i = 0; i < table->num_hem; ++i) {
+		obj = i * buf_chunk_size / table->obj_size;
+		if (table->hem[i])
+			hns_roce_table_mhop_put(hr_dev, table, obj, 0);
+	}
+
+	kfree(table->hem);
+	table->hem = NULL;
+	kfree(table->bt_l1);
+	table->bt_l1 = NULL;
+	kfree(table->bt_l1_dma_addr);
+	table->bt_l1_dma_addr = NULL;
+	kfree(table->bt_l0);
+	table->bt_l0 = NULL;
+	kfree(table->bt_l0_dma_addr);
+	table->bt_l0_dma_addr = NULL;
 }
 
 void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
@@ -383,10 +936,15 @@ void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 	struct device *dev = hr_dev->dev;
 	unsigned long i;
 
+	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
+		hns_roce_cleanup_mhop_hem_table(hr_dev, table);
+		return;
+	}
+
 	for (i = 0; i < table->num_hem; ++i)
 		if (table->hem[i]) {
 			if (hr_dev->hw->clear_hem(hr_dev, table,
-			    i * HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size))
+			    i * HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size, 0))
 				dev_err(dev, "Clear HEM base address failed.\n");
 
 			hns_roce_free_hem(hr_dev, table->hem[i]);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index 4357488..b064ef5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -54,6 +54,15 @@ enum {
 	 ((256 - sizeof(struct list_head) - 2 * sizeof(int)) /	 \
 	 (sizeof(struct scatterlist)))
 
+#define check_whether_bt_num_3(type, hop_num) \
+	(type < HEM_TYPE_MTT && hop_num == 2)
+
+#define check_whether_bt_num_2(type, hop_num) \
+	(type < HEM_TYPE_MTT && hop_num == 1)
+
+#define check_whether_bt_num_1(type, hop_num) \
+	(type < HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0)
+
 enum {
 	 HNS_ROCE_HEM_PAGE_SHIFT = 12,
 	 HNS_ROCE_HEM_PAGE_SIZE  = 1 << HNS_ROCE_HEM_PAGE_SHIFT,
@@ -77,6 +86,16 @@ struct hns_roce_hem_iter {
 	int				 page_idx;
 };
 
+struct hns_roce_hem_mhop {
+	u32	hop_num;
+	u32	buf_chunk_size;
+	u32	bt_chunk_size;
+	u32	ba_l0_num;
+	u32	l0_idx;/* level 0 base address table index */
+	u32	l1_idx;/* level 1 base address table index */
+	u32	l2_idx;/* level 2 base address table index */
+};
+
 void hns_roce_free_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem *hem);
 int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 		       struct hns_roce_hem_table *table, unsigned long obj);
@@ -97,6 +116,10 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 void hns_roce_cleanup_hem_table(struct hns_roce_dev *hr_dev,
 				struct hns_roce_hem_table *table);
 void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev);
+int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
+			   struct hns_roce_hem_table *table, unsigned long *obj,
+			   struct hns_roce_hem_mhop *mhop);
+bool hns_roce_check_whether_mhop(struct hns_roce_dev *hr_dev, u32 type);
 
 static inline void hns_roce_hem_first(struct hns_roce_hem *hem,
 				      struct hns_roce_hem_iter *iter)
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 2bf2816..50dee13 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2356,7 +2356,7 @@ int hns_roce_v1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 }
 
 int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
-		struct hns_roce_hem_table *table, int obj)
+		struct hns_roce_hem_table *table, int obj, int step_idx)
 {
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_v1_priv *priv;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 259af2e..5127edc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -545,6 +545,19 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->reserved_uars	= 0;
 	caps->reserved_cqs	= 0;
 
+	caps->qpc_ba_pg_sz	= 0;
+	caps->qpc_buf_pg_sz	= 0;
+	caps->qpc_hop_num	= HNS_ROCE_CONTEXT_HOP_NUM;
+	caps->srqc_ba_pg_sz	= 0;
+	caps->srqc_buf_pg_sz	= 0;
+	caps->srqc_hop_num	= HNS_ROCE_HOP_NUM_0;
+	caps->cqc_ba_pg_sz	= 0;
+	caps->cqc_buf_pg_sz	= 0;
+	caps->cqc_hop_num	= HNS_ROCE_CONTEXT_HOP_NUM;
+	caps->mpt_ba_pg_sz	= 0;
+	caps->mpt_buf_pg_sz	= 0;
+	caps->mpt_hop_num	= HNS_ROCE_CONTEXT_HOP_NUM;
+
 	caps->pkey_table_len[0] = 1;
 	caps->gid_table_len[0] = 2;
 	caps->local_ca_ack_delay = 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index b420ea9..91f5161 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -72,6 +72,9 @@
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_CMQ_TX_TIMEOUT			200
 
+#define HNS_ROCE_CONTEXT_HOP_NUM		1
+#define HNS_ROCE_MTT_HOP_NUM			1
+
 #define HNS_ROCE_CMD_FLAG_IN_VALID_SHIFT	0
 #define HNS_ROCE_CMD_FLAG_OUT_VALID_SHIFT	1
 #define HNS_ROCE_CMD_FLAG_NEXT_SHIFT		2
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
