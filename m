From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 5/6] IB/uverbs: move cast from u64 to void __user pointer to its own variable
Date: Mon,  4 May 2015 15:00:51 +0200
Message-ID: <b6429847b72958a0fc5c3d37c31cebf24445a152.1430743694.git.ydroneaud@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use a dedicated variable to hold address of the response buffer after
conversion (aka. cast) from u64 to void __user *, so that this value
could be used for INIT_UDATA(), copy_to_user() or access_ok(), reducing
the visual clutter introduced by the multiple casts.

This variable will be used for multiple purposes:
- check pointer / size validity with access_ok()
- setup ib_udata through INIT_UDATA()
- in copy_to_user()

When implicit cast will be removed from INIT_UDATA() macro,
this variable will be used so that the address will be stored
in pointer and will not trigger warnings from compiler.

Link: http://marc.info/?i=cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c  | 175 ++++++++++++++++++++++------------
 drivers/infiniband/core/uverbs_main.c |  11 ++-
 2 files changed, 121 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 147f61c8692b..046ca87480e9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -287,6 +287,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_get_context      cmd;
 	struct ib_uverbs_get_context_resp resp;
+	char __user			 *response;
 	struct ib_udata                   udata;
 	struct ib_device                 *ibdev = file->device->ib_dev;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
@@ -305,6 +306,8 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	mutex_lock(&file->mutex);
 
 	if (file->ucontext) {
@@ -313,7 +316,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	}
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
@@ -364,8 +367,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_fd;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_file;
 	}
@@ -455,6 +457,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_device      cmd;
 	struct ib_uverbs_query_device_resp resp;
+	char __user			  *response;
 	struct ib_device_attr              attr;
 	int                                ret;
 
@@ -467,6 +470,8 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = ib_query_device(file->device->ib_dev, &attr);
 	if (ret)
 		return ret;
@@ -474,8 +479,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	copy_query_dev_fields(file, &resp, &attr);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -487,6 +491,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_port      cmd;
 	struct ib_uverbs_query_port_resp resp;
+	char __user			*response;
 	struct ib_port_attr              attr;
 	int                              ret;
 
@@ -499,6 +504,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = ib_query_port(file->device->ib_dev, cmd.port_num, &attr);
 	if (ret)
 		return ret;
@@ -527,8 +534,7 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
 							cmd.port_num);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -540,6 +546,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_alloc_pd      cmd;
 	struct ib_uverbs_alloc_pd_resp resp;
+	char __user		      *response;
 	struct ib_udata                udata;
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
@@ -554,8 +561,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
@@ -584,8 +593,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	resp.pd_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -740,6 +748,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_open_xrcd	cmd;
 	struct ib_uverbs_open_xrcd_resp	resp;
+	char __user		       *response;
 	struct ib_udata			udata;
 	struct ib_uxrcd_object         *obj;
 	struct ib_xrcd                 *xrcd = NULL;
@@ -757,8 +766,10 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof  resp);
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
@@ -830,8 +841,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 		atomic_inc(&xrcd->usecnt);
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -960,6 +970,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_reg_mr      cmd;
 	struct ib_uverbs_reg_mr_resp resp;
+	char __user		    *response;
 	struct ib_udata              udata;
 	struct ib_uobject           *uobj;
 	struct ib_pd                *pd;
@@ -975,8 +986,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
@@ -1034,8 +1047,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	resp.rkey      = mr->rkey;
 	resp.mr_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1072,6 +1084,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_rereg_mr      cmd;
 	struct ib_uverbs_rereg_mr_resp resp;
+	char __user                   *response;
 	struct ib_udata              udata;
 	struct ib_pd                *pd = NULL;
 	struct ib_mr                *mr;
@@ -1088,8 +1101,10 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
+	response = (char __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof(cmd),
-		   (unsigned long) cmd.response + sizeof(resp),
+		   response + sizeof(resp),
 		   in_len - sizeof(cmd), out_len - sizeof(resp));
 
 	if (cmd.flags & ~IB_MR_REREG_SUPPORTED || !cmd.flags)
@@ -1145,8 +1160,7 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	resp.lkey      = mr->lkey;
 	resp.rkey      = mr->rkey;
 
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp)))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 	else
 		ret = in_len;
@@ -1209,6 +1223,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_alloc_mw      cmd;
 	struct ib_uverbs_alloc_mw_resp resp;
+	char __user		      *response;
 	struct ib_uobject             *uobj;
 	struct ib_pd                  *pd;
 	struct ib_mw                  *mw;
@@ -1223,6 +1238,8 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -1256,8 +1273,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	resp.rkey      = mw->rkey;
 	resp.mw_handle = uobj->id;
 
-	if (copy_to_user((void __user *)(unsigned long)cmd.response,
-			 &resp, sizeof(resp))) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1335,6 +1351,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_comp_channel	   cmd;
 	struct ib_uverbs_create_comp_channel_resp  resp;
+	char __user				  *response;
 	struct file				  *filp;
 	int ret;
 
@@ -1347,6 +1364,8 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0)
 		return ret;
@@ -1358,8 +1377,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 		return PTR_ERR(filp);
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		put_unused_fd(resp.fd);
 		fput(filp);
 		return -EFAULT;
@@ -1375,6 +1393,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_cq      cmd;
 	struct ib_uverbs_create_cq_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_ucq_object           *obj;
 	struct ib_uverbs_event_file    *ev_file = NULL;
@@ -1390,8 +1409,10 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	if (cmd.comp_vector >= file->device->num_comp_vectors)
@@ -1442,8 +1463,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	resp.cq_handle = obj->uobject.id;
 	resp.cqe       = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1479,6 +1499,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_resize_cq	cmd;
 	struct ib_uverbs_resize_cq_resp	resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
@@ -1492,8 +1513,10 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
@@ -1506,8 +1529,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 
 	resp.cqe = cq->cqe;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp.cqe))
+	if (copy_to_user(response, &resp, sizeof(resp.cqe)))
 		ret = -EFAULT;
 
 out:
@@ -1548,7 +1570,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_poll_cq       cmd;
 	struct ib_uverbs_poll_cq_resp  resp;
-	u8 __user                     *header_ptr;
+	char __user		      *response;
 	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
 	struct ib_wc                   wc;
@@ -1563,6 +1585,8 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	if ((out_len - sizeof resp)/(sizeof(struct ib_uverbs_wc)) < cmd.ne)
 		return -ENOSPC;
 
@@ -1571,8 +1595,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
-	header_ptr = (void __user *)(unsigned long) cmd.response;
-	data_ptr = header_ptr + sizeof resp;
+	data_ptr = response + sizeof resp;
 
 	memset(&resp, 0, sizeof resp);
 	while (resp.count < cmd.ne) {
@@ -1590,7 +1613,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 		++resp.count;
 	}
 
-	if (copy_to_user(header_ptr, &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto out_put;
 	}
@@ -1633,6 +1656,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_cq      cmd;
 	struct ib_uverbs_destroy_cq_resp resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_cq               	*cq;
 	struct ib_ucq_object        	*obj;
@@ -1648,6 +1672,8 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -1678,8 +1704,7 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -1691,6 +1716,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_qp      cmd;
 	struct ib_uverbs_create_qp_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_device	       *device;
@@ -1712,11 +1738,13 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	obj = kzalloc(sizeof *obj, GFP_KERNEL);
@@ -1829,8 +1857,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	resp.max_send_wr     = attr.cap.max_send_wr;
 	resp.max_inline_data = attr.cap.max_inline_data;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -1888,6 +1915,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_open_qp        cmd;
 	struct ib_uverbs_create_qp_resp resp;
+	char __user		       *response;
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_xrcd		       *xrcd;
@@ -1905,8 +1933,10 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
@@ -1948,8 +1978,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	resp.qpn       = qp->qp_num;
 	resp.qp_handle = obj->uevent.uobject.id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_remove;
 	}
@@ -1986,6 +2015,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_qp      cmd;
 	struct ib_uverbs_query_qp_resp resp;
+	char __user		       *response;
 	struct ib_qp                   *qp;
 	struct ib_qp_attr              *attr;
 	struct ib_qp_init_attr         *init_attr;
@@ -2000,6 +2030,8 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	attr      = kmalloc(sizeof *attr, GFP_KERNEL);
 	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
 	if (!attr || !init_attr) {
@@ -2075,8 +2107,7 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.max_inline_data        = init_attr->cap.max_inline_data;
 	resp.sq_sig_all             = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -2205,6 +2236,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_qp      cmd;
 	struct ib_uverbs_destroy_qp_resp resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_qp               	*qp;
 	struct ib_uqp_object        	*obj;
@@ -2219,6 +2251,8 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	memset(&resp, 0, sizeof resp);
 
 	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
@@ -2256,8 +2290,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -2269,6 +2302,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_send      cmd;
 	struct ib_uverbs_post_send_resp resp;
+	char __user		       *response;
 	struct ib_uverbs_send_wr       *user_wr;
 	struct ib_send_wr              *wr = NULL, *last, *next, *bad_wr;
 	struct ib_qp                   *qp;
@@ -2285,6 +2319,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	if (in_len < sizeof cmd + cmd.wqe_size * cmd.wr_count +
 	    cmd.sge_count * sizeof (struct ib_uverbs_sge))
 		return -EINVAL;
@@ -2407,8 +2443,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out_put:
@@ -2519,6 +2554,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_recv      cmd;
 	struct ib_uverbs_post_recv_resp resp;
+	char __user		       *response;
 	struct ib_recv_wr              *wr, *next, *bad_wr;
 	struct ib_qp                   *qp;
 	ssize_t                         ret = -EINVAL;
@@ -2532,6 +2568,8 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2554,8 +2592,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -2574,6 +2611,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_post_srq_recv      cmd;
 	struct ib_uverbs_post_srq_recv_resp resp;
+	char __user			   *response;
 	struct ib_recv_wr                  *wr, *next, *bad_wr;
 	struct ib_srq                      *srq;
 	ssize_t                             ret = -EINVAL;
@@ -2587,6 +2625,8 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2609,8 +2649,7 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 				break;
 		}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 out:
@@ -2629,6 +2668,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_ah	 cmd;
 	struct ib_uverbs_create_ah_resp	 resp;
+	char __user			*response;
 	struct ib_uobject		*uobj;
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
@@ -2644,6 +2684,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -2686,8 +2728,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	resp.ah_handle = uobj->id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -3097,6 +3138,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 				struct ib_udata *udata)
 {
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_usrq_object           *obj;
 	struct ib_pd                    *pd;
 	struct ib_srq                   *srq;
@@ -3104,6 +3146,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	struct ib_srq_init_attr          attr;
 	int ret;
 
+	response = (void __user *)(unsigned long)cmd->response;
+
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
@@ -3179,8 +3223,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (cmd->srq_type == IB_SRQT_XRC)
 		resp.srqn = srq->ext.xrc.srq_num;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd->response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user(response, &resp, sizeof(resp))) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -3232,6 +3275,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_srq      cmd;
 	struct ib_uverbs_create_xsrq     xcmd;
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_udata                  udata;
 	int ret;
 
@@ -3244,6 +3288,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	xcmd.response	 = cmd.response;
 	xcmd.user_handle = cmd.user_handle;
 	xcmd.srq_type	 = IB_SRQT_BASIC;
@@ -3253,7 +3299,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	xcmd.srq_limit	 = cmd.srq_limit;
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, &xcmd, &udata);
@@ -3268,6 +3314,7 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_create_xsrq     cmd;
 	struct ib_uverbs_create_srq_resp resp;
+	char __user			*response;
 	struct ib_udata                  udata;
 	int ret;
 
@@ -3280,8 +3327,10 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
+		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, &cmd, &udata);
@@ -3330,6 +3379,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_query_srq      cmd;
 	struct ib_uverbs_query_srq_resp resp;
+	char __user		       *response;
 	struct ib_srq_attr              attr;
 	struct ib_srq                   *srq;
 	int                             ret;
@@ -3343,6 +3393,8 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
@@ -3360,8 +3412,7 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	resp.max_sge   = attr.max_sge;
 	resp.srq_limit = attr.srq_limit;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		return -EFAULT;
 
 	return in_len;
@@ -3373,6 +3424,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 {
 	struct ib_uverbs_destroy_srq      cmd;
 	struct ib_uverbs_destroy_srq_resp resp;
+	char __user			 *response;
 	struct ib_uobject		 *uobj;
 	struct ib_srq               	 *srq;
 	struct ib_uevent_object        	 *obj;
@@ -3389,6 +3441,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	response = (void __user *)(unsigned long)cmd.response;
+
 	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -3423,8 +3477,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp))
+	if (copy_to_user(response, &resp, sizeof(resp)))
 		ret = -EFAULT;
 
 	return ret ? ret : in_len;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 6ab287c6693c..24225d32aa55 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -653,6 +653,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		__u32 command;
 
 		struct ib_uverbs_ex_cmd_hdr ex_hdr;
+		char __user *response;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
 		int err;
@@ -688,12 +689,14 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		if (ex_hdr.cmd_hdr_reserved)
 			return -EINVAL;
 
-		if (ex_hdr.response) {
+		response = (char __user *)(unsigned long)ex_hdr.response;
+
+		if (response) {
 			if (!hdr.out_words && !ex_hdr.provider_out_words)
 				return -EINVAL;
 
 			if (!access_ok(VERIFY_WRITE,
-				       (void __user *) (unsigned long) ex_hdr.response,
+				       response,
 				       (hdr.out_words + ex_hdr.provider_out_words) * 8))
 				return -EFAULT;
 		} else {
@@ -701,12 +704,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 				return -EINVAL;
 		}
 
-		INIT_UDATA_BUF_OR_NULL(&ucore, buf, (unsigned long) ex_hdr.response,
+		INIT_UDATA_BUF_OR_NULL(&ucore, buf, response,
 				       hdr.in_words * 8, hdr.out_words * 8);
 
 		INIT_UDATA_BUF_OR_NULL(&uhw,
 				       buf + ucore.inlen,
-				       (unsigned long) ex_hdr.response + ucore.outlen,
+				       response + ucore.outlen,
 				       ex_hdr.provider_in_words * 8,
 				       ex_hdr.provider_out_words * 8);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
