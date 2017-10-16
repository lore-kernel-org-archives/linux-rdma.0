From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/12] i40iw: Ignore AE source field in AEQE for some AEs
Date: Mon, 16 Oct 2017 15:45:55 -0500
Message-ID: <20171016204605.37512-3-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The AE source field in Asynchronous Event Queue Entry (AEQE) is
not set by the hardware for some AEs, but the code assumes it does.
This results in incorrect processing of some AEs.
Fix this by setting ae_src to I40IW_AE_SOURCE_RSVD for those AEs.

Fixes: 86dbcd0f12e9 ("i40iw: add file to handle cqp calls")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 49 ++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/i40iw/i40iw_d.h    |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index 4597cf4..810fdda 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -1774,6 +1774,53 @@ static enum i40iw_status_code i40iw_sc_get_next_aeqe(struct i40iw_sc_aeq *aeq,
 	info->iwarp_state = (u8)RS_64(temp, I40IW_AEQE_IWSTATE);
 	info->q2_data_written = (u8)RS_64(temp, I40IW_AEQE_Q2DATA);
 	info->aeqe_overflow = (bool)RS_64(temp, I40IW_AEQE_OVERFLOW);
+
+	switch (info->ae_id) {
+	case I40IW_AE_PRIV_OPERATION_DENIED:
+	case I40IW_AE_UDA_XMIT_DGRAM_TOO_LONG:
+	case I40IW_AE_UDA_XMIT_DGRAM_TOO_SHORT:
+	case I40IW_AE_BAD_CLOSE:
+	case I40IW_AE_RDMAP_ROE_BAD_LLP_CLOSE:
+	case I40IW_AE_RDMA_READ_WHILE_ORD_ZERO:
+	case I40IW_AE_STAG_ZERO_INVALID:
+	case I40IW_AE_IB_RREQ_AND_Q1_FULL:
+	case I40IW_AE_WQE_UNEXPECTED_OPCODE:
+	case I40IW_AE_DDP_UBE_INVALID_DDP_VERSION:
+	case I40IW_AE_DDP_UBE_INVALID_MO:
+	case I40IW_AE_DDP_UBE_INVALID_QN:
+	case I40IW_AE_DDP_NO_L_BIT:
+	case I40IW_AE_RDMAP_ROE_INVALID_RDMAP_VERSION:
+	case I40IW_AE_RDMAP_ROE_UNEXPECTED_OPCODE:
+	case I40IW_AE_ROE_INVALID_RDMA_READ_REQUEST:
+	case I40IW_AE_ROE_INVALID_RDMA_WRITE_OR_READ_RESP:
+	case I40IW_AE_INVALID_ARP_ENTRY:
+	case I40IW_AE_INVALID_TCP_OPTION_RCVD:
+	case I40IW_AE_STALE_ARP_ENTRY:
+	case I40IW_AE_LLP_CLOSE_COMPLETE:
+	case I40IW_AE_LLP_CONNECTION_RESET:
+	case I40IW_AE_LLP_FIN_RECEIVED:
+	case I40IW_AE_LLP_RECEIVED_MPA_CRC_ERROR:
+	case I40IW_AE_LLP_SEGMENT_TOO_SMALL:
+	case I40IW_AE_LLP_SYN_RECEIVED:
+	case I40IW_AE_LLP_TERMINATE_RECEIVED:
+	case I40IW_AE_LLP_TOO_MANY_RETRIES:
+	case I40IW_AE_LLP_DOUBT_REACHABILITY:
+	case I40IW_AE_RESET_SENT:
+	case I40IW_AE_TERMINATE_SENT:
+	case I40IW_AE_RESET_NOT_SENT:
+	case I40IW_AE_LCE_QP_CATASTROPHIC:
+	case I40IW_AE_QP_SUSPEND_COMPLETE:
+		info->qp = true;
+		info->compl_ctx = compl_ctx;
+		ae_src = I40IW_AE_SOURCE_RSVD;
+		break;
+	case I40IW_AE_LCE_CQ_CATASTROPHIC:
+		info->cq = true;
+		info->compl_ctx = LS_64_1(compl_ctx, 1);
+		ae_src = I40IW_AE_SOURCE_RSVD;
+		break;
+	}
+
 	switch (ae_src) {
 	case I40IW_AE_SOURCE_RQ:
 	case I40IW_AE_SOURCE_RQ_0011:
@@ -1807,6 +1854,8 @@ static enum i40iw_status_code i40iw_sc_get_next_aeqe(struct i40iw_sc_aeq *aeq,
 		info->compl_ctx = compl_ctx;
 		info->out_rdrsp = true;
 		break;
+	case I40IW_AE_SOURCE_RSVD:
+		/* fallthrough */
 	default:
 		break;
 	}
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
index dc319e9..60c785a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_d.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_d.h
@@ -128,6 +128,7 @@
 		&_ceq->ceqe_base[I40IW_RING_GETCURRENT_TAIL(_ceq->ceq_ring)]   \
 	)
 
+#define I40IW_AE_SOURCE_RSVD            0x0
 #define I40IW_AE_SOURCE_RQ              0x1
 #define I40IW_AE_SOURCE_RQ_0011         0x3
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
