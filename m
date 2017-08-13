From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 02/22] IB/uverbs: Introduce and use helper functions to copy ah attributes
Date: Sun, 13 Aug 2017 13:17:56 +0300
Message-ID: <20170813101816.3120-3-leon@kernel.org>
References: <20170813101816.3120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101816.3120-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch introduces two helper functions to copy ah attributes
from uverbs to internal ib_ah_attr structure and the other way
during modify qp and query qp respectively.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++---------------------
 1 file changed, 49 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 670176b670a0..515425a50059 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1810,6 +1810,28 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	return ret;
 }
 
+static void copy_ah_attr_to_uverbs(struct ib_uverbs_qp_dest *uverb_attr,
+				   struct rdma_ah_attr *rdma_attr)
+{
+	const struct ib_global_route   *grh;
+
+	uverb_attr->dlid              = rdma_ah_get_dlid(rdma_attr);
+	uverb_attr->sl                = rdma_ah_get_sl(rdma_attr);
+	uverb_attr->src_path_bits     = rdma_ah_get_path_bits(rdma_attr);
+	uverb_attr->static_rate       = rdma_ah_get_static_rate(rdma_attr);
+	uverb_attr->is_global         = !!(rdma_ah_get_ah_flags(rdma_attr) &
+					 IB_AH_GRH);
+	if (uverb_attr->is_global) {
+		grh = rdma_ah_read_grh(rdma_attr);
+		memcpy(uverb_attr->dgid, grh->dgid.raw, 16);
+		uverb_attr->flow_label        = grh->flow_label;
+		uverb_attr->sgid_index        = grh->sgid_index;
+		uverb_attr->hop_limit         = grh->hop_limit;
+		uverb_attr->traffic_class     = grh->traffic_class;
+	}
+	uverb_attr->port_num          = rdma_ah_get_port_num(rdma_attr);
+}
+
 ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 			   struct ib_device *ib_dev,
 			   const char __user *buf, int in_len,
@@ -1820,7 +1842,6 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	struct ib_qp                   *qp;
 	struct ib_qp_attr              *attr;
 	struct ib_qp_init_attr         *init_attr;
-	const struct ib_global_route   *grh;
 	int                            ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
@@ -1870,39 +1891,8 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.alt_port_num           = attr->alt_port_num;
 	resp.alt_timeout            = attr->alt_timeout;
 
-	resp.dest.dlid              = rdma_ah_get_dlid(&attr->ah_attr);
-	resp.dest.sl                = rdma_ah_get_sl(&attr->ah_attr);
-	resp.dest.src_path_bits     = rdma_ah_get_path_bits(&attr->ah_attr);
-	resp.dest.static_rate       = rdma_ah_get_static_rate(&attr->ah_attr);
-	resp.dest.is_global         = !!(rdma_ah_get_ah_flags(&attr->ah_attr) &
-					 IB_AH_GRH);
-	if (resp.dest.is_global) {
-		grh = rdma_ah_read_grh(&attr->ah_attr);
-		memcpy(resp.dest.dgid, grh->dgid.raw, 16);
-		resp.dest.flow_label        = grh->flow_label;
-		resp.dest.sgid_index        = grh->sgid_index;
-		resp.dest.hop_limit         = grh->hop_limit;
-		resp.dest.traffic_class     = grh->traffic_class;
-	}
-	resp.dest.port_num          = rdma_ah_get_port_num(&attr->ah_attr);
-
-	resp.alt_dest.dlid          = rdma_ah_get_dlid(&attr->alt_ah_attr);
-	resp.alt_dest.sl            = rdma_ah_get_sl(&attr->alt_ah_attr);
-	resp.alt_dest.src_path_bits = rdma_ah_get_path_bits(&attr->alt_ah_attr);
-	resp.alt_dest.static_rate
-			= rdma_ah_get_static_rate(&attr->alt_ah_attr);
-	resp.alt_dest.is_global
-			= !!(rdma_ah_get_ah_flags(&attr->alt_ah_attr) &
-						  IB_AH_GRH);
-	if (resp.alt_dest.is_global) {
-		grh = rdma_ah_read_grh(&attr->alt_ah_attr);
-		memcpy(resp.alt_dest.dgid, grh->dgid.raw, 16);
-		resp.alt_dest.flow_label    = grh->flow_label;
-		resp.alt_dest.sgid_index    = grh->sgid_index;
-		resp.alt_dest.hop_limit     = grh->hop_limit;
-		resp.alt_dest.traffic_class = grh->traffic_class;
-	}
-	resp.alt_dest.port_num      = rdma_ah_get_port_num(&attr->alt_ah_attr);
+	copy_ah_attr_to_uverbs(&resp.dest, &attr->ah_attr);
+	copy_ah_attr_to_uverbs(&resp.alt_dest, &attr->alt_ah_attr);
 
 	resp.max_send_wr            = init_attr->cap.max_send_wr;
 	resp.max_recv_wr            = init_attr->cap.max_recv_wr;
@@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
+static void copy_ah_attr_from_uverbs(struct ib_device *dev,
+				     struct rdma_ah_attr *rdma_attr,
+				     struct ib_uverbs_qp_dest *uverb_attr)
+{
+	rdma_attr->type = rdma_ah_find_type(dev, uverb_attr->port_num);
+	if (uverb_attr->is_global) {
+		rdma_ah_set_grh(rdma_attr, NULL,
+				uverb_attr->flow_label,
+				uverb_attr->sgid_index,
+				uverb_attr->hop_limit,
+				uverb_attr->traffic_class);
+		rdma_ah_set_dgid_raw(rdma_attr, uverb_attr->dgid);
+	} else {
+		rdma_ah_set_ah_flags(rdma_attr, 0);
+	}
+	rdma_ah_set_dlid(rdma_attr, uverb_attr->dlid);
+	rdma_ah_set_sl(rdma_attr, uverb_attr->sl);
+	rdma_ah_set_path_bits(rdma_attr, uverb_attr->src_path_bits);
+	rdma_ah_set_static_rate(rdma_attr, uverb_attr->static_rate);
+	rdma_ah_set_port_num(rdma_attr, uverb_attr->port_num);
+}
+
 static int modify_qp(struct ib_uverbs_file *file,
 		     struct ib_uverbs_ex_modify_qp *cmd, struct ib_udata *udata)
 {
@@ -1982,47 +1994,9 @@ static int modify_qp(struct ib_uverbs_file *file,
 	attr->alt_timeout	  = cmd->base.alt_timeout;
 	attr->rate_limit	  = cmd->rate_limit;
 
-	attr->ah_attr.type = rdma_ah_find_type(qp->device,
-					       cmd->base.dest.port_num);
-	if (cmd->base.dest.is_global) {
-		rdma_ah_set_grh(&attr->ah_attr, NULL,
-				cmd->base.dest.flow_label,
-				cmd->base.dest.sgid_index,
-				cmd->base.dest.hop_limit,
-				cmd->base.dest.traffic_class);
-		rdma_ah_set_dgid_raw(&attr->ah_attr, cmd->base.dest.dgid);
-	} else {
-		rdma_ah_set_ah_flags(&attr->ah_attr, 0);
-	}
-	rdma_ah_set_dlid(&attr->ah_attr, cmd->base.dest.dlid);
-	rdma_ah_set_sl(&attr->ah_attr, cmd->base.dest.sl);
-	rdma_ah_set_path_bits(&attr->ah_attr, cmd->base.dest.src_path_bits);
-	rdma_ah_set_static_rate(&attr->ah_attr, cmd->base.dest.static_rate);
-	rdma_ah_set_port_num(&attr->ah_attr,
-			     cmd->base.dest.port_num);
-
-	attr->alt_ah_attr.type = rdma_ah_find_type(qp->device,
-						   cmd->base.dest.port_num);
-	if (cmd->base.alt_dest.is_global) {
-		rdma_ah_set_grh(&attr->alt_ah_attr, NULL,
-				cmd->base.alt_dest.flow_label,
-				cmd->base.alt_dest.sgid_index,
-				cmd->base.alt_dest.hop_limit,
-				cmd->base.alt_dest.traffic_class);
-		rdma_ah_set_dgid_raw(&attr->alt_ah_attr,
-				     cmd->base.alt_dest.dgid);
-	} else {
-		rdma_ah_set_ah_flags(&attr->alt_ah_attr, 0);
-	}
-
-	rdma_ah_set_dlid(&attr->alt_ah_attr, cmd->base.alt_dest.dlid);
-	rdma_ah_set_sl(&attr->alt_ah_attr, cmd->base.alt_dest.sl);
-	rdma_ah_set_path_bits(&attr->alt_ah_attr,
-			      cmd->base.alt_dest.src_path_bits);
-	rdma_ah_set_static_rate(&attr->alt_ah_attr,
-				cmd->base.alt_dest.static_rate);
-	rdma_ah_set_port_num(&attr->alt_ah_attr,
-			     cmd->base.alt_dest.port_num);
+	copy_ah_attr_from_uverbs(qp->device, &attr->ah_attr, &cmd->base.dest);
+	copy_ah_attr_from_uverbs(qp->device, &attr->alt_ah_attr,
+				 &cmd->base.alt_dest);
 
 	ret = ib_modify_qp_with_udata(qp, attr,
 				      modify_qp_mask(qp->qp_type,
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
