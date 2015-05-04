From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 6/6] IB/uverbs: check access to userspace response buffer
Date: Mon,  4 May 2015 15:00:52 +0200
Message-ID: <00c9a22048840220d85c0d6136c83072fcf50054.1430743694.git.ydroneaud@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add checks like the one added in commit 6cc3df840a8
('IB/uverbs: Check access to userspace response buffer
in extended command'), check output buffers with
access_ok(VERIFY_WRITE,...) to ensure they are fully
in userspace memory: if the buffer or a subset of the
buffer is not valid, returns -EFAULT.

Each uverbs functions using a response buffer must have
the same check. This patch adds such checks.

Just like the check in read(2) syscall, it's a sanity
check to detect invalid parameters provided by userspace.
This particular check was added in vfs_read() by Linus
Torvalds for v2.6.12 with following commit message:

https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=fd770e66c9a65b14ce114e171266cf6f393df502

  Make read/write always do the full "access_ok()" tests.

  The actual user copy will do them too, but only for the
  range that ends up being actually copied. That hides
  bugs when the range has been clamped by file size or other
  issues.

Note: there's no need to check input buffer since vfs_write()
already does access_ok(VERIFY_READ, ...) as part of write()
syscall.

In order to check the output buffer in its entirety with
access_ok() to reject invalid request before any other checks,
this patch move the output size check after copy_from_user(),

It's going to slightly change the behavior of uverbs: an invalid
command partially not mapped, with a response size too short,
would return -EFAULT while previously it would have returned
-ENOSPC. Anyway, it makes more sense to return -EFAULT in such
case.

Applications using libibverbs are not going to be affected
by this patch, but unknown broken applications using directly
kernel uverbs API may fail.

Link: http://marc.info/?i=cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 225 +++++++++++++++++++++++------------
 1 file changed, 150 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 046ca87480e9..4fe77814c0e8 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -300,14 +300,17 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	mutex_lock(&file->mutex);
 
 	if (file->ucontext) {
@@ -464,14 +467,17 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	ret = ib_query_device(file->device->ib_dev, &attr);
 	if (ret)
 		return ret;
@@ -498,14 +504,17 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	ret = ib_query_port(file->device->ib_dev, cmd.port_num, &attr);
 	if (ret)
 		return ret;
@@ -555,14 +564,17 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -760,14 +772,17 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof  resp);
@@ -980,14 +995,17 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -1095,14 +1113,17 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 	if (in_len < sizeof(cmd))
 		return -EINVAL;
 
-	if (out_len < sizeof(resp))
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
 	response = (char __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof(cmd),
 		   response + sizeof(resp),
 		   in_len - sizeof(cmd), out_len - sizeof(resp));
@@ -1232,14 +1253,17 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	if (in_len < sizeof(cmd))
 		return -EINVAL;
 
-	if (out_len < sizeof(resp))
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof(resp))
+		return -ENOSPC;
+
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -1358,14 +1382,17 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0)
 		return ret;
@@ -1403,14 +1430,17 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -1507,14 +1537,17 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -1579,14 +1612,17 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if ((out_len - sizeof resp)/(sizeof(struct ib_uverbs_wc)) < cmd.ne)
 		return -ENOSPC;
 
@@ -1666,14 +1702,17 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	uobj = idr_write_uobj(&ib_uverbs_cq_idr, cmd.cq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
@@ -1732,14 +1771,17 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
 
@@ -1927,14 +1969,17 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -2024,14 +2069,17 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	attr      = kmalloc(sizeof *attr, GFP_KERNEL);
 	init_attr = kmalloc(sizeof *init_attr, GFP_KERNEL);
 	if (!attr || !init_attr) {
@@ -2245,14 +2293,17 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	memset(&resp, 0, sizeof resp);
 
 	uobj = idr_write_uobj(&ib_uverbs_qp_idr, cmd.qp_handle, file->ucontext);
@@ -2313,14 +2364,17 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	if (in_len < sizeof cmd + cmd.wqe_size * cmd.wr_count +
 	    cmd.sge_count * sizeof (struct ib_uverbs_sge))
 		return -EINVAL;
@@ -2562,14 +2616,17 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2619,14 +2676,17 @@ ssize_t ib_uverbs_post_srq_recv(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
@@ -2678,14 +2738,17 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -3282,14 +3345,17 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	xcmd.response	 = cmd.response;
 	xcmd.user_handle = cmd.user_handle;
 	xcmd.srq_type	 = IB_SRQT_BASIC;
@@ -3321,14 +3387,17 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
@@ -3387,14 +3456,17 @@ ssize_t ib_uverbs_query_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	srq = idr_read_srq(cmd.srq_handle, file->ucontext);
 	if (!srq)
 		return -EINVAL;
@@ -3435,14 +3507,17 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (in_len < sizeof cmd)
 		return -EINVAL;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
-
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	response = (void __user *)(unsigned long)cmd.response;
 
+	if (!access_ok(VERIFY_WRITE, response, out_len))
+		return -EFAULT;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
 	uobj = idr_write_uobj(&ib_uverbs_srq_idr, cmd.srq_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
