From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/4] RDMA/hns: Support cq record doorbell for the user space
Date: Thu, 18 Jan 2018 10:34:29 +0800
Message-ID: <1516242871-154089-3-git-send-email-liuyixian@huawei.com>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516242871-154089-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support cq record doorbell for
the user space.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 26 +++++++++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  9 +++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  3 +++
 include/uapi/rdma/hns-abi.h                 |  1 +
 5 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index bccc9b5..918960d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -354,6 +354,15 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
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
@@ -375,7 +384,7 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 				hr_cq, vector);
 	if (ret) {
 		dev_err(dev, "Creat CQ .Failed to cq_alloc.\n");
-		goto err_mtt;
+		goto err_dbmap;
 	}
 
 	/*
@@ -404,6 +413,11 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
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
@@ -430,12 +444,18 @@ int hns_roce_ib_destroy_cq(struct ib_cq *ib_cq)
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
index 65c09c5..9ee6da6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -376,6 +376,7 @@ struct hns_roce_cq_buf {
 
 struct hns_roce_cq {
 	struct ib_cq			ib_cq;
+	struct hns_roce_db		db;
 	struct hns_roce_cq_buf		hr_buf;
 	spinlock_t			lock;
 	struct ib_umem			*umem;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e0f4dc4..07129d2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1610,6 +1610,15 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 	roce_set_field(cq_context->byte_40_cqe_ba, V2_CQC_BYTE_40_CQE_BA_M,
 		       V2_CQC_BYTE_40_CQE_BA_S, (dma_handle >> (32 + 3)));
 
+	roce_set_bit(cq_context->byte_44_db_record,
+		     V2_CQC_BYTE_44_DB_RECORD_EN_S, 1);
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
index 960df09..e022fb5 100644
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
index a9c03b0..ab66057 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -38,6 +38,7 @@
 
 struct hns_roce_ib_create_cq {
 	__u64   buf_addr;
+	__u64	db_addr;
 };
 
 struct hns_roce_ib_create_qp {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
