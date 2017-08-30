From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 11/20] RDMA/hns: Split CQE from MTT in hip08
Date: Wed, 30 Aug 2017 17:23:09 +0800
Message-ID: <1504084998-64397-12-git-send-email-xavier.huwei@huawei.com>
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

In hip08, the SQWQE/SGE/RQWQE and CQE have different hop num and
page size, so we need to manage the base address table of the
SQWQE/SGE/RQWQE and CQE separately.

This patch is to split CQE from MTT(SQWQE/SGE/RQWQE).

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 15 ++++++-
 drivers/infiniband/hw/hns/hns_roce_device.h | 14 ++++--
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  3 ++
 drivers/infiniband/hw/hns/hns_roce_main.c   | 17 ++++++++
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 66 ++++++++++++++++++++++-------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  2 +
 6 files changed, 98 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 362aeec..9cf213c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -96,7 +96,11 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 	cq_table = &hr_dev->cq_table;
 
 	/* Get the physical address of cq buf */
-	mtt_table = &hr_dev->mr_table.mtt_table;
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		mtt_table = &hr_dev->mr_table.mtt_cqe_table;
+	else
+		mtt_table = &hr_dev->mr_table.mtt_table;
+
 	mtts = hns_roce_table_find(hr_dev, mtt_table,
 				   hr_mtt->first_seg, &dma_handle);
 	if (!mtts) {
@@ -221,6 +225,10 @@ static int hns_roce_ib_get_cq_umem(struct hns_roce_dev *hr_dev,
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
 
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		buf->hr_mtt.mtt_type = MTT_TYPE_CQE;
+	else
+		buf->hr_mtt.mtt_type = MTT_TYPE_WQE;
 	ret = hns_roce_mtt_init(hr_dev, ib_umem_page_count(*umem),
 				(*umem)->page_shift, &buf->hr_mtt);
 	if (ret)
@@ -250,6 +258,11 @@ static int hns_roce_ib_alloc_cq_buf(struct hns_roce_dev *hr_dev,
 	if (ret)
 		goto out;
 
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		buf->hr_mtt.mtt_type = MTT_TYPE_CQE;
+	else
+		buf->hr_mtt.mtt_type = MTT_TYPE_WQE;
+
 	ret = hns_roce_mtt_init(hr_dev, buf->hr_buf.npages,
 				buf->hr_buf.page_shift, &buf->hr_mtt);
 	if (ret)
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 7dd8fbb2..319c7054 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -170,6 +170,11 @@ enum {
 	HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE	= 0x07,
 };
 
+enum hns_roce_mtt_type {
+	MTT_TYPE_WQE = 0,
+	MTT_TYPE_CQE,
+};
+
 #define HNS_ROCE_CMD_SUCCESS			1
 
 #define HNS_ROCE_PORT_DOWN			0
@@ -241,9 +246,10 @@ struct hns_roce_hem_table {
 };
 
 struct hns_roce_mtt {
-	unsigned long	first_seg;
-	int		order;
-	int		page_shift;
+	unsigned long		first_seg;
+	int			order;
+	int			page_shift;
+	enum hns_roce_mtt_type	mtt_type;
 };
 
 /* Only support 4K page size for mr register */
@@ -268,6 +274,8 @@ struct hns_roce_mr_table {
 	struct hns_roce_buddy		mtt_buddy;
 	struct hns_roce_hem_table	mtt_table;
 	struct hns_roce_hem_table	mtpt_table;
+	struct hns_roce_buddy		mtt_cqe_buddy;
+	struct hns_roce_hem_table	mtt_cqe_table;
 };
 
 struct hns_roce_wq {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index ac2d671..8a3e174 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1041,4 +1041,7 @@ void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev)
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->qp_table.qp_table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtpt_table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtt_table);
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		hns_roce_cleanup_hem_table(hr_dev,
+					   &hr_dev->mr_table.mtt_cqe_table);
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index db6593e..a110f96 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -546,6 +546,17 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		return ret;
 	}
 
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE)) {
+		ret = hns_roce_init_hem_table(hr_dev,
+				      &hr_dev->mr_table.mtt_cqe_table,
+				      HEM_TYPE_CQE, hr_dev->caps.mtt_entry_sz,
+				      hr_dev->caps.num_cqe_segs, 1);
+		if (ret) {
+			dev_err(dev, "Failed to init MTT CQE context memory, aborting.\n");
+			goto err_unmap_cqe;
+		}
+	}
+
 	ret = hns_roce_init_hem_table(hr_dev, &hr_dev->mr_table.mtpt_table,
 				      HEM_TYPE_MTPT, hr_dev->caps.mtpt_entry_sz,
 				      hr_dev->caps.num_mtpts, 1);
@@ -593,6 +604,12 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 
 err_unmap_mtt:
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtt_table);
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		hns_roce_cleanup_hem_table(hr_dev,
+					   &hr_dev->mr_table.mtt_cqe_table);
+
+err_unmap_cqe:
+	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtt_table);
 
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index d8f7b41..88b436f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -177,18 +177,28 @@ static void hns_roce_buddy_cleanup(struct hns_roce_buddy *buddy)
 }
 
 static int hns_roce_alloc_mtt_range(struct hns_roce_dev *hr_dev, int order,
-				    unsigned long *seg)
+				    unsigned long *seg, u32 mtt_type)
 {
 	struct hns_roce_mr_table *mr_table = &hr_dev->mr_table;
-	int ret = 0;
+	struct hns_roce_hem_table *table;
+	struct hns_roce_buddy *buddy;
+	int ret;
+
+	if (mtt_type == MTT_TYPE_WQE) {
+		buddy = &mr_table->mtt_buddy;
+		table = &mr_table->mtt_table;
+	} else {
+		buddy = &mr_table->mtt_cqe_buddy;
+		table = &mr_table->mtt_cqe_table;
+	}
 
-	ret = hns_roce_buddy_alloc(&mr_table->mtt_buddy, order, seg);
+	ret = hns_roce_buddy_alloc(buddy, order, seg);
 	if (ret == -1)
 		return -1;
 
-	if (hns_roce_table_get_range(hr_dev, &mr_table->mtt_table, *seg,
+	if (hns_roce_table_get_range(hr_dev, table, *seg,
 				     *seg + (1 << order) - 1)) {
-		hns_roce_buddy_free(&mr_table->mtt_buddy, *seg, order);
+		hns_roce_buddy_free(buddy, *seg, order);
 		return -1;
 	}
 
@@ -198,7 +208,7 @@ static int hns_roce_alloc_mtt_range(struct hns_roce_dev *hr_dev, int order,
 int hns_roce_mtt_init(struct hns_roce_dev *hr_dev, int npages, int page_shift,
 		      struct hns_roce_mtt *mtt)
 {
-	int ret = 0;
+	int ret;
 	int i;
 
 	/* Page num is zero, correspond to DMA memory register */
@@ -217,7 +227,8 @@ int hns_roce_mtt_init(struct hns_roce_dev *hr_dev, int npages, int page_shift,
 		++mtt->order;
 
 	/* Allocate MTT entry */
-	ret = hns_roce_alloc_mtt_range(hr_dev, mtt->order, &mtt->first_seg);
+	ret = hns_roce_alloc_mtt_range(hr_dev, mtt->order, &mtt->first_seg,
+				       mtt->mtt_type);
 	if (ret == -1)
 		return -ENOMEM;
 
@@ -231,9 +242,19 @@ void hns_roce_mtt_cleanup(struct hns_roce_dev *hr_dev, struct hns_roce_mtt *mtt)
 	if (mtt->order < 0)
 		return;
 
-	hns_roce_buddy_free(&mr_table->mtt_buddy, mtt->first_seg, mtt->order);
-	hns_roce_table_put_range(hr_dev, &mr_table->mtt_table, mtt->first_seg,
-				 mtt->first_seg + (1 << mtt->order) - 1);
+	if (mtt->mtt_type == MTT_TYPE_WQE) {
+		hns_roce_buddy_free(&mr_table->mtt_buddy, mtt->first_seg,
+				    mtt->order);
+		hns_roce_table_put_range(hr_dev, &mr_table->mtt_table,
+					mtt->first_seg,
+					mtt->first_seg + (1 << mtt->order) - 1);
+	} else {
+		hns_roce_buddy_free(&mr_table->mtt_cqe_buddy, mtt->first_seg,
+				    mtt->order);
+		hns_roce_table_put_range(hr_dev, &mr_table->mtt_cqe_table,
+					mtt->first_seg,
+					mtt->first_seg + (1 << mtt->order) - 1);
+	}
 }
 EXPORT_SYMBOL_GPL(hns_roce_mtt_cleanup);
 
@@ -362,7 +383,11 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 	if (start_index & (HNS_ROCE_MTT_ENTRY_PER_SEG - 1))
 		return -EINVAL;
 
-	table = &hr_dev->mr_table.mtt_table;
+	if (mtt->mtt_type == MTT_TYPE_WQE)
+		table = &hr_dev->mr_table.mtt_table;
+	else
+		table = &hr_dev->mr_table.mtt_cqe_table;
+
 	mtts = hns_roce_table_find(hr_dev, table,
 				mtt->first_seg + s / hr_dev->caps.mtt_entry_sz,
 				&dma_handle);
@@ -409,9 +434,9 @@ static int hns_roce_write_mtt(struct hns_roce_dev *hr_dev,
 int hns_roce_buf_write_mtt(struct hns_roce_dev *hr_dev,
 			   struct hns_roce_mtt *mtt, struct hns_roce_buf *buf)
 {
-	u32 i = 0;
-	int ret = 0;
-	u64 *page_list = NULL;
+	u64 *page_list;
+	int ret;
+	u32 i;
 
 	page_list = kmalloc_array(buf->npages, sizeof(*page_list), GFP_KERNEL);
 	if (!page_list)
@@ -434,7 +459,7 @@ int hns_roce_buf_write_mtt(struct hns_roce_dev *hr_dev,
 int hns_roce_init_mr_table(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_mr_table *mr_table = &hr_dev->mr_table;
-	int ret = 0;
+	int ret;
 
 	ret = hns_roce_bitmap_init(&mr_table->mtpt_bitmap,
 				   hr_dev->caps.num_mtpts,
@@ -448,8 +473,17 @@ int hns_roce_init_mr_table(struct hns_roce_dev *hr_dev)
 	if (ret)
 		goto err_buddy;
 
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE)) {
+		ret = hns_roce_buddy_init(&mr_table->mtt_cqe_buddy,
+					  ilog2(hr_dev->caps.num_cqe_segs));
+		if (ret)
+			goto err_buddy_cqe;
+	}
 	return 0;
 
+err_buddy_cqe:
+	hns_roce_buddy_cleanup(&mr_table->mtt_buddy);
+
 err_buddy:
 	hns_roce_bitmap_cleanup(&mr_table->mtpt_bitmap);
 	return ret;
@@ -460,6 +494,8 @@ void hns_roce_cleanup_mr_table(struct hns_roce_dev *hr_dev)
 	struct hns_roce_mr_table *mr_table = &hr_dev->mr_table;
 
 	hns_roce_buddy_cleanup(&mr_table->mtt_buddy);
+	if (hns_roce_check_whether_mhop(hr_dev, HEM_TYPE_CQE))
+		hns_roce_buddy_cleanup(&mr_table->mtt_cqe_buddy);
 	hns_roce_bitmap_cleanup(&mr_table->mtpt_bitmap);
 }
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index b512ecc..881ea67 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -440,6 +440,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 			goto err_out;
 		}
 
+		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
 		ret = hns_roce_mtt_init(hr_dev, ib_umem_page_count(hr_qp->umem),
 					hr_qp->umem->page_shift, &hr_qp->mtt);
 		if (ret) {
@@ -490,6 +491,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 			goto err_out;
 		}
 
+		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
 		/* Write MTT */
 		ret = hns_roce_mtt_init(hr_dev, hr_qp->hr_buf.npages,
 					hr_qp->hr_buf.page_shift, &hr_qp->mtt);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
