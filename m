From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 8/9] IB/core: Add RoCE IP based addressing extensions for rdma_ucm
Date: Wed,  7 Aug 2013 18:35:01 +0300
Message-ID: <1375889702-14818-9-git-send-email-ogerlitz@mellanox.com>
References: <1375889702-14818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375889702-14818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add rdma_ucm support for RoCE (IBoE) IP based addressing extensions
towards librdmacm

Extend INIT_QP_ATTR and QUERY_ROUTE ucma commands.

INIT_QP_ATTR_EX uses struct ib_uverbs_qp_attr_ex

QUERY_ROUTE_EX uses struct rdma_ucm_query_route_resp_ex which in turn
uses ib_user_path_rec_ex

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c   |  175 ++++++++++++++++++++++++++++++++++++-
 include/uapi/rdma/rdma_user_cm.h |   29 ++++++-
 2 files changed, 198 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 7e7da86..4d59e88 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -652,6 +652,35 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
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
@@ -678,14 +707,39 @@ static void ucma_copy_iboe_route(struct rdma_ucm_query_route_resp *resp,
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
@@ -737,7 +791,74 @@ static ssize_t ucma_query_route(struct ucma_file *file,
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
@@ -1071,6 +1192,48 @@ out:
 	return ret;
 }
 
+static ssize_t ucma_init_qp_attr_ex(struct ucma_file *file,
+				    const char __user *inbuf,
+				    int in_len, int out_len)
+{
+	struct rdma_ucm_init_qp_attr_ex cmd;
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
+	if (copy_from_user(&resp, (void __user *)(unsigned long)cmd.response,
+			   sizeof(resp)))
+		return -EFAULT;
+
+	ctx = ucma_get_ctx(file, cmd.id);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	resp.comp_mask = cmd.comp_mask;
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
@@ -1474,7 +1637,9 @@ static ssize_t (*ucma_cmd_table[])(struct ucma_file *file,
 	[RDMA_USER_CM_CMD_QUERY]	 = ucma_query,
 	[RDMA_USER_CM_CMD_BIND]		 = ucma_bind,
 	[RDMA_USER_CM_CMD_RESOLVE_ADDR]	 = ucma_resolve_addr,
-	[RDMA_USER_CM_CMD_JOIN_MCAST]	 = ucma_join_multicast
+	[RDMA_USER_CM_CMD_JOIN_MCAST]	 = ucma_join_multicast,
+	[RDMA_USER_CM_CMD_QUERY_ROUTE_EX] = ucma_query_route_ex,
+	[RDMA_USER_CM_CMD_INIT_QP_ATTR_EX] = ucma_init_qp_attr_ex
 };
 
 static ssize_t ucma_write(struct file *filp, const char __user *buf,
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 99b80ab..ceb7f1f 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -65,7 +65,9 @@ enum {
 	RDMA_USER_CM_CMD_QUERY,
 	RDMA_USER_CM_CMD_BIND,
 	RDMA_USER_CM_CMD_RESOLVE_ADDR,
-	RDMA_USER_CM_CMD_JOIN_MCAST
+	RDMA_USER_CM_CMD_JOIN_MCAST,
+	RDMA_USER_CM_CMD_QUERY_ROUTE_EX,
+	RDMA_USER_CM_CMD_INIT_QP_ATTR_EX
 };
 
 /*
@@ -146,6 +148,13 @@ struct rdma_ucm_query {
 	__u32 option;
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
@@ -173,6 +182,16 @@ struct rdma_ucm_query_path_resp {
 	struct ib_path_rec_data path_data[0];
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
 	__u32 qkey;
@@ -231,6 +250,14 @@ struct rdma_ucm_init_qp_attr {
 	__u32 qp_state;
 };
 
+struct rdma_ucm_init_qp_attr_ex {
+	__u32 comp_mask;
+	__u32 reserved;
+	__u64 response;
+	__u32 id;
+	__u32 qp_state;
+};
+
 struct rdma_ucm_notify {
 	__u32 id;
 	__u32 event;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
