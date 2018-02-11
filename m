From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 2/4] RDMA/hns: Support cq record doorbell for the user space
Date: Sun, 11 Feb 2018 20:40:51 +0800
Message-ID: <1518352853-80652-3-git-send-email-liuyixian@huawei.com>
References: <1518352853-80652-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518352853-80652-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support cq record doorbell for
the user space.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 40 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_device.h |  6 +++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 10 ++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  3 +++
 include/uapi/rdma/hns-abi.h                 |  8 ++++++
 5 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index bccc9b5..ebedcf3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -315,6 +315,7 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 	struct hns_roce_dev *hr_dev = to_hr_dev(ib_dev);
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_ib_create_cq ucmd;
+	struct hns_roce_ib_create_cq_resp resp;
 	struct hns_roce_cq *hr_cq = NULL;
 	struct hns_roce_uar *uar = NULL;
 	int vector = attr->comp_vector;
@@ -354,6 +355,15 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 			goto err_cq;
 		}
 
+		if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
+			ret = hns_roce_db_map_user(to_hr_ucontext(context),
+						   ucmd.db_addr, &hr_cq->db);
+			if (ret) {
+				dev_err(dev, "cq record doorbell map failed!\n");
+				goto err_mtt;
+			}
+		}
+
 		/* Get user space parameters */
 		uar = &to_hr_ucontext(context)->uar;
 	} else {
@@ -375,7 +385,7 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 				hr_cq, vector);
 	if (ret) {
 		dev_err(dev, "Creat CQ .Failed to cq_alloc.\n");
-		goto err_mtt;
+		goto err_dbmap;
 	}
 
 	/*
@@ -393,10 +403,17 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 	hr_cq->cq_depth = cq_entries;
 
 	if (context) {
-		if (ib_copy_to_udata(udata, &hr_cq->cqn, sizeof(u64))) {
-			ret = -EFAULT;
+		if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
+					(udata->outlen == sizeof(resp))) {
+			hr_cq->db_en = 1;
+			resp.cqn = hr_cq->cqn;
+			resp.cap_flags |= HNS_ROCE_SUPPORT_CQ_RECORD_DB;
+			ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		} else
+			ret = ib_copy_to_udata(udata, &hr_cq->cqn, sizeof(u64));
+
+		if (ret)
 			goto err_cqc;
-		}
 	}
 
 	return &hr_cq->ib_cq;
@@ -404,6 +421,11 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 err_cqc:
 	hns_roce_free_cq(hr_dev, hr_cq);
 
+err_dbmap:
+	if (context && (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB))
+		hns_roce_db_unmap_user(to_hr_ucontext(context),
+				       &hr_cq->db);
+
 err_mtt:
 	hns_roce_mtt_cleanup(hr_dev, &hr_cq->hr_buf.hr_mtt);
 	if (context)
@@ -430,12 +452,18 @@ int hns_roce_ib_destroy_cq(struct ib_cq *ib_cq)
 		hns_roce_free_cq(hr_dev, hr_cq);
 		hns_roce_mtt_cleanup(hr_dev, &hr_cq->hr_buf.hr_mtt);
 
-		if (ib_cq->uobject)
+		if (ib_cq->uobject) {
 			ib_umem_release(hr_cq->umem);
-		else
+
+			if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB)
+				hns_roce_db_unmap_user(
+					to_hr_ucontext(ib_cq->uobject->context),
+					&hr_cq->db);
+		} else {
 			/* Free the buff of stored cq */
 			hns_roce_ib_free_cq_buf(hr_dev, &hr_cq->hr_buf,
 						ib_cq->cqe);
+		}
 
 		kfree(hr_cq);
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index e436282..3499d9a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -109,6 +109,10 @@ enum {
 	HNS_ROCE_SUPPORT_RQ_RECORD_DB = 1 << 0,
 };
 
+enum {
+	HNS_ROCE_SUPPORT_CQ_RECORD_DB = 1 << 0,
+};
+
 enum hns_roce_qp_state {
 	HNS_ROCE_QP_STATE_RST,
 	HNS_ROCE_QP_STATE_INIT,
@@ -380,6 +384,8 @@ struct hns_roce_cq_buf {
 
 struct hns_roce_cq {
 	struct ib_cq			ib_cq;
+	struct hns_roce_db		db;
+	u8				db_en;
 	struct hns_roce_cq_buf		hr_buf;
 	spinlock_t			lock;
 	struct ib_umem			*umem;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 275ee84..a24c1fe 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1638,6 +1638,16 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 	roce_set_field(cq_context->byte_40_cqe_ba, V2_CQC_BYTE_40_CQE_BA_M,
 		       V2_CQC_BYTE_40_CQE_BA_S, (dma_handle >> (32 + 3)));
 
+	if (hr_cq->db_en)
+		roce_set_bit(cq_context->byte_44_db_record,
+			     V2_CQC_BYTE_44_DB_RECORD_EN_S, 1);
+
+	roce_set_field(cq_context->byte_44_db_record,
+		       V2_CQC_BYTE_44_DB_RECORD_ADDR_M,
+		       V2_CQC_BYTE_44_DB_RECORD_ADDR_S,
+		       ((u32)hr_cq->db.dma) >> 1);
+	cq_context->db_record_addr = hr_cq->db.dma >> 32;
+
 	roce_set_field(cq_context->byte_56_cqe_period_maxcnt,
 		       V2_CQC_BYTE_56_CQ_MAX_CNT_M,
 		       V2_CQC_BYTE_56_CQ_MAX_CNT_S,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2bf8a47..182b672 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -299,6 +299,9 @@ struct hns_roce_v2_cq_context {
 
 #define	V2_CQC_BYTE_44_DB_RECORD_EN_S 0
 
+#define	V2_CQC_BYTE_44_DB_RECORD_ADDR_S 1
+#define	V2_CQC_BYTE_44_DB_RECORD_ADDR_M GENMASK(31, 1)
+
 #define	V2_CQC_BYTE_52_CQE_CNT_S 0
 #define	V2_CQC_BYTE_52_CQE_CNT_M GENMASK(23, 0)
 
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index 390ba59..63afbd4 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -38,6 +38,14 @@
 
 struct hns_roce_ib_create_cq {
 	__u64   buf_addr;
+	__u64	db_addr;
+};
+
+struct hns_roce_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+	__u32	cap_flags;
+	__u32	reserved1;
 };
 
 struct hns_roce_ib_create_qp {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
