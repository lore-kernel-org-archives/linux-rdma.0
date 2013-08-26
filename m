From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/14] RDMA/ocrdma: FRMA code cleanup.
Date: Mon, 26 Aug 2013 15:27:43 +0530
Message-ID: <e1e6574f-81be-4038-a875-febe995b9458@CMEXHTCAS1.ad.emulex.com>
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

1) Fixed setting FR_MR bit for FRMR stag allocation
2) Access rights are passsed during FRMR stage and not during STAT allocation stage
3) FRMR WQE structure cleanup
4) Add QP level signaled bit.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 16 +++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  8 +++++---
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 9cc966a..1c8ba4c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -289,6 +289,7 @@ struct ocrdma_qp {
 	u32 qkey;
 	bool dpp_enabled;
 	u8 *ird_q_va;
+	bool signaled;
 	u16 db_cache;
 };
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 2c2991b..16ce664 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1500,6 +1500,7 @@ static int ocrdma_mbx_reg_mr(struct ocrdma_dev *dev, struct ocrdma_hw_mr *hwmr,
 		return -ENOMEM;
 	cmd->num_pbl_pdid =
 	    pdid | (hwmr->num_pbls << OCRDMA_REG_NSMR_NUM_PBL_SHIFT);
+	cmd->fr_mr = hwmr->fr_mr;
 
 	cmd->flags_hpage_pbe_sz |= (hwmr->remote_wr <<
 				    OCRDMA_REG_NSMR_REMOTE_WR_SHIFT);
@@ -2049,6 +2050,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	    (ah_attr->grh.traffic_class << OCRDMA_QP_PARAMS_TCLASS_SHIFT);
 	cmd->params.rnt_rc_sl_fl |=
 	    (ah_attr->grh.flow_label & OCRDMA_QP_PARAMS_FLOW_LABEL_MASK);
+	cmd->params.rnt_rc_sl_fl |= (ah_attr->sl << OCRDMA_QP_PARAMS_SL_SHIFT);
 	cmd->params.hop_lmt_rq_psn |=
 	    (ah_attr->grh.hop_limit << OCRDMA_QP_PARAMS_HOP_LMT_SHIFT);
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index bfd0acb..d1a9fb7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -143,8 +143,11 @@ enum {
 # 2: 16K Bytes
 # 3: 32K Bytes
 # 4: 64K Bytes
+# 5: 128K Bytes
+# 6: 256K Bytes
+# 7: 512K Bytes
 */
-#define OCRDMA_MAX_Q_PAGE_SIZE_CNT (5)
+#define OCRDMA_MAX_Q_PAGE_SIZE_CNT (8)
 #define OCRDMA_Q_PAGE_BASE_SIZE (OCRDMA_MIN_Q_PAGE_SIZE * OCRDMA_MAX_Q_PAGES)
 
 #define MAX_OCRDMA_QP_PAGES      (8)
@@ -1274,7 +1277,7 @@ struct ocrdma_reg_nsmr {
 	struct ocrdma_mqe_hdr hdr;
 	struct ocrdma_mbx_hdr cmd;
 
-	u32 lrkey_key_index;
+	u32 fr_mr;
 	u32 num_pbl_pdid;
 	u32 flags_hpage_pbe_sz;
 	u32 totlen_low;
@@ -1611,12 +1614,6 @@ struct ocrdma_ewqe_ud_hdr {
 	u32 rsvd;
 };
 
-#define OCRDMA_MAX_FR_PBES 11
-struct ocrdma_fr_pbe {
-	u32 pa_hi;
-	u32 pa_lo;
-};
-
 /* extended wqe followed by hdr_wqe for Fast Memory register */
 struct ocrdma_ewqe_fr {
 	u32 va_hi;
@@ -1625,7 +1622,8 @@ struct ocrdma_ewqe_fr {
 	u32 fbo_lo;
 	u32 size_sge;
 	u32 num_sges;
-	struct ocrdma_fr_pbe pbe[0];
+	u32 rsvd;
+	u32 rsvd2;
 };
 
 struct ocrdma_eth_basic {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 79917ff..39567b6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -82,7 +82,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 					IB_DEVICE_RC_RNR_NAK_GEN |
 					IB_DEVICE_SHUTDOWN_PORT |
 					IB_DEVICE_SYS_IMAGE_GUID |
-					IB_DEVICE_LOCAL_DMA_LKEY;
+					IB_DEVICE_LOCAL_DMA_LKEY |
+					IB_DEVICE_MEM_MGT_EXTENSIONS;
 	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_srq_sge);
 	attr->max_sge_rd = dev->attr.max_rdma_sge;
 	attr->max_cq = dev->attr.max_cq;
@@ -1015,6 +1016,7 @@ static void ocrdma_set_qp_init_params(struct ocrdma_qp *qp,
 	qp->sq.max_sges = attrs->cap.max_send_sge;
 	qp->rq.max_sges = attrs->cap.max_recv_sge;
 	qp->state = OCRDMA_QPS_RST;
+	qp->signaled = (attrs->sq_sig_type == IB_SIGNAL_ALL_WR) ? true : false;
 }
 
 
@@ -1864,7 +1866,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 		hdr = ocrdma_hwq_head(&qp->sq);
 		hdr->cw = 0;
-		if (wr->send_flags & IB_SEND_SIGNALED)
+		if (wr->send_flags & IB_SEND_SIGNALED || qp->signaled)
 			hdr->cw |= (OCRDMA_FLAG_SIG << OCRDMA_WQE_FLAGS_SHIFT);
 		if (wr->send_flags & IB_SEND_FENCE)
 			hdr->cw |=
@@ -1918,7 +1920,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
-		if (wr->send_flags & IB_SEND_SIGNALED)
+		if (wr->send_flags & IB_SEND_SIGNALED || qp->signaled)
 			qp->wqe_wr_id_tbl[qp->sq.head].signaled = 1;
 		else
 			qp->wqe_wr_id_tbl[qp->sq.head].signaled = 0;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
