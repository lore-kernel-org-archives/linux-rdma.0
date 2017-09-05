From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core RESEND] libqedr: Add iWARP support for user-space lib
Date: Tue, 5 Sep 2017 17:36:54 +0300
Message-ID: <1504622214-9730-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Introduce IS_IWARP / IS_ROCE macros for libqedr as there are no global
macros for this in rdma-core.
There is a second doorbell required for RQ.
QP states in user lib are not updated, as they are updated implicitly by
the driver and not driven by modify_qp as they are in ib / roce.
For this reason, decisions based on states are encapsulated in IS_ROCE.

Signed-off-by: Michal Kalderon  <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |  2 ++
 providers/qedr/qelr_verbs.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index 0dd6835..3c663e7 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -192,6 +192,8 @@ struct qelr_qp_hwq_info {
 	void					*db;      /* Doorbell address */
 	void					*edpm_db;
 	union db_prod32				db_data;  /* Doorbell data */
+	void					*iwarp_db2;      /* iWARP RQ Doorbell address */
+	union db_prod32				iwarp_db2_data;  /* iWARP RQ Doorbell data */
 
 	uint16_t				icid;
 };
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 676b18c..a087499 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -59,6 +59,9 @@
 #define QELR_RQE_ELEMENT_SIZE	(sizeof(struct rdma_rq_sge))
 #define QELR_CQE_SIZE		(sizeof(union rdma_cqe))
 
+#define IS_IWARP(_dev)		(_dev->node_type == IBV_NODE_RNIC)
+#define IS_ROCE(_dev)		(_dev->node_type == IBV_NODE_CA)
+
 static void qelr_inc_sw_cons_u16(struct qelr_qp_hwq_info *info)
 {
 	info->cons = (info->cons + 1) % info->max_wr;
@@ -434,6 +437,9 @@ static inline int qelr_configure_qp_rq(struct qelr_devctx *cxt,
 	qp->rq.icid = resp->rq_icid;
 	qp->rq.db_data.data.icid = htole16(resp->rq_icid);
 	qp->rq.db = cxt->db_addr + resp->rq_db_offset;
+	qp->rq.iwarp_db2 = cxt->db_addr + resp->rq_db2_offset;
+	qp->rq.iwarp_db2_data.data.icid = qp->rq.icid;
+	qp->rq.iwarp_db2_data.data.value = DQ_TCM_IWARP_POST_RQ_CF_CMD;
 	qp->rq.prod = 0;
 
 	/* shadow RQ */
@@ -648,6 +654,12 @@ static int qelr_update_qp_state(struct qelr_qp *qp,
 	int status = 0;
 	enum qelr_qp_state new_state;
 
+	/* iWARP states are updated implicitely by driver and don't have a
+	 * real purpose in user-lib.
+	 */
+	if (IS_IWARP(qp->ibv_qp.context->device))
+		return 0;
+
 	new_state = get_qelr_qp_state(new_ib_state);
 
 	pthread_spin_lock(&qp->q_lock);
@@ -677,9 +689,11 @@ static int qelr_update_qp_state(struct qelr_qp *qp,
 			/* Update doorbell (in case post_recv was done before
 			 * move to RTR)
 			 */
-			mmio_wc_start();
-			writel(qp->rq.db_data.raw, qp->rq.db);
-			mmio_flush_writes();
+			if (IS_ROCE(qp->ibv_qp.context->device)) {
+				mmio_wc_start();
+				writel(qp->rq.db_data.raw, qp->rq.db);
+				mmio_flush_writes();
+			}
 			break;
 		case QELR_QPS_ERR:
 			break;
@@ -870,6 +884,10 @@ static inline void qelr_init_edpm_info(struct qelr_devctx *cxt,
 {
 	edpm->is_edpm = 0;
 
+	/* Currently dpm is not supported for iWARP */
+	if (IS_IWARP(cxt->ibv_ctx.device))
+		return;
+
 	if (qelr_chain_is_full(&qp->sq.chain) &&
 	    wr->send_flags & IBV_SEND_INLINE && !qp->edpm_disabled) {
 		memset(edpm, 0, sizeof(*edpm));
@@ -1405,7 +1423,8 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 
 	pthread_spin_lock(&qp->q_lock);
 
-	if ((qp->state != QELR_QPS_RTS && qp->state != QELR_QPS_ERR &&
+	if (IS_ROCE(ib_qp->context->device) &&
+	    (qp->state != QELR_QPS_RTS && qp->state != QELR_QPS_ERR &&
 	     qp->state != QELR_QPS_SQD)) {
 		pthread_spin_unlock(&qp->q_lock);
 		*bad_wr = wr;
@@ -1445,10 +1464,11 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	struct qelr_qp *qp =  get_qelr_qp(ibqp);
 	struct qelr_devctx *cxt = get_qelr_ctx(ibqp->context);
 	uint16_t db_val;
+	uint8_t iwarp = IS_IWARP(ibqp->context->device);
 
 	pthread_spin_lock(&qp->q_lock);
 
-	if (qp->state == QELR_QPS_RST) {
+	if (!iwarp && qp->state == QELR_QPS_RST) {
 		pthread_spin_unlock(&qp->q_lock);
 		*bad_wr = wr;
 		return -EINVAL;
@@ -1517,6 +1537,10 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		writel(qp->rq.db_data.raw, qp->rq.db);
 		mmio_flush_writes();
 
+		if (iwarp) {
+			writel(qp->rq.iwarp_db2_data.raw, qp->rq.iwarp_db2);
+			mmio_flush_writes();
+		}
 		wr = wr->next;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
