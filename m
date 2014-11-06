From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 2/5] IB/uverbs: Add userspace interface to DC verbs
Date: Thu,  6 Nov 2014 17:52:36 +0200
Message-ID: <1415289159-4376-3-git-send-email-eli@mellanox.com>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415289159-4376-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  11 +
 drivers/infiniband/core/uverbs_cmd.c  | 474 +++++++++++++++++++++++++++++-----
 drivers/infiniband/core/uverbs_main.c |  35 ++-
 include/rdma/ib_verbs.h               |   1 +
 include/uapi/rdma/ib_user_verbs.h     | 126 ++++++++-
 5 files changed, 584 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b716b0815644..3343696df6b1 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -163,6 +163,10 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
+struct ib_udct_object {
+	struct ib_uevent_object	uevent;
+};
+
 extern spinlock_t ib_uverbs_idr_lock;
 extern struct idr ib_uverbs_pd_idr;
 extern struct idr ib_uverbs_mr_idr;
@@ -173,6 +177,7 @@ extern struct idr ib_uverbs_qp_idr;
 extern struct idr ib_uverbs_srq_idr;
 extern struct idr ib_uverbs_xrcd_idr;
 extern struct idr ib_uverbs_rule_idr;
+extern struct idr ib_uverbs_dct_idr;
 
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
@@ -189,6 +194,7 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr);
+void ib_uverbs_dct_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
@@ -259,5 +265,10 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
 IB_UVERBS_DECLARE_EX_CMD(query_device);
+IB_UVERBS_DECLARE_EX_CMD(create_dct);
+IB_UVERBS_DECLARE_EX_CMD(destroy_dct);
+IB_UVERBS_DECLARE_EX_CMD(query_dct);
+IB_UVERBS_DECLARE_EX_CMD(arm_dct);
+IB_UVERBS_DECLARE_EX_CMD(modify_qp);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0bc215fa2a85..e2a1f691315c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -56,6 +56,7 @@ static struct uverbs_lock_class ah_lock_class	= { .name = "AH-uobj" };
 static struct uverbs_lock_class srq_lock_class	= { .name = "SRQ-uobj" };
 static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 static struct uverbs_lock_class rule_lock_class = { .name = "RULE-uobj" };
+static struct uverbs_lock_class dct_lock_class	= { .name = "DCT-uobj" };
 
 /*
  * The ib_uobject locking scheme is as follows:
@@ -258,6 +259,16 @@ static void put_qp_write(struct ib_qp *qp)
 	put_uobj_write(qp->uobject);
 }
 
+static struct ib_dct *idr_read_dct(int dct_handle, struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_dct_idr, dct_handle, context, 0);
+}
+
+static void put_dct_read(struct ib_dct *dct)
+{
+	put_uobj_read(dct->uobject);
+}
+
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
@@ -325,6 +336,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
+	INIT_LIST_HEAD(&ucontext->dct_list);
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -1990,86 +2002,79 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
-ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
-			    const char __user *buf, int in_len,
-			    int out_len)
+static ssize_t modify_qp(struct ib_uverbs_file *file,
+			 struct ib_uverbs_modify_qp_ex *cmd,
+			 struct ib_udata *udata)
 {
-	struct ib_uverbs_modify_qp cmd;
-	struct ib_udata            udata;
 	struct ib_qp              *qp;
 	struct ib_qp_attr         *attr;
 	int                        ret;
 
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
-
-	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
-		   out_len);
-
 	attr = kmalloc(sizeof *attr, GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_read_qp(cmd->qp_handle, file->ucontext);
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
+	attr->dct_key		  = cmd->dct_key;
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
+	attr->ah_attr.ah_flags		    = cmd->dest.is_global ? IB_AH_GRH : 0;
+	attr->ah_attr.port_num		    = cmd->dest.port_num;
+
+	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd->alt_dest.dgid, 16);
+	attr->alt_ah_attr.grh.flow_label    = cmd->alt_dest.flow_label;
+	attr->alt_ah_attr.grh.sgid_index    = cmd->alt_dest.sgid_index;
+	attr->alt_ah_attr.grh.hop_limit     = cmd->alt_dest.hop_limit;
+	attr->alt_ah_attr.grh.traffic_class = cmd->alt_dest.traffic_class;
+	attr->alt_ah_attr.dlid		    = cmd->alt_dest.dlid;
+	attr->alt_ah_attr.sl		    = cmd->alt_dest.sl;
+	attr->alt_ah_attr.src_path_bits	    = cmd->alt_dest.src_path_bits;
+	attr->alt_ah_attr.static_rate	    = cmd->alt_dest.static_rate;
+	attr->alt_ah_attr.ah_flags	    = cmd->alt_dest.is_global ? IB_AH_GRH : 0;
+	attr->alt_ah_attr.port_num	    = cmd->alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
-		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
+		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd->attr_mask);
 		if (ret)
 			goto out;
 		ret = qp->device->modify_qp(qp, attr,
-			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+			modify_qp_mask(qp->qp_type, cmd->attr_mask), udata);
 	} else {
-		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
+		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd->attr_mask));
 	}
 
 	put_qp_read(qp);
@@ -2077,7 +2082,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	if (ret)
 		goto out;
 
-	ret = in_len;
+	return 0;
 
 out:
 	kfree(attr);
@@ -2085,6 +2090,30 @@ out:
 	return ret;
 }
 
+ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_modify_qp_ex xcmd;
+	struct ib_uverbs_modify_qp cmd;
+	struct ib_udata            udata;
+	int                        ret;
+
+	if (copy_from_user(&cmd, buf, sizeof(cmd)))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof(cmd), NULL, in_len - sizeof(cmd),
+		   out_len);
+
+	memset(&xcmd, 0, sizeof(xcmd));
+	memcpy(&xcmd.dest, &cmd, sizeof(cmd));
+	ret = modify_qp(file, &xcmd, &udata);
+	if (ret)
+		return ret;
+
+	return in_len;
+}
+
 ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 			     const char __user *buf, int in_len,
 			     int out_len)
@@ -3300,9 +3329,332 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 		resp.atomics.max_fa_bit_boundary = 0;
 		resp.atomics.log_max_atomic_inline = 0;
 	}
+	if (cmd.comp_mask & IB_UVERBS_EX_QUERY_DEV_CAP_FLAGS2) {
+		resp.device_cap_flags2 = (__u32)(attr.device_cap_flags >> 32);
+		resp.comp_mask |= IB_UVERBS_EX_QUERY_DEV_CAP_FLAGS2;
+	}
+
+	if (cmd.comp_mask & IB_UVERBS_EX_QUERY_DEV_DC_PARAMS) {
+		resp.dc_rd_req = attr.dc_rd_req;
+		resp.dc_rd_res = attr.dc_rd_res;
+		resp.comp_mask |= IB_UVERBS_EX_QUERY_DEV_DC_PARAMS;
+	}
+
+	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int ib_uverbs_ex_create_dct(struct ib_uverbs_file *file,
+			    struct ib_udata *ucore,
+			    struct ib_udata *uhw)
+{
+	int out_len			= ucore->outlen + uhw->outlen;
+	struct ib_uverbs_create_dct	 *cmd;
+	struct ib_uverbs_create_dct_resp resp;
+	struct ib_udct_object		*obj;
+	struct ib_dct			*dct;
+	int                             err;
+	struct ib_dct_init_attr		*attr;
+	struct ib_pd			*pd = NULL;
+	struct ib_cq			*cq = NULL;
+	struct ib_srq			*srq = NULL;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr || !cmd) {
+		err = -ENOMEM;
+		goto err_cmd_attr;
+	}
+
+	err = ib_copy_from_udata(cmd, ucore, sizeof(*cmd));
+	if (err)
+		goto err_cmd_attr;
+
+	if (cmd->comp_mask) {
+		err = -EINVAL;
+		goto err_cmd_attr;
+	}
+
+	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj) {
+		err = -ENOMEM;
+		goto err_cmd_attr;
+	}
+
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
+		  &dct_lock_class);
+	down_write(&obj->uevent.uobject.mutex);
+
+	srq = idr_read_srq(cmd->srq_handle, file->ucontext);
+	if (!srq) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	cq = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+	if (!cq) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	pd = idr_read_pd(cmd->pd_handle, file->ucontext);
+	if (!pd) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	if (cmd->create_flags & ~IB_DCT_CREATE_FLAGS_MASK) {
+		err = -EINVAL;
+		goto err_put;
+	}
+
+	attr->cq = cq;
+	attr->access_flags = cmd->access_flags;
+	attr->min_rnr_timer = cmd->min_rnr_timer;
+	attr->srq = srq;
+	attr->tclass = cmd->tclass;
+	attr->flow_label = cmd->flow_label;
+	attr->dc_key = cmd->dc_key;
+	attr->mtu = cmd->mtu;
+	attr->port = cmd->port;
+	attr->pkey_index = cmd->pkey_index;
+	attr->gid_index = cmd->gid_index;
+	attr->hop_limit = cmd->hop_limit;
+	attr->create_flags = cmd->create_flags;
+	attr->inline_size = cmd->inline_size;
+	attr->event_handler = ib_uverbs_dct_event_handler;
+	attr->dct_context   = file;
+
+	obj->uevent.events_reported = 0;
+	INIT_LIST_HEAD(&obj->uevent.event_list);
+	dct = ib_create_dct(pd, attr, uhw);
+	if (IS_ERR(dct)) {
+		err = PTR_ERR(dct);
+		goto err_put;
+	}
+
+	dct->device        = file->device->ib_dev;
+	dct->uobject       = &obj->uevent.uobject;
+	dct->event_handler = attr->event_handler;
+	dct->dct_context   = attr->dct_context;
+
+	obj->uevent.uobject.object = dct;
+	err = idr_add_uobj(&ib_uverbs_dct_idr, &obj->uevent.uobject);
+	if (err)
+		goto err_dct;
+
+	memset(&resp, 0, sizeof(resp));
+	resp.dct_handle = obj->uevent.uobject.id;
+	resp.dctn = dct->dct_num;
+	resp.inline_size = attr->inline_size;
+
+	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
+	if (err)
+		goto err_copy;
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->dct_list);
+	mutex_unlock(&file->mutex);
+
+	obj->uevent.uobject.live = 1;
+
+	put_pd_read(pd);
+	put_cq_read(cq);
+	put_srq_read(srq);
+
+	up_write(&obj->uevent.uobject.mutex);
+	kfree(attr);
+	kfree(cmd);
+
+	return 0;
+
+err_copy:
+	idr_remove_uobj(&ib_uverbs_dct_idr, &obj->uevent.uobject);
+
+err_dct:
+	ib_destroy_dct(dct, uhw);
+
+err_put:
+	if (pd)
+		put_pd_read(pd);
+	if (cq)
+		put_cq_read(cq);
+	if (srq)
+		put_srq_read(srq);
+
+	put_uobj_write(&obj->uevent.uobject);
+
+err_cmd_attr:
+	kfree(attr);
+	kfree(cmd);
+	return err;
+}
+
+int ib_uverbs_ex_destroy_dct(struct ib_uverbs_file *file,
+			     struct ib_udata *ucore,
+			     struct ib_udata *uhw)
+{
+	int out_len				= ucore->outlen + uhw->outlen;
+	struct ib_uverbs_destroy_dct		cmd;
+	struct ib_uverbs_destroy_dct_resp	resp;
+	struct ib_uobject		       *uobj;
+	struct ib_udct_object		       *obj;
+	struct ib_dct			       *dct;
+	int					err;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	uobj = idr_write_uobj(&ib_uverbs_dct_idr, cmd.dct_handle, file->ucontext);
+	if (!uobj)
+		return -EINVAL;
+
+	dct      = uobj->object;
+	obj = container_of(uobj, struct ib_udct_object, uevent.uobject);
+
+	err = ib_destroy_dct(dct, uhw);
+	if (!err)
+		uobj->live = 0;
+
+	put_uobj_write(uobj);
+
+	if (err)
+		return err;
+
+	idr_remove_uobj(&ib_uverbs_dct_idr, uobj);
+
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	memset(&resp, 0, sizeof(resp));
+	resp.events_reported = obj->uevent.events_reported;
+
+	put_uobj(uobj);
+
 	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
 	if (err)
 		return err;
 
 	return 0;
 }
+
+int ib_uverbs_ex_arm_dct(struct ib_uverbs_file *file,
+			 struct ib_udata *ucore,
+			 struct ib_udata *uhw)
+{
+	struct ib_uverbs_arm_dct	cmd;
+	struct ib_dct		       *dct;
+	int				err;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	dct = idr_read_dct(cmd.dct_handle, file->ucontext);
+	if (!dct)
+		return -EINVAL;
+
+	err = ib_arm_dct(dct, uhw);
+	put_dct_read(dct);
+	if (err)
+		return err;
+
+	return err;
+}
+
+int ib_uverbs_ex_query_dct(struct ib_uverbs_file *file,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	int out_len			= ucore->outlen + uhw->outlen;
+	struct ib_uverbs_query_dct	cmd;
+	struct ib_uverbs_query_dct_resp	resp;
+	struct ib_dct		       *dct;
+	struct ib_dct_attr	       *attr;
+	int				err;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask)
+		return -EINVAL;
+
+	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	dct = idr_read_dct(cmd.dct_handle, file->ucontext);
+	if (!dct) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ib_query_dct(dct, attr, uhw);
+
+	put_dct_read(dct);
+
+	if (err)
+		goto out;
+
+	memset(&resp, 0, sizeof(resp));
+
+	resp.dc_key = attr->dc_key;
+	resp.access_flags = attr->access_flags;
+	resp.flow_label = attr->flow_label;
+	resp.key_violations = attr->key_violations;
+	resp.port = attr->port;
+	resp.min_rnr_timer = attr->min_rnr_timer;
+	resp.tclass = attr->tclass;
+	resp.mtu = attr->mtu;
+	resp.pkey_index = attr->pkey_index;
+	resp.gid_index = attr->gid_index;
+	resp.hop_limit = attr->hop_limit;
+	resp.state = attr->state;
+
+	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
+
+out:
+	kfree(attr);
+
+	return err;
+}
+
+int ib_uverbs_ex_modify_qp(struct ib_uverbs_file *file,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_modify_qp_ex cmd;
+	int                        err;
+
+	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
+	if (err)
+		return err;
+
+	if (cmd.comp_mask > IB_UVERBS_EX_MODIFY_QP_MAX_MASK)
+		return -EINVAL;
+
+	return modify_qp(file, &cmd, ucore);
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 974025028790..64ba9afd97f4 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -74,6 +74,7 @@ DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
 DEFINE_IDR(ib_uverbs_xrcd_idr);
 DEFINE_IDR(ib_uverbs_rule_idr);
+DEFINE_IDR(ib_uverbs_dct_idr);
 
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -123,7 +124,12 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 				    struct ib_udata *uhw) = {
 	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	= ib_uverbs_ex_create_flow,
 	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	= ib_uverbs_ex_destroy_flow,
-	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device
+	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	= ib_uverbs_ex_query_device,
+	[IB_USER_VERBS_EX_CMD_CREATE_DCT]	= ib_uverbs_ex_create_dct,
+	[IB_USER_VERBS_EX_CMD_DESTROY_DCT]	= ib_uverbs_ex_destroy_dct,
+	[IB_USER_VERBS_EX_CMD_QUERY_DCT]	= ib_uverbs_ex_query_dct,
+	[IB_USER_VERBS_EX_CMD_ARM_DCT]		= ib_uverbs_ex_arm_dct,
+	[IB_USER_VERBS_EX_CMD_MODIFY_QP]	= ib_uverbs_ex_modify_qp,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -199,6 +205,7 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 				      struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj, *tmp;
+	int err;
 
 	if (!context)
 		return 0;
@@ -246,6 +253,20 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uqp);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->dct_list, list) {
+		struct ib_dct *dct = uobj->object;
+		struct ib_udct_object *udct =
+			container_of(uobj, struct ib_udct_object, uevent.uobject);
+
+		idr_remove_uobj(&ib_uverbs_dct_idr, uobj);
+
+		err = ib_destroy_dct(dct, NULL);
+		if (err)
+			pr_warn("destroying uverbs dct failed: err %d\n", err);
+
+		kfree(udct);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
 		struct ib_cq *cq = uobj->object;
 		struct ib_uverbs_event_file *ev_file = cq->cq_context;
@@ -516,6 +537,18 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 				&uobj->events_reported);
 }
 
+void ib_uverbs_dct_event_handler(struct ib_event *event, void *context_ptr)
+{
+	struct ib_uevent_object *uobj;
+
+	uobj = container_of(event->element.dct->uobject,
+			    struct ib_uevent_object, uobject);
+
+	ib_uverbs_async_handler(context_ptr, uobj->uobject.user_handle,
+				event->event, &uobj->event_list,
+				&uobj->events_reported);
+}
+
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr)
 {
 	struct ib_uevent_object *uobj;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9c67cffe1ecc..97eb232ce05b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1147,6 +1147,7 @@ struct ib_ucontext {
 	struct list_head	ah_list;
 	struct list_head	xrcd_list;
 	struct list_head	rule_list;
+	struct list_head	dct_list;
 	int			closing;
 };
 
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index ec98fe636f2b..4db0607b0654 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -91,8 +91,13 @@ enum {
 
 enum {
 	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
+	IB_USER_VERBS_EX_CMD_MODIFY_QP	  = IB_USER_VERBS_CMD_MODIFY_QP,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
+	IB_USER_VERBS_EX_CMD_CREATE_DCT,
+	IB_USER_VERBS_EX_CMD_DESTROY_DCT,
+	IB_USER_VERBS_EX_CMD_QUERY_DCT,
+	IB_USER_VERBS_EX_CMD_ARM_DCT,
 };
 
 /*
@@ -204,7 +209,9 @@ struct ib_uverbs_query_device_resp {
 
 enum {
 	IB_UVERBS_EX_QUERY_DEV_MASKED_ATOMIC	= 1 << 0,
-	IB_UVERBS_EX_QUERY_DEV_LAST		= 1 << 1,
+	IB_UVERBS_EX_QUERY_DEV_CAP_FLAGS2	= 1 << 1,
+	IB_UVERBS_EX_QUERY_DEV_DC_PARAMS	= 1 << 2,
+	IB_UVERBS_EX_QUERY_DEV_LAST		= 1 << 3,
 	IB_UVERBS_EX_QUERY_DEV_MAX_MASK		= IB_UVERBS_EX_QUERY_DEV_LAST - 1,
 };
 
@@ -223,6 +230,9 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
 	struct ib_uverbs_ex_atomic_caps atomics;
+	__u32 device_cap_flags2;
+	__u32 dc_rd_req;
+	__u32 dc_rd_res;
 };
 
 struct ib_uverbs_query_port {
@@ -613,6 +623,46 @@ struct ib_uverbs_modify_qp {
 struct ib_uverbs_modify_qp_resp {
 };
 
+enum {
+	IB_UVERBS_EX_MODIFY_QP_DCT_KEY	= 1 << 0,
+	IB_UVERBS_EX_MODIFY_QP_MAX_MASK = (1 << (0 /*last shift value */ + 1)) - 1,
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
+	__u8  reserved[6];
+	__u64 dct_key;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_modify_qp_ex_resp {
+};
+
 struct ib_uverbs_destroy_qp {
 	__u64 response;
 	__u32 qp_handle;
@@ -901,4 +951,78 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+struct ib_uverbs_create_dct {
+	__u32	comp_mask;
+	__u32	reserved;
+	__u64	user_handle;
+	__u32	pd_handle;
+	__u32	cq_handle;
+	__u32	srq_handle;
+	__u32	access_flags;
+	__u64	dc_key;
+	__u32	flow_label;
+	__u8	min_rnr_timer;
+	__u8	tclass;
+	__u8	port;
+	__u8	pkey_index;
+	__u8	gid_index;
+	__u8	hop_limit;
+	__u8	mtu;
+	__u8	reserved0;
+	__u32	create_flags;
+	__u32	inline_size;
+	__u32	reserved1;
+	__u32	driver_data[0];
+};
+
+struct ib_uverbs_create_dct_resp {
+	__u32 comp_mask;
+	__u32 dct_handle;
+	__u32 dctn;
+	__u32 inline_size;
+	__u64 rsvd;
+};
+
+struct ib_uverbs_destroy_dct {
+	__u32 comp_mask;
+	__u32 dct_handle;
+	__u32 reserved;
+};
+
+struct ib_uverbs_destroy_dct_resp {
+	__u32	events_reported;
+	__u32	reserved;
+};
+
+struct ib_uverbs_query_dct {
+	__u32	comp_mask;
+	__u32	dct_handle;
+	__u32	reserved;
+	__u32	driver_data[0];
+};
+
+struct ib_uverbs_query_dct_resp {
+	__u64	dc_key;
+	__u32	access_flags;
+	__u32	flow_label;
+	__u32	key_violations;
+	__u8	port;
+	__u8	min_rnr_timer;
+	__u8	tclass;
+	__u8	mtu;
+	__u8	pkey_index;
+	__u8	gid_index;
+	__u8	hop_limit;
+	__u8	state;
+	__u32	rsvd;
+	__u32	driver_data[0];
+};
+
+struct ib_uverbs_arm_dct {
+	__u32	comp_mask;
+	__u32	dct_handle;
+	__u32	reserved;
+	__u32	driver_data[0];
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
