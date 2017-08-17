From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 8/8] IB/mlx5: Report mlx5 enhanced multi packet WQE capability
Date: Thu, 17 Aug 2017 15:52:35 +0300
Message-ID: <20170817125235.5107-9-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose enhanced multi packet WQE capability to user space through
query_device by uhw.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++++
 include/linux/mlx5/mlx5_ifc.h     | 2 +-
 include/uapi/rdma/mlx5-abi.h      | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index aef1d8a0f4e4..06cdc279364d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -815,6 +815,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (MLX5_CAP_ETH(mdev, multi_pkt_send_wqe))
 			resp.mlx5_ib_support_multi_pkt_send_wqes =
 				MLX5_IB_ALLOW_MPW;
+
+		if (MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe))
+			resp.mlx5_ib_support_multi_pkt_send_wqes |=
+				MLX5_IB_SUPPORT_EMPW;
+
 		resp.response_length +=
 			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
 	}
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4334ce9fc803..6329348ff1d2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -604,7 +604,7 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         rss_ind_tbl_cap[0x4];
 	u8         reg_umr_sq[0x1];
 	u8         scatter_fcs[0x1];
-	u8         reserved_at_1a[0x1];
+	u8         enhanced_multi_pkt_send_wqe[0x1];
 	u8         tunnel_lso_const_out_ip_id[0x1];
 	u8         reserved_at_1c[0x2];
 	u8         tunnel_statless_gre[0x1];
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index a61a512e5747..1791bf123ba9 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -171,6 +171,7 @@ struct mlx5_packet_pacing_caps {
 enum mlx5_ib_mpw_caps {
 	MPW_RESERVED		= 1 << 0,
 	MLX5_IB_ALLOW_MPW	= 1 << 1,
+	MLX5_IB_SUPPORT_EMPW	= 1 << 2,
 };
 
 enum mlx5_ib_sw_parsing_offloads {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
