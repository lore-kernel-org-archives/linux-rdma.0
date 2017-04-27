From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core 4/4] libqedr: prevent EDPM loopback
Date: Thu, 27 Apr 2017 09:11:08 +0300
Message-ID: <1493273468-23774-5-git-send-email-Ram.Amrani@cavium.com>
References: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493273468-23774-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

HW doesn't support EDPM loopback. Hence disable EDPM if this is
a loopback QP.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |  1 +
 providers/qedr/qelr_verbs.c | 44 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index b5310b5..0dd6835 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -243,6 +243,7 @@ struct qelr_qp {
 	uint32_t				qp_id;
 	int					sq_sig_all;
 	int					atomic_supported;
+	uint8_t					edpm_disabled;
 };
 
 static inline struct qelr_devctx *get_qelr_ctx(struct ibv_context *ibctx)
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 375664b..676b18c 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -768,6 +768,7 @@ int qelr_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	struct ibv_modify_qp cmd = {};
 	struct qelr_qp *qp = get_qelr_qp(ibqp);
 	struct qelr_devctx *cxt = get_qelr_ctx(ibqp->context);
+	union ibv_gid sgid, *p_dgid;
 	int rc;
 
 	DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "QP Modify %p, attr_mask=0x%x\n",
@@ -776,14 +777,45 @@ int qelr_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	qelr_print_qp_attr(cxt, attr);
 
 	rc = ibv_cmd_modify_qp(ibqp, attr, attr_mask, &cmd, sizeof(cmd));
+	if (rc) {
+		DP_ERR(cxt->dbg_fp, "QP Modify: Failed command. rc=%d\n", rc);
+		return rc;
+	}
 
-	if (!rc && (attr_mask & IBV_QP_STATE)) {
-		DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP, "QP Modify state %d->%d\n",
-			   qp->state, attr->qp_state);
-		qelr_update_qp_state(qp, attr->qp_state);
+	if (attr_mask & IBV_QP_STATE) {
+		rc = qelr_update_qp_state(qp, attr->qp_state);
+		DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+			   "QP Modify state %d->%d, rc=%d\n", qp->state,
+			   attr->qp_state, rc);
+		if (rc) {
+			DP_ERR(cxt->dbg_fp,
+			       "QP Modify: Failed to update state. rc=%d\n",
+			       rc);
+
+			return rc;
+		}
 	}
 
-	return rc;
+	/* EDPM must be disabled if GIDs match */
+	if (attr_mask & IBV_QP_AV) {
+		rc = ibv_query_gid(ibqp->context, attr->ah_attr.port_num,
+				   attr->ah_attr.grh.sgid_index, &sgid);
+
+		if (!rc) {
+			p_dgid = &attr->ah_attr.grh.dgid;
+			qp->edpm_disabled = !memcmp(&sgid, p_dgid,
+						    sizeof(sgid));
+			DP_VERBOSE(cxt->dbg_fp, QELR_MSG_QP,
+				   "QP Modify: %p, edpm_disabled=%d\n", qp,
+				   qp->edpm_disabled);
+		} else  {
+			DP_ERR(cxt->dbg_fp,
+			       "QP Modify: Failed querying GID. rc=%d\n",
+			       rc);
+		}
+	}
+
+	return 0;
 }
 
 int qelr_destroy_qp(struct ibv_qp *ibqp)
@@ -839,7 +871,7 @@ static inline void qelr_init_edpm_info(struct qelr_devctx *cxt,
 	edpm->is_edpm = 0;
 
 	if (qelr_chain_is_full(&qp->sq.chain) &&
-	    wr->send_flags & IBV_SEND_INLINE) {
+	    wr->send_flags & IBV_SEND_INLINE && !qp->edpm_disabled) {
 		memset(edpm, 0, sizeof(*edpm));
 		edpm->rdma_ext = (struct qelr_rdma_ext *)&edpm->dpm_payload;
 		edpm->is_edpm = 1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
