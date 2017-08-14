From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 08/11] IB/mlx5: Fill XRQ capabilities
Date: Mon, 14 Aug 2017 16:53:49 +0300
Message-ID: <20170814135352.5324-9-leon@kernel.org>
References: <20170814135352.5324-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170814135352.5324-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide driver specific values for XRQ capabilities.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 10 ++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 387d90ad8ec1..c72c33e2b65f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -777,6 +777,16 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
 	}
 
+	if (MLX5_CAP_GEN(mdev, tag_matching)) {
+		props->xrq_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
+		props->xrq_caps.max_num_tags =
+			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
+		props->xrq_caps.flags = IB_TM_CAP_RC;
+		props->xrq_caps.max_ops =
+			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+		props->xrq_caps.max_sge = MLX5_TM_MAX_SGE;
+	}
+
 	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
 		resp.cqe_comp_caps.max_num =
 			MLX5_CAP_GEN(dev->mdev, cqe_compression) ?
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7ac991070020..76a731f39d2b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -107,6 +107,11 @@ enum {
 	MLX5_CQE_VERSION_V1,
 };
 
+enum {
+	MLX5_TM_MAX_RNDV_MSG_SIZE	= 64,
+	MLX5_TM_MAX_SGE			= 1,
+};
+
 struct mlx5_ib_vma_private_data {
 	struct list_head list;
 	struct vm_area_struct *vma;
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
