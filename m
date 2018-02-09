From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 4/4] RDMA/hns: Support cq record doorbell for kernel space
Date: Fri, 9 Feb 2018 19:45:00 +0800
Message-ID: <1518176700-126906-5-git-send-email-liuyixian@huawei.com>
References: <1518176700-126906-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518176700-126906-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support cq record doorbell for
the kernel space.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 17 ++++++++++++++++-
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 19 +------------------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index ebedcf3..6ae9c45 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -367,12 +367,21 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 		/* Get user space parameters */
 		uar = &to_hr_ucontext(context)->uar;
 	} else {
+		if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
+			ret = hns_roce_alloc_db(hr_dev, &hr_cq->db, 1);
+			if (ret)
+				goto err_cq;
+
+			hr_cq->set_ci_db = hr_cq->db.db_record;
+			*hr_cq->set_ci_db = 0;
+		}
+
 		/* Init mmt table and write buff address to mtt table */
 		ret = hns_roce_ib_alloc_cq_buf(hr_dev, &hr_cq->hr_buf,
 					       cq_entries);
 		if (ret) {
 			dev_err(dev, "Failed to alloc_cq_buf.\n");
-			goto err_cq;
+			goto err_db;
 		}
 
 		uar = &hr_dev->priv_uar;
@@ -434,6 +443,10 @@ struct ib_cq *hns_roce_ib_create_cq(struct ib_device *ib_dev,
 		hns_roce_ib_free_cq_buf(hr_dev, &hr_cq->hr_buf,
 					hr_cq->ib_cq.cqe);
 
+err_db:
+	if (!context && (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB))
+		hns_roce_free_db(hr_dev, &hr_cq->db);
+
 err_cq:
 	kfree(hr_cq);
 	return ERR_PTR(ret);
@@ -463,6 +476,8 @@ int hns_roce_ib_destroy_cq(struct ib_cq *ib_cq)
 			/* Free the buff of stored cq */
 			hns_roce_ib_free_cq_buf(hr_dev, &hr_cq->hr_buf,
 						ib_cq->cqe);
+			if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB)
+				hns_roce_free_db(hr_dev, &hr_cq->db);
 		}
 
 		kfree(hr_cq);
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 69d8c3f..0bd00ea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -395,6 +395,7 @@ struct hns_roce_cq {
 	struct hns_roce_uar		*uar;
 	u32				cq_depth;
 	u32				cons_index;
+	u32				*set_ci_db;
 	void __iomem			*cq_db_l;
 	u16				*tptr_addr;
 	int				arm_sn;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5dc57f6..6bc48ed 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1481,24 +1481,7 @@ static struct hns_roce_v2_cqe *next_cqe_sw_v2(struct hns_roce_cq *hr_cq)
 
 static void hns_roce_v2_cq_set_ci(struct hns_roce_cq *hr_cq, u32 cons_index)
 {
-	struct hns_roce_v2_cq_db cq_db;
-
-	cq_db.byte_4 = 0;
-	cq_db.parameter = 0;
-
-	roce_set_field(cq_db.byte_4, V2_CQ_DB_BYTE_4_TAG_M,
-		       V2_CQ_DB_BYTE_4_TAG_S, hr_cq->cqn);
-	roce_set_field(cq_db.byte_4, V2_CQ_DB_BYTE_4_CMD_M,
-		       V2_CQ_DB_BYTE_4_CMD_S, HNS_ROCE_V2_CQ_DB_PTR);
-
-	roce_set_field(cq_db.parameter, V2_CQ_DB_PARAMETER_CONS_IDX_M,
-		       V2_CQ_DB_PARAMETER_CONS_IDX_S,
-		       cons_index & ((hr_cq->cq_depth << 1) - 1));
-	roce_set_field(cq_db.parameter, V2_CQ_DB_PARAMETER_CMD_SN_M,
-		       V2_CQ_DB_PARAMETER_CMD_SN_S, 1);
-
-	hns_roce_write64_k((__be32 *)&cq_db, hr_cq->cq_db_l);
-
+	*hr_cq->set_ci_db = cons_index & 0xffffff;
 }
 
 static void __hns_roce_v2_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
