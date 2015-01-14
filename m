From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] RDMA/libocrdma: return positive error codes
Date: Wed, 14 Jan 2015 12:23:51 +0530
Message-ID: <f00bc08d-df55-4008-b36b-a1607443b02e@CMEXHTCAS2.ad.emulex.com>
References: <1421218432-17812-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421218432-17812-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

As per the standard practice if any faiulre encountered in the
library code, the library should return a positive error code
to the user.

A bug has been reported in a used case scenario of KVM migration
as well.

This patch fixs the return code problem.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_verbs.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index edff8b6..c089a5f 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -778,7 +778,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			ocrdma_del_flush_qp(qp);
 			break;
 		default:
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -794,7 +794,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			break;
 		default:
 			/* invalid state change. */
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -808,7 +808,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			break;
 		default:
 			/* invalid state change. */
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -823,7 +823,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			break;
 		default:
 			/* invalid state change. */
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -836,7 +836,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			break;
 		default:
 			/* invalid state change. */
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -847,7 +847,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 			break;
 		default:
 			/* invalid state change. */
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
@@ -857,12 +857,12 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 		case OCRDMA_QPS_RST:
 			break;
 		default:
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		};
 		break;
 	default:
-		status = -EINVAL;
+		status = EINVAL;
 		break;
 	};
 	if (!status)
@@ -1226,7 +1226,7 @@ static inline int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 			ocrdma_err
 			("%s() supported_len=0x%x, unspported len req=0x%x\n",
 			__func__, qp->max_inline_data, hdr->total_len);
-			return -EINVAL;
+			return EINVAL;
 		}
 
 		dpp_addr = (char *)sge;
@@ -1391,7 +1391,7 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 	if (qp->state != OCRDMA_QPS_RTS && qp->state != OCRDMA_QPS_SQD) {
 		pthread_spin_unlock(&qp->q_lock);
 		*bad_wr = wr;
-		return -EINVAL;
+		return EINVAL;
 	}
 
 	while (wr) {
@@ -1399,14 +1399,14 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 		if (qp->qp_type == IBV_QPT_UD && (wr->opcode != IBV_WR_SEND &&
 		    wr->opcode != IBV_WR_SEND_WITH_IMM)) {
 			*bad_wr = wr;
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		}
 
 		if (ocrdma_hwq_free_cnt(&qp->sq) == 0 ||
 		    wr->num_sge > qp->sq.max_sges) {
 			*bad_wr = wr;
-			status = -ENOMEM;
+			status = ENOMEM;
 			break;
 		}
 		hdr = ocrdma_hwq_head(&qp->sq);
@@ -1441,7 +1441,7 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			ocrdma_build_read(qp, hdr, wr);
 			break;
 		default:
-			status = -EINVAL;
+			status = EINVAL;
 			break;
 		}
 		if (status) {
@@ -1509,13 +1509,13 @@ int ocrdma_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	if (qp->state == OCRDMA_QPS_RST || qp->state == OCRDMA_QPS_ERR) {
 		pthread_spin_unlock(&qp->q_lock);
 		*bad_wr = wr;
-		return -EINVAL;
+		return EINVAL;
 	}
 
 	while (wr) {
 		if (ocrdma_hwq_free_cnt(&qp->rq) == 0 ||
 		    wr->num_sge > qp->rq.max_sges) {
-			status = -ENOMEM;
+			status = ENOMEM;
 			*bad_wr = wr;
 			break;
 		}
@@ -2098,7 +2098,7 @@ int ocrdma_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
 	while (wr) {
 		if (ocrdma_hwq_free_cnt(&srq->rq) == 0 ||
 		    wr->num_sge > srq->rq.max_sges) {
-			status = -ENOMEM;
+			status = ENOMEM;
 			*bad_wr = wr;
 			break;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
