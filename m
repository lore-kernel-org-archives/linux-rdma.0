From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 1/3] IB/mlx5: Define interface bits for IPoIB offloads
Date: Sun, 21 Feb 2016 16:27:16 +0200
Message-ID: <1456064838-31710-2-git-send-email-eranbe@mellanox.com>
References: <1456064838-31710-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456064838-31710-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The HW can supply several offloads for UD QP, added  offloads for
checksumming for both TX and RX and LSO for TX.
Two new bits were added in order to expose and enable these offloads:
1. HCA capability bit: declares the support for IPoIB basic offloads.
2. QPC bit which will be used in the QP creation flow, which set these
abilities in the QP.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 51f1e54..7d73492 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -736,7 +736,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cqe_version[0x4];
 
 	u8         compact_address_vector[0x1];
-	u8         reserved_at_200[0xe];
+	u8         reserved_at_200[0x3];
+	u8         ipoib_basic_offloads[0x1];
+	u8         reserved_at_204[0xa];
 	u8         drain_sigerr[0x1];
 	u8         cmdif_checksum[0x2];
 	u8         sigerr_cqe[0x1];
@@ -1780,7 +1782,7 @@ struct mlx5_ifc_qpc_bits {
 	u8         log_sq_size[0x4];
 	u8         reserved_at_55[0x6];
 	u8         rlky[0x1];
-	u8         reserved_at_5c[0x4];
+	u8         ulp_stateless_offload_mode[0x4];
 
 	u8         counter_set_id[0x8];
 	u8         uar_page[0x18];
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
