From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 for-3.13 01/10] IB/uverbs: move cast from u64 to void __user pointer to it's own variable
Date: Tue, 17 Dec 2013 10:58:50 +0100
Message-ID: <29d85a8ef9d8fabf0980afd4f1d4dccab019bf33.1387273677.git.ydroneaud@opteya.com>
References: <cover.1387273677.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use a dedicated variable to hold address of the response buffer after
'conversion' from u64 to void __user *, so that this value could be used for
INIT_UDATA() and copy_to_user(), reducing the visual clutter introduced by
the cast.

This variable will be used when implicit cast will be removed from
INIT_UDATA() macro, which is required in order to remove a sparse warning.

Link: http://marc.info/?i=cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 158 +++++++++++++++++++++++------------
 1 file changed, 104 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 65f6e7dc380c..971e16c970b9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -285,6 +285,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
+	char __user			 *response;
 	struct ib_udata                   udata;
 	struct ib_device                 *ibdev = file->device->ib_dev;
 	struct ib_ucontext		 *ucontext;
@@ -297,6 +298,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	mutex_lock(&file->mutex);
 
 	if (file->ucontext) {
@@ -305,7 +308,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
@@ -339,8 +342,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_fd;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_file;
 	}
@@ -383,6 +385,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_device      cmd;
 	struct ib_uverbs_query_device_resp resp;
+	char __user			  *response;
 	struct ib_device_attr              attr;
 	int                                ret;
 
@@ -392,6 +395,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = ib_query_device(file->device->ib_dev, &attr);
 	if (ret)
 		return ret;
@@ -439,8 +444,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	resp.local_ca_ack_delay        = attr.local_ca_ack_delay;
 	resp.phys_port_cnt	       = file->device->ib_dev->phys_port_cnt;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -452,6 +456,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_port      cmd;
 	struct ib_uverbs_query_port_resp resp;
+	char __user			*response;
 	struct ib_port_attr              attr;
 	int                              ret;
 
@@ -461,6 +466,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = ib_query_port(file->device->ib_dev, cmd.port_num, &attr);
 	if (ret)
 		return ret;
@@ -489,8 +496,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
 							cmd.port_num);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -502,6 +508,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_alloc_pd      cmd;
 	struct ib_uverbs_alloc_pd_resp resp;
+	char __user		      *response;
 	struct ib_udata                udata;
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
@@ -513,8 +520,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
@@ -543,8 +552,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -696,6 +704,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_open_xrcd	cmd;
 	struct ib_uverbs_open_xrcd_resp	resp;
+	char __user		       *response;
 	struct ib_udata			udata;
 	struct ib_uxrcd_object         *obj;
 	struct ib_xrcd                 *xrcd = NULL;
@@ -710,8 +719,10 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof  resp);
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
@@ -783,8 +794,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		atomic_inc(&xrcd->usecnt);
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -910,6 +920,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_reg_mr      cmd;
 	struct ib_uverbs_reg_mr_resp resp;
+	char __user		    *response;
 	struct ib_udata              udata;
 	struct ib_uobject           *uobj;
 	struct ib_pd                *pd;
@@ -922,8 +933,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
@@ -969,8 +982,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	resp.rkey      = mr->rkey;
 	resp.mr_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1045,6 +1057,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_alloc_mw      cmd;
 	struct ib_uverbs_alloc_mw_resp resp;
+	char __user		      *response;
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
 	struct ib_mw                  *mw;
@@ -1056,6 +1069,8 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -1089,8 +1104,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	resp.rkey      = mw->rkey;
 	resp.mw_handle = uobj->id;
 
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp))) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1165,6 +1179,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
+	char __user				  *response;
 	struct file				  *filp;
 	int ret;
 
@@ -1174,6 +1189,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0)
 		return ret;
@@ -1185,8 +1202,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 		return PTR_ERR(filp);
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		put_unused_fd(resp.fd);
 		fput(filp);
 		return -EFAULT;
@@ -1202,6 +1218,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_cq      cmd;
 	struct ib_uverbs_create_cq_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_ucq_object           *obj;
 	struct ib_uverbs_event_file    *ev_file = NULL;
@@ -1214,8 +1231,10 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	if (cmd.comp_vector >= file->device->num_comp_vectors)
@@ -1266,8 +1285,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	resp.cq_handle = obj->uobject.id;
 	resp.cqe       = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1303,6 +1321,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_resize_cq	cmd;
 	struct ib_uverbs_resize_cq_resp	resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
@@ -1310,8 +1329,10 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
@@ -1324,8 +1345,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 
 	resp.cqe = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp.cqe))
+	if (copy_to_user(response, &resp, sizeof(resp.cqe)))
 		ret = -EFAULT;
 
 out:
@@ -1439,6 +1459,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_cq      cmd;
 	struct ib_uverbs_destroy_cq_resp resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_cq               	*cq;
 	struct ib_ucq_object        	*obj;
@@ -1448,6 +1469,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -1478,8 +1501,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -1491,6 +1513,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_qp      cmd;
 	struct ib_uverbs_create_qp_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_device	       *device;
@@ -1512,8 +1535,10 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	obj = kzalloc(sizeof *obj, GFP_KERNEL);
@@ -1626,8 +1651,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	resp.max_send_wr     = attr.cap.max_send_wr;
 	resp.max_inline_data = attr.cap.max_inline_data;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1685,6 +1709,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_open_qp        cmd;
 	struct ib_uverbs_create_qp_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_xrcd		       *xrcd;
@@ -1699,8 +1724,10 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
@@ -1742,8 +1769,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	resp.qpn       = qp->qp_num;
 	resp.qp_handle = obj->uevent.uobject.id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_remove;
 	}
@@ -1780,6 +1806,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_qp      cmd;
 	struct ib_uverbs_query_qp_resp resp;
+	char __user		       *response;
 	struct ib_qp                   *qp;
 	struct ib_qp_attr              *attr;
 	struct ib_qp_init_attr         *init_attr;
@@ -1788,6 +1815,8 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	attr      = kmalloc(sizeof *attr, GFP_KERNEL);
 	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
 	if (!attr || !init_attr) {
@@ -1863,8 +1892,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.max_inline_data        = init_attr->cap.max_inline_data;
 	resp.sq_sig_all             = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -1986,6 +2014,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_qp      cmd;
 	struct ib_uverbs_destroy_qp_resp resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_qp               	*qp;
 	struct ib_uqp_object        	*obj;
@@ -1994,6 +2023,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	memset(&resp, 0, sizeof resp);
 
 	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
@@ -2031,8 +2062,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -2044,6 +2074,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_send      cmd;
 	struct ib_uverbs_post_send_resp resp;
+	char __user		       *response;
 	struct ib_uverbs_send_wr       *user_wr;
 	struct ib_send_wr              *wr = NULL, *last, *next, *bad_wr;
 	struct ib_qp                   *qp;
@@ -2061,6 +2092,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (cmd.wqe_size < sizeof (struct ib_uverbs_send_wr))
 		return -EINVAL;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
 	if (!user_wr)
 		return -ENOMEM;
@@ -2176,8 +2209,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out_put:
@@ -2288,6 +2320,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_recv      cmd;
 	struct ib_uverbs_post_recv_resp resp;
+	char __user		       *response;
 	struct ib_recv_wr              *wr, *next, *bad_wr;
 	struct ib_qp                   *qp;
 	ssize_t                         ret = -EINVAL;
@@ -2295,6 +2328,8 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2317,8 +2352,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -2337,6 +2371,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_srq_recv      cmd;
 	struct ib_uverbs_post_srq_recv_resp resp;
+	char __user			   *response;
 	struct ib_recv_wr                  *wr, *next, *bad_wr;
 	struct ib_srq                      *srq;
 	ssize_t                             ret = -EINVAL;
@@ -2344,6 +2379,8 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2366,8 +2403,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -2386,6 +2422,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_ah	 cmd;
 	struct ib_uverbs_create_ah_resp	 resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
@@ -2398,6 +2435,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -2438,8 +2477,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	resp.ah_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -2823,6 +2861,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 				struct ib_udata *udata)
 {
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_usrq_object           *obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
@@ -2830,6 +2869,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
+	response = (void __user *)(unsigned long)cmd->response;
+
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
@@ -2905,8 +2946,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (cmd->srq_type == IB_SRQT_XRC)
 		resp.srqn = srq->ext.xrc.srq_num;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd->response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -2958,6 +2998,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_srq      cmd;
 	struct ib_uverbs_create_xsrq     xcmd;
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_udata                  udata;
 	int ret;
 
@@ -2967,6 +3008,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	xcmd.response	 = cmd.response;
 	xcmd.user_handle = cmd.user_handle;
 	xcmd.srq_type	 = IB_SRQT_BASIC;
@@ -2976,7 +3019,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	xcmd.srq_limit	 = cmd.srq_limit;
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, &xcmd, &udata);
@@ -2991,6 +3034,7 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_xsrq     cmd;
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_udata                  udata;
 	int ret;
 
@@ -3000,8 +3044,10 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, &cmd, &udata);
@@ -3047,6 +3093,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_srq      cmd;
 	struct ib_uverbs_query_srq_resp resp;
+	char __user		       *response;
 	struct ib_srq_attr              attr;
 	struct ib_srq                   *srq;
 	int                             ret;
@@ -3057,6 +3104,8 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
@@ -3074,8 +3123,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	resp.max_sge   = attr.max_sge;
 	resp.srq_limit = attr.srq_limit;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -3087,6 +3135,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_srq      cmd;
 	struct ib_uverbs_destroy_srq_resp resp;
+	char __user			 *response;
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
 	struct ib_uevent_object        	 *obj;
@@ -3097,6 +3146,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -3131,8 +3182,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 	return ret ? ret : in_len;
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
