From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/4] IB/core: Add RoCE IP based addressing extensions towards user space
Date: Thu, 13 Jun 2013 18:01:44 +0300
Message-ID: <1371135704-5712-5-git-send-email-ogerlitz@mellanox.com>
References: <1371135704-5712-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371135704-5712-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for RoCE (IBoE) IP based addressing extensions towards user space.

Extend INIT_QP_ATTR and QUERY_ROUTE ucma commands.

Extend MODIFY_QP and CREATE_AH uverbs commands.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c            |  172 +++++++++++++++-
 drivers/infiniband/core/uverbs.h          |    2 +
 drivers/infiniband/core/uverbs_cmd.c      |  330 ++++++++++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c     |    4 +-
 drivers/infiniband/core/uverbs_marshall.c |   94 ++++++++-
 include/rdma/ib_marshall.h                |   12 +
 include/uapi/rdma/ib_user_sa.h            |   34 +++-
 include/uapi/rdma/ib_user_verbs.h         |  120 +++++++++++-
 include/uapi/rdma/rdma_user_cm.h          |   21 ++-
 9 files changed, 690 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index bc2cb5d..c7dfd99 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -599,6 +599,35 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
 	}
 }
 
+static void ucma_copy_ib_route_ex(struct rdma_ucm_query_route_resp_ex *resp,
+				  struct rdma_route *route)
+{
+	struct rdma_dev_addr *dev_addr;
+
+	resp->num_paths = route->num_paths;
+	switch (route->num_paths) {
+	case 0:
+		dev_addr = &route->addr.dev_addr;
+		rdma_addr_get_dgid(dev_addr,
+				   (union ib_gid *)&resp->ib_route[0].dgid);
+		rdma_addr_get_sgid(dev_addr,
+				   (union ib_gid *)&resp->ib_route[0].sgid);
+		resp->ib_route[0].pkey =
+			cpu_to_be16(ib_addr_get_pkey(dev_addr));
+		break;
+	case 2:
+		ib_copy_path_rec_to_user_ex(&resp->ib_route[1],
+					    &route->path_rec[1]);
+		/* fall through */
+	case 1:
+		ib_copy_path_rec_to_user_ex(&resp->ib_route[0],
+					    &route->path_rec[0]);
+		break;
+	default:
+		break;
+	}
+}
+
 static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
 				 struct rdma_route *route)
 {
@@ -625,14 +654,39 @@ static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
 	}
 }
 
-static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
+static void ucma_copy_iboe_route_ex(struct rdma_ucm_query_route_resp_ex *resp,
+				    struct rdma_route *route)
+{
+	resp->num_paths = route->num_paths;
+	switch (route->num_paths) {
+	case 0:
+		rdma_ip2gid((struct sockaddr *)&route->addr.dst_addr,
+			    (union ib_gid *)&resp->ib_route[0].dgid);
+		rdma_ip2gid((struct sockaddr *)&route->addr.src_addr,
+			    (union ib_gid *)&resp->ib_route[0].sgid);
+		resp->ib_route[0].pkey = cpu_to_be16(0xffff);
+		break;
+	case 2:
+		ib_copy_path_rec_to_user_ex(&resp->ib_route[1],
+					    &route->path_rec[1]);
+		/* fall through */
+	case 1:
+		ib_copy_path_rec_to_user_ex(&resp->ib_route[0],
+					    &route->path_rec[0]);
+		break;
+	default:
+		break;
+	}
+}
+
+static void ucma_copy_iw_route(struct ib_user_path_rec *resp_path,
 			       struct rdma_route *route)
 {
 	struct rdma_dev_addr *dev_addr;
 
 	dev_addr = &route->addr.dev_addr;
-	rdma_addr_get_dgid(dev_addr, (union ib_gid *) &resp->ib_route[0].dgid);
-	rdma_addr_get_sgid(dev_addr, (union ib_gid *) &resp->ib_route[0].sgid);
+	rdma_addr_get_dgid(dev_addr, (union ib_gid *)&resp_path->dgid);
+	rdma_addr_get_sgid(dev_addr, (union ib_gid *)&resp_path->sgid);
 }
 
 static ssize_t ucma_query_route(struct ucma_file *file,
@@ -684,7 +738,74 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 		}
 		break;
 	case RDMA_TRANSPORT_IWARP:
-		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
+		ucma_copy_iw_route(&resp.ib_route[0], &ctx->cm_id->route);
+		break;
+	default:
+		break;
+	}
+
+out:
+	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+			 &resp, sizeof(resp)))
+		ret = -EFAULT;
+
+	ucma_put_ctx(ctx);
+	return ret;
+}
+
+static ssize_t ucma_query_route_ex(struct ucma_file *file,
+				   const char __user *inbuf,
+				   int in_len, int out_len)
+{
+	struct rdma_ucm_query_route_ex cmd;
+	struct rdma_ucm_query_route_resp_ex resp;
+	struct ucma_context *ctx;
+	struct sockaddr *addr;
+	int ret = 0;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	ctx = ucma_get_ctx(file, cmd.id);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	memset(&resp, 0, sizeof(resp));
+	addr = (struct sockaddr *)&ctx->cm_id->route.addr.src_addr;
+	memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
+				     sizeof(struct sockaddr_in) :
+				     sizeof(struct sockaddr_in6));
+	addr = (struct sockaddr *)&ctx->cm_id->route.addr.dst_addr;
+	memcpy(&resp.dst_addr, addr, addr->sa_family == AF_INET ?
+				     sizeof(struct sockaddr_in) :
+				     sizeof(struct sockaddr_in6));
+	if (!ctx->cm_id->device)
+		goto out;
+
+	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
+	resp.port_num = ctx->cm_id->port_num;
+	switch (rdma_node_get_transport(ctx->cm_id->device->node_type)) {
+	case RDMA_TRANSPORT_IB:
+		switch (rdma_port_get_link_layer(ctx->cm_id->device,
+			ctx->cm_id->port_num)) {
+		case IB_LINK_LAYER_INFINIBAND:
+			ucma_copy_ib_route_ex(&resp, &ctx->cm_id->route);
+			break;
+		case IB_LINK_LAYER_ETHERNET:
+			ucma_copy_iboe_route_ex(&resp, &ctx->cm_id->route);
+			break;
+		default:
+			break;
+		}
+		break;
+	case RDMA_TRANSPORT_IWARP:
+		ucma_copy_iw_route((struct ib_user_path_rec *)
+				   ((void *)&resp.ib_route[0] +
+				    sizeof(resp.ib_route[0].comp_mask)),
+				   &ctx->cm_id->route);
 		break;
 	default:
 		break;
@@ -862,6 +983,43 @@ out:
 	return ret;
 }
 
+static ssize_t ucma_init_qp_attr_ex(struct ucma_file *file,
+				    const char __user *inbuf,
+				    int in_len, int out_len)
+{
+	struct rdma_ucm_init_qp_attr cmd;
+	struct ib_uverbs_qp_attr_ex resp;
+	struct ucma_context *ctx;
+	struct ib_qp_attr qp_attr;
+	int ret;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
+		return -EFAULT;
+
+	ctx = ucma_get_ctx(file, cmd.id);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	resp.qp_attr_mask = 0;
+	memset(&qp_attr, 0, sizeof(qp_attr));
+	qp_attr.qp_state = cmd.qp_state;
+	ret = rdma_init_qp_attr(ctx->cm_id, &qp_attr, &resp.qp_attr_mask);
+	if (ret)
+		goto out;
+
+	ib_copy_qp_attr_to_user_ex(&resp, &qp_attr);
+	if (copy_to_user((void __user *)(unsigned long)cmd.response,
+			 &resp, sizeof(resp)))
+		ret = -EFAULT;
+
+out:
+	ucma_put_ctx(ctx);
+	return ret;
+}
+
 static int ucma_set_option_id(struct ucma_context *ctx, int optname,
 			      void *optval, size_t optlen)
 {
@@ -1229,7 +1387,9 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_NOTIFY]	= ucma_notify,
 	[RDMA_USER_CM_CMD_JOIN_MCAST]	= ucma_join_multicast,
 	[RDMA_USER_CM_CMD_LEAVE_MCAST]	= ucma_leave_multicast,
-	[RDMA_USER_CM_CMD_MIGRATE_ID]	= ucma_migrate_id
+	[RDMA_USER_CM_CMD_MIGRATE_ID]	= ucma_migrate_id,
+	[RDMA_USER_CM_CMD_QUERY_ROUTE_EX] = ucma_query_route_ex,
+	[RDMA_USER_CM_CMD_INIT_QP_ATTR_EX] = ucma_init_qp_attr_ex
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
@@ -1245,6 +1405,8 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof(hdr)))
 		return -EFAULT;
 
+	pr_info("UCMA: HDR_CMD: %d\n", hdr.cmd);
+
 	if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
 		return -EINVAL;
 
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 0fcd7aa..1ec4850 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -200,11 +200,13 @@ IB_UVERBS_DECLARE_CMD(create_qp);
 IB_UVERBS_DECLARE_CMD(open_qp);
 IB_UVERBS_DECLARE_CMD(query_qp);
 IB_UVERBS_DECLARE_CMD(modify_qp);
+IB_UVERBS_DECLARE_CMD(modify_qp_ex);
 IB_UVERBS_DECLARE_CMD(destroy_qp);
 IB_UVERBS_DECLARE_CMD(post_send);
 IB_UVERBS_DECLARE_CMD(post_recv);
 IB_UVERBS_DECLARE_CMD(post_srq_recv);
 IB_UVERBS_DECLARE_CMD(create_ah);
+IB_UVERBS_DECLARE_CMD(create_ah_ex);
 IB_UVERBS_DECLARE_CMD(destroy_ah);
 IB_UVERBS_DECLARE_CMD(attach_mcast);
 IB_UVERBS_DECLARE_CMD(detach_mcast);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a7d00f6..eb3e7e6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1891,6 +1891,58 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
+static void ib_uverbs_modify_qp_assign(struct ib_uverbs_modify_qp *cmd,
+				       struct ib_qp_attr *attr) {
+	attr->qp_state		  = cmd->qp_state;
+	attr->cur_qp_state	  = cmd->cur_qp_state;
+	attr->path_mtu		  = cmd->path_mtu;
+	attr->path_mig_state	  = cmd->path_mig_state;
+	attr->qkey		  = cmd->qkey;
+	attr->rq_psn		  = cmd->rq_psn;
+	attr->sq_psn		  = cmd->sq_psn;
+	attr->dest_qp_num	  = cmd->dest_qp_num;
+	attr->qp_access_flags	  = cmd->qp_access_flags;
+	attr->pkey_index	  = cmd->pkey_index;
+	attr->alt_pkey_index	  = cmd->alt_pkey_index;
+	attr->en_sqd_async_notify = cmd->en_sqd_async_notify;
+	attr->max_rd_atomic	  = cmd->max_rd_atomic;
+	attr->max_dest_rd_atomic  = cmd->max_dest_rd_atomic;
+	attr->min_rnr_timer	  = cmd->min_rnr_timer;
+	attr->port_num		  = cmd->port_num;
+	attr->timeout		  = cmd->timeout;
+	attr->retry_cnt		  = cmd->retry_cnt;
+	attr->rnr_retry		  = cmd->rnr_retry;
+	attr->alt_port_num	  = cmd->alt_port_num;
+	attr->alt_timeout	  = cmd->alt_timeout;
+
+	memcpy(attr->ah_attr.grh.dgid.raw, cmd->dest.dgid, 16);
+	attr->ah_attr.grh.flow_label        = cmd->dest.flow_label;
+	attr->ah_attr.grh.sgid_index        = cmd->dest.sgid_index;
+	attr->ah_attr.grh.hop_limit         = cmd->dest.hop_limit;
+	attr->ah_attr.grh.traffic_class     = cmd->dest.traffic_class;
+	attr->ah_attr.dlid		    = cmd->dest.dlid;
+	attr->ah_attr.sl		    = cmd->dest.sl;
+	attr->ah_attr.src_path_bits	    = cmd->dest.src_path_bits;
+	attr->ah_attr.static_rate	    = cmd->dest.static_rate;
+	attr->ah_attr.ah_flags		    = cmd->dest.is_global ?
+					      IB_AH_GRH : 0;
+	attr->ah_attr.port_num		    = cmd->dest.port_num;
+
+	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd->alt_dest.dgid, 16);
+	attr->alt_ah_attr.grh.flow_label    = cmd->alt_dest.flow_label;
+	attr->alt_ah_attr.grh.sgid_index    = cmd->alt_dest.sgid_index;
+	attr->alt_ah_attr.grh.hop_limit     = cmd->alt_dest.hop_limit;
+	attr->alt_ah_attr.grh.traffic_class = cmd->alt_dest.traffic_class;
+	attr->alt_ah_attr.dlid		    = cmd->alt_dest.dlid;
+	attr->alt_ah_attr.sl		    = cmd->alt_dest.sl;
+	attr->alt_ah_attr.src_path_bits     = cmd->alt_dest.src_path_bits;
+	attr->alt_ah_attr.static_rate       = cmd->alt_dest.static_rate;
+	attr->alt_ah_attr.ah_flags	    = cmd->alt_dest.is_global
+					      ? IB_AH_GRH : 0;
+	attr->alt_ah_attr.port_num	    = cmd->alt_dest.port_num;
+}
+
+
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
@@ -1917,51 +1969,11 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 		goto out;
 	}
 
-	attr->qp_state 		  = cmd.qp_state;
-	attr->cur_qp_state 	  = cmd.cur_qp_state;
-	attr->path_mtu 		  = cmd.path_mtu;
-	attr->path_mig_state 	  = cmd.path_mig_state;
-	attr->qkey 		  = cmd.qkey;
-	attr->rq_psn 		  = cmd.rq_psn;
-	attr->sq_psn 		  = cmd.sq_psn;
-	attr->dest_qp_num 	  = cmd.dest_qp_num;
-	attr->qp_access_flags 	  = cmd.qp_access_flags;
-	attr->pkey_index 	  = cmd.pkey_index;
-	attr->alt_pkey_index 	  = cmd.alt_pkey_index;
-	attr->en_sqd_async_notify = cmd.en_sqd_async_notify;
-	attr->max_rd_atomic 	  = cmd.max_rd_atomic;
-	attr->max_dest_rd_atomic  = cmd.max_dest_rd_atomic;
-	attr->min_rnr_timer 	  = cmd.min_rnr_timer;
-	attr->port_num 		  = cmd.port_num;
-	attr->timeout 		  = cmd.timeout;
-	attr->retry_cnt 	  = cmd.retry_cnt;
-	attr->rnr_retry 	  = cmd.rnr_retry;
-	attr->alt_port_num 	  = cmd.alt_port_num;
-	attr->alt_timeout 	  = cmd.alt_timeout;
-
-	memcpy(attr->ah_attr.grh.dgid.raw, cmd.dest.dgid, 16);
-	attr->ah_attr.grh.flow_label        = cmd.dest.flow_label;
-	attr->ah_attr.grh.sgid_index        = cmd.dest.sgid_index;
-	attr->ah_attr.grh.hop_limit         = cmd.dest.hop_limit;
-	attr->ah_attr.grh.traffic_class     = cmd.dest.traffic_class;
-	attr->ah_attr.dlid 	    	    = cmd.dest.dlid;
-	attr->ah_attr.sl   	    	    = cmd.dest.sl;
-	attr->ah_attr.src_path_bits 	    = cmd.dest.src_path_bits;
-	attr->ah_attr.static_rate   	    = cmd.dest.static_rate;
-	attr->ah_attr.ah_flags 	    	    = cmd.dest.is_global ? IB_AH_GRH : 0;
-	attr->ah_attr.port_num 	    	    = cmd.dest.port_num;
-
-	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd.alt_dest.dgid, 16);
-	attr->alt_ah_attr.grh.flow_label    = cmd.alt_dest.flow_label;
-	attr->alt_ah_attr.grh.sgid_index    = cmd.alt_dest.sgid_index;
-	attr->alt_ah_attr.grh.hop_limit     = cmd.alt_dest.hop_limit;
-	attr->alt_ah_attr.grh.traffic_class = cmd.alt_dest.traffic_class;
-	attr->alt_ah_attr.dlid 	    	    = cmd.alt_dest.dlid;
-	attr->alt_ah_attr.sl   	    	    = cmd.alt_dest.sl;
-	attr->alt_ah_attr.src_path_bits     = cmd.alt_dest.src_path_bits;
-	attr->alt_ah_attr.static_rate       = cmd.alt_dest.static_rate;
-	attr->alt_ah_attr.ah_flags 	    = cmd.alt_dest.is_global ? IB_AH_GRH : 0;
-	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
+	ib_uverbs_modify_qp_assign(&cmd, attr);
+	memset(attr->ah_attr.dmac, 0, sizeof(attr->ah_attr.dmac));
+	attr->ah_attr.vlan = 0xFFFF;
+	memset(attr->alt_ah_attr.dmac, 0, sizeof(attr->alt_ah_attr.dmac));
+	attr->alt_ah_attr.vlan = 0xFFFF;
 
 	if (qp->real_qp == qp) {
 		ret = qp->device->modify_qp(qp, attr,
@@ -1983,6 +1995,80 @@ out:
 	return ret;
 }
 
+ssize_t ib_uverbs_modify_qp_ex(struct ib_uverbs_file *file,
+			       const char __user *buf, int in_len,
+			       int out_len)
+{
+	struct ib_uverbs_modify_qp_ex cmd;
+	struct ib_udata               udata;
+	struct ib_qp                 *qp;
+	struct ib_qp_attr	     *attr;
+	int                           ret;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof(cmd), NULL, in_len - sizeof(cmd),
+		   out_len);
+
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	if (!qp) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ib_uverbs_modify_qp_assign((struct ib_uverbs_modify_qp *)((void *)&cmd +
+				    sizeof(cmd.comp_mask)), attr);
+
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_DEST_EX_FLAGS) {
+		if (cmd.dest_ex.comp_mask & IBV_QP_DEST_EX_DMAC)
+			memcpy(attr->ah_attr.dmac, cmd.dest_ex.dmac,
+			       sizeof(attr->ah_attr.dmac));
+		else
+			memset(attr->ah_attr.dmac, 0,
+			       sizeof(attr->ah_attr.dmac));
+		if (cmd.dest_ex.comp_mask & IBV_QP_DEST_EX_VID)
+			attr->ah_attr.vlan = cmd.dest_ex.vid;
+		else
+			attr->ah_attr.vlan = 0xFFFF;
+	}
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX_FLAGS) {
+		if (cmd.alt_dest_ex.comp_mask & IBV_QP_DEST_EX_DMAC)
+			memcpy(attr->alt_ah_attr.dmac, cmd.alt_dest_ex.dmac,
+			       sizeof(attr->alt_ah_attr.dmac));
+		else
+			memset(attr->alt_ah_attr.dmac, 0,
+			       sizeof(attr->alt_ah_attr.dmac));
+		if (cmd.alt_dest_ex.comp_mask & IBV_QP_DEST_EX_VID)
+			attr->alt_ah_attr.vlan = cmd.alt_dest_ex.vid;
+		else
+			attr->alt_ah_attr.vlan = 0xFFFF;
+	}
+
+	if (qp->real_qp == qp) {
+		ret = qp->device->modify_qp(qp, attr,
+			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+	} else {
+		ret = ib_modify_qp(qp, attr,
+				   modify_qp_mask(qp->qp_type, cmd.attr_mask));
+	}
+
+	put_qp_read(qp);
+
+	if (ret)
+		goto out;
+
+	ret = in_len;
+
+out:
+	kfree(attr);
+
+	return ret;
+}
 ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len,
 			     int out_len)
@@ -2377,48 +2463,51 @@ out:
 	return ret ? ret : in_len;
 }
 
-ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+struct ib_uobject *ib_uverbs_create_ah_assign(
+		struct ib_uverbs_create_ah_ex *cmd,
+		struct ib_uverbs_ah_attr_ex *src_attr,
+		struct ib_uverbs_file *file)
 {
-	struct ib_uverbs_create_ah	 cmd;
-	struct ib_uverbs_create_ah_resp	 resp;
-	struct ib_uobject		*uobj;
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
 	struct ib_ah_attr		attr;
-	int ret;
-
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
+	struct ib_uobject		*uobj;
+	long				ret;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
+	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
 	if (!uobj)
-		return -ENOMEM;
+		return (void *)-ENOMEM;
 
-	init_uobj(uobj, cmd.user_handle, file->ucontext, &ah_lock_class);
+	init_uobj(uobj, cmd->user_handle, file->ucontext, &ah_lock_class);
 	down_write(&uobj->mutex);
 
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	pd = idr_read_pd(cmd->pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	attr.dlid 	       = cmd.attr.dlid;
-	attr.sl 	       = cmd.attr.sl;
-	attr.src_path_bits     = cmd.attr.src_path_bits;
-	attr.static_rate       = cmd.attr.static_rate;
-	attr.ah_flags          = cmd.attr.is_global ? IB_AH_GRH : 0;
-	attr.port_num 	       = cmd.attr.port_num;
-	attr.grh.flow_label    = cmd.attr.grh.flow_label;
-	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
-	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
-	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
-	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
+	attr.dlid	       = src_attr->dlid;
+	attr.sl		       = src_attr->sl;
+	attr.src_path_bits     = src_attr->src_path_bits;
+	attr.static_rate       = src_attr->static_rate;
+	attr.ah_flags          = src_attr->is_global ? IB_AH_GRH : 0;
+	attr.port_num	       = src_attr->port_num;
+	attr.grh.flow_label    = src_attr->grh.flow_label;
+	attr.grh.sgid_index    = src_attr->grh.sgid_index;
+	attr.grh.hop_limit     = src_attr->grh.hop_limit;
+	attr.grh.traffic_class = src_attr->grh.traffic_class;
+	memcpy(attr.grh.dgid.raw, src_attr->grh.dgid, 16);
+
+	if (src_attr->comp_mask & IB_UVERBS_AH_ATTR_DMAC)
+		memcpy(attr.dmac, src_attr->dmac, sizeof(attr.dmac));
+	else
+		memset(attr.dmac, 0, sizeof(attr.dmac));
+
+	if (src_attr->comp_mask & IB_UVERBS_AH_ATTR_VID)
+		attr.vlan = src_attr->vlan;
+	else
+		attr.vlan = 0xFFFF;
 
 	ah = ib_create_ah(pd, &attr);
 	if (IS_ERR(ah)) {
@@ -2427,22 +2516,62 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	}
 
 	ah->uobject  = uobj;
+
 	uobj->object = ah;
 
 	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
 	if (ret)
 		goto err_destroy;
 
+	put_pd_read(pd);
+
+	return uobj;
+
+err_destroy:
+	ib_destroy_ah(ah);
+err_put:
+	put_pd_read(pd);
+err:
+	put_uobj_write(uobj);
+	return (void *)ret;
+}
+
+ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_create_ah_ex	 cmd_ex;
+	struct ib_uverbs_create_ah	*cmd = (struct ib_uverbs_create_ah *)
+					       ((void *)&cmd_ex +
+						sizeof(cmd_ex.comp_mask));
+	struct ib_uverbs_ah_attr_ex	 attr_ex;
+	struct ib_uverbs_create_ah_resp	 resp;
+	struct ib_uobject		*uobj;
+	int ret;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	cmd_ex.comp_mask = 0;
+	if (copy_from_user(cmd, buf, sizeof(*cmd)))
+		return -EFAULT;
+
+	attr_ex.comp_mask = 0;
+	memcpy(((void *)&attr_ex) + sizeof(attr_ex.comp_mask),
+	       &cmd->attr, sizeof(cmd->attr));
+
+	uobj = ib_uverbs_create_ah_assign(&cmd_ex,  &attr_ex, file);
+	if (IS_ERR(uobj))
+		return (ssize_t)uobj;
+
 	resp.ah_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+	if (copy_to_user((void __user *)(unsigned long) cmd->response,
 			 &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-
 	mutex_lock(&file->mutex);
 	list_add_tail(&uobj->list, &file->ucontext->ah_list);
 	mutex_unlock(&file->mutex);
@@ -2455,15 +2584,54 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 err_copy:
 	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	ib_destroy_ah(uobj->object);
+	put_uobj_write(uobj);
 
-err_destroy:
-	ib_destroy_ah(ah);
+	return ret;
+}
 
-err_put:
-	put_pd_read(pd);
+ssize_t ib_uverbs_create_ah_ex(struct ib_uverbs_file *file,
+			       const char __user *buf, int in_len,
+			       int out_len)
+{
+	struct ib_uverbs_create_ah_ex	 cmd_ex;
+	struct ib_uverbs_create_ah_resp	 resp;
+	struct ib_uobject		*uobj;
+	int ret;
 
-err:
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd_ex, buf, sizeof(cmd_ex)))
+		return -EFAULT;
+
+	uobj = ib_uverbs_create_ah_assign(&cmd_ex,  &cmd_ex.attr, file);
+	if (IS_ERR(uobj))
+		return (ssize_t)uobj;
+
+	resp.ah_handle = uobj->id;
+
+	if (copy_to_user((void __user *)(unsigned long)cmd_ex.response,
+			 &resp, sizeof(resp))) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&uobj->list, &file->ucontext->ah_list);
+	mutex_unlock(&file->mutex);
+
+	uobj->live = 1;
+
+	up_write(&uobj->mutex);
+
+	return in_len;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_ah_idr, uobj);
+	ib_destroy_ah(uobj->object);
 	put_uobj_write(uobj);
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e4e7b24..93264c8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -113,7 +113,9 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
-	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp
+	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
+	[IB_USER_VERBS_CMD_MODIFY_QP_EX]	= ib_uverbs_modify_qp_ex,
+	[IB_USER_VERBS_CMD_CREATE_AH_EX]	= ib_uverbs_create_ah_ex,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index e7bee46..0470407 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -33,6 +33,9 @@
 #include <linux/export.h>
 #include <rdma/ib_marshall.h>
 
+#define UVERB_EX_TO_UVERB(uverb_ex) ((void *)(uverb_ex) + \
+				     sizeof(uverb_ex->comp_mask))
+
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 			     struct ib_ah_attr *src)
 {
@@ -52,9 +55,20 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
-void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
-			     struct ib_qp_attr *src)
+void ib_copy_ah_attr_to_user_ex(struct ib_uverbs_ah_attr_ex *dst,
+				struct ib_ah_attr *src)
 {
+	ib_copy_ah_attr_to_user((struct ib_uverbs_ah_attr *)
+				UVERB_EX_TO_UVERB(dst), src);
+	dst->comp_mask = IB_UVERBS_AH_ATTR_DMAC;
+	memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
+	dst->comp_mask = IB_UVERBS_AH_ATTR_VID;
+	dst->vlan		   = src->vlan;
+}
+EXPORT_SYMBOL(ib_copy_ah_attr_to_user_ex);
+
+static void ib_copy_qp_attr_to_user_data(struct ib_uverbs_qp_attr *dst,
+					 struct ib_qp_attr *src) {
 	dst->qp_state	        = src->qp_state;
 	dst->cur_qp_state	= src->cur_qp_state;
 	dst->path_mtu		= src->path_mtu;
@@ -71,9 +85,6 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->max_recv_sge	= src->cap.max_recv_sge;
 	dst->max_inline_data	= src->cap.max_inline_data;
 
-	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
-	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
-
 	dst->pkey_index		= src->pkey_index;
 	dst->alt_pkey_index	= src->alt_pkey_index;
 	dst->en_sqd_async_notify = src->en_sqd_async_notify;
@@ -89,8 +100,26 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->alt_timeout	= src->alt_timeout;
 	memset(dst->reserved, 0, sizeof(dst->reserved));
 }
+
+void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
+			     struct ib_qp_attr *src)
+{
+	ib_copy_qp_attr_to_user_data(dst, src);
+	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
+	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
+}
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
+void ib_copy_qp_attr_to_user_ex(struct ib_uverbs_qp_attr_ex *dst,
+				struct ib_qp_attr *src)
+{
+	ib_copy_qp_attr_to_user_data((struct ib_uverbs_qp_attr *)
+				     UVERB_EX_TO_UVERB(dst), src);
+	ib_copy_ah_attr_to_user_ex(&dst->ah_attr, &src->ah_attr);
+	ib_copy_ah_attr_to_user_ex(&dst->alt_ah_attr, &src->alt_ah_attr);
+}
+EXPORT_SYMBOL(ib_copy_qp_attr_to_user_ex);
+
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 			      struct ib_sa_path_rec *src)
 {
@@ -117,11 +146,27 @@ void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 }
 EXPORT_SYMBOL(ib_copy_path_rec_to_user);
 
-void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
-				struct ib_user_path_rec *src)
+void ib_copy_path_rec_to_user_ex(struct ib_user_path_rec_ex *dst,
+				 struct ib_sa_path_rec *src)
+{
+	ib_copy_path_rec_to_user((struct ib_user_path_rec *)
+				  UVERB_EX_TO_UVERB(dst), src);
+
+	dst->comp_mask = IB_USER_PATH_REC_ATTR_DMAC |
+			 IB_USER_PATH_REC_ATTR_SMAC |
+			 IB_USER_PATH_REC_ATTR_VID;
+
+	memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
+	memcpy(dst->smac, src->smac, sizeof(dst->smac));
+	dst->vlan = src->vlan;
+}
+EXPORT_SYMBOL(ib_copy_path_rec_to_user_ex);
+
+void ib_copy_path_rec_from_user_assign(struct ib_sa_path_rec *dst,
+				       struct ib_user_path_rec *src)
 {
-	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
-	memcpy(dst->sgid.raw, src->sgid, sizeof dst->sgid);
+	memcpy(dst->dgid.raw, src->dgid, sizeof(dst->dgid));
+	memcpy(dst->sgid.raw, src->sgid, sizeof(dst->sgid));
 
 	dst->dlid		= src->dlid;
 	dst->slid		= src->slid;
@@ -141,4 +186,35 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 }
+
+void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
+				struct ib_user_path_rec *src) {
+	memset(dst->dmac, 0, sizeof(dst->dmac));
+	memset(dst->smac, 0, sizeof(dst->smac));
+	dst->vlan = 0xFFFF;
+
+	ib_copy_path_rec_from_user_assign(dst, src);
+}
 EXPORT_SYMBOL(ib_copy_path_rec_from_user);
+
+void ib_copy_path_rec_from_user_ex(struct ib_sa_path_rec *dst,
+				   struct ib_user_path_rec_ex *src) {
+	if (src->comp_mask & IB_USER_PATH_REC_ATTR_DMAC)
+		memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
+	else
+		memset(dst->dmac, 0, sizeof(dst->dmac));
+
+	if (src->comp_mask & IB_USER_PATH_REC_ATTR_SMAC)
+		memcpy(dst->smac, src->smac, sizeof(dst->smac));
+	else
+		memset(dst->smac, 0, sizeof(dst->smac));
+
+	if (src->comp_mask & IB_USER_PATH_REC_ATTR_VID)
+		dst->vlan = src->vlan;
+	else
+		dst->vlan = 0xFFFF;
+
+	ib_copy_path_rec_from_user_assign(dst, (struct ib_user_path_rec *)
+					  UVERB_EX_TO_UVERB(src));
+}
+EXPORT_SYMBOL(ib_copy_path_rec_from_user_ex);
diff --git a/include/rdma/ib_marshall.h b/include/rdma/ib_marshall.h
index db03720..11ab3a8 100644
--- a/include/rdma/ib_marshall.h
+++ b/include/rdma/ib_marshall.h
@@ -41,13 +41,25 @@
 void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src);
 
+void ib_copy_qp_attr_to_user_ex(struct ib_uverbs_qp_attr_ex *dst,
+				struct ib_qp_attr *src);
+
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 			     struct ib_ah_attr *src);
 
+void ib_copy_ah_attr_to_user_ex(struct ib_uverbs_ah_attr_ex *dst,
+				struct ib_ah_attr *src);
+
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 			      struct ib_sa_path_rec *src);
 
+void ib_copy_path_rec_to_user_ex(struct ib_user_path_rec_ex *dst,
+				 struct ib_sa_path_rec *src);
+
 void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 				struct ib_user_path_rec *src);
 
+void ib_copy_path_rec_from_user_ex(struct ib_sa_path_rec *dst,
+				   struct ib_user_path_rec_ex *src);
+
 #endif /* IB_USER_MARSHALL_H */
diff --git a/include/uapi/rdma/ib_user_sa.h b/include/uapi/rdma/ib_user_sa.h
index cfc7c9b..367d66a 100644
--- a/include/uapi/rdma/ib_user_sa.h
+++ b/include/uapi/rdma/ib_user_sa.h
@@ -48,7 +48,13 @@ enum {
 struct ib_path_rec_data {
 	__u32	flags;
 	__u32	reserved;
-	__u32	path_rec[16];
+	__u32	path_rec[20];
+};
+
+enum ibv_kern_path_rec_attr_mask {
+	IB_USER_PATH_REC_ATTR_DMAC = 1ULL << 0,
+	IB_USER_PATH_REC_ATTR_SMAC = 1ULL << 1,
+	IB_USER_PATH_REC_ATTR_VID  = 1ULL << 2
 };
 
 struct ib_user_path_rec {
@@ -73,4 +79,30 @@ struct ib_user_path_rec {
 	__u8	preference;
 };
 
+struct ib_user_path_rec_ex {
+	__u32   comp_mask;
+	__u8	dgid[16];
+	__u8	sgid[16];
+	__be16	dlid;
+	__be16	slid;
+	__u32	raw_traffic;
+	__be32	flow_label;
+	__u32	reversible;
+	__u32	mtu;
+	__be16	pkey;
+	__u8	hop_limit;
+	__u8	traffic_class;
+	__u8	numb_path;
+	__u8	sl;
+	__u8	mtu_selector;
+	__u8	rate_selector;
+	__u8	rate;
+	__u8	packet_life_time_selector;
+	__u8	packet_life_time;
+	__u8	preference;
+	__u8	smac[6];
+	__u8	dmac[6];
+	__be16  vlan;
+};
+
 #endif /* IB_USER_SA_H */
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 61535aa..954a790 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -86,7 +86,9 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_XRCD,
 	IB_USER_VERBS_CMD_CLOSE_XRCD,
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
-	IB_USER_VERBS_CMD_OPEN_QP
+	IB_USER_VERBS_CMD_OPEN_QP,
+	IB_USER_VERBS_CMD_MODIFY_QP_EX = IB_USER_VERBS_CMD_THRESHOLD,
+	IB_USER_VERBS_CMD_CREATE_AH_EX,
 };
 
 /*
@@ -392,6 +394,25 @@ struct ib_uverbs_ah_attr {
 	__u8  reserved;
 };
 
+enum ib_uverbs_ah_attr_mask {
+	IB_UVERBS_AH_ATTR_DMAC,
+	IB_UVERBS_AH_ATTR_VID
+};
+
+struct ib_uverbs_ah_attr_ex {
+	__u32 comp_mask;
+	struct ib_uverbs_global_route grh;
+	__u16 dlid;
+	__u8  sl;
+	__u8  src_path_bits;
+	__u8  static_rate;
+	__u8  is_global;
+	__u8  port_num;
+	__u8  reserved;
+	__u8  dmac[6];
+	__u16 vlan;
+};
+
 struct ib_uverbs_qp_attr {
 	__u32	qp_attr_mask;
 	__u32	qp_state;
@@ -430,6 +451,45 @@ struct ib_uverbs_qp_attr {
 	__u8	reserved[5];
 };
 
+struct ib_uverbs_qp_attr_ex {
+	__u32   comp_mask;
+	__u32	qp_attr_mask;
+	__u32	qp_state;
+	__u32	cur_qp_state;
+	__u32	path_mtu;
+	__u32	path_mig_state;
+	__u32	qkey;
+	__u32	rq_psn;
+	__u32	sq_psn;
+	__u32	dest_qp_num;
+	__u32	qp_access_flags;
+
+	struct ib_uverbs_ah_attr_ex ah_attr;
+	struct ib_uverbs_ah_attr_ex alt_ah_attr;
+
+	/* ib_qp_cap */
+	__u32	max_send_wr;
+	__u32	max_recv_wr;
+	__u32	max_send_sge;
+	__u32	max_recv_sge;
+	__u32	max_inline_data;
+
+	__u16	pkey_index;
+	__u16	alt_pkey_index;
+	__u8	en_sqd_async_notify;
+	__u8	sq_draining;
+	__u8	max_rd_atomic;
+	__u8	max_dest_rd_atomic;
+	__u8	min_rnr_timer;
+	__u8	port_num;
+	__u8	timeout;
+	__u8	retry_cnt;
+	__u8	rnr_retry;
+	__u8	alt_port_num;
+	__u8	alt_timeout;
+	__u8	reserved[5];
+};
+
 struct ib_uverbs_create_qp {
 	__u64 response;
 	__u64 user_handle;
@@ -531,6 +591,17 @@ struct ib_uverbs_query_qp_resp {
 	__u64 driver_data[0];
 };
 
+enum ib_uverbs_qp_dest_ex_comp_mask {
+	IBV_QP_DEST_EX_DMAC          = (1ULL << 0),
+	IBV_QP_DEST_EX_VID           = (1ULL << 1)
+};
+
+struct ib_uverbs_qp_dest_ex {
+	__u32 comp_mask;
+	__u8  dmac[6];
+	__u16 vid;
+};
+
 struct ib_uverbs_modify_qp {
 	struct ib_uverbs_qp_dest dest;
 	struct ib_uverbs_qp_dest alt_dest;
@@ -561,6 +632,44 @@ struct ib_uverbs_modify_qp {
 	__u64 driver_data[0];
 };
 
+enum ib_uverbs_modify_qp_ex_comp_mask {
+	IB_UVERBS_MODIFY_QP_EX_DEST_EX_FLAGS          = (1ULL << 0),
+	IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX_FLAGS      = (1ULL << 1)
+};
+
+struct ib_uverbs_modify_qp_ex {
+	__u32 comp_mask;
+	struct ib_uverbs_qp_dest dest;
+	struct ib_uverbs_qp_dest alt_dest;
+	__u32 qp_handle;
+	__u32 attr_mask;
+	__u32 qkey;
+	__u32 rq_psn;
+	__u32 sq_psn;
+	__u32 dest_qp_num;
+	__u32 qp_access_flags;
+	__u16 pkey_index;
+	__u16 alt_pkey_index;
+	__u8  qp_state;
+	__u8  cur_qp_state;
+	__u8  path_mtu;
+	__u8  path_mig_state;
+	__u8  en_sqd_async_notify;
+	__u8  max_rd_atomic;
+	__u8  max_dest_rd_atomic;
+	__u8  min_rnr_timer;
+	__u8  port_num;
+	__u8  timeout;
+	__u8  retry_cnt;
+	__u8  rnr_retry;
+	__u8  alt_port_num;
+	__u8  alt_timeout;
+	__u8  reserved[2];
+	struct ib_uverbs_qp_dest_ex dest_ex;
+	struct ib_uverbs_qp_dest_ex alt_dest_ex;
+	__u64 driver_data[0];
+};
+
 struct ib_uverbs_modify_qp_resp {
 };
 
@@ -670,6 +779,15 @@ struct ib_uverbs_create_ah {
 	struct ib_uverbs_ah_attr attr;
 };
 
+struct ib_uverbs_create_ah_ex {
+	int comp_mask;
+	__u64 response;
+	__u64 user_handle;
+	__u32 pd_handle;
+	__u32 reserved;
+	struct ib_uverbs_ah_attr_ex attr;
+};
+
 struct ib_uverbs_create_ah_resp {
 	__u32 ah_handle;
 };
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 1ee9239..8dceb35 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -61,7 +61,9 @@ enum {
 	RDMA_USER_CM_CMD_NOTIFY,
 	RDMA_USER_CM_CMD_JOIN_MCAST,
 	RDMA_USER_CM_CMD_LEAVE_MCAST,
-	RDMA_USER_CM_CMD_MIGRATE_ID
+	RDMA_USER_CM_CMD_MIGRATE_ID,
+	RDMA_USER_CM_CMD_QUERY_ROUTE_EX,
+	RDMA_USER_CM_CMD_INIT_QP_ATTR_EX
 };
 
 /*
@@ -119,6 +121,13 @@ struct rdma_ucm_query_route {
 	__u32 reserved;
 };
 
+struct rdma_ucm_query_route_ex {
+	__u32 comp_mask;
+	__u64 response;
+	__u32 id;
+	__u32 reserved;
+};
+
 struct rdma_ucm_query_route_resp {
 	__u64 node_guid;
 	struct ib_user_path_rec ib_route[2];
@@ -129,6 +138,16 @@ struct rdma_ucm_query_route_resp {
 	__u8 reserved[3];
 };
 
+struct rdma_ucm_query_route_resp_ex {
+	__u64 node_guid;
+	struct ib_user_path_rec_ex ib_route[2];
+	struct sockaddr_in6 src_addr;
+	struct sockaddr_in6 dst_addr;
+	__u32 num_paths;
+	__u8 port_num;
+	__u8 reserved[3];
+};
+
 struct rdma_ucm_conn_param {
 	__u32 qp_num;
 	__u32 reserved;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
