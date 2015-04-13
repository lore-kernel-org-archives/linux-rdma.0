From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
Date: Mon, 13 Apr 2015 14:26:55 +0200
Message-ID: <552BB60F.60109@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552BB470.4090407-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform cm related part in IB-core cma.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 79 ++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..8ba5553 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -735,8 +735,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 	int ret = 0;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num)) {
 		if (!id_priv->cm_id.ib || (id_priv->id.qp_type == IB_QPT_UD))
 			ret = cma_ib_init_qp_attr(id_priv, qp_attr, qp_attr_mask);
 		else
@@ -745,19 +744,16 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 
 		if (qp_attr->qp_state == IB_QPS_RTR)
 			qp_attr->rq_psn = id_priv->seq_num;
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	} else if (rdma_tech_iwarp(id_priv->id.device,
+				   id_priv->id.port_num)) {
 		if (!id_priv->cm_id.iw) {
 			qp_attr->qp_access_flags = 0;
 			*qp_attr_mask = IB_QP_STATE | IB_QP_ACCESS_FLAGS;
 		} else
 			ret = iw_cm_init_qp_attr(id_priv->cm_id.iw, qp_attr,
 						 qp_attr_mask);
-		break;
-	default:
+	} else
 		ret = -ENOSYS;
-		break;
-	}
 
 	return ret;
 }
@@ -1037,17 +1033,13 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	mutex_unlock(&id_priv->handler_mutex);
 
 	if (id_priv->cma_dev) {
-		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
-		case RDMA_TRANSPORT_IB:
+		if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
-			break;
-		case RDMA_TRANSPORT_IWARP:
+		} else if (rdma_tech_iwarp(id_priv->id.device,
+					   id_priv->id.port_num)) {
 			if (id_priv->cm_id.iw)
 				iw_destroy_cm_id(id_priv->cm_id.iw);
-			break;
-		default:
-			break;
 		}
 		cma_leave_mc_groups(id_priv);
 		cma_release_dev(id_priv);
@@ -2060,7 +2052,7 @@ port_found:
 		goto out;
 
 	id_priv->id.route.addr.dev_addr.dev_type =
-		(rdma_port_get_link_layer(cma_dev->device, p) == IB_LINK_LAYER_INFINIBAND) ?
+		(rdma_tech_ib(cma_dev->device, p)) ?
 		ARPHRD_INFINIBAND : ARPHRD_ETHER;
 
 	rdma_addr_set_sgid(&id_priv->id.route.addr.dev_addr, &gid);
@@ -2537,18 +2529,15 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 
 	id_priv->backlog = backlog;
 	if (id->device) {
-		switch (rdma_node_get_transport(id->device->node_type)) {
-		case RDMA_TRANSPORT_IB:
+		if (rdma_ib_or_iboe(id->device, id->port_num)) {
 			ret = cma_ib_listen(id_priv);
 			if (ret)
 				goto err;
-			break;
-		case RDMA_TRANSPORT_IWARP:
+		} else if (rdma_tech_iwarp(id->device, id->port_num)) {
 			ret = cma_iw_listen(id_priv, backlog);
 			if (ret)
 				goto err;
-			break;
-		default:
+		} else {
 			ret = -ENOSYS;
 			goto err;
 		}
@@ -2884,20 +2873,15 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	if (rdma_ib_or_iboe(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_resolve_ib_udp(id_priv, conn_param);
 		else
 			ret = cma_connect_ib(id_priv, conn_param);
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	} else if (rdma_tech_iwarp(id->device, id->port_num))
 		ret = cma_connect_iw(id_priv, conn_param);
-		break;
-	default:
+	else
 		ret = -ENOSYS;
-		break;
-	}
 	if (ret)
 		goto err;
 
@@ -3000,8 +2984,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	if (rdma_ib_or_iboe(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD) {
 			if (conn_param)
 				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
@@ -3017,14 +3000,10 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			else
 				ret = cma_rep_recv(id_priv);
 		}
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	} else if (rdma_tech_iwarp(id->device, id->port_num))
 		ret = cma_accept_iw(id_priv, conn_param);
-		break;
-	default:
+	else
 		ret = -ENOSYS;
-		break;
-	}
 
 	if (ret)
 		goto reject;
@@ -3068,8 +3047,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	if (rdma_ib_or_iboe(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
 						private_data, private_data_len);
@@ -3077,15 +3055,12 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 			ret = ib_send_cm_rej(id_priv->cm_id.ib,
 					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
 					     0, private_data, private_data_len);
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	} else if (rdma_tech_iwarp(id->device, id->port_num)) {
 		ret = iw_cm_reject(id_priv->cm_id.iw,
 				   private_data, private_data_len);
-		break;
-	default:
+	} else
 		ret = -ENOSYS;
-		break;
-	}
+
 	return ret;
 }
 EXPORT_SYMBOL(rdma_reject);
@@ -3099,22 +3074,18 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	switch (rdma_node_get_transport(id->device->node_type)) {
-	case RDMA_TRANSPORT_IB:
+	if (rdma_ib_or_iboe(id->device, id->port_num)) {
 		ret = cma_modify_qp_err(id_priv);
 		if (ret)
 			goto out;
 		/* Initiate or respond to a disconnect. */
 		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0))
 			ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0);
-		break;
-	case RDMA_TRANSPORT_IWARP:
+	} else if (rdma_tech_iwarp(id->device, id->port_num)) {
 		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
-		break;
-	default:
+	} else
 		ret = -EINVAL;
-		break;
-	}
+
 out:
 	return ret;
 }
-- 
2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
