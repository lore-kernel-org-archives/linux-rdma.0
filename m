From: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] RDMA/core: Optimized path for kernel post_send/post_recv
Date: Thu, 24 Mar 2011 13:43:36 +0100
Message-ID: <20110324123937.19461.56781.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch introduces a new path of posting buffers from user-space to kernel
post_send/post_recv using shared page.

The shared page is allocated and defined by vendor driver.
The vendor driver during create QP decides when the new path will be used
setting a field use_shpage_for_rxtx field in connection context.

When the connection context indicates that the shared page  should be used
the uverbs_post_send()/uverbs_post_recv() calls directly the vendor driver
private post_send()/post_recv() functions improving the kernel path.

Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/uverbs_cmd.c |   55 +++++++++++++++++++++++++++-------
 include/rdma/ib_verbs.h              |    1 +
 2 files changed, 45 insertions(+), 11 deletions(-)


diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c426992..ba6655c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -299,6 +299,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	ucontext->closing = 0;
+	ucontext->use_shpage_for_rxtx = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
 
@@ -1448,15 +1449,31 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 
 	if (cmd.wqe_size < sizeof (struct ib_uverbs_send_wr))
 		return -EINVAL;
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	if (!qp)
+		goto out_raw_qp;
+
+	if (file->ucontext->use_shpage_for_rxtx) {
+		/* pass NULL pointers as the information about */
+		/* buffers is passed using endor defined shared page */
+		resp.bad_wr = 0;
+		ret = qp->device->post_send(qp, NULL, NULL);
+		if (ret)
+			resp.bad_wr = cmd.wr_count;
+
+		if (copy_to_user((void __user *) (unsigned long)
+				cmd.response,
+				&resp,
+				sizeof resp))
+			ret = -EFAULT;
+		put_qp_read(qp);
+		goto out_raw_qp;
+	}
 
 	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
 	if (!user_wr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
-	if (!qp)
-		goto out;
-
 	is_ud = qp->qp_type == IB_QPT_UD;
 	sg_ind = 0;
 	last = NULL;
@@ -1576,9 +1593,8 @@ out_put:
 		wr = next;
 	}
 
-out:
 	kfree(user_wr);
-
+out_raw_qp:
 	return ret ? ret : in_len;
 }
 
@@ -1680,16 +1696,33 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	if (!qp)
+		goto out_raw_qp;
+
+	if (file->ucontext->use_shpage_for_rxtx) {
+		resp.bad_wr = 0;
+		/* pass NULL pointers as the information about */
+		/* buffers is passed using endor defined shared page */
+		ret = qp->device->post_recv(qp, NULL, NULL);
+		if (ret)
+			resp.bad_wr = cmd.wr_count;
+
+		if (copy_to_user((void __user *) (unsigned long)
+				cmd.response,
+				&resp,
+				sizeof resp))
+			ret = -EFAULT;
+		put_qp_read(qp);
+		goto out_raw_qp;
+	}
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
-	if (!qp)
-		goto out;
-
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp, wr, &bad_wr);
 
@@ -1706,13 +1739,13 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 			 &resp, sizeof resp))
 		ret = -EFAULT;
 
-out:
 	while (wr) {
 		next = wr->next;
 		kfree(wr);
 		wr = next;
 	}
 
+out_raw_qp:
 	return ret ? ret : in_len;
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 55cd0a0..ab31c03 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -831,6 +831,7 @@ struct ib_ucontext {
 	struct list_head	srq_list;
 	struct list_head	ah_list;
 	int			closing;
+	int                     use_shpage_for_rxtx;
 };
 
 struct ib_uobject {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
