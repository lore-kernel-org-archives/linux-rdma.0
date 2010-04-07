From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/26 v2] rdma/cm: set qkey for port space IB
Date: Tue, 6 Apr 2010 17:49:12 -0700
Message-ID: <1DFB5728040C4859814321F81E52EEF5@amr.corp.intel.com>
References: <0B94CA7CD279474EAAF856BCEC45BDED@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0B94CA7CD279474EAAF856BCEC45BDED-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow the user to specify the qkey when using port space IB.  The
qkey is added to struct rdma_ucm_conn_param in place of a reserved
field, but for backwards compatibility, is only accessed if the
associated rdma_cm_id is using the IB port space.

The qkey associated with an id is now set when sending or receiving the
SIDR REP.  If the qkey is read before being set, to modify the QP
state early for example, it reverts to the default value.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1:
Allow the user to specify the QKey, rather than automatically using
the hard-coded RDMA_QKEY_UDP value.

 drivers/infiniband/core/cma.c  |   33 ++++++++++++++++++++-------------
 drivers/infiniband/core/ucma.c |   11 ++++++++---
 include/rdma/rdma_cm.h         |    1 +
 include/rdma/rdma_user_cm.h    |    2 +-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ccf47c6..f8ca424 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -293,16 +293,25 @@ static void cma_detach_from_dev(struct rdma_id_private *id_priv)
 	id_priv->cma_dev = NULL;
 }
 
-static int cma_set_qkey(struct rdma_id_private *id_priv)
+static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
 {
 	struct ib_sa_mcmember_rec rec;
 	int ret = 0;
 
-	if (id_priv->qkey)
+	if (id_priv->qkey) {
+		if (qkey && id_priv->qkey != qkey)
+			return -EINVAL;
 		return 0;
+	}
+
+	if (qkey) {
+		id_priv->qkey = qkey;
+		return 0;
+	}
 
 	switch (id_priv->id.ps) {
 	case RDMA_PS_UDP:
+	case RDMA_PS_IB:
 		id_priv->qkey = RDMA_UDP_QKEY;
 		break;
 	case RDMA_PS_IPOIB:
@@ -565,7 +574,7 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	*qp_attr_mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_PORT;
 
 	if (id_priv->id.qp_type == IB_QPT_UD) {
-		ret = cma_set_qkey(id_priv);
+		ret = cma_set_qkey(id_priv, 0);
 		if (ret)
 			return ret;
 
@@ -2302,15 +2311,10 @@ static int cma_sidr_rep_handler(struct ib_cm_id *cm_id,
 			event.status = ib_event->param.sidr_rep_rcvd.status;
 			break;
 		}
-		ret = cma_set_qkey(id_priv);
+		ret = cma_set_qkey(id_priv, rep->qkey);
 		if (ret) {
 			event.event = RDMA_CM_EVENT_ADDR_ERROR;
-			event.status = -EINVAL;
-			break;
-		}
-		if (id_priv->qkey != rep->qkey) {
-			event.event = RDMA_CM_EVENT_UNREACHABLE;
-			event.status = -EINVAL;
+			event.status = ret;
 			break;
 		}
 		ib_init_ah_from_path(id_priv->id.device, id_priv->id.port_num,
@@ -2583,7 +2587,7 @@ static int cma_accept_iw(struct rdma_id_private *id_priv,
 }
 
 static int cma_send_sidr_rep(struct rdma_id_private *id_priv,
-			     enum ib_cm_sidr_status status,
+			     enum ib_cm_sidr_status status, u32 qkey,
 			     const void *private_data, int private_data_len)
 {
 	struct ib_cm_sidr_rep_param rep;
@@ -2592,7 +2596,7 @@ static int cma_send_sidr_rep(struct rdma_id_private *id_priv,
 	memset(&rep, 0, sizeof rep);
 	rep.status = status;
 	if (status == IB_SIDR_SUCCESS) {
-		ret = cma_set_qkey(id_priv);
+		ret = cma_set_qkey(id_priv, qkey);
 		if (ret)
 			return ret;
 		rep.qp_num = id_priv->qp_num;
@@ -2622,6 +2626,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	case RDMA_TRANSPORT_IB:
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
+						conn_param->qkey,
 						conn_param->private_data,
 						conn_param->private_data_len);
 		else if (conn_param)
@@ -2682,7 +2687,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	switch (rdma_node_get_transport(id->device->node_type)) {
 	case RDMA_TRANSPORT_IB:
 		if (id->qp_type == IB_QPT_UD)
-			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT,
+			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
 						private_data, private_data_len);
 		else
 			ret = ib_send_cm_rej(id_priv->cm_id.ib,
@@ -2743,6 +2748,8 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	    cma_disable_callback(id_priv, CMA_ADDR_RESOLVED))
 		return 0;
 
+	if (!status)
+		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
 	mutex_lock(&id_priv->qp_mutex);
 	if (!status && id_priv->id.qp)
 		status = ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 723fe83..07afd38 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -655,7 +655,8 @@ out:
 	return ret;
 }
 
-static void ucma_copy_conn_param(struct rdma_conn_param *dst,
+static void ucma_copy_conn_param(struct rdma_cm_id *id,
+				 struct rdma_conn_param *dst,
 				 struct rdma_ucm_conn_param *src)
 {
 	dst->private_data = src->private_data;
@@ -667,6 +668,10 @@ static void ucma_copy_conn_param(struct rdma_conn_param *dst,
 	dst->rnr_retry_count = src->rnr_retry_count;
 	dst->srq = src->srq;
 	dst->qp_num = src->qp_num;
+	if (id->ps == RDMA_PS_IB)
+		dst->qkey = src->qkey;
+	else
+		dst->qkey = 0;
 }
 
 static ssize_t ucma_connect(struct ucma_file *file, const char __user *inbuf,
@@ -687,7 +692,7 @@ static ssize_t ucma_connect(struct ucma_file *file, const char __user *inbuf,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	ucma_copy_conn_param(&conn_param, &cmd.conn_param);
+	ucma_copy_conn_param(ctx->cm_id, &conn_param, &cmd.conn_param);
 	ret = rdma_connect(ctx->cm_id, &conn_param);
 	ucma_put_ctx(ctx);
 	return ret;
@@ -731,7 +736,7 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 
 	if (cmd.conn_param.valid) {
 		ctx->uid = cmd.uid;
-		ucma_copy_conn_param(&conn_param, &cmd.conn_param);
+		ucma_copy_conn_param(ctx->cm_id, &conn_param, &cmd.conn_param);
 		ret = rdma_accept(ctx->cm_id, &conn_param);
 	} else
 		ret = rdma_accept(ctx->cm_id, NULL);
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 68e73d1..363e7a3 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -99,6 +99,7 @@ struct rdma_conn_param {
 	/* Fields below ignored if a QP is created on the rdma_cm_id. */
 	u8 srq;
 	u32 qp_num;
+	u32 qkey;
 };
 
 struct rdma_ud_param {
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index d88c23c..fa6693c 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -131,7 +131,7 @@ struct rdma_ucm_query_route_resp {
 
 struct rdma_ucm_conn_param {
 	__u32 qp_num;
-	__u32 reserved;
+	__u32 qkey;
 	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
 	__u8  private_data_len;
 	__u8  srq;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
