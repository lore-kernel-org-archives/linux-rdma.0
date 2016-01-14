From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 03/13] IB/mlx5: Expose CQE version to user-space
Date: Thu, 14 Jan 2016 19:12:58 +0200
Message-ID: <1452791588-19895-4-git-send-email-majd@mellanox.com>
References: <1452791588-19895-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452791588-19895-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Per user context, work with CQE version that both the user-space
and the kernel support. Report this CQE version via the response of
the alloc_ucontext command.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 15 +++++++++++----
 drivers/infiniband/hw/mlx5/user.h |  8 +++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b02bf8d..c874c09 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -868,7 +868,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (req.total_num_uuars == 0)
 		return ERR_PTR(-EINVAL);
 
-	if (req.comp_mask)
+	if (req.comp_mask || req.reserved0 || req.reserved1 || req.reserved2)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (reqlen > sizeof(req) &&
@@ -891,6 +891,9 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.max_send_wqebb = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_srq_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	resp.cqe_version = min_t(__u8,
+				 (__u8)MLX5_CAP_GEN(dev->mdev, cqe_version),
+				 req.max_cqe_version);
 	resp.response_length = min(offsetof(typeof(resp), response_length) +
 				   sizeof(resp.response_length), udata->outlen);
 
@@ -944,8 +947,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.tot_uuars = req.total_num_uuars;
 	resp.num_ports = MLX5_CAP_GEN(dev->mdev, num_ports);
 
-	if (field_avail(typeof(resp), reserved2, udata->outlen))
-		resp.response_length += sizeof(resp.reserved2);
+	if (field_avail(typeof(resp), cqe_version, udata->outlen))
+		resp.response_length += sizeof(resp.cqe_version);
 
 	if (field_avail(typeof(resp), hca_core_clock_offset, udata->outlen)) {
 		resp.comp_mask |=
@@ -953,7 +956,9 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 		resp.hca_core_clock_offset =
 			offsetof(struct mlx5_init_seg, internal_timer_h) %
 			PAGE_SIZE;
-		resp.response_length += sizeof(resp.hca_core_clock_offset);
+		resp.response_length += sizeof(resp.hca_core_clock_offset) +
+					sizeof(resp.reserved2) +
+					sizeof(resp.reserved3);
 	}
 
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
@@ -964,6 +969,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	uuari->num_low_latency_uuars = req.num_low_latency_uuars;
 	uuari->uars = uars;
 	uuari->num_uars = num_uars;
+	context->cqe_version = resp.cqe_version;
+
 	return &context->ibucontext;
 
 out_uars:
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 5bf0935..41f0525 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -69,6 +69,10 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 	__u32	num_low_latency_uuars;
 	__u32	flags;
 	__u32	comp_mask;
+	__u8	max_cqe_version;
+	__u8	reserved0;
+	__u16	reserved1;
+	__u32	reserved2;
 };
 
 enum mlx5_ib_alloc_ucontext_resp_mask {
@@ -89,7 +93,9 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u16	reserved1;
 	__u32	comp_mask;
 	__u32	response_length;
-	__u32	reserved2;
+	__u8	cqe_version;
+	__u8	reserved2;
+	__u16	reserved3;
 	__u64	hca_core_clock_offset;
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
