From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 3/4] IB/core: Make sure that the PSN does not overflow
Date: Thu, 29 Jan 2015 11:14:30 +0200
Message-ID: <1422522871-11216-4-git-send-email-ogerlitz@mellanox.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422522871-11216-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The rq/sq->psn is 24 bits as defined in the IB spec, therefore ULPs and User
space applications shouldn't use the 8 most significant bits in the 32 bits
variables to avoid overflow in modify_qp.

Fixed the PSN usage for kernel ULPs and masked out the 8 most significant bits
for User-space applications.

>From now on, we check in ib_modify_qp_is_ok that the PSN doesn't overflow, and
we fail if so.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c               |    6 +++---
 drivers/infiniband/core/uverbs_cmd.c        |    4 ++--
 drivers/infiniband/core/verbs.c             |   10 ++++++++--
 drivers/infiniband/hw/ehca/ehca_qp.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c      |    2 +-
 drivers/infiniband/hw/mlx4/qp.c             |    6 +++---
 drivers/infiniband/hw/mlx5/qp.c             |    4 ++--
 drivers/infiniband/hw/mthca/mthca_qp.c      |    4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    7 ++++---
 drivers/infiniband/hw/qib/qib_qp.c          |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    4 ++--
 include/rdma/ib_verbs.h                     |    7 ++++---
 12 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..26c203a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -744,7 +744,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 						 qp_attr_mask);
 
 		if (qp_attr->qp_state == IB_QPS_RTR)
-			qp_attr->rq_psn = id_priv->seq_num;
+			qp_attr->rq_psn = id_priv->seq_num & 0xffffff;
 		break;
 	case RDMA_TRANSPORT_IWARP:
 		if (!id_priv->cm_id.iw) {
@@ -2807,7 +2807,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.service_id = rdma_get_service_id(&id_priv->id, cma_dst_addr(id_priv));
 	req.qp_num = id_priv->qp_num;
 	req.qp_type = id_priv->id.qp_type;
-	req.starting_psn = id_priv->seq_num;
+	req.starting_psn = id_priv->seq_num & 0xffffff;
 	req.responder_resources = conn_param->responder_resources;
 	req.initiator_depth = conn_param->initiator_depth;
 	req.flow_control = conn_param->flow_control;
@@ -2924,7 +2924,7 @@ static int cma_accept_ib(struct rdma_id_private *id_priv,
 
 	memset(&rep, 0, sizeof rep);
 	rep.qp_num = id_priv->qp_num;
-	rep.starting_psn = id_priv->seq_num;
+	rep.starting_psn = id_priv->seq_num & 0xffffff;
 	rep.private_data = conn_param->private_data;
 	rep.private_data_len = conn_param->private_data_len;
 	rep.responder_resources = conn_param->responder_resources;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 532d8eb..ecb6430 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2053,8 +2053,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->path_mtu 		  = cmd.path_mtu;
 	attr->path_mig_state 	  = cmd.path_mig_state;
 	attr->qkey 		  = cmd.qkey;
-	attr->rq_psn 		  = cmd.rq_psn;
-	attr->sq_psn 		  = cmd.sq_psn;
+	attr->rq_psn              = cmd.rq_psn & 0xffffff;
+	attr->sq_psn              = cmd.sq_psn & 0xffffff;
 	attr->dest_qp_num 	  = cmd.dest_qp_num;
 	attr->qp_access_flags 	  = cmd.qp_access_flags;
 	attr->pkey_index 	  = cmd.pkey_index;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f93eb8d..2cad161 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -827,8 +827,8 @@ static const struct {
 };
 
 int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
-		       enum ib_qp_type type, enum ib_qp_attr_mask mask,
-		       enum rdma_link_layer ll)
+		       enum ib_qp_type type, struct ib_qp_attr *attr,
+		       enum ib_qp_attr_mask mask, enum rdma_link_layer ll)
 {
 	enum ib_qp_attr_mask req_param, opt_param;
 
@@ -860,6 +860,12 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 	if (mask & ~(req_param | opt_param | IB_QP_STATE))
 		return 0;
 
+	if ((mask & IB_QP_SQ_PSN) && (attr->sq_psn & 0xff000000))
+		return 0;
+
+	if ((mask & IB_QP_RQ_PSN) && (attr->rq_psn & 0xff000000))
+		return 0;
+
 	return 1;
 }
 EXPORT_SYMBOL(ib_modify_qp_is_ok);
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 2e89356..c773cc2 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1329,7 +1329,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	qp_new_state = attr_mask & IB_QP_STATE ? attr->qp_state : qp_cur_state;
 	if (!smi_reset2init &&
 	    !ib_modify_qp_is_ok(qp_cur_state, qp_new_state, ibqp->qp_type,
-				attr_mask, IB_LINK_LAYER_UNSPECIFIED)) {
+				attr, attr_mask, IB_LINK_LAYER_UNSPECIFIED)) {
 		ret = -EINVAL;
 		ehca_err(ibqp->device,
 			 "Invalid qp transition new_state=%x cur_state=%x "
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
index face876..a3a3be7 100644
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -462,7 +462,7 @@ int ipath_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr,
 				attr_mask, IB_LINK_LAYER_UNSPECIFIED))
 		goto inval;
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cc37e01..96c607c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1898,9 +1898,9 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	}
 
 	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
-				attr_mask, ll)) {
-		pr_debug("qpn 0x%x: invalid attribute mask specified "
-			 "for transition %d to %d. qp_type %d,"
+				attr, attr_mask, ll)) {
+		pr_debug("qpn 0x%x: invalid attribute mask or attributes "
+			 "specified for transition %d to %d. qp_type %d,"
 			 " attr_mask 0x%x\n",
 			 ibqp->qp_num, cur_state, new_state,
 			 ibqp->qp_type, attr_mask);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index be0cd35..9a120a8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1790,8 +1790,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
 	if (ibqp->qp_type != MLX5_IB_QPT_REG_UMR &&
-	    !ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask,
-				IB_LINK_LAYER_UNSPECIFIED))
+	    !ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr,
+				attr_mask, IB_LINK_LAYER_UNSPECIFIED))
 		goto out;
 
 	if ((attr_mask & IB_QP_PORT) &&
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index e354b2f..7822f64 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -860,8 +860,8 @@ int mthca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask,
-				IB_LINK_LAYER_UNSPECIFIED)) {
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr,
+				attr_mask, IB_LINK_LAYER_UNSPECIFIED)) {
 		mthca_dbg(dev, "Bad QP transition (transport %d) "
 			  "%d->%d with attr 0x%08x\n",
 			  qp->transport, cur_state, new_state,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fb8d8c4..b74dd07 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1348,9 +1348,10 @@ int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		new_qps = old_qps;
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
-	if (!ib_modify_qp_is_ok(old_qps, new_qps, ibqp->qp_type, attr_mask,
-				IB_LINK_LAYER_ETHERNET)) {
-		pr_err("%s(%d) invalid attribute mask=0x%x specified for\n"
+	if (!ib_modify_qp_is_ok(old_qps, new_qps, ibqp->qp_type, attr,
+				attr_mask, IB_LINK_LAYER_ETHERNET)) {
+		pr_err("%s(%d) invalid attribute mask=0x%x or "
+		       "attributues specified for\n"
 		       "qpn=0x%x of type=0x%x old_qps=0x%x, new_qps=0x%x\n",
 		       __func__, dev->id, attr_mask, qp->id, ibqp->qp_type,
 		       old_qps, new_qps);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6ddc026..3b4a176 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -584,7 +584,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr,
 				attr_mask, IB_LINK_LAYER_UNSPECIFIED))
 		goto inval;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 56959ad..bdf35b0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -294,7 +294,7 @@ static int ipoib_cm_modify_rx_qp(struct net_device *dev,
 		ipoib_warn(priv, "failed to init QP attr for RTR: %d\n", ret);
 		return ret;
 	}
-	qp_attr.rq_psn = psn;
+	qp_attr.rq_psn = psn & 0xffffff;
 	ret = ib_modify_qp(qp, &qp_attr, qp_attr_mask);
 	if (ret) {
 		ipoib_warn(priv, "failed to modify QP to RTR: %d\n", ret);
@@ -433,7 +433,7 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
 	rep.rnr_retry_count = req->rnr_retry_count;
 	rep.srq = ipoib_cm_has_srq(dev);
 	rep.qp_num = qp->qp_num;
-	rep.starting_psn = psn;
+	rep.starting_psn = psn & 0xffffff;
 	return ib_send_cm_rep(cm_id, &rep);
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0d74f1d..a8bb978 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1716,10 +1716,11 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
 /**
  * ib_modify_qp_is_ok - Check that the supplied attribute mask
  * contains all required attributes and no attributes not allowed for
- * the given QP state transition.
+ * the given QP state transition, and checks the QP attributes.
  * @cur_state: Current QP state
  * @next_state: Next QP state
  * @type: QP type
+ * @attr: QP attributes
  * @mask: Mask of supplied QP attributes
  * @ll : link layer of port
  *
@@ -1730,8 +1731,8 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
  * and that the attribute mask supplied is allowed for the transition.
  */
 int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
-		       enum ib_qp_type type, enum ib_qp_attr_mask mask,
-		       enum rdma_link_layer ll);
+		       enum ib_qp_type type, struct ib_qp_attr *attr,
+		       enum ib_qp_attr_mask mask, enum rdma_link_layer ll);
 
 int ib_register_event_handler  (struct ib_event_handler *event_handler);
 int ib_unregister_event_handler(struct ib_event_handler *event_handler);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
