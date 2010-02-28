From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Sun, 28 Feb 2010 11:02:21 +0200
Message-ID: <201002281102.21207.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added creation of XRC receive-only QPs for userspace, which
reside in kernel space (user cannot post-to or poll these QPs).

Motivation:  MPI community requires XRC receive QPs which will
not be destroyed when the creating process terminates.

Solution:  Userspace requests that a QP be created in kernel space.
Each userspace process using that QP (i.e. receiving packets on an XRC SRQ
via the qp), registers with that QP. When the last userspace user unregisters with
the QP, it is destroyed.  Unregistration is also part of userspace process
cleanup, so there is no leakage.

This patch implements the kernel procedures to implement the following
(new) libibverbs API:
ibv_create_xrc_rcv_qp
ibv_modify_xrc_rcv_qp
ibv_query_xrc_rcv_qp
ibv_reg_xrc_rcv_qp
ibv_unreg_xrc_rcv_qp
ibv_destroy_xrc_rcv_qp

Note that for users who do not wish to utilize the reg/unreg verbs,
a destroy_xrc_rcv_qp verb is also provided.  Thus, usage is:
Either: create/destroy_xrc_rcv_qp
Or: create/reg/unreg_xrc_rcv_qp (the unreg is used in place of destroy) 

In addition, the patch implements the foundation for distributing
XRC-receive-only-QP events to userspace processes registered with that QP.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   11 +
 drivers/infiniband/core/uverbs_cmd.c  |  427 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   25 ++
 include/rdma/ib_user_verbs.h          |   86 +++++++-
 include/rdma/ib_verbs.h               |   32 +++
 5 files changed, 580 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e873437..b2383b9 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -176,6 +176,10 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
 void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 			    struct ib_xrcd *xrcd);
+void ib_uverbs_xrc_rcv_qp_event_handler(struct ib_event *event,
+					void *context_ptr);
+int ib_uverbs_cleanup_xrc_rcv_qp(struct ib_uverbs_file *file,
+				 u32 xrcd_handle, u32 qp_num);
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
@@ -213,5 +217,12 @@ IB_UVERBS_DECLARE_CMD(destroy_srq);
 IB_UVERBS_DECLARE_CMD(create_xrc_srq);
 IB_UVERBS_DECLARE_CMD(open_xrcd);
 IB_UVERBS_DECLARE_CMD(close_xrcd);
+IB_UVERBS_DECLARE_CMD(create_xrc_rcv_qp);
+IB_UVERBS_DECLARE_CMD(modify_xrc_rcv_qp);
+IB_UVERBS_DECLARE_CMD(query_xrc_rcv_qp);
+IB_UVERBS_DECLARE_CMD(reg_xrc_rcv_qp);
+IB_UVERBS_DECLARE_CMD(unreg_xrc_rcv_qp);
+IB_UVERBS_DECLARE_CMD(destroy_xrc_rcv_qp);
+ 
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cd4c692..a0e4b6f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -307,6 +307,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
+	INIT_LIST_HEAD(&ucontext->xrc_rcv_qp_list);
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -1078,6 +1079,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		goto err_put;
 	}
 
+	attr.create_flags  = 0;
 	attr.event_handler = ib_uverbs_qp_event_handler;
 	attr.qp_context    = file;
 	attr.send_cq       = scq;
@@ -2645,3 +2647,428 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 	if (inode)
 		xrcd_table_delete(dev, inode);
 }
+
+ssize_t ib_uverbs_create_xrc_rcv_qp(struct ib_uverbs_file *file,
+				    const char __user *buf, int in_len,
+				    int out_len)
+{
+	struct ib_uverbs_create_xrc_rcv_qp	cmd;
+	struct ib_uverbs_create_xrc_rcv_qp_resp resp;
+	struct ib_uxrc_rcv_qp_object   *obj;
+	struct ib_qp_init_attr		init_attr;
+	struct ib_xrcd		       *xrcd;
+	struct ib_uobject	       *uobj;
+	struct ib_uxrcd_object	       *xrcd_uobj;
+	u32				qp_num;
+	int				err;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	obj = kzalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd) {
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	init_attr.event_handler = ib_uverbs_xrc_rcv_qp_event_handler;
+	init_attr.qp_context	= file;
+	init_attr.srq		= NULL;
+	init_attr.sq_sig_type	=
+		cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
+	init_attr.qp_type	= IB_QPT_XRC;
+	init_attr.xrcd		= xrcd;
+
+	init_attr.cap.max_send_wr	= 1;
+	init_attr.cap.max_recv_wr	= 0;
+	init_attr.cap.max_send_sge	= 1;
+	init_attr.cap.max_recv_sge	= 0;
+	init_attr.cap.max_inline_data	= 0;
+
+	err = xrcd->device->create_xrc_rcv_qp(&init_attr, &qp_num);
+	if (err)
+		goto err_put;
+
+	memset(&resp, 0, sizeof resp);
+	resp.qpn = qp_num;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		err = -EFAULT;
+		goto err_destroy;
+	}
+
+	atomic_inc(&xrcd->usecnt);
+	put_uobj_read(uobj);
+	obj->qp_num = qp_num;
+	obj->domain_handle = cmd.xrcd_handle;
+	xrcd_uobj = container_of(uobj, struct ib_uxrcd_object, uobject);
+	atomic_inc(&xrcd_uobj->refcnt);
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->list, &file->ucontext->xrc_rcv_qp_list);
+	mutex_unlock(&file->mutex);
+
+	return in_len;
+
+err_destroy:
+	xrcd->device->destroy_xrc_rcv_qp(xrcd, file, qp_num);
+err_put:
+	put_uobj_read(uobj);
+err_out:
+	kfree(obj);
+	return err;
+}
+
+ssize_t ib_uverbs_modify_xrc_rcv_qp(struct ib_uverbs_file *file,
+				    const char __user *buf, int in_len,
+				    int out_len)
+{
+	struct ib_uverbs_modify_xrc_rcv_qp      cmd;
+	struct ib_qp_attr	       *attr;
+	struct ib_xrcd		       *xrcd;
+	struct ib_uobject	       *uobj;
+	int				err;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	attr = kzalloc(sizeof *attr, GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd) {
+		kfree(attr);
+		return -EINVAL;
+	}
+
+	attr->qp_state		  = cmd.qp_state;
+	attr->cur_qp_state	  = cmd.cur_qp_state;
+	attr->qp_access_flags	  = cmd.qp_access_flags;
+	attr->pkey_index	  = cmd.pkey_index;
+	attr->port_num		  = cmd.port_num;
+	attr->path_mtu		  = cmd.path_mtu;
+	attr->path_mig_state	  = cmd.path_mig_state;
+	attr->qkey		  = cmd.qkey;
+	attr->rq_psn		  = cmd.rq_psn;
+	attr->sq_psn		  = cmd.sq_psn;
+	attr->dest_qp_num	  = cmd.dest_qp_num;
+	attr->alt_pkey_index	  = cmd.alt_pkey_index;
+	attr->en_sqd_async_notify = cmd.en_sqd_async_notify;
+	attr->max_rd_atomic	  = cmd.max_rd_atomic;
+	attr->max_dest_rd_atomic  = cmd.max_dest_rd_atomic;
+	attr->min_rnr_timer	  = cmd.min_rnr_timer;
+	attr->port_num		  = cmd.port_num;
+	attr->timeout		  = cmd.timeout;
+	attr->retry_cnt		  = cmd.retry_cnt;
+	attr->rnr_retry		  = cmd.rnr_retry;
+	attr->alt_port_num	  = cmd.alt_port_num;
+	attr->alt_timeout	  = cmd.alt_timeout;
+
+	memcpy(attr->ah_attr.grh.dgid.raw, cmd.dest.dgid, 16);
+	attr->ah_attr.grh.flow_label	    = cmd.dest.flow_label;
+	attr->ah_attr.grh.sgid_index	    = cmd.dest.sgid_index;
+	attr->ah_attr.grh.hop_limit	    = cmd.dest.hop_limit;
+	attr->ah_attr.grh.traffic_class	    = cmd.dest.traffic_class;
+	attr->ah_attr.dlid		    = cmd.dest.dlid;
+	attr->ah_attr.sl		    = cmd.dest.sl;
+	attr->ah_attr.src_path_bits	    = cmd.dest.src_path_bits;
+	attr->ah_attr.static_rate	    = cmd.dest.static_rate;
+	attr->ah_attr.ah_flags		    = cmd.dest.is_global ? IB_AH_GRH : 0;
+	attr->ah_attr.port_num		    = cmd.dest.port_num;
+
+	memcpy(attr->alt_ah_attr.grh.dgid.raw, cmd.alt_dest.dgid, 16);
+	attr->alt_ah_attr.grh.flow_label    = cmd.alt_dest.flow_label;
+	attr->alt_ah_attr.grh.sgid_index    = cmd.alt_dest.sgid_index;
+	attr->alt_ah_attr.grh.hop_limit     = cmd.alt_dest.hop_limit;
+	attr->alt_ah_attr.grh.traffic_class = cmd.alt_dest.traffic_class;
+	attr->alt_ah_attr.dlid		    = cmd.alt_dest.dlid;
+	attr->alt_ah_attr.sl		    = cmd.alt_dest.sl;
+	attr->alt_ah_attr.src_path_bits	    = cmd.alt_dest.src_path_bits;
+	attr->alt_ah_attr.static_rate	    = cmd.alt_dest.static_rate;
+	attr->alt_ah_attr.ah_flags	    = cmd.alt_dest.is_global ? IB_AH_GRH : 0;
+	attr->alt_ah_attr.port_num	    = cmd.alt_dest.port_num;
+
+	err = xrcd->device->modify_xrc_rcv_qp(xrcd, cmd.qp_num, attr, cmd.attr_mask);
+	put_uobj_read(uobj);
+	kfree(attr);
+	return err ? err : in_len;
+}
+
+ssize_t ib_uverbs_query_xrc_rcv_qp(struct ib_uverbs_file *file,
+				   const char __user *buf, int in_len,
+				   int out_len)
+{
+	struct ib_uverbs_query_xrc_rcv_qp cmd;
+	struct ib_uverbs_query_qp_resp	 resp;
+	struct ib_qp_attr		*attr;
+	struct ib_qp_init_attr		*init_attr;
+	struct ib_xrcd			*xrcd;
+	struct ib_uobject		*uobj;
+	int				 ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	attr      = kmalloc(sizeof *attr, GFP_KERNEL);
+	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
+	if (!attr || !init_attr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = xrcd->device->query_xrc_rcv_qp(xrcd, cmd.qp_num, attr,
+					     cmd.attr_mask, init_attr);
+
+	put_uobj_read(uobj);
+
+	if (ret)
+		goto out;
+
+	memset(&resp, 0, sizeof resp);
+	resp.qp_state		    = attr->qp_state;
+	resp.cur_qp_state	    = attr->cur_qp_state;
+	resp.path_mtu		    = attr->path_mtu;
+	resp.path_mig_state	    = attr->path_mig_state;
+	resp.qkey		    = attr->qkey;
+	resp.rq_psn		    = attr->rq_psn;
+	resp.sq_psn		    = attr->sq_psn;
+	resp.dest_qp_num	    = attr->dest_qp_num;
+	resp.qp_access_flags	    = attr->qp_access_flags;
+	resp.pkey_index		    = attr->pkey_index;
+	resp.alt_pkey_index	    = attr->alt_pkey_index;
+	resp.sq_draining	    = attr->sq_draining;
+	resp.max_rd_atomic	    = attr->max_rd_atomic;
+	resp.max_dest_rd_atomic	    = attr->max_dest_rd_atomic;
+	resp.min_rnr_timer	    = attr->min_rnr_timer;
+	resp.port_num		    = attr->port_num;
+	resp.timeout		    = attr->timeout;
+	resp.retry_cnt		    = attr->retry_cnt;
+	resp.rnr_retry		    = attr->rnr_retry;
+	resp.alt_port_num	    = attr->alt_port_num;
+	resp.alt_timeout	    = attr->alt_timeout;
+
+	memcpy(resp.dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
+	resp.dest.flow_label	    = attr->ah_attr.grh.flow_label;
+	resp.dest.sgid_index	    = attr->ah_attr.grh.sgid_index;
+	resp.dest.hop_limit	    = attr->ah_attr.grh.hop_limit;
+	resp.dest.traffic_class	    = attr->ah_attr.grh.traffic_class;
+	resp.dest.dlid		    = attr->ah_attr.dlid;
+	resp.dest.sl		    = attr->ah_attr.sl;
+	resp.dest.src_path_bits	    = attr->ah_attr.src_path_bits;
+	resp.dest.static_rate	    = attr->ah_attr.static_rate;
+	resp.dest.is_global	    = !!(attr->ah_attr.ah_flags & IB_AH_GRH);
+	resp.dest.port_num	    = attr->ah_attr.port_num;
+
+	memcpy(resp.alt_dest.dgid, attr->alt_ah_attr.grh.dgid.raw, 16);
+	resp.alt_dest.flow_label    = attr->alt_ah_attr.grh.flow_label;
+	resp.alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
+	resp.alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
+	resp.alt_dest.traffic_class = attr->alt_ah_attr.grh.traffic_class;
+	resp.alt_dest.dlid	    = attr->alt_ah_attr.dlid;
+	resp.alt_dest.sl	    = attr->alt_ah_attr.sl;
+	resp.alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
+	resp.alt_dest.static_rate   = attr->alt_ah_attr.static_rate;
+	resp.alt_dest.is_global	    = !!(attr->alt_ah_attr.ah_flags & IB_AH_GRH);
+	resp.alt_dest.port_num	    = attr->alt_ah_attr.port_num;
+
+	resp.max_send_wr	    = init_attr->cap.max_send_wr;
+	resp.max_recv_wr	    = init_attr->cap.max_recv_wr;
+	resp.max_send_sge	    = init_attr->cap.max_send_sge;
+	resp.max_recv_sge	    = init_attr->cap.max_recv_sge;
+	resp.max_inline_data	    = init_attr->cap.max_inline_data;
+	resp.sq_sig_all		    = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp))
+		ret = -EFAULT;
+
+out:
+	kfree(attr);
+	kfree(init_attr);
+
+	return ret ? ret : in_len;
+}
+
+ssize_t ib_uverbs_reg_xrc_rcv_qp(struct ib_uverbs_file *file,
+				 const char __user *buf, int in_len,
+				 int out_len)
+{
+	struct ib_uverbs_reg_xrc_rcv_qp  cmd;
+	struct ib_uxrc_rcv_qp_object	*qp_obj, *tmp;
+	struct ib_xrcd			*xrcd;
+	struct ib_uobject		*uobj;
+	struct ib_uxrcd_object		*xrcd_uobj;
+	int				 ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	qp_obj = kmalloc(sizeof *qp_obj, GFP_KERNEL);
+	if (!qp_obj)
+		return -ENOMEM;
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	ret = xrcd->device->reg_xrc_rcv_qp(xrcd, file, cmd.qp_num);
+	if (ret)
+		goto err_put;
+
+	xrcd_uobj = container_of(uobj, struct ib_uxrcd_object, uobject);
+	atomic_inc(&xrcd_uobj->refcnt);
+	mutex_lock(&file->mutex);
+	list_for_each_entry(tmp, &file->ucontext->xrc_rcv_qp_list, list)
+		if ((cmd.qp_num == tmp->qp_num))  {
+			kfree(qp_obj);
+			mutex_unlock(&file->mutex);
+			put_uobj_read(uobj);
+			return in_len;
+		}
+	qp_obj->qp_num = cmd.qp_num;
+	qp_obj->domain_handle = cmd.xrcd_handle;
+	list_add_tail(&qp_obj->list, &file->ucontext->xrc_rcv_qp_list);
+	mutex_unlock(&file->mutex);
+	atomic_inc(&xrcd->usecnt);
+	put_uobj_read(uobj);
+	return in_len;
+
+err_put:
+	put_uobj_read(uobj);
+err_out:
+
+	kfree(qp_obj);
+	return ret;
+}
+
+int ib_uverbs_cleanup_xrc_rcv_qp(struct ib_uverbs_file *file,
+				 u32 xrcd_handle, u32 qp_num)
+{
+	struct ib_xrcd *xrcd;
+	struct ib_uobject *uobj;
+	struct ib_uxrcd_object *xrcd_uobj;
+	int err;
+
+	xrcd = idr_read_xrcd(xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd)
+		return -EINVAL;
+
+	if (!xrcd->device->destroy_xrc_rcv_qp &&
+	    !xrcd->device->unreg_xrc_rcv_qp) {
+		put_uobj_read(uobj);
+		return -ENOSYS;
+	}
+
+	if (xrcd->device->unreg_xrc_rcv_qp)
+		err = xrcd->device->unreg_xrc_rcv_qp(xrcd, file, qp_num);
+	else
+		err = xrcd->device->destroy_xrc_rcv_qp(xrcd, file, qp_num);
+
+	if (err) {
+		put_uobj_read(uobj);
+		return -EINVAL;
+	}
+	atomic_dec(&xrcd->usecnt);
+	xrcd_uobj = container_of(uobj, struct ib_uxrcd_object, uobject);
+	atomic_dec(&xrcd_uobj->refcnt);
+	put_uobj_read(uobj);
+	return 0;
+}
+
+ssize_t ib_uverbs_unreg_xrc_rcv_qp(struct ib_uverbs_file *file,
+				   const char __user *buf, int in_len,
+				   int out_len)
+{
+	struct ib_uverbs_unreg_xrc_rcv_qp cmd;
+	struct ib_uxrc_rcv_qp_object *qp_obj, *tmp;
+	struct ib_xrcd *xrcd;
+	struct ib_uobject *uobj;
+	struct ib_uxrcd_object *xrcd_uobj;
+	int ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd)
+		return -EINVAL;
+
+	ret = xrcd->device->unreg_xrc_rcv_qp(xrcd, file, cmd.qp_num);
+	if (ret) {
+		put_uobj_read(uobj);
+		return -EINVAL;
+	}
+	atomic_dec(&xrcd->usecnt);
+
+	xrcd_uobj = container_of(uobj, struct ib_uxrcd_object, uobject);
+	atomic_dec(&xrcd_uobj->refcnt);
+	mutex_lock(&file->mutex);
+	list_for_each_entry_safe(qp_obj, tmp,
+				 &file->ucontext->xrc_rcv_qp_list, list)
+		if ((cmd.qp_num == qp_obj->qp_num)) {
+			list_del(&qp_obj->list);
+			kfree(qp_obj);
+			break;
+		}
+	mutex_unlock(&file->mutex);
+	put_uobj_read(uobj);
+	return in_len;
+}
+
+ssize_t ib_uverbs_destroy_xrc_rcv_qp(struct ib_uverbs_file *file,
+				     const char __user *buf, int in_len,
+				     int out_len)
+{
+	struct ib_uverbs_destroy_xrc_rcv_qp cmd;
+	struct ib_uxrc_rcv_qp_object *qp_obj, *tmp;
+	struct ib_xrcd *xrcd;
+	struct ib_uobject *uobj;
+	struct ib_uxrcd_object *xrcd_uobj;
+	int ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	xrcd = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &uobj);
+	if (!xrcd)
+		return -EINVAL;
+
+	ret = xrcd->device->destroy_xrc_rcv_qp(xrcd, file, cmd.qp_num);
+	if (ret) {
+		put_uobj_read(uobj);
+		return -EINVAL;
+	}
+	atomic_dec(&xrcd->usecnt);
+
+	xrcd_uobj = container_of(uobj, struct ib_uxrcd_object, uobject);
+	atomic_dec(&xrcd_uobj->refcnt);
+	mutex_lock(&file->mutex);
+	list_for_each_entry_safe(qp_obj, tmp, &file->ucontext->xrc_rcv_qp_list,
+				 list)
+		if (cmd.qp_num == qp_obj->qp_num) {
+			list_del(&qp_obj->list);
+			kfree(qp_obj);
+			break;
+		}
+	mutex_unlock(&file->mutex);
+	put_uobj_read(uobj);
+	return in_len;
+}
+
+
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2b9d744..2a3c9b2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -113,6 +113,12 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_CREATE_XRC_SRQ]	= ib_uverbs_create_xrc_srq,
 	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
+	[IB_USER_VERBS_CMD_CREATE_XRC_RCV_QP]	= ib_uverbs_create_xrc_rcv_qp,
+	[IB_USER_VERBS_CMD_MODIFY_XRC_RCV_QP]	= ib_uverbs_modify_xrc_rcv_qp,
+	[IB_USER_VERBS_CMD_QUERY_XRC_RCV_QP]	= ib_uverbs_query_xrc_rcv_qp,
+	[IB_USER_VERBS_CMD_REG_XRC_RCV_QP]	= ib_uverbs_reg_xrc_rcv_qp,
+	[IB_USER_VERBS_CMD_UNREG_XRC_RCV_QP]	= ib_uverbs_unreg_xrc_rcv_qp,
+	[IB_USER_VERBS_CMD_DESTROY_XRC_RCV_QP]	= ib_uverbs_destroy_xrc_rcv_qp,
 };
 
 static struct vfsmount *uverbs_event_mnt;
@@ -250,6 +256,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	{
+		struct ib_uxrc_rcv_qp_object *obj, *x;
+		list_for_each_entry_safe(obj, x, &context->xrc_rcv_qp_list,
+					 list) {
+			ib_uverbs_cleanup_xrc_rcv_qp(file, obj->domain_handle,
+						     obj->qp_num);
+			list_del(&obj->list);
+			kfree(obj);
+		}
+	}
+
 	mutex_lock(&file->device->xrcd_tree_mutex);
 	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
 		struct ib_xrcd *xrcd = uobj->object;
@@ -505,6 +522,14 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 				NULL, NULL);
 }
 
+void ib_uverbs_xrc_rcv_qp_event_handler(struct ib_event *event,
+					void *context_ptr)
+{
+	ib_uverbs_async_handler(context_ptr, event->element.xrc_qp_num,
+				event->event, NULL, NULL);
+}
+
+
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					int is_async, int *fd)
 {
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index c9e540c..9b3fdac 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -84,7 +84,13 @@ enum {
 	IB_USER_VERBS_CMD_POST_SRQ_RECV,
 	IB_USER_VERBS_CMD_CREATE_XRC_SRQ,
 	IB_USER_VERBS_CMD_OPEN_XRCD,
-	IB_USER_VERBS_CMD_CLOSE_XRCD
+	IB_USER_VERBS_CMD_CLOSE_XRCD,
+	IB_USER_VERBS_CMD_CREATE_XRC_RCV_QP,
+	IB_USER_VERBS_CMD_MODIFY_XRC_RCV_QP,
+	IB_USER_VERBS_CMD_QUERY_XRC_RCV_QP,
+	IB_USER_VERBS_CMD_REG_XRC_RCV_QP,
+	IB_USER_VERBS_CMD_UNREG_XRC_RCV_QP,
+	IB_USER_VERBS_CMD_DESTROY_XRC_RCV_QP,
 };
 
 /*
@@ -719,4 +725,82 @@ struct ib_uverbs_close_xrcd {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_create_xrc_rcv_qp {
+	__u64 response;
+	__u64 user_handle;
+	__u32 xrcd_handle;
+	__u32 max_send_wr;
+	__u32 max_recv_wr;
+	__u32 max_send_sge;
+	__u32 max_recv_sge;
+	__u32 max_inline_data;
+	__u8  sq_sig_all;
+	__u8  qp_type;
+	__u8  reserved[6];
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_create_xrc_rcv_qp_resp {
+	__u32 qpn;
+	__u32 reserved;
+};
+
+struct ib_uverbs_modify_xrc_rcv_qp {
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	struct ib_uverbs_qp_dest dest;
+	struct ib_uverbs_qp_dest alt_dest;
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
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_query_xrc_rcv_qp {
+	__u64 response;
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	__u32 attr_mask;
+	__u32 reserved;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_reg_xrc_rcv_qp {
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_unreg_xrc_rcv_qp {
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_destroy_xrc_rcv_qp {
+	__u32 xrcd_handle;
+	__u32 qp_num;
+	__u64 driver_data[0];
+};
+
 #endif /* IB_USER_VERBS_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 322d145..75cbf2f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -344,12 +344,17 @@ enum ib_event_type {
 	IB_EVENT_CLIENT_REREGISTER
 };
 
+enum ib_event_flags {
+	IB_XRC_QP_EVENT_FLAG = 0x80000000,
+};
+
 struct ib_event {
 	struct ib_device	*device;
 	union {
 		struct ib_cq	*cq;
 		struct ib_qp	*qp;
 		struct ib_srq	*srq;
+		u32		xrc_qp_num;
 		u8		port_num;
 	} element;
 	enum ib_event_type	event;
@@ -819,6 +824,7 @@ struct ib_ucontext {
 	struct list_head	srq_list;
 	struct list_head	ah_list;
 	struct list_head	xrcd_list;
+	struct list_head	xrc_rcv_qp_list;
 	int			closing;
 };
 
@@ -852,6 +858,12 @@ struct ib_xrcd {
 	atomic_t		usecnt; /* count all resources */
 };
 
+struct ib_uxrc_rcv_qp_object {
+	struct list_head	list;		/* link to context's list */
+	u32			qp_num;
+	u32			domain_handle;
+};
+
 struct ib_ah {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
@@ -1154,6 +1166,26 @@ struct ib_device {
 						 struct ib_ucontext *context,
 						 struct ib_udata *udata);
 	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
+	int			   (*create_xrc_rcv_qp)(struct ib_qp_init_attr *init_attr,
+							u32 *qp_num);
+	int			   (*modify_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+							u32 qp_num,
+							struct ib_qp_attr *attr,
+							int attr_mask);
+	int			   (*query_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+						       u32 qp_num,
+						       struct ib_qp_attr *attr,
+						       int attr_mask,
+						       struct ib_qp_init_attr *init_attr);
+	int 			   (*reg_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+						     void *context,
+						     u32 qp_num);
+	int 			   (*unreg_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+						       void *context,
+						       u32 qp_num);
+	int 			   (*destroy_xrc_rcv_qp)(struct ib_xrcd *xrcd,
+							 void *context,
+							 u32 qp_num);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
-- 
1.6.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
