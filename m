From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 02/11] {topost} RDMA/hns: Configure TRRL field in hip08 RoCE device
Date: Fri, 10 Nov 2017 16:55:44 +0800
Message-ID: <1510304153-91394-3-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The TRRL(Target RDMA Read/aTOMIC List) record the information
of receiving RDMA READ or ATOMIC operation in hip08. It will
be used the hardware. The driver neet to assign a continuous
physical address for trrl_ba field of qp context.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 ++
 drivers/infiniband/hw/hns/hns_roce_hem.c    |  3 +++
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 23 +++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  1 +
 drivers/infiniband/hw/hns/hns_roce_main.c   | 21 ++++++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 19 ++++++++++++++++++-
 7 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index c4a28a0..724a5a0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -367,6 +367,7 @@ struct hns_roce_qp_table {
 	spinlock_t			lock;
 	struct hns_roce_hem_table	qp_table;
 	struct hns_roce_hem_table	irrl_table;
+	struct hns_roce_hem_table	trrl_table;
 };
 
 struct hns_roce_cq_table {
@@ -542,6 +543,7 @@ struct hns_roce_caps {
 	int		mtpt_entry_sz;
 	int		qpc_entry_sz;
 	int		irrl_entry_sz;
+	int		trrl_entry_sz;
 	int		cqc_entry_sz;
 	u32		pbl_ba_pg_sz;
 	u32		pbl_buf_pg_sz;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 576eb3b..f1f8fa4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1037,6 +1037,9 @@ void hns_roce_cleanup_hem(struct hns_roce_dev *hr_dev)
 {
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->cq_table.table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->qp_table.irrl_table);
+	if (hr_dev->caps.trrl_entry_sz)
+		hns_roce_cleanup_hem_table(hr_dev,
+					   &hr_dev->qp_table.trrl_table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->qp_table.qp_table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtpt_table);
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->mr_table.mtt_table);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index af28bbf..db66db1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -49,6 +49,7 @@ enum {
 	HEM_TYPE_MTT,
 	HEM_TYPE_CQE,
 	HEM_TYPE_IRRL,
+	HEM_TYPE_TRRL,
 };
 
 #define HNS_ROCE_HEM_CHUNK_LEN	\
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a950f78..8ed8164 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -911,6 +911,7 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->max_srq_desc_sz	= HNS_ROCE_V2_MAX_SRQ_DESC_SZ;
 	caps->qpc_entry_sz	= HNS_ROCE_V2_QPC_ENTRY_SZ;
 	caps->irrl_entry_sz	= HNS_ROCE_V2_IRRL_ENTRY_SZ;
+	caps->trrl_entry_sz	= HNS_ROCE_V2_TRRL_ENTRY_SZ;
 	caps->cqc_entry_sz	= HNS_ROCE_V2_CQC_ENTRY_SZ;
 	caps->mtpt_entry_sz	= HNS_ROCE_V2_MTPT_ENTRY_SZ;
 	caps->mtt_entry_sz	= HNS_ROCE_V2_MTT_ENTRY_SZ;
@@ -2265,10 +2266,12 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
 	struct device *dev = hr_dev->dev;
+	dma_addr_t dma_handle_3;
 	dma_addr_t dma_handle_2;
 	dma_addr_t dma_handle;
 	u32 page_size;
 	u8 port_num;
+	u64 *mtts_3;
 	u64 *mtts_2;
 	u64 *mtts;
 	u8 *dmac;
@@ -2291,6 +2294,14 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		return -EINVAL;
 	}
 
+	/* Search TRRL's mtts */
+	mtts_3 = hns_roce_table_find(hr_dev, &hr_dev->qp_table.trrl_table,
+				     hr_qp->qpn, &dma_handle_3);
+	if (!mtts_3) {
+		dev_err(dev, "qp trrl_table find failed\n");
+		return -EINVAL;
+	}
+
 	if ((attr_mask & IB_QP_ALT_PATH) || (attr_mask & IB_QP_ACCESS_FLAGS) ||
 	    (attr_mask & IB_QP_PKEY_INDEX) || (attr_mask & IB_QP_QKEY)) {
 		dev_err(dev, "INIT2RTR attr_mask (0x%x) error\n", attr_mask);
@@ -2393,6 +2404,18 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_108_RX_REQ_EPSN_M,
 		       V2_QPC_BYTE_108_RX_REQ_EPSN_S, 0);
 
+	roce_set_field(context->byte_132_trrl, V2_QPC_BYTE_132_TRRL_BA_M,
+		       V2_QPC_BYTE_132_TRRL_BA_S, dma_handle_3 >> 4);
+	roce_set_field(qpc_mask->byte_132_trrl, V2_QPC_BYTE_132_TRRL_BA_M,
+		       V2_QPC_BYTE_132_TRRL_BA_S, 0);
+	context->trrl_ba = (u32)(dma_handle_3 >> (16 + 4));
+	qpc_mask->trrl_ba = 0;
+	roce_set_field(context->byte_140_raq, V2_QPC_BYTE_140_TRRL_BA_M,
+		       V2_QPC_BYTE_140_TRRL_BA_S,
+		       (u32)(dma_handle_3 >> (32 + 16 + 4)));
+	roce_set_field(qpc_mask->byte_140_raq, V2_QPC_BYTE_140_TRRL_BA_M,
+		       V2_QPC_BYTE_140_TRRL_BA_S, 0);
+
 	context->irrl_ba = (u32)(dma_handle_2 >> 6);
 	qpc_mask->irrl_ba = 0;
 	roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_IRRL_BA_M,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 864fcd1..ea14225 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -64,6 +64,7 @@
 #define HNS_ROCE_V2_MAX_SRQ_DESC_SZ		64
 #define HNS_ROCE_V2_QPC_ENTRY_SZ		256
 #define HNS_ROCE_V2_IRRL_ENTRY_SZ		64
+#define HNS_ROCE_V2_TRRL_ENTRY_SZ		48
 #define HNS_ROCE_V2_CQC_ENTRY_SZ		64
 #define HNS_ROCE_V2_MTPT_ENTRY_SZ		64
 #define HNS_ROCE_V2_MTT_ENTRY_SZ		64
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 5bc8cc2..cf02ac2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -597,16 +597,35 @@ static int hns_roce_init_hem(struct hns_roce_dev *hr_dev)
 		goto err_unmap_qp;
 	}
 
+	if (hr_dev->caps.trrl_entry_sz) {
+		ret = hns_roce_init_hem_table(hr_dev,
+					      &hr_dev->qp_table.trrl_table,
+					      HEM_TYPE_TRRL,
+					      hr_dev->caps.trrl_entry_sz *
+					      hr_dev->caps.max_qp_dest_rdma,
+					      hr_dev->caps.num_qps, 1);
+		if (ret) {
+			dev_err(dev,
+			       "Failed to init trrl_table memory, aborting.\n");
+			goto err_unmap_irrl;
+		}
+	}
+
 	ret = hns_roce_init_hem_table(hr_dev, &hr_dev->cq_table.table,
 				      HEM_TYPE_CQC, hr_dev->caps.cqc_entry_sz,
 				      hr_dev->caps.num_cqs, 1);
 	if (ret) {
 		dev_err(dev, "Failed to init CQ context memory, aborting.\n");
-		goto err_unmap_irrl;
+		goto err_unmap_trrl;
 	}
 
 	return 0;
 
+err_unmap_trrl:
+	if (hr_dev->caps.trrl_entry_sz)
+		hns_roce_cleanup_hem_table(hr_dev,
+					   &hr_dev->qp_table.trrl_table);
+
 err_unmap_irrl:
 	hns_roce_cleanup_hem_table(hr_dev, &hr_dev->qp_table.irrl_table);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index b1c9a37..49586ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -194,13 +194,23 @@ static int hns_roce_qp_alloc(struct hns_roce_dev *hr_dev, unsigned long qpn,
 		goto err_put_qp;
 	}
 
+	if (hr_dev->caps.trrl_entry_sz) {
+		/* Alloc memory for TRRL */
+		ret = hns_roce_table_get(hr_dev, &qp_table->trrl_table,
+					 hr_qp->qpn);
+		if (ret) {
+			dev_err(dev, "TRRL table get failed\n");
+			goto err_put_irrl;
+		}
+	}
+
 	spin_lock_irq(&qp_table->lock);
 	ret = radix_tree_insert(&hr_dev->qp_table_tree,
 				hr_qp->qpn & (hr_dev->caps.num_qps - 1), hr_qp);
 	spin_unlock_irq(&qp_table->lock);
 	if (ret) {
 		dev_err(dev, "QPC radix_tree_insert failed\n");
-		goto err_put_irrl;
+		goto err_put_trrl;
 	}
 
 	atomic_set(&hr_qp->refcount, 1);
@@ -208,6 +218,10 @@ static int hns_roce_qp_alloc(struct hns_roce_dev *hr_dev, unsigned long qpn,
 
 	return 0;
 
+err_put_trrl:
+	if (hr_dev->caps.trrl_entry_sz)
+		hns_roce_table_put(hr_dev, &qp_table->trrl_table, hr_qp->qpn);
+
 err_put_irrl:
 	hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
 
@@ -239,6 +253,9 @@ void hns_roce_qp_free(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 	wait_for_completion(&hr_qp->free);
 
 	if ((hr_qp->ibqp.qp_type) != IB_QPT_GSI) {
+		if (hr_dev->caps.trrl_entry_sz)
+			hns_roce_table_put(hr_dev, &qp_table->trrl_table,
+					   hr_qp->qpn);
 		hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
 		hns_roce_table_put(hr_dev, &qp_table->qp_table, hr_qp->qpn);
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
