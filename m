From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 4/5] IB/mlx5: Add hca_core_clock_offset to udata in init_ucontext
Date: Thu,  3 Dec 2015 17:44:22 +0200
Message-ID: <1449157463-25313-5-git-send-email-matanb@mellanox.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449157463-25313-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pass hca_core_clock_offset to user-space is mandatory in order to
let the user-space read the free-running clock register from the
right offset in the memory mapped page.
Passing this value is done by changing the vendor's command
and response of init_ucontext to be in extensible form.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-By: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 37 ++++++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 +++
 drivers/infiniband/hw/mlx5/user.h    | 12 ++++++++++--
 include/linux/mlx5/device.h          |  7 +++++--
 4 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8aa0330..e4ce010 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -796,8 +796,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 						  struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	struct mlx5_ib_alloc_ucontext_req_v2 req;
-	struct mlx5_ib_alloc_ucontext_resp resp;
+	struct mlx5_ib_alloc_ucontext_req_v2 req = {};
+	struct mlx5_ib_alloc_ucontext_resp resp = {};
 	struct mlx5_ib_ucontext *context;
 	struct mlx5_uuar_info *uuari;
 	struct mlx5_uar *uars;
@@ -812,20 +812,19 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (!dev->ib_active)
 		return ERR_PTR(-EAGAIN);
 
-	memset(&req, 0, sizeof(req));
 	reqlen = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
 		ver = 0;
-	else if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
+	else if (reqlen >= sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
 		ver = 2;
 	else
 		return ERR_PTR(-EINVAL);
 
-	err = ib_copy_from_udata(&req, udata, reqlen);
+	err = ib_copy_from_udata(&req, udata, min(reqlen, sizeof(req)));
 	if (err)
 		return ERR_PTR(err);
 
-	if (req.flags || req.reserved)
+	if (req.flags)
 		return ERR_PTR(-EINVAL);
 
 	if (req.total_num_uuars > MLX5_MAX_UUARS)
@@ -834,6 +833,14 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (req.total_num_uuars == 0)
 		return ERR_PTR(-EINVAL);
 
+	if (req.comp_mask)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (reqlen > sizeof(req) &&
+	    !ib_is_udata_cleared(udata, '\0', sizeof(req),
+				 udata->inlen - sizeof(req)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	req.total_num_uuars = ALIGN(req.total_num_uuars,
 				    MLX5_NON_FP_BF_REGS_PER_PAGE);
 	if (req.num_low_latency_uuars > req.total_num_uuars - 1)
@@ -849,6 +856,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.max_send_wqebb = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_srq_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	resp.response_length = min(offsetof(typeof(resp), response_length) +
+				   sizeof(resp.response_length), udata->outlen);
 
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
@@ -899,8 +908,20 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	resp.tot_uuars = req.total_num_uuars;
 	resp.num_ports = MLX5_CAP_GEN(dev->mdev, num_ports);
-	err = ib_copy_to_udata(udata, &resp,
-			       sizeof(resp) - sizeof(resp.reserved));
+
+	if (field_avail(typeof(resp), reserved2, udata->outlen))
+		resp.response_length += sizeof(resp.reserved2);
+
+	if (field_avail(typeof(resp), hca_core_clock_offset, udata->outlen)) {
+		resp.comp_mask |=
+			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET;
+		resp.hca_core_clock_offset =
+			offsetof(struct mlx5_init_seg, internal_timer_h) %
+			PAGE_SIZE;
+		resp.response_length += sizeof(resp.hca_core_clock_offset);
+	}
+
+	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
 		goto out_uars;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b0deeb3..b2a6643 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -55,6 +55,9 @@ pr_err("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 pr_warn("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 	__LINE__, current->pid, ##arg)
 
+#define field_avail(type, fld, sz) (offsetof(type, fld) +		\
+				    sizeof(((type *)0)->fld) <= (sz))
+
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 76fb7b9..e22a35f 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -66,7 +66,11 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 	__u32	total_num_uuars;
 	__u32	num_low_latency_uuars;
 	__u32	flags;
-	__u32	reserved;
+	__u32	comp_mask;
+};
+
+enum mlx5_ib_alloc_ucontext_resp_mask {
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 };
 
 struct mlx5_ib_alloc_ucontext_resp {
@@ -80,7 +84,11 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	max_recv_wr;
 	__u32	max_srq_recv_wr;
 	__u16	num_ports;
-	__u16	reserved;
+	__u16	reserved1;
+	__u32	comp_mask;
+	__u32	response_length;
+	__u32	reserved2;
+	__u64	hca_core_clock_offset;
 };
 
 struct mlx5_ib_alloc_pd_resp {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 14b6e7e..841d7de 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -461,9 +461,12 @@ struct mlx5_init_seg {
 	__be32			cmd_dbell;
 	__be32			rsvd1[121];
 	struct health_buffer	health;
-	__be32			rsvd2[884];
+	__be32			rsvd2[880];
+	__be32			internal_timer_h;
+	__be32			internal_timer_l;
+	__be32			rsvd3[2];
 	__be32			health_counter;
-	__be32			rsvd3[1019];
+	__be32			rsvd4[1019];
 	__be64			ieee1588_clk;
 	__be32			ieee1588_clk_type;
 	__be32			clr_intx;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
