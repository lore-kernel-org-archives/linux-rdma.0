From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user verbs
Date: Tue, 27 Jun 2017 17:04:42 +0300
Message-ID: <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498572282-22370-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Most user verbs pass user data to the kernel with the inclusion of the
ib_uverbs_cmd_hdr structure. This is problematic because the vendor has
no ideas if the verb was called by a legacy verb or an extended verb.
Also, the incosistency between the verbs is confusing.

Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         | 70 ++++++++++++++++------------
 drivers/infiniband/hw/mlx5/cq.c              |  6 +--
 drivers/infiniband/hw/mlx5/main.c            | 11 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c |  2 +-
 4 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb1..c418a0a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -91,9 +91,10 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err;
 	}
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
 	if (ret)
@@ -313,9 +314,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+                   out_len - sizeof(resp));
 
 	uobj  = uobj_alloc(uobj_get_type(pd), file->ucontext);
 	if (IS_ERR(uobj))
@@ -482,9 +484,10 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof  resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+                   out_len - sizeof(resp));
 
 	mutex_lock(&file->device->xrcd_tree_mutex);
 
@@ -646,9 +649,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+                   out_len - sizeof(resp));
 
 	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
 		return -EINVAL;
@@ -740,7 +744,8 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 
 	INIT_UDATA(&udata, buf + sizeof(cmd),
 		   (unsigned long) cmd.response + sizeof(resp),
-		   in_len - sizeof(cmd), out_len - sizeof(resp));
+                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+                   out_len - sizeof(resp));
 
 	if (cmd.flags & ~IB_MR_REREG_SUPPORTED || !cmd.flags)
 		return -EINVAL;
@@ -1080,7 +1085,8 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 
 	INIT_UDATA(&uhw, buf + sizeof(cmd),
 		   (unsigned long)cmd.response + sizeof(resp),
-		   in_len - sizeof(cmd), out_len - sizeof(resp));
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	memset(&cmd_ex, 0, sizeof(cmd_ex));
 	cmd_ex.user_handle = cmd.user_handle;
@@ -1161,9 +1167,10 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
 	if (!cq)
@@ -1719,9 +1726,10 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	obj  = (struct ib_uqp_object *)uobj_alloc(uobj_get_type(qp),
 						  file->ucontext);
@@ -2038,7 +2046,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 		return -EOPNOTSUPP;
 
 	INIT_UDATA(&udata, buf + sizeof(cmd.base), NULL,
-		   in_len - sizeof(cmd.base), out_len);
+		   in_len - sizeof(cmd.base) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len);
 
 	ret = modify_qp(file, &cmd, &udata);
 	if (ret)
@@ -2543,7 +2552,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	INIT_UDATA(&udata, buf + sizeof(cmd),
 		   (unsigned long)cmd.response + sizeof(resp),
-		   in_len - sizeof(cmd), out_len - sizeof(resp));
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	uobj  = uobj_alloc(uobj_get_type(ah), file->ucontext);
 	if (IS_ERR(uobj))
@@ -3609,10 +3619,10 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	xcmd.max_sge	 = cmd.max_sge;
 	xcmd.srq_limit	 = cmd.srq_limit;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
-		   out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	ret = __uverbs_create_xsrq(file, ib_dev, &xcmd, &udata);
 	if (ret)
@@ -3636,10 +3646,10 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
-		   out_len - sizeof resp);
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long) cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof(resp));
 
 	ret = __uverbs_create_xsrq(file, ib_dev, &cmd, &udata);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 94c049b..619e265 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -751,10 +751,8 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	void *cqc;
 	int err;
 
-	ucmdlen =
-		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
-		 sizeof(ucmd)) ? (sizeof(ucmd) -
-				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+	ucmdlen = udata->inlen < sizeof(ucmd) ?
+		  (sizeof(ucmd) - sizeof(ucmd.reserved)) : sizeof(ucmd);
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen))
 		return -EFAULT;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9ecc089..906baf0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1211,7 +1211,6 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	struct mlx5_bfreg_info *bfregi;
 	int ver;
 	int err;
-	size_t reqlen;
 	size_t min_req_v2 = offsetof(struct mlx5_ib_alloc_ucontext_req_v2,
 				     max_cqe_version);
 	bool lib_uar_4k;
@@ -1219,18 +1218,14 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
 
-	if (udata->inlen < sizeof(struct ib_uverbs_cmd_hdr))
-		return ERR_PTR(-EINVAL);
-
-	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
-	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
+	if (udata->inlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
 		ver = 0;
-	else if (reqlen >= min_req_v2)
+	else if (udata->inlen >= min_req_v2)
 		ver = 2;
 	else
 		return ERR_PTR(-EINVAL);
 
-	err = ib_copy_from_udata(&req, udata, min(reqlen, sizeof(req)));
+	err = ib_copy_from_udata(&req, udata, min(udata->inlen, sizeof(req)));
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index c197cd9..1a222dc 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -914,7 +914,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int err = 0;
 	int write_mtt_size;
 
-	if (udata->inlen - sizeof (struct ib_uverbs_cmd_hdr) < sizeof ucmd) {
+	if (udata->inlen < sizeof ucmd) {
 		if (!to_mucontext(pd->uobject->context)->reg_mr_warned) {
 			mthca_warn(dev, "Process '%s' did not pass in MR attrs.\n",
 				   current->comm);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
