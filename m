From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/14] RDMA/ocrdma: Report correct state in ibv_query_qp
Date: Thu, 18 Dec 2014 14:13:00 +0530
Message-ID: <83e406b0-d47a-48e9-ba13-0ec0de31c4c9@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fix ocrdma_query_qp to refelect correct qp state based on FW.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 75c7276..dc18085 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1522,8 +1522,6 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 		goto mbx_err;
 	if (qp->qp_type == IB_QPT_UD)
 		qp_attr->qkey = params.qkey;
-	qp_attr->qp_state = get_ibqp_state(IB_QPS_INIT);
-	qp_attr->cur_qp_state = get_ibqp_state(IB_QPS_INIT);
 	qp_attr->path_mtu =
 		ocrdma_mtu_int_to_enum(params.path_mtu_pkey_indx &
 				OCRDMA_QP_PARAMS_PATH_MTU_MASK) >>
@@ -1578,6 +1576,8 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 	memset(&qp_attr->alt_ah_attr, 0, sizeof(qp_attr->alt_ah_attr));
 	qp_state = (params.max_sge_recv_flags & OCRDMA_QP_PARAMS_STATE_MASK) >>
 		    OCRDMA_QP_PARAMS_STATE_SHIFT;
+	qp_attr->qp_state = get_ibqp_state(qp_state);
+	qp_attr->cur_qp_state = qp_attr->qp_state;
 	qp_attr->sq_draining = (qp_state == OCRDMA_QPS_SQ_DRAINING) ? 1 : 0;
 	qp_attr->max_dest_rd_atomic =
 	    params.max_ord_ird >> OCRDMA_QP_PARAMS_MAX_ORD_SHIFT;
@@ -1585,6 +1585,8 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
 	    params.max_ord_ird & OCRDMA_QP_PARAMS_MAX_IRD_MASK;
 	qp_attr->en_sqd_async_notify = (params.max_sge_recv_flags &
 				OCRDMA_QP_PARAMS_FLAGS_SQD_ASYNC) ? 1 : 0;
+	/* Sync driver QP state with FW */
+	ocrdma_qp_state_change(qp, qp_attr->qp_state, NULL);
 mbx_err:
 	return status;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
