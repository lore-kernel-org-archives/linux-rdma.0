From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 08/10] IB/mlx5: Fill XRQ capabilities
Date: Sun, 28 Aug 2016 14:00:48 +0300
Message-ID: <1472382050-25908-9-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide driver specific values for XRQ capabilities

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 13 +++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 77ca218..692a687 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -594,6 +594,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (!mlx5_core_is_pf(mdev))
 		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
 
+	props->xrq_caps.max_unexpected_tags =
+		1 << MLX5_CAP_GEN(mdev, log_max_srq_sz);
+	props->xrq_caps.tag_mask_length  = MLX5_TM_TAG_SIZE;
+	props->xrq_caps.header_size      = MLX5_TM_HEADER_SIZE;
+	props->xrq_caps.app_context_size = MLX5_TM_APP_CTX_SIZE;
+	props->xrq_caps.max_match_list   =
+		1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz);
+	props->xrq_caps.capability_flags = IBV_NO_TAG |
+					   IBV_EAGER_EXPECTED |
+					   IBV_EAGER_UNEXPECTED |
+					   IBV_RNDV_EXPECTED_RC |
+					   IBV_RNDV_UNEXPECTED;
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a59034a..1c204d7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -105,6 +105,12 @@ enum {
 	MLX5_CQE_VERSION_V1,
 };
 
+enum {
+	MLX5_TM_TAG_SIZE		= 64,
+	MLX5_TM_HEADER_SIZE		= 16,
+	MLX5_TM_APP_CTX_SIZE		= 32,
+};
+
 struct mlx5_ib_vma_private_data {
 	struct list_head list;
 	struct vm_area_struct *vma;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
