From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/14] RDMA/ocrdma: For ERX2 irrespective of Qid, num_posted offset is 24.
Date: Mon, 26 Aug 2013 15:27:42 +0530
Message-ID: <0eed406e-6b32-466c-b7ee-ef9e588e9150@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1) All RQ doorbells are handled by ERX2 and doorbell->num_posted offset is
constant to bit offset 24 for ERX2 irrspective of Q id.
2) Fixed RESET to INIT state change (from ERR->RST->INIT->RTR case).

 Please enter the commit message for your changes. Lines starting

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 21 +++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 12 +++++-------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |  1 +
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 1b14ef8..2c2991b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -256,11 +256,11 @@ static int ocrdma_get_mbx_cqe_errno(u16 cqe_status)
 		break;
 	case OCRDMA_MBX_CQE_STATUS_INSUFFICIENT_RESOURCES:
 	case OCRDMA_MBX_CQE_STATUS_QUEUE_FLUSHING:
-		err_num = -EAGAIN;
+		err_num = -EINVAL;
 		break;
 	case OCRDMA_MBX_CQE_STATUS_DMA_FAILED:
 	default:
-		err_num = -EIO;
+		err_num = -EINVAL;
 		break;
 	}
 	return err_num;
@@ -1654,6 +1654,14 @@ void ocrdma_flush_qp(struct ocrdma_qp *qp)
 	spin_unlock_irqrestore(&qp->dev->flush_q_lock, flags);
 }
 
+static void ocrdma_init_hwq_ptr(struct ocrdma_qp *qp)
+{
+	qp->sq.head = 0;
+	qp->sq.tail = 0;
+	qp->rq.head = 0;
+	qp->rq.tail = 0;
+}
+
 int ocrdma_qp_state_change(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
 			   enum ib_qp_state *old_ib_state)
 {
@@ -1673,8 +1681,12 @@ int ocrdma_qp_state_change(struct ocrdma_qp *qp, enum ib_qp_state new_ib_state,
 	}
 
 
-	if (new_state == OCRDMA_QPS_ERR)
+	if (new_state == OCRDMA_QPS_INIT) {
+		ocrdma_init_hwq_ptr(qp);
+		ocrdma_del_flush_qp(qp);
+	} else if (new_state == OCRDMA_QPS_ERR) {
 		ocrdma_flush_qp(qp);
+	}
 
 	qp->state = new_state;
 
@@ -2317,7 +2329,8 @@ int ocrdma_mbx_modify_srq(struct ocrdma_srq *srq, struct ib_srq_attr *srq_attr)
 {
 	int status = -ENOMEM;
 	struct ocrdma_modify_srq *cmd;
-	struct ocrdma_dev *dev = get_ocrdma_dev(srq->ibsrq.device);
+	struct ocrdma_pd *pd = srq->pd;
+	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_CREATE_SRQ, sizeof(*cmd));
 	if (!cmd)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 6cf5a96..bfd0acb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -95,12 +95,11 @@ enum {
 
 enum {
 	OCRDMA_DB_RQ_OFFSET		= 0xE0,
-	OCRDMA_DB_GEN2_RQ1_OFFSET	= 0x100,
-	OCRDMA_DB_GEN2_RQ2_OFFSET	= 0xC0,
+	OCRDMA_DB_GEN2_RQ_OFFSET        = 0x100,
 	OCRDMA_DB_SQ_OFFSET		= 0x60,
 	OCRDMA_DB_GEN2_SQ_OFFSET	= 0x1C0,
 	OCRDMA_DB_SRQ_OFFSET		= OCRDMA_DB_RQ_OFFSET,
-	OCRDMA_DB_GEN2_SRQ_OFFSET	= OCRDMA_DB_GEN2_RQ1_OFFSET,
+	OCRDMA_DB_GEN2_SRQ_OFFSET	= OCRDMA_DB_GEN2_RQ_OFFSET,
 	OCRDMA_DB_CQ_OFFSET		= 0x120,
 	OCRDMA_DB_EQ_OFFSET		= OCRDMA_DB_CQ_OFFSET,
 	OCRDMA_DB_MQ_OFFSET		= 0x140
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cc88c6d..79917ff 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -930,9 +930,8 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	uresp.db_page_size = dev->nic_info.db_page_size;
 	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
 		uresp.db_sq_offset = OCRDMA_DB_GEN2_SQ_OFFSET;
-		uresp.db_rq_offset = ((qp->id & 0xFFFF) < 128) ?
-			OCRDMA_DB_GEN2_RQ1_OFFSET : OCRDMA_DB_GEN2_RQ2_OFFSET;
-		uresp.db_shift = (qp->id < 128) ? 24 : 16;
+		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
+		uresp.db_shift = 24;
 	} else {
 		uresp.db_sq_offset = OCRDMA_DB_SQ_OFFSET;
 		uresp.db_rq_offset = OCRDMA_DB_RQ_OFFSET;
@@ -975,8 +974,7 @@ static void ocrdma_set_qp_db(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 			OCRDMA_DB_GEN2_SQ_OFFSET;
 		qp->rq_db = dev->nic_info.db +
 			(pd->id * dev->nic_info.db_page_size) +
-			((qp->id < 128) ?
-			OCRDMA_DB_GEN2_RQ1_OFFSET : OCRDMA_DB_GEN2_RQ2_OFFSET);
+			OCRDMA_DB_GEN2_RQ_OFFSET;
 	} else {
 		qp->sq_db = dev->nic_info.db +
 			(pd->id * dev->nic_info.db_page_size) +
@@ -1399,7 +1397,7 @@ skip_cqe:
 	spin_unlock_irqrestore(&cq->cq_lock, cq_flags);
 }
 
-static void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
+void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
 {
 	int found = false;
 	unsigned long flags;
@@ -1496,7 +1494,7 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
 	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.num_rqe_allocated = srq->rq.max_cnt;
 	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ1_OFFSET;
+		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
 		uresp.db_shift = 24;
 	} else {
 		uresp.db_rq_offset = OCRDMA_DB_RQ_OFFSET;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 7f30567..b8f7853 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -72,6 +72,7 @@ int ocrdma_query_qp(struct ib_qp *,
 		    struct ib_qp_attr *qp_attr,
 		    int qp_attr_mask, struct ib_qp_init_attr *);
 int ocrdma_destroy_qp(struct ib_qp *);
+void ocrdma_del_flush_qp(struct ocrdma_qp *qp);
 
 struct ib_srq *ocrdma_create_srq(struct ib_pd *, struct ib_srq_init_attr *,
 				 struct ib_udata *);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
