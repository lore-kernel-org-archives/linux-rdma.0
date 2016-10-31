From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Report mlx5 multi packet WQE capabilities when querying device
Date: Mon, 31 Oct 2016 12:15:21 +0200
Message-ID: <1477908921-12222-2-git-send-email-leon@kernel.org>
References: <1477908921-12222-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477908921-12222-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The capabilities whether hardware support multi packet WQE or not is
exposed to user space through query_device by uhw.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 include/uapi/rdma/mlx5-abi.h      |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2217477..9245b51 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -669,6 +669,17 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
 	}
 
+	if (field_avail(typeof(resp), mlx5_ib_support_multi_pkt_send_wqes,
+			uhw->outlen)) {
+		resp.mlx5_ib_support_multi_pkt_send_wqes =
+			MLX5_CAP_ETH(mdev, multi_pkt_send_wqe);
+		resp.response_length +=
+			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
+	}
+
+	if (field_avail(typeof(resp), reserved, uhw->outlen))
+		resp.response_length += sizeof(resp.reserved);
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index f5d0f4e..93d6b9f 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -129,6 +129,8 @@ struct mlx5_ib_query_device_resp {
 	__u32	response_length;
 	struct	mlx5_ib_tso_caps tso_caps;
 	struct	mlx5_ib_rss_caps rss_caps;
+	__u32	mlx5_ib_support_multi_pkt_send_wqes;
+	__u32	reserved;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
