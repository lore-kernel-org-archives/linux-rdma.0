From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 08/10] IB/core: Extend create QP to get indirection table
Date: Mon, 23 May 2016 15:20:54 +0300
Message-ID: <1464006056-19653-9-git-send-email-yishaih@mellanox.com>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464006056-19653-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend create QP to get Receive Work Queue (WQ) indirection table.

QP can be created with external Receive Work Queue indirection table,
in that case it is ready to receive immediately.


Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 19 +++++++++++++++++--
 include/rdma/ib_verbs.h         |  2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6b548d7..6916d5c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -754,6 +754,12 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	struct ib_qp *qp;
 	int ret;
 
+	if (qp_init_attr->rwq_ind_tbl &&
+	    (qp_init_attr->recv_cq ||
+	    qp_init_attr->srq || qp_init_attr->cap.max_recv_wr ||
+	    qp_init_attr->cap.max_recv_sge))
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * If the callers is using the RDMA API calculate the resources
 	 * needed for the RDMA READ/WRITE operations.
@@ -771,6 +777,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
+	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
 
 	atomic_set(&qp->usecnt, 0);
 	qp->mrs_used = 0;
@@ -788,7 +795,8 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		qp->srq = NULL;
 	} else {
 		qp->recv_cq = qp_init_attr->recv_cq;
-		atomic_inc(&qp_init_attr->recv_cq->usecnt);
+		if (qp_init_attr->recv_cq)
+			atomic_inc(&qp_init_attr->recv_cq->usecnt);
 		qp->srq = qp_init_attr->srq;
 		if (qp->srq)
 			atomic_inc(&qp_init_attr->srq->usecnt);
@@ -799,7 +807,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->xrcd    = NULL;
 
 	atomic_inc(&pd->usecnt);
-	atomic_inc(&qp_init_attr->send_cq->usecnt);
+	if (qp_init_attr->send_cq)
+		atomic_inc(&qp_init_attr->send_cq->usecnt);
+	if (qp_init_attr->rwq_ind_tbl)
+		atomic_inc(&qp->rwq_ind_tbl->usecnt);
 
 	if (qp_init_attr->cap.max_rdma_ctxs) {
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
@@ -1279,6 +1290,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
+	struct ib_rwq_ind_table *ind_tbl;
 	int ret;
 
 	WARN_ON_ONCE(qp->mrs_used > 0);
@@ -1293,6 +1305,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
+	ind_tbl = qp->rwq_ind_tbl;
 
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);
@@ -1307,6 +1320,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (ind_tbl)
+			atomic_dec(&ind_tbl->usecnt);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a12682e..3e9653e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1018,6 +1018,7 @@ struct ib_qp_init_attr {
 	 * Only needed for special QP types, or when using the RW API.
 	 */
 	u8			port_num;
+	struct ib_rwq_ind_table *rwq_ind_tbl;
 };
 
 struct ib_qp_open_attr {
@@ -1512,6 +1513,7 @@ struct ib_qp {
 	void		       *qp_context;
 	u32			qp_num;
 	enum ib_qp_type		qp_type;
+	struct ib_rwq_ind_table *rwq_ind_tbl;
 };
 
 struct ib_mr {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
