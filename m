From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 10/20] RDMA/hns: Update the interfaces for MTT/CQE multi hop addressing in hip08
Date: Wed, 30 Aug 2017 17:23:08 +0800
Message-ID: <1504084998-64397-11-git-send-email-xavier.huwei@huawei.com>
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

The MTT(SQWQE/SGE/RQWQE) and CQE in hip08 can support multi hop
addressing. The address of MTT/CQE can be retrieved by the BT
(Base Address Table) with multi hop addressing.

This patch is to update the interfaces in HEM to support multi hop
addressing for the MTT/CQE.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  12 +--
 drivers/infiniband/hw/hns/hns_roce_device.h |   6 ++
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 119 +++++++++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  11 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   8 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |   6 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   1 +
 drivers/infiniband/hw/hns/hns_roce_mr.c     |  16 ++--
 8 files changed, 143 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 5f51242..362aeec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -85,17 +85,19 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 			     struct hns_roce_uar *hr_uar,
 			     struct hns_roce_cq *hr_cq, int vector)
 {
-	struct hns_roce_cmd_mailbox *mailbox = NULL;
-	struct hns_roce_cq_table *cq_table = NULL;
+	struct hns_roce_cmd_mailbox *mailbox;
+	struct hns_roce_hem_table *mtt_table;
+	struct hns_roce_cq_table *cq_table;
 	struct device *dev = hr_dev->dev;
 	dma_addr_t dma_handle;
-	u64 *mtts = NULL;
-	int ret = 0;
+	u64 *mtts;
+	int ret;
 
 	cq_table = &hr_dev->cq_table;
 
 	/* Get the physical address of cq buf */
-	mtts = hns_roce_table_find(&hr_dev->mr_table.mtt_table,
+	mtt_table = &hr_dev->mr_table.mtt_table;
+	mtts = hns_roce_table_find(hr_dev, mtt_table,
 				   hr_mtt->first_seg, &dma_handle);
 	if (!mtts) {
 		dev_err(dev, "CQ alloc.Failed to find cq buf addr.\n");
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 4574a7b..7dd8fbb2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -525,6 +525,12 @@ struct hns_roce_caps {
 	u32		mpt_ba_pg_sz;
 	u32		mpt_buf_pg_sz;
 	u32		mpt_hop_num;
+	u32		mtt_ba_pg_sz;
+	u32		mtt_buf_pg_sz;
+	u32		mtt_hop_num;
+	u32		cqe_ba_pg_sz;
+	u32		cqe_buf_pg_sz;
+	u32		cqe_hop_num;
 };
 
 struct hns_roce_hw {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 9bc8c6b..ac2d671 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -47,7 +47,9 @@ bool hns_roce_check_whether_mhop(struct hns_roce_dev *hr_dev, u32 type)
 	if ((hr_dev->caps.qpc_hop_num && type == HEM_TYPE_QPC) ||
 	    (hr_dev->caps.mpt_hop_num && type == HEM_TYPE_MTPT) ||
 	    (hr_dev->caps.cqc_hop_num && type == HEM_TYPE_CQC) ||
-	    (hr_dev->caps.srqc_hop_num && type == HEM_TYPE_SRQC))
+	    (hr_dev->caps.srqc_hop_num && type == HEM_TYPE_SRQC) ||
+	    (hr_dev->caps.cqe_hop_num && type == HEM_TYPE_CQE) ||
+	    (hr_dev->caps.mtt_hop_num && type == HEM_TYPE_MTT))
 		return true;
 
 	return false;
@@ -132,6 +134,22 @@ int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
 		mhop->ba_l0_num = hr_dev->caps.srqc_bt_num;
 		mhop->hop_num = hr_dev->caps.srqc_hop_num;
 		break;
+	case HEM_TYPE_MTT:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.mtt_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.mtt_ba_pg_sz
+					     + PAGE_SHIFT);
+		mhop->ba_l0_num = mhop->bt_chunk_size / 8;
+		mhop->hop_num = hr_dev->caps.mtt_hop_num;
+		break;
+	case HEM_TYPE_CQE:
+		mhop->buf_chunk_size = 1 << (hr_dev->caps.cqe_buf_pg_sz
+					     + PAGE_SHIFT);
+		mhop->bt_chunk_size = 1 << (hr_dev->caps.cqe_ba_pg_sz
+					     + PAGE_SHIFT);
+		mhop->ba_l0_num = mhop->bt_chunk_size / 8;
+		mhop->hop_num = hr_dev->caps.cqe_hop_num;
+		break;
 	default:
 		dev_err(dev, "Table %d not support multi-hop addressing!\n",
 			 table->type);
@@ -141,10 +159,14 @@ int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
 	if (!obj)
 		return 0;
 
-	/* QPC/MTPT/CQC/SRQC alloc hem for buffer pages. */
+	/*
+	 * QPC/MTPT/CQC/SRQC alloc hem for buffer pages.
+	 * MTT/CQE alloc hem for bt pages.
+	 */
 	bt_num = hns_roce_get_bt_num(table->type, mhop->hop_num);
 	chunk_ba_num = mhop->bt_chunk_size / 8;
-	chunk_size = mhop->buf_chunk_size;
+	chunk_size = table->type < HEM_TYPE_MTT ? mhop->buf_chunk_size :
+			      mhop->bt_chunk_size;
 	table_idx = (*obj & (table->num_obj - 1)) /
 		     (chunk_size / table->obj_size);
 	switch (bt_num) {
@@ -448,8 +470,11 @@ int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 		}
 	}
 
-	/* alloc buffer space chunk for QPC/MTPT/CQC/SRQC. */
-	size = buf_chunk_size;
+	/*
+	 * alloc buffer space chunk for QPC/MTPT/CQC/SRQC.
+	 * alloc bt space chunk for MTT/CQE.
+	 */
+	size = table->type < HEM_TYPE_MTT ? buf_chunk_size : bt_chunk_size;
 	table->hem[hem_idx] = hns_roce_alloc_hem(hr_dev,
 						size >> PAGE_SHIFT,
 						size,
@@ -480,6 +505,8 @@ int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 			dev_err(dev, "set HEM base address to HW failed!\n");
 			goto err_alloc_hem_buf;
 		}
+	} else if (hop_num == 2) {
+		*(table->bt_l0[bt_l0_idx] + mhop.l1_idx) = bt_ba;
 	}
 
 	++table->hem[hem_idx]->refcount;
@@ -610,7 +637,10 @@ void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
 			dev_warn(dev, "Clear HEM base address failed.\n");
 	}
 
-	/* free buffer space chunk for QPC/MTPT/CQC/SRQC. */
+	/*
+	 * free buffer space chunk for QPC/MTPT/CQC/SRQC.
+	 * free bt space chunk for MTT/CQE.
+	 */
 	hns_roce_free_hem(hr_dev, table->hem[hem_idx]);
 	table->hem[hem_idx] = NULL;
 
@@ -686,23 +716,46 @@ void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 	mutex_unlock(&table->mutex);
 }
 
-void *hns_roce_table_find(struct hns_roce_hem_table *table, unsigned long obj,
-			  dma_addr_t *dma_handle)
+void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
+			  struct hns_roce_hem_table *table,
+			  unsigned long obj, dma_addr_t *dma_handle)
 {
 	struct hns_roce_hem_chunk *chunk;
-	unsigned long idx;
-	int i;
-	int offset, dma_offset;
+	struct hns_roce_hem_mhop mhop;
 	struct hns_roce_hem *hem;
 	struct page *page = NULL;
+	unsigned long mhop_obj = obj;
+	unsigned long idx;
+	int offset, dma_offset;
+	int i, j;
+	u32 hem_idx = 0;
 
 	if (!table->lowmem)
 		return NULL;
 
 	mutex_lock(&table->mutex);
-	idx = (obj & (table->num_obj - 1)) * table->obj_size;
-	hem = table->hem[idx / HNS_ROCE_TABLE_CHUNK_SIZE];
-	dma_offset = offset = idx % HNS_ROCE_TABLE_CHUNK_SIZE;
+
+	if (!hns_roce_check_whether_mhop(hr_dev, table->type)) {
+		idx = (obj & (table->num_obj - 1)) * table->obj_size;
+		hem = table->hem[idx / HNS_ROCE_TABLE_CHUNK_SIZE];
+		dma_offset = offset = idx % HNS_ROCE_TABLE_CHUNK_SIZE;
+	} else {
+		hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
+		/* mtt mhop */
+		i = mhop.l0_idx;
+		j = mhop.l1_idx;
+		if (mhop.hop_num == 2)
+			hem_idx = i * (mhop.bt_chunk_size / 8) + j;
+		else if (mhop.hop_num == 1 ||
+			 mhop.hop_num == HNS_ROCE_HOP_NUM_0)
+			hem_idx = i;
+
+		hem = table->hem[hem_idx];
+		dma_offset = offset = (obj & (table->num_obj - 1)) *
+				       table->obj_size % mhop.bt_chunk_size;
+		if (mhop.hop_num == 2)
+			dma_offset = offset = 0;
+	}
 
 	if (!hem)
 		goto out;
@@ -735,9 +788,15 @@ int hns_roce_table_get_range(struct hns_roce_dev *hr_dev,
 			     struct hns_roce_hem_table *table,
 			     unsigned long start, unsigned long end)
 {
+	struct hns_roce_hem_mhop mhop;
 	unsigned long inc = HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size;
-	unsigned long i = 0;
-	int ret = 0;
+	unsigned long i;
+	int ret;
+
+	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
+		hns_roce_calc_hem_mhop(hr_dev, table, NULL, &mhop);
+		inc = mhop.bt_chunk_size / table->obj_size;
+	}
 
 	/* Allocate MTT entry memory according to chunk(128K) */
 	for (i = start; i <= end; i += inc) {
@@ -760,10 +819,17 @@ void hns_roce_table_put_range(struct hns_roce_dev *hr_dev,
 			      struct hns_roce_hem_table *table,
 			      unsigned long start, unsigned long end)
 {
+	struct hns_roce_hem_mhop mhop;
+	unsigned long inc = HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size;
 	unsigned long i;
 
+	if (hns_roce_check_whether_mhop(hr_dev, table->type)) {
+		hns_roce_calc_hem_mhop(hr_dev, table, NULL, &mhop);
+		inc = mhop.bt_chunk_size / table->obj_size;
+	}
+
 	for (i = start; i <= end;
-		i += HNS_ROCE_TABLE_CHUNK_SIZE / table->obj_size)
+		i += inc)
 		hns_roce_table_put(hr_dev, table, i);
 }
 
@@ -787,7 +853,7 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 		unsigned long buf_chunk_size;
 		unsigned long bt_chunk_size;
 		unsigned long bt_chunk_num;
-		unsigned long num_bt_l0;
+		unsigned long num_bt_l0 = 0;
 		u32 hop_num;
 
 		switch (type) {
@@ -823,6 +889,18 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 			num_bt_l0 = hr_dev->caps.srqc_bt_num;
 			hop_num = hr_dev->caps.srqc_hop_num;
 			break;
+		case HEM_TYPE_MTT:
+			buf_chunk_size = 1 << (hr_dev->caps.mtt_ba_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = buf_chunk_size;
+			hop_num = hr_dev->caps.mtt_hop_num;
+			break;
+		case HEM_TYPE_CQE:
+			buf_chunk_size = 1 << (hr_dev->caps.cqe_ba_pg_sz
+					+ PAGE_SHIFT);
+			bt_chunk_size = buf_chunk_size;
+			hop_num = hr_dev->caps.cqe_hop_num;
+			break;
 		default:
 			dev_err(dev,
 			  "Table %d not support to init hem table here!\n",
@@ -832,6 +910,8 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 		obj_per_chunk = buf_chunk_size / obj_size;
 		num_hem = (nobj + obj_per_chunk - 1) / obj_per_chunk;
 		bt_chunk_num = bt_chunk_size / 8;
+		if (table->type >= HEM_TYPE_MTT)
+			num_bt_l0 = bt_chunk_num;
 
 		table->hem = kcalloc(num_hem, sizeof(*table->hem),
 					 GFP_KERNEL);
@@ -910,7 +990,8 @@ void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
 	u64 obj;
 
 	hns_roce_calc_hem_mhop(hr_dev, table, NULL, &mhop);
-	buf_chunk_size = mhop.buf_chunk_size;
+	buf_chunk_size = table->type < HEM_TYPE_MTT ? mhop.buf_chunk_size :
+					mhop.bt_chunk_size;
 
 	for (i = 0; i < table->num_hem; ++i) {
 		obj = i * buf_chunk_size / table->obj_size;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index b064ef5..1aa54b6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -47,6 +47,7 @@ enum {
 
 	 /* UNMAP HEM */
 	HEM_TYPE_MTT,
+	HEM_TYPE_CQE,
 	HEM_TYPE_IRRL,
 };
 
@@ -58,10 +59,13 @@ enum {
 	(type < HEM_TYPE_MTT && hop_num == 2)
 
 #define check_whether_bt_num_2(type, hop_num) \
-	(type < HEM_TYPE_MTT && hop_num == 1)
+	((type < HEM_TYPE_MTT && hop_num == 1) || \
+	(type >= HEM_TYPE_MTT && hop_num == 2))
 
 #define check_whether_bt_num_1(type, hop_num) \
-	(type < HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0)
+	((type < HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0) || \
+	(type >= HEM_TYPE_MTT && hop_num == 1) || \
+	(type >= HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0))
 
 enum {
 	 HNS_ROCE_HEM_PAGE_SHIFT = 12,
@@ -101,7 +105,8 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 		       struct hns_roce_hem_table *table, unsigned long obj);
 void hns_roce_table_put(struct hns_roce_dev *hr_dev,
 			struct hns_roce_hem_table *table, unsigned long obj);
-void *hns_roce_table_find(struct hns_roce_hem_table *table, unsigned long obj,
+void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
+			  struct hns_roce_hem_table *table, unsigned long obj,
 			  dma_addr_t *dma_handle);
 int hns_roce_table_get_range(struct hns_roce_dev *hr_dev,
 			     struct hns_roce_hem_table *table,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 50dee13..0a634c5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2524,7 +2524,7 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		return -ENOMEM;
 
 	/* Search QP buf's MTTs */
-	mtts = hns_roce_table_find(&hr_dev->mr_table.mtt_table,
+	mtts = hns_roce_table_find(hr_dev, &hr_dev->mr_table.mtt_table,
 				   hr_qp->mtt.first_seg, &dma_handle);
 	if (!mtts) {
 		dev_err(dev, "qp buf pa find failed\n");
@@ -2671,7 +2671,7 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		return -ENOMEM;
 
 	/* Search qp buf's mtts */
-	mtts = hns_roce_table_find(&hr_dev->mr_table.mtt_table,
+	mtts = hns_roce_table_find(hr_dev, &hr_dev->mr_table.mtt_table,
 				   hr_qp->mtt.first_seg, &dma_handle);
 	if (mtts == NULL) {
 		dev_err(dev, "qp buf pa find failed\n");
@@ -2679,8 +2679,8 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	}
 
 	/* Search IRRL's mtts */
-	mtts_2 = hns_roce_table_find(&hr_dev->qp_table.irrl_table, hr_qp->qpn,
-				     &dma_handle_2);
+	mtts_2 = hns_roce_table_find(hr_dev, &hr_dev->qp_table.irrl_table,
+				     hr_qp->qpn, &dma_handle_2);
 	if (mtts_2 == NULL) {
 		dev_err(dev, "qp irrl_table find failed\n");
 		goto out;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 77cf476..c59d15e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -613,6 +613,12 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->mpt_ba_pg_sz	= 0;
 	caps->mpt_buf_pg_sz	= 0;
 	caps->mpt_hop_num	= HNS_ROCE_CONTEXT_HOP_NUM;
+	caps->mtt_ba_pg_sz	= 0;
+	caps->mtt_buf_pg_sz	= 0;
+	caps->mtt_hop_num	= HNS_ROCE_MTT_HOP_NUM;
+	caps->cqe_ba_pg_sz	= 0;
+	caps->cqe_buf_pg_sz	= 0;
+	caps->cqe_hop_num	= HNS_ROCE_CQE_HOP_NUM;
 
 	caps->pkey_table_len[0] = 1;
 	caps->gid_table_len[0] = 2;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index cc8c8d0..212d511 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -74,6 +74,7 @@
 
 #define HNS_ROCE_CONTEXT_HOP_NUM		1
 #define HNS_ROCE_MTT_HOP_NUM			1
+#define HNS_ROCE_CQE_HOP_NUM			1
 
 #define HNS_ROCE_CMD_FLAG_IN_VALID_SHIFT	0
 #define HNS_ROCE_CMD_FLAG_OUT_VALID_SHIFT	1
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 923d2b4..d8f7b41 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -348,10 +348,11 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 				    struct hns_roce_mtt *mtt, u32 start_index,
 				    u32 npages, u64 *page_list)
 {
-	u32 i = 0;
-	__le64 *mtts = NULL;
+	struct hns_roce_hem_table *table;
 	dma_addr_t dma_handle;
+	__le64 *mtts;
 	u32 s = start_index * sizeof(u64);
+	u32 i;
 
 	/* All MTTs must fit in the same page */
 	if (start_index / (PAGE_SIZE / sizeof(u64)) !=
@@ -361,15 +362,20 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 	if (start_index & (HNS_ROCE_MTT_ENTRY_PER_SEG - 1))
 		return -EINVAL;
 
-	mtts = hns_roce_table_find(&hr_dev->mr_table.mtt_table,
+	table = &hr_dev->mr_table.mtt_table;
+	mtts = hns_roce_table_find(hr_dev, table,
 				mtt->first_seg + s / hr_dev->caps.mtt_entry_sz,
 				&dma_handle);
 	if (!mtts)
 		return -ENOMEM;
 
 	/* Save page addr, low 12 bits : 0 */
-	for (i = 0; i < npages; ++i)
-		mtts[i] = (cpu_to_le64(page_list[i])) >> PAGE_ADDR_SHIFT;
+	for (i = 0; i < npages; ++i) {
+		if (!hr_dev->caps.mtt_hop_num)
+			mtts[i] = cpu_to_le64(page_list[i] >> PAGE_ADDR_SHIFT);
+		else
+			mtts[i] = cpu_to_le64(page_list[i]);
+	}
 
 	return 0;
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
