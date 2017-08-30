From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 02/20] RDMA/hns: Move priv in order to add multiple hns_roce support
Date: Wed, 30 Aug 2017 17:23:00 +0800
Message-ID: <1504084998-64397-3-git-send-email-xavier.huwei@huawei.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move the data member called priv from hns_roce_hw to hns_roce_dev
structure in order to support multiple hns_roce devices in one
system at the same time. For example, there are two hip06 engines
in the system.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 61 ++++++++++++++++-------------
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index fc2b82d..aa9281e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -535,7 +535,6 @@ struct hns_roce_hw {
 	int (*poll_cq)(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 	int (*dereg_mr)(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr);
 	int (*destroy_cq)(struct ib_cq *ibcq);
-	void	*priv;
 };
 
 struct hns_roce_dev {
@@ -572,6 +571,7 @@ struct hns_roce_dev {
 	dma_addr_t		tptr_dma_addr; /*only for hw v1*/
 	u32			tptr_size; /*only for hw v1*/
 	const struct hns_roce_hw *hw;
+	void			*priv;
 };
 
 static inline struct hns_roce_dev *to_hr_dev(struct ib_device *ib_dev)
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 917d003..e4d13a9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -473,7 +473,7 @@ static void hns_roce_set_sdb_ext(struct hns_roce_dev *hr_dev, u32 ext_sdb_alept,
 	dma_addr_t sdb_dma_addr;
 	u32 val;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	db = &priv->db_table;
 
 	/* Configure extend SDB threshold */
@@ -512,7 +512,7 @@ static void hns_roce_set_odb_ext(struct hns_roce_dev *hr_dev, u32 ext_odb_alept,
 	dma_addr_t odb_dma_addr;
 	u32 val;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	db = &priv->db_table;
 
 	/* Configure extend ODB threshold */
@@ -548,7 +548,7 @@ static int hns_roce_db_ext_init(struct hns_roce_dev *hr_dev, u32 sdb_ext_mod,
 	dma_addr_t odb_dma_addr;
 	int ret = 0;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	db = &priv->db_table;
 
 	db->ext_db = kmalloc(sizeof(*db->ext_db), GFP_KERNEL);
@@ -669,7 +669,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 	u8 port = 0;
 	u8 sl;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	/* Reserved cq for loop qp */
@@ -817,7 +817,7 @@ static void hns_roce_v1_release_lp_qp(struct hns_roce_dev *hr_dev)
 	int ret;
 	int i;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	for (i = 0; i < HNS_ROCE_V1_RESV_QP; i++) {
@@ -851,7 +851,7 @@ static int hns_roce_db_init(struct hns_roce_dev *hr_dev)
 	u32 odb_evt_mod;
 	int ret = 0;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	db = &priv->db_table;
 
 	memset(db, 0, sizeof(*db));
@@ -907,7 +907,7 @@ static int hns_roce_v1_recreate_lp_qp(struct hns_roce_dev *hr_dev)
 	unsigned long end =
 	  msecs_to_jiffies(HNS_ROCE_V1_RECREATE_LP_QP_TIMEOUT_MSECS) + jiffies;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	lp_qp_work = kzalloc(sizeof(struct hns_roce_recreate_lp_qp_work),
@@ -983,7 +983,7 @@ static void hns_roce_v1_mr_free_work_fn(struct work_struct *work)
 	hr_dev = to_hr_dev(mr_work->ib_dev);
 	dev = &hr_dev->pdev->dev;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 	mr_free_cq = free_mr->mr_free_cq;
 
@@ -1039,7 +1039,7 @@ int hns_roce_v1_dereg_mr(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr)
 	int npages;
 	int ret = 0;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	if (mr->enabled) {
@@ -1104,7 +1104,7 @@ static void hns_roce_db_free(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	struct hns_roce_db_table *db;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	db = &priv->db_table;
 
 	if (db->sdb_ext_mod) {
@@ -1134,7 +1134,7 @@ static int hns_roce_raq_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_raq_table *raq;
 	struct device *dev = &hr_dev->pdev->dev;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	raq = &priv->raq_table;
 
 	raq->e_raq_buf = kzalloc(sizeof(*(raq->e_raq_buf)), GFP_KERNEL);
@@ -1211,7 +1211,7 @@ static void hns_roce_raq_free(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	struct hns_roce_raq_table *raq;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	raq = &priv->raq_table;
 
 	dma_free_coherent(dev, HNS_ROCE_V1_RAQ_SIZE, raq->e_raq_buf->buf,
@@ -1245,7 +1245,7 @@ static int hns_roce_bt_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	int ret;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 
 	priv->bt_table.qpc_buf.buf = dma_alloc_coherent(dev,
 		HNS_ROCE_BT_RSV_BUF_SIZE, &priv->bt_table.qpc_buf.map,
@@ -1287,7 +1287,7 @@ static void hns_roce_bt_free(struct hns_roce_dev *hr_dev)
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_v1_priv *priv;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 
 	dma_free_coherent(dev, HNS_ROCE_BT_RSV_BUF_SIZE,
 		priv->bt_table.cqc_buf.buf, priv->bt_table.cqc_buf.map);
@@ -1305,7 +1305,7 @@ static int hns_roce_tptr_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_buf_list *tptr_buf;
 	struct hns_roce_v1_priv *priv;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	tptr_buf = &priv->tptr_table.tptr_buf;
 
 	/*
@@ -1331,7 +1331,7 @@ static void hns_roce_tptr_free(struct hns_roce_dev *hr_dev)
 	struct hns_roce_buf_list *tptr_buf;
 	struct hns_roce_v1_priv *priv;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	tptr_buf = &priv->tptr_table.tptr_buf;
 
 	dma_free_coherent(dev, HNS_ROCE_V1_TPTR_BUF_SIZE,
@@ -1345,7 +1345,7 @@ static int hns_roce_free_mr_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	int ret = 0;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	free_mr->free_mr_wq = create_singlethread_workqueue("hns_roce_free_mr");
@@ -1369,7 +1369,7 @@ static void hns_roce_free_mr_free(struct hns_roce_dev *hr_dev)
 	struct hns_roce_free_mr *free_mr;
 	struct hns_roce_v1_priv *priv;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	free_mr = &priv->free_mr;
 
 	flush_workqueue(free_mr->free_mr_wq);
@@ -1433,7 +1433,7 @@ static int hns_roce_des_qp_init(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	struct hns_roce_des_qp *des_qp;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	des_qp = &priv->des_qp;
 
 	des_qp->requeue_flag = 1;
@@ -1451,7 +1451,7 @@ static void hns_roce_des_qp_free(struct hns_roce_dev *hr_dev)
 	struct hns_roce_v1_priv *priv;
 	struct hns_roce_des_qp *des_qp;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	des_qp = &priv->des_qp;
 
 	des_qp->requeue_flag = 0;
@@ -1942,7 +1942,7 @@ void hns_roce_v1_write_cqc(struct hns_roce_dev *hr_dev,
 	dma_addr_t tptr_dma_addr;
 	int offset;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	tptr_buf = &priv->tptr_table.tptr_buf;
 
 	cq_context = mb_buf;
@@ -2290,7 +2290,7 @@ int hns_roce_v1_clear_hem(struct hns_roce_dev *hr_dev,
 	void __iomem *bt_cmd;
 	u64 bt_ba = 0;
 
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 
 	switch (table->type) {
 	case HEM_TYPE_QPC:
@@ -3665,7 +3665,7 @@ static void hns_roce_v1_destroy_qp_work_fn(struct work_struct *work)
 	qp_work_entry = container_of(work, struct hns_roce_qp_work, work);
 	hr_dev = to_hr_dev(qp_work_entry->ib_dev);
 	dev = &hr_dev->pdev->dev;
-	priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+	priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 	hr_qp = qp_work_entry->qp;
 	qpn = hr_qp->qpn;
 
@@ -3782,7 +3782,7 @@ int hns_roce_v1_destroy_qp(struct ib_qp *ibqp)
 		qp_work->sdb_inv_cnt	= qp_work_entry.sdb_inv_cnt;
 		qp_work->sche_cnt	= qp_work_entry.sche_cnt;
 
-		priv = (struct hns_roce_v1_priv *)hr_dev->hw->priv;
+		priv = (struct hns_roce_v1_priv *)hr_dev->priv;
 		queue_work(priv->des_qp.qp_wq, &qp_work->work);
 		dev_dbg(dev, "Begin destroy QP(0x%lx) work.\n", hr_qp->qpn);
 	}
@@ -3842,8 +3842,6 @@ int hns_roce_v1_destroy_cq(struct ib_cq *ibcq)
 	return ret;
 }
 
-struct hns_roce_v1_priv hr_v1_priv;
-
 static const struct hns_roce_hw hns_roce_hw_v1 = {
 	.reset = hns_roce_v1_reset,
 	.hw_profile = hns_roce_v1_profile,
@@ -3864,7 +3862,6 @@ int hns_roce_v1_destroy_cq(struct ib_cq *ibcq)
 	.poll_cq = hns_roce_v1_poll_cq,
 	.dereg_mr = hns_roce_v1_dereg_mr,
 	.destroy_cq = hns_roce_v1_destroy_cq,
-	.priv = &hr_v1_priv,
 };
 
 static const struct of_device_id hns_roce_of_match[] = {
@@ -4046,6 +4043,12 @@ static int hns_roce_probe(struct platform_device *pdev)
 	if (!hr_dev)
 		return -ENOMEM;
 
+	hr_dev->priv = kzalloc(sizeof(struct hns_roce_v1_priv), GFP_KERNEL);
+	if (!hr_dev->priv) {
+		ret = -ENOMEM;
+		goto error_failed_kzalloc;
+	}
+
 	hr_dev->pdev = pdev;
 	platform_set_drvdata(pdev, hr_dev);
 
@@ -4071,6 +4074,9 @@ static int hns_roce_probe(struct platform_device *pdev)
 	return 0;
 
 error_failed_get_cfg:
+	kfree(hr_dev->priv);
+
+error_failed_kzalloc:
 	ib_dealloc_device(&hr_dev->ib_dev);
 
 	return ret;
@@ -4085,6 +4091,7 @@ static int hns_roce_remove(struct platform_device *pdev)
 	struct hns_roce_dev *hr_dev = platform_get_drvdata(pdev);
 
 	hns_roce_exit(hr_dev);
+	kfree(hr_dev->priv);
 	ib_dealloc_device(&hr_dev->ib_dev);
 
 	return 0;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
