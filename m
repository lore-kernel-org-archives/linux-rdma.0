From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] IB/mlx5: Add CQ moderation capability to query_device
Date: Thu, 19 Oct 2017 08:35:24 +0300
Message-ID: <20171019053524.11135-7-leon@kernel.org>
References: <20171019053524.11135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019053524.11135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

query_device can now obtain the maximum values for
cq_max_count and cq_period, needed for cq moderation.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index da4c577d653c..61ce3ca503b8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -790,6 +790,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
+	if (MLX5_CAP_GEN(dev->mdev, cq_moderation)) {
+		props->cq_caps.max_cq_moderation_count =
+						MLX5_MAX_CQ_COUNT;
+		props->cq_caps.max_cq_moderation_period =
+						MLX5_MAX_CQ_PERIOD;
+	}
+
 	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
 		resp.cqe_comp_caps.max_num =
 			MLX5_CAP_GEN(dev->mdev, cqe_compression) ?
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
