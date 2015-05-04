From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv1 4/6] IB/uverbs: subtract command header from input size
Date: Mon,  4 May 2015 15:00:50 +0200
Message-ID: <7fde9269b66548f6eabcc3d1d30f8438e8a10069.1430743694.git.ydroneaud@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The uverbs handler functions are given a pointer
to the command buffer, which point right after the
command header.

But the size given to the function is the total size,
including the command header size.

The size of the command header must be subtracted
from the input length before calling the uverbs handler
function so that the parameters are in par.

This patch makes ib_uverbs_write() subtract the header
size from the total size when calling uverbs function.

As the return value from the uverbs function will
be the size without the header (or a negative value),
it must not be used as-is. Instead the function use
the total size as return value when no error occurred.

Additionally, drivers (mthca, mlx5) taking the size
of command header in account in their size checks are
modified accordingly.

This patch is a pre-requisite to make bound checking
effective.

Link: http://marc.info/?i=cover.1430743694.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c        | 18 +++++++++++++-----
 drivers/infiniband/hw/mlx5/cq.c              |  6 ++----
 drivers/infiniband/hw/mlx5/main.c            |  2 +-
 drivers/infiniband/hw/mlx5/srq.c             |  6 ++----
 drivers/infiniband/hw/mthca/mthca_provider.c |  2 +-
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 88cce9bb72fe..6ab287c6693c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -601,6 +601,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_cmd_hdr hdr;
+	const size_t written_count = count;
 	__u32 flags;
 
 	if (count < sizeof hdr)
@@ -614,6 +615,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 
 	if (!flags) {
 		__u32 command;
+		ssize_t err;
 
 		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
 					   IB_USER_VERBS_CMD_COMMAND_MASK))
@@ -635,10 +637,17 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		if (hdr.in_words * 4 != count)
 			return -EINVAL;
 
-		return uverbs_cmd_table[command](file,
-						 buf + sizeof(hdr),
-						 hdr.in_words * 4,
-						 hdr.out_words * 4);
+		count -= sizeof(hdr);
+		buf += sizeof(hdr);
+
+		err = uverbs_cmd_table[command](file,
+						buf,
+						count,
+						hdr.out_words * 4);
+		if (err < 0)
+			return err;
+
+		return written_count;
 
 	} else if (flags == IB_USER_VERBS_CMD_FLAG_EXTENDED) {
 		__u32 command;
@@ -647,7 +656,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_udata ucore;
 		struct ib_udata uhw;
 		int err;
-		size_t written_count = count;
 
 		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
 					   IB_USER_VERBS_CMD_COMMAND_MASK))
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 2ee6b1051975..3b38febf685e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -613,10 +613,8 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	int ncont;
 	int err;
 
-	ucmdlen =
-		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
-		 sizeof(ucmd)) ? (sizeof(ucmd) -
-				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+	ucmdlen = (udata->inlen < sizeof(ucmd)) ?
+	    (sizeof(ucmd) - sizeof(ucmd.reserved)) : sizeof(ucmd);
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen))
 		return -EFAULT;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 57c9809e8b87..d951bb9a89a3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -408,7 +408,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		return ERR_PTR(-EAGAIN);
 
 	memset(&req, 0, sizeof(req));
-	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
+	reqlen = udata->inlen;
 	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
 		ver = 0;
 	else if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 02d77a29764d..c342bd47e168 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -86,10 +86,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	int ncont;
 	u32 offset;
 
-	ucmdlen =
-		(udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) <
-		 sizeof(ucmd)) ? (sizeof(ucmd) -
-				  sizeof(ucmd.reserved)) : sizeof(ucmd);
+	ucmdlen = (udata->inlen < sizeof(ucmd)) ?
+	    (sizeof(ucmd) - sizeof(ucmd.reserved)) : sizeof(ucmd);
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
 		mlx5_ib_dbg(dev, "failed copy udata\n");
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1a54db..e5933b032fc3 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -986,7 +986,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int err = 0;
 	int write_mtt_size;
 
-	if (udata->inlen - sizeof (struct ib_uverbs_cmd_hdr) < sizeof ucmd) {
+	if (udata->inlen < sizeof ucmd) {
 		if (!to_mucontext(pd->uobject->context)->reg_mr_warned) {
 			mthca_warn(dev, "Process '%s' did not pass in MR attrs.\n",
 				   current->comm);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
