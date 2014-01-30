From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] IB/mlx5: Fix binary compatibility with libmlx5
Date: Thu, 30 Jan 2014 13:49:48 +0200
Message-ID: <1391082588-29077-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit c1be5232d21d "Fix micro UAR allocator" broke binary compatibility
between libmlx5 and mlx5_ib since it defines a different value to the number of
micro UARs per page, leading to wrong calculation in libmlx5. This patch
defines struct mlx5_ib_alloc_ucontext_req_v2 as an extension to struct
mlx5_ib_alloc_ucontext_req.  The extended size is determined in
mlx5_ib_alloc_ucontext() and in case of old library we use uuarn 0 which works
fine -- this is acheived due to create_user_qp() falling back from high to
medium then to low class where low class will return 0. For new libraries we
use the more sophisticated allocation algorithm.

Fixes: c1be5232d21d ('Fix micro UAR allocator')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes from v1:
Use 12 digit hash code as required
Fix mlx5_ib_alloc_ucontext to subtract the size of struct ib_uverbs_cmd_hdr)
Improve change log documentation
Remove whitesapce

 drivers/infiniband/hw/mlx5/main.c | 19 +++++++++++++++++--
 drivers/infiniband/hw/mlx5/qp.c   | 10 ++++++++--
 drivers/infiniband/hw/mlx5/user.h |  7 +++++++
 include/linux/mlx5/driver.h       |  1 +
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9660d093f8cf..f4ef4a24d410 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -536,24 +536,38 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 						  struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	struct mlx5_ib_alloc_ucontext_req req;
+	struct mlx5_ib_alloc_ucontext_req_v2 req;
 	struct mlx5_ib_alloc_ucontext_resp resp;
 	struct mlx5_ib_ucontext *context;
 	struct mlx5_uuar_info *uuari;
 	struct mlx5_uar *uars;
 	int gross_uuars;
 	int num_uars;
+	int ver;
 	int uuarn;
 	int err;
 	int i;
+	int reqlen;
 
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
 
-	err = ib_copy_from_udata(&req, udata, sizeof(req));
+	memset(&req, 0, sizeof(req));
+	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
+	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
+		ver = 0;
+	else if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
+		ver = 2;
+	else
+		return ERR_PTR(-EINVAL);
+
+	err = ib_copy_from_udata(&req, udata, reqlen);
 	if (err)
 		return ERR_PTR(err);
 
+	if (req.flags || req.reserved)
+		return ERR_PTR(-EINVAL);
+
 	if (req.total_num_uuars > MLX5_MAX_UUARS)
 		return ERR_PTR(-ENOMEM);
 
@@ -626,6 +640,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (err)
 		goto out_uars;
 
+	uuari->ver = ver;
 	uuari->num_low_latency_uuars = req.num_low_latency_uuars;
 	uuari->uars = uars;
 	uuari->num_uars = num_uars;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 492dc330e907..091576a777e9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -430,11 +430,17 @@ static int alloc_uuar(struct mlx5_uuar_info *uuari,
 		break;
 
 	case MLX5_IB_LATENCY_CLASS_MEDIUM:
-		uuarn = alloc_med_class_uuar(uuari);
+		if (uuari->ver < 2)
+			uuarn = -ENOMEM;
+		else
+			uuarn = alloc_med_class_uuar(uuari);
 		break;
 
 	case MLX5_IB_LATENCY_CLASS_HIGH:
-		uuarn = alloc_high_class_uuar(uuari);
+		if (uuari->ver < 2)
+			uuarn = -ENOMEM;
+		else
+			uuarn = alloc_high_class_uuar(uuari);
 		break;
 
 	case MLX5_IB_LATENCY_CLASS_FAST_PATH:
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 32a2a5dfc523..0f4f8e42a17f 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -62,6 +62,13 @@ struct mlx5_ib_alloc_ucontext_req {
 	__u32	num_low_latency_uuars;
 };
 
+struct mlx5_ib_alloc_ucontext_req_v2 {
+	__u32	total_num_uuars;
+	__u32	num_low_latency_uuars;
+	__u32	flags;
+	__u32	reserved;
+};
+
 struct mlx5_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
 	__u32	bf_reg_size;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 554548cd3dd4..32cb18c399c2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -227,6 +227,7 @@ struct mlx5_uuar_info {
 	 * protect uuar allocation data structs
 	 */
 	struct mutex		lock;
+	u32			ver;
 };
 
 struct mlx5_bf {
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
