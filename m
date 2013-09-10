From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 7/9] IB/core: Add RoCE IP based addressing extensions for uverbs
Date: Tue, 10 Sep 2013 17:41:37 +0300
Message-ID: <1378824099-22150-8-git-send-email-ogerlitz@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378824099-22150-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add uverbs support for RoCE (IBoE) IP based addressing extensions
towards user space libraries.

Under ip based gid addressing, for RC QPs, QP attributes should contain the
Ethernet L2 destination. Until now, indicatings GID was sufficient. When
using ip encoded in gids, the QP attributes should contain extended destination,
indicating vlan and dmac as well. This is done via a new struct ib_uverbs_qp_dest_ex.
This new structure is contained in a new struct ib_uverbs_modify_qp_ex that is
used by MODIFY_QP_EX command. In order to make those changes seamlessly, those
extended structures were added in the bottom of the current structures.
The new command also gets smac/alt_smac/vlan_id/alt_vlan_id. Those parameters
are fixed in the QP context in order to enhance security.
The extended dest is used a a pointer rather than as a inline fixed field
in the sake of future scalability.

Also, when the gid encodes ip address, the AH attributes should contain also
dmac. Therefore, ib_uverbs_create_ah was extended to contain those fields.
When creating an AH, the user indicates the exact L2 ethernet destination
parameters. This is done by a new CREATE_AH_EX command that uses a new struct
ib_uverbs_create_ah_ex.

struct ib_user_path_rec was extended too, to contain source and destination
MAC and VLAN ID, this structure is of use by the rdma_ucm driver.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h          |    2 +
 drivers/infiniband/core/uverbs_cmd.c      |  359 ++++++++++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c     |    4 +-
 drivers/infiniband/core/uverbs_marshall.c |  128 ++++++++++-
 include/rdma/ib_marshall.h                |   12 +
 include/uapi/rdma/ib_user_sa.h            |   34 +++-
 include/uapi/rdma/ib_user_verbs.h         |  160 +++++++++++++-
 7 files changed, 608 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index d040b87..b0fcb0b 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -202,11 +202,13 @@ IB_UVERBS_DECLARE_CMD(create_qp);
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
index f2b81b9..9a0c5d7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1900,6 +1900,60 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
+static void ib_uverbs_modify_qp_assign(struct ib_uverbs_modify_qp *cmd,
+				       struct ib_qp_attr *attr,
+				       struct ib_uverbs_qp_dest *dest,
+				       struct ib_uverbs_qp_dest *alt_dest) {
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
+	memcpy(attr->ah_attr.grh.dgid.raw, dest->dgid, 16);
+	attr->ah_attr.grh.flow_label        = dest->flow_label;
+	attr->ah_attr.grh.sgid_index        = dest->sgid_index;
+	attr->ah_attr.grh.hop_limit         = dest->hop_limit;
+	attr->ah_attr.grh.traffic_class     = dest->traffic_class;
+	attr->ah_attr.dlid		    = dest->dlid;
+	attr->ah_attr.sl		    = dest->sl;
+	attr->ah_attr.src_path_bits	    = dest->src_path_bits;
+	attr->ah_attr.static_rate	    = dest->static_rate;
+	attr->ah_attr.ah_flags		    = dest->is_global ?
+					      IB_AH_GRH : 0;
+	attr->ah_attr.port_num		    = dest->port_num;
+
+	memcpy(attr->alt_ah_attr.grh.dgid.raw, alt_dest->dgid, 16);
+	attr->alt_ah_attr.grh.flow_label    = alt_dest->flow_label;
+	attr->alt_ah_attr.grh.sgid_index    = alt_dest->sgid_index;
+	attr->alt_ah_attr.grh.hop_limit     = alt_dest->hop_limit;
+	attr->alt_ah_attr.grh.traffic_class = alt_dest->traffic_class;
+	attr->alt_ah_attr.dlid		    = alt_dest->dlid;
+	attr->alt_ah_attr.sl		    = alt_dest->sl;
+	attr->alt_ah_attr.src_path_bits     = alt_dest->src_path_bits;
+	attr->alt_ah_attr.static_rate       = alt_dest->static_rate;
+	attr->alt_ah_attr.ah_flags	    = alt_dest->is_global
+					      ? IB_AH_GRH : 0;
+	attr->alt_ah_attr.port_num	    = alt_dest->port_num;
+}
+
+
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
@@ -1926,51 +1980,13 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
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
+	ib_uverbs_modify_qp_assign(&cmd, attr, &cmd.dest, &cmd.alt_dest);
+	memset(attr->ah_attr.dmac, 0, sizeof(attr->ah_attr.dmac));
+	attr->vlan_id = 0xFFFF;
+	memset(attr->smac, 0, sizeof(attr->smac));
+	memset(attr->alt_ah_attr.dmac, 0, sizeof(attr->alt_ah_attr.dmac));
+	attr->alt_vlan_id = 0xFFFF;
+	memset(attr->alt_smac, 0, sizeof(attr->alt_smac));
 
 	if (qp->real_qp == qp) {
 		ret = qp->device->modify_qp(qp, attr,
@@ -1992,6 +2008,111 @@ out:
 	return ret;
 }
 
+ssize_t ib_uverbs_modify_qp_ex(struct ib_uverbs_file *file,
+			       const char __user *buf, int in_len,
+			       int out_len)
+{
+	struct ib_uverbs_modify_qp_ex cmd;
+	struct ib_uverbs_qp_dest_ex   dest_ex;
+	struct ib_uverbs_qp_dest_ex   alt_dest_ex;
+	struct ib_uverbs_qp_dest     *dest;
+	struct ib_uverbs_qp_dest     *alt_dest;
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
+	if (!(cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_DEST_EX) ||
+	    copy_from_user(&dest_ex, cmd.dest_ex, sizeof(dest_ex)))
+		dest = &cmd.dest;
+	else
+		dest = (struct ib_uverbs_qp_dest *)&dest_ex;
+
+
+	if (!(cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX) ||
+	    copy_from_user(&alt_dest_ex, cmd.alt_dest_ex, sizeof(alt_dest_ex)))
+		alt_dest = &cmd.alt_dest;
+	else
+		alt_dest = (struct ib_uverbs_qp_dest *)&alt_dest_ex;
+
+	ib_uverbs_modify_qp_assign((struct ib_uverbs_modify_qp *)((void *)&cmd +
+				   offsetof(
+				   struct ib_uverbs_modify_qp_ex, dest)), attr,
+				   dest,
+				   alt_dest);
+
+	if (cmd.comp_mask &  IB_UVERBS_MODIFY_QP_EX_DEST_EX &&
+	    dest_ex.comp_mask & IB_UVERBS_QP_DEST_ATTR_DMAC)
+		memcpy(attr->ah_attr.dmac, dest_ex.dmac,
+		       sizeof(attr->ah_attr.dmac));
+	else
+		memset(attr->ah_attr.dmac, 0,
+		       sizeof(attr->ah_attr.dmac));
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_VID)
+		attr->vlan_id = cmd.vid;
+	else
+		attr->vlan_id = 0xFFFF;
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_SMAC)
+		memcpy(attr->smac, cmd.smac,
+		       sizeof(attr->smac));
+	else
+		memset(attr->smac, 0,
+		       sizeof(attr->smac));
+	if (cmd.comp_mask &  IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX &&
+	    alt_dest_ex.comp_mask & IB_UVERBS_QP_DEST_ATTR_DMAC)
+		memcpy(attr->alt_ah_attr.dmac, alt_dest_ex.dmac,
+		       sizeof(attr->alt_ah_attr.dmac));
+	else
+		memset(attr->alt_ah_attr.dmac, 0,
+		       sizeof(attr->alt_ah_attr.dmac));
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_ALT_VID)
+		attr->alt_vlan_id = cmd.alt_vid;
+	else
+		attr->alt_vlan_id = 0xFFFF;
+	if (cmd.comp_mask & IB_UVERBS_MODIFY_QP_EX_ALT_SMAC)
+		memcpy(attr->alt_smac, cmd.alt_smac,
+		       sizeof(attr->alt_smac));
+	else
+		memset(attr->alt_smac, 0,
+		       sizeof(attr->alt_smac));
+
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
@@ -2389,48 +2510,46 @@ out:
 	return ret ? ret : in_len;
 }
 
-ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+static struct ib_uobject *ib_uverbs_create_ah_assign(
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
 
 	ah = ib_create_ah(pd, &attr);
 	if (IS_ERR(ah)) {
@@ -2439,22 +2558,61 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
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
+	memcpy(&attr_ex, &cmd->attr, sizeof(cmd->attr));
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
@@ -2467,15 +2625,54 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
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
index 75ad86c..f1cc3f0 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -116,7 +116,9 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
 	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp,
 	[IB_USER_VERBS_CMD_CREATE_FLOW]		= ib_uverbs_create_flow,
-	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow
+	[IB_USER_VERBS_CMD_DESTROY_FLOW]	= ib_uverbs_destroy_flow,
+	[IB_USER_VERBS_CMD_MODIFY_QP_EX]	= ib_uverbs_modify_qp_ex,
+	[IB_USER_VERBS_CMD_CREATE_AH_EX]	= ib_uverbs_create_ah_ex
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index e7bee46..7f7a7e2 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/etherdevice.h>
 #include <rdma/ib_marshall.h>
 
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
@@ -52,6 +53,17 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
+void ib_copy_ah_attr_to_user_ex(struct ib_uverbs_ah_attr_ex *dst,
+				struct ib_ah_attr *src)
+{
+	dst->comp_mask = 0;
+	ib_copy_ah_attr_to_user((struct ib_uverbs_ah_attr *)
+				dst, src);
+	dst->comp_mask |= IB_UVERBS_AH_ATTR_DMAC;
+	memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
+}
+EXPORT_SYMBOL(ib_copy_ah_attr_to_user_ex);
+
 void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src)
 {
@@ -65,15 +77,15 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->dest_qp_num	= src->dest_qp_num;
 	dst->qp_access_flags	= src->qp_access_flags;
 
+	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
+	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
+
 	dst->max_send_wr	= src->cap.max_send_wr;
 	dst->max_recv_wr	= src->cap.max_recv_wr;
 	dst->max_send_sge	= src->cap.max_send_sge;
 	dst->max_recv_sge	= src->cap.max_recv_sge;
 	dst->max_inline_data	= src->cap.max_inline_data;
 
-	ib_copy_ah_attr_to_user(&dst->ah_attr, &src->ah_attr);
-	ib_copy_ah_attr_to_user(&dst->alt_ah_attr, &src->alt_ah_attr);
-
 	dst->pkey_index		= src->pkey_index;
 	dst->alt_pkey_index	= src->alt_pkey_index;
 	dst->en_sqd_async_notify = src->en_sqd_async_notify;
@@ -91,6 +103,63 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
+void ib_copy_qp_attr_to_user_ex(struct ib_uverbs_qp_attr_ex *dst,
+				struct ib_qp_attr *src)
+{
+	struct ib_uverbs_ah_attr_ex ah_attr_ex;
+	struct ib_uverbs_ah_attr_ex alt_ah_attr_ex;
+
+	ib_copy_qp_attr_to_user((struct ib_uverbs_qp_attr *)
+				dst, src);
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_AH_EX &&
+	    !is_zero_ether_addr(src->ah_attr.dmac)) {
+		ib_copy_ah_attr_to_user_ex(&ah_attr_ex, &src->ah_attr);
+		if (dst->ah_attr_ex == NULL ||
+		    copy_to_user(dst->ah_attr_ex, &ah_attr_ex,
+				 sizeof(ah_attr_ex)))
+			dst->comp_mask &= ~IB_UVERBS_QP_ATTR_AH_EX;
+	} else {
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_AH_EX;
+	}
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_AH_EX &&
+	    !is_zero_ether_addr(src->alt_ah_attr.dmac)) {
+		ib_copy_ah_attr_to_user_ex(&alt_ah_attr_ex, &src->alt_ah_attr);
+		if (dst->alt_ah_attr_ex == NULL ||
+		    copy_to_user(dst->alt_ah_attr_ex, &alt_ah_attr_ex,
+				 sizeof(alt_ah_attr_ex)))
+			dst->comp_mask &= ~IB_UVERBS_QP_ATTR_AH_EX;
+	} else {
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_AH_EX;
+	}
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_SMAC &&
+	    !is_zero_ether_addr(src->smac))
+		memcpy(dst->smac, src->smac, sizeof(dst->smac));
+	else
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_SMAC;
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_SMAC &&
+	    !is_zero_ether_addr(src->alt_smac))
+		memcpy(dst->alt_smac, src->alt_smac, sizeof(dst->alt_smac));
+	else
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_ALT_SMAC;
+
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_SMAC &&
+	    src->vlan_id != 0xFFFF)
+		dst->vlan_id = src->vlan_id;
+	else
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_VID;
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_VID &&
+	    src->vlan_id != 0xFFFF)
+		dst->vlan_id = src->vlan_id;
+	else
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_VID;
+	if (dst->comp_mask & IB_UVERBS_QP_ATTR_ALT_VID &&
+	    src->alt_vlan_id != 0xFFFF)
+		dst->alt_vlan_id = src->alt_vlan_id;
+	else
+		dst->comp_mask &= ~IB_UVERBS_QP_ATTR_VID;
+}
+EXPORT_SYMBOL(ib_copy_qp_attr_to_user_ex);
+
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 			      struct ib_sa_path_rec *src)
 {
@@ -117,11 +186,26 @@ void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 }
 EXPORT_SYMBOL(ib_copy_path_rec_to_user);
 
-void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
-				struct ib_user_path_rec *src)
+void ib_copy_path_rec_to_user_ex(struct ib_user_path_rec_ex *dst,
+				 struct ib_sa_path_rec *src)
 {
-	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
-	memcpy(dst->sgid.raw, src->sgid, sizeof dst->sgid);
+	ib_copy_path_rec_to_user((struct ib_user_path_rec *)dst, src);
+
+	dst->comp_mask = IB_USER_PATH_REC_ATTR_DMAC |
+			 IB_USER_PATH_REC_ATTR_SMAC |
+			 IB_USER_PATH_REC_ATTR_VID;
+
+	memcpy(dst->dmac, src->dmac, sizeof(dst->dmac));
+	memcpy(dst->smac, src->smac, sizeof(dst->smac));
+	dst->vlan_id = src->vlan_id;
+}
+EXPORT_SYMBOL(ib_copy_path_rec_to_user_ex);
+
+static void ib_copy_path_rec_from_user_assign(struct ib_sa_path_rec *dst,
+					      struct ib_user_path_rec *src)
+{
+	memcpy(dst->dgid.raw, src->dgid, sizeof(dst->dgid));
+	memcpy(dst->sgid.raw, src->sgid, sizeof(dst->sgid));
 
 	dst->dlid		= src->dlid;
 	dst->slid		= src->slid;
@@ -141,4 +225,34 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
 	dst->preference		= src->preference;
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 }
+
+void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
+				struct ib_user_path_rec *src) {
+	memset(dst->dmac, 0, sizeof(dst->dmac));
+	memset(dst->smac, 0, sizeof(dst->smac));
+	dst->vlan_id = 0xFFFF;
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
+		dst->vlan_id = src->vlan_id;
+	else
+		dst->vlan_id = 0xFFFF;
+
+	ib_copy_path_rec_from_user_assign(dst, (struct ib_user_path_rec *)src);
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
index cfc7c9b..8a24e10 100644
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
+	__u32   comp_mask;
+	__u8	smac[ETH_ALEN];
+	__u8	dmac[ETH_ALEN];
+	u16	vlan_id;
+};
+
 #endif /* IB_USER_SA_H */
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 0b233c5..f1939cf 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -37,6 +37,7 @@
 #define IB_USER_VERBS_H
 
 #include <linux/types.h>
+#include <linux/if_ether.h>
 
 /*
  * Increment this value if any changes that break userspace ABI
@@ -88,7 +89,9 @@ enum {
 	IB_USER_VERBS_CMD_CREATE_XSRQ,
 	IB_USER_VERBS_CMD_OPEN_QP,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW
+	IB_USER_VERBS_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_CMD_MODIFY_QP_EX,
+	IB_USER_VERBS_CMD_CREATE_AH_EX
 };
 
 /*
@@ -394,6 +397,24 @@ struct ib_uverbs_ah_attr {
 	__u8  reserved;
 };
 
+enum ib_uverbs_ah_attr_mask {
+	IB_UVERBS_AH_ATTR_DMAC,
+	IB_UVERBS_AH_ATTR_VID
+};
+
+struct ib_uverbs_ah_attr_ex {
+	struct ib_uverbs_global_route grh;
+	__u16 dlid;
+	__u8  sl;
+	__u8  src_path_bits;
+	__u8  static_rate;
+	__u8  is_global;
+	__u8  port_num;
+	__u8  reserved;
+	__u32 comp_mask;
+	__u8  dmac[ETH_ALEN];
+};
+
 struct ib_uverbs_qp_attr {
 	__u32	qp_attr_mask;
 	__u32	qp_state;
@@ -432,6 +453,65 @@ struct ib_uverbs_qp_attr {
 	__u8	reserved[5];
 };
 
+enum ib_uverbs_qh_attr_mask {
+	IB_UVERBS_QP_ATTR_AH_EX		= 1 << 0,
+	IB_UVERBS_QP_ATTR_ALT_AH_EX	= 1 << 1,
+	IB_UVERBS_QP_ATTR_SMAC		= 1 << 2,
+	IB_UVERBS_QP_ATTR_ALT_SMAC	= 1 << 3,
+	IB_UVERBS_QP_ATTR_VID		= 1 << 4,
+	IB_UVERBS_QP_ATTR_ALT_VID	= 1 << 5,
+};
+
+struct ib_uverbs_qp_attr_ex {
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
+	/* deprecated for extension */
+	struct ib_uverbs_ah_attr ah_attr;
+	/* deprecated for extension */
+	struct ib_uverbs_ah_attr alt_ah_attr;
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
+
+	__u32   comp_mask;
+	/* represents: struct ib_uverbs_ah_attr_ex * __user */
+	void __user *ah_attr_ex;
+	/* represents: struct ib_uverbs_ah_attr_ex * __user */
+	void __user *alt_ah_attr_ex;
+	__u8	smac[ETH_ALEN];
+	__u8	alt_smac[ETH_ALEN];
+	__u16	vlan_id;
+	__u16	alt_vlan_id;
+};
+
 struct ib_uverbs_create_qp {
 	__u64 response;
 	__u64 user_handle;
@@ -492,6 +572,27 @@ struct ib_uverbs_qp_dest {
 	__u8  port_num;
 };
 
+enum ib_uverbs_qp_dest_attr_mask {
+	IB_UVERBS_QP_DEST_ATTR_DMAC = 1ULL << 0
+};
+
+struct ib_uverbs_qp_dest_ex {
+	__u8  dgid[16];
+	__u32 flow_label;
+	__u16 dlid;
+	__u16 reserved;
+	__u8  sgid_index;
+	__u8  hop_limit;
+	__u8  traffic_class;
+	__u8  sl;
+	__u8  src_path_bits;
+	__u8  static_rate;
+	__u8  is_global;
+	__u8  port_num;
+	__u32 comp_mask;
+	__u8  dmac[ETH_ALEN];
+};
+
 struct ib_uverbs_query_qp {
 	__u64 response;
 	__u32 qp_handle;
@@ -563,6 +664,54 @@ struct ib_uverbs_modify_qp {
 	__u64 driver_data[0];
 };
 
+enum ib_uverbs_modify_qp_ex_comp_mask {
+	IB_UVERBS_MODIFY_QP_EX_SMAC		      = (1ULL << 0),
+	IB_UVERBS_MODIFY_QP_EX_ALT_SMAC		      = (1ULL << 1),
+	IB_UVERBS_MODIFY_QP_EX_VID		      = (1ULL << 2),
+	IB_UVERBS_MODIFY_QP_EX_ALT_VID		      = (1ULL << 3),
+	IB_UVERBS_MODIFY_QP_EX_DEST_EX		      = (1ULL << 4),
+	IB_UVERBS_MODIFY_QP_EX_ALT_DEST_EX	      = (1ULL << 5)
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
+	__u8  smac[ETH_ALEN];
+	__u8  alt_smac[ETH_ALEN];
+	__u16 vid;
+	__u16 alt_vid;
+	/* represents: struct ib_uverbs_qp_dest_ex * __user */
+	void __user *dest_ex;
+	/* represents: struct ib_uverbs_qp_dest_ex * __user */
+	void __user *alt_dest_ex;
+	__u64 driver_data[0];
+};
+
 struct ib_uverbs_modify_qp_resp {
 };
 
@@ -672,6 +821,15 @@ struct ib_uverbs_create_ah {
 	struct ib_uverbs_ah_attr attr;
 };
 
+struct ib_uverbs_create_ah_ex {
+	__u32 comp_mask;
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
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
