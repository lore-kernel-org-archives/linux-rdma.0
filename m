From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] IB/uverbs: Extend modify_qp and support packet pacing
Date: Mon, 31 Oct 2016 12:21:36 +0200
Message-ID: <1477909297-14491-4-git-send-email-leon@kernel.org>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477909297-14491-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

- Modify_qp is extended to support more attributes. Existing
  applications are not affected when calling modify_qp. New
  applications could call modify_qp_ex to use the extended fields.
- New member rate_limit is added to the modify_qp extended structure,
  users can modify it through modify_qp to control packet packing.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 178 +++++++++++++++++++++-------------
 drivers/infiniband/core/uverbs_main.c |   1 +
 include/uapi/rdma/ib_user_verbs.h     |  12 +++
 4 files changed, 123 insertions(+), 69 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index df26a74..455034a 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -289,5 +289,6 @@ IB_UVERBS_DECLARE_EX_CMD(modify_wq);
 IB_UVERBS_DECLARE_EX_CMD(destroy_wq);
 IB_UVERBS_DECLARE_EX_CMD(create_rwq_ind_table);
 IB_UVERBS_DECLARE_EX_CMD(destroy_rwq_ind_table);
+IB_UVERBS_DECLARE_EX_CMD(modify_qp);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..14ceba3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2328,94 +2328,86 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
-ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
-			    struct ib_device *ib_dev,
-			    const char __user *buf, int in_len,
-			    int out_len)
+static int modify_qp(struct ib_uverbs_file *file,
+		     struct ib_uverbs_ex_modify_qp *cmd, struct ib_udata *udata)
 {
-	struct ib_uverbs_modify_qp cmd;
-	struct ib_udata            udata;
-	struct ib_qp              *qp;
-	struct ib_qp_attr         *attr;
-	int                        ret;
-
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
-
-	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
-		   out_len);
+	struct ib_qp_attr *attr;
+	struct ib_qp *qp;
+	int ret;
 
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd->base.qp_handle, file->ucontext);
 	if (!qp) {
 		ret = -EINVAL;
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
+	attr->qp_state		  = cmd->base.qp_state;
+	attr->cur_qp_state	  = cmd->base.cur_qp_state;
+	attr->path_mtu		  = cmd->base.path_mtu;
+	attr->path_mig_state	  = cmd->base.path_mig_state;
+	attr->qkey		  = cmd->base.qkey;
+	attr->rq_psn		  = cmd->base.rq_psn;
+	attr->sq_psn		  = cmd->base.sq_psn;
+	attr->dest_qp_num	  = cmd->base.dest_qp_num;
+	attr->qp_access_flags	  = cmd->base.qp_access_flags;
+	attr->pkey_index	  = cmd->base.pkey_index;
+	attr->alt_pkey_index	  = cmd->base.alt_pkey_index;
+	attr->en_sqd_async_notify = cmd->base.en_sqd_async_notify;
+	attr->max_rd_atomic	  = cmd->base.max_rd_atomic;
+	attr->max_dest_rd_atomic  = cmd->base.max_dest_rd_atomic;
+	attr->min_rnr_timer	  = cmd->base.min_rnr_timer;
+	attr->port_num		  = cmd->base.port_num;
+	attr->timeout		  = cmd->base.timeout;
+	attr->retry_cnt		  = cmd->base.retry_cnt;
+	attr->rnr_retry		  = cmd->base.rnr_retry;
+	attr->alt_port_num	  = cmd->base.alt_port_num;
+	attr->alt_timeout	  = cmd->base.alt_timeout;
+	attr->rate_limit	  = cmd->rate_limit;
+
+	memcpy(attr->ah_attr.grh.dgid.raw, cmd->base.dest.dgid, 16);
+	attr->ah_attr.grh.flow_label	= cmd->base.dest.flow_label;
+	attr->ah_attr.grh.sgid_index	= cmd->base.dest.sgid_index;
+	attr->ah_attr.grh.hop_limit	= cmd->base.dest.hop_limit;
+	attr->ah_attr.grh.traffic_class	= cmd->base.dest.traffic_class;
+	attr->ah_attr.dlid		= cmd->base.dest.dlid;
+	attr->ah_attr.sl		= cmd->base.dest.sl;
+	attr->ah_attr.src_path_bits	= cmd->base.dest.src_path_bits;
+	attr->ah_attr.static_rate	= cmd->base.dest.static_rate;
+	attr->ah_attr.ah_flags		= cmd->base.dest.is_global ?
+					  IB_AH_GRH : 0;
+	attr->ah_attr.port_num		= cmd->base.dest.port_num;
+
+	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd->base.alt_dest.dgid, 16);
+	attr->alt_ah_attr.grh.flow_label    = cmd->base.alt_dest.flow_label;
+	attr->alt_ah_attr.grh.sgid_index    = cmd->base.alt_dest.sgid_index;
+	attr->alt_ah_attr.grh.hop_limit     = cmd->base.alt_dest.hop_limit;
+	attr->alt_ah_attr.grh.traffic_class = cmd->base.alt_dest.traffic_class;
+	attr->alt_ah_attr.dlid		    = cmd->base.alt_dest.dlid;
+	attr->alt_ah_attr.sl		    = cmd->base.alt_dest.sl;
+	attr->alt_ah_attr.src_path_bits	    = cmd->base.alt_dest.src_path_bits;
+	attr->alt_ah_attr.static_rate	    = cmd->base.alt_dest.static_rate;
+	attr->alt_ah_attr.ah_flags	    = cmd->base.alt_dest.is_global ?
+					      IB_AH_GRH : 0;
+	attr->alt_ah_attr.port_num	    = cmd->base.alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
-		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
+		ret = ib_resolve_eth_dmac(qp, attr, &cmd->base.attr_mask);
 		if (ret)
 			goto release_qp;
 		ret = qp->device->modify_qp(qp, attr,
-			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+					    modify_qp_mask(qp->qp_type,
+							   cmd->base.attr_mask),
+					    udata);
 	} else {
-		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
+		ret = ib_modify_qp(qp, attr,
+				   modify_qp_mask(qp->qp_type,
+						  cmd->base.attr_mask));
 	}
 
-	if (ret)
-		goto release_qp;
-
-	ret = in_len;
-
 release_qp:
 	put_qp_read(qp);
 
@@ -2425,6 +2417,54 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	return ret;
 }
 
+ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
+			    struct ib_device *ib_dev,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_ex_modify_qp cmd = {};
+	struct ib_udata udata;
+	int ret;
+
+	if (copy_from_user(&cmd.base, buf, sizeof(cmd.base)))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof(cmd.base), NULL,
+		   in_len - sizeof(cmd.base), out_len);
+
+	ret = modify_qp(file, &cmd, &udata);
+	if (ret)
+		return ret;
+
+	return in_len;
+}
+
+int ib_uverbs_ex_modify_qp(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_modify_qp cmd = {};
+	int ret;
+
+	if (ucore->inlen < sizeof(cmd.base))
+		return -EINVAL;
+
+	ret = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
+	if (ret)
+		return ret;
+
+	if (ucore->inlen > sizeof(cmd)) {
+		if (ib_is_udata_cleared(ucore, sizeof(cmd),
+					ucore->inlen - sizeof(cmd)))
+			return -EOPNOTSUPP;
+	}
+
+	ret = modify_qp(file, &cmd, ucore);
+
+	return ret;
+}
+
 ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 			     struct ib_device *ib_dev,
 			     const char __user *buf, int in_len,
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0012fa5..80839c3 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -137,6 +137,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_DESTROY_WQ]       = ib_uverbs_ex_destroy_wq,
 	[IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL] = ib_uverbs_ex_create_rwq_ind_table,
 	[IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL] = ib_uverbs_ex_destroy_rwq_ind_table,
+	[IB_USER_VERBS_EX_CMD_MODIFY_QP]        = ib_uverbs_ex_modify_qp,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 25225eb..351f260 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -93,6 +93,7 @@ enum {
 	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ,
 	IB_USER_VERBS_EX_CMD_CREATE_QP = IB_USER_VERBS_CMD_CREATE_QP,
+	IB_USER_VERBS_EX_CMD_MODIFY_QP = IB_USER_VERBS_CMD_MODIFY_QP,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
 	IB_USER_VERBS_EX_CMD_CREATE_WQ,
@@ -684,9 +685,20 @@ struct ib_uverbs_modify_qp {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_ex_modify_qp {
+	struct ib_uverbs_modify_qp base;
+	__u32	rate_limit;
+	__u32	reserved;
+};
+
 struct ib_uverbs_modify_qp_resp {
 };
 
+struct ib_uverbs_ex_modify_qp_resp {
+	__u32  comp_mask;
+	__u32  response_length;
+};
+
 struct ib_uverbs_destroy_qp {
 	__u64 response;
 	__u32 qp_handle;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
