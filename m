From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Expose DC scatter to CQE capability bit
Date: Sun,  7 Oct 2018 12:03:34 +0300
Message-ID: <20181007090337.21037-2-leon@kernel.org>
References: <20181007090337.21037-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181007090337.21037-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

dc_req_scat_data_cqe capability bit determines
if requester scatter to cqe is available for 64 bytes CQE over
DC transport type.

Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 68f4d5f9d929..0f460fb22c31 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1005,7 +1005,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         umr_modify_atomic_disabled[0x1];
 	u8         umr_indirect_mkey_disabled[0x1];
 	u8         umr_fence[0x2];
-	u8         reserved_at_20c[0x3];
+	u8         dc_req_scat_data_cqe[0x1];
+	u8         reserved_at_20d[0x2];
 	u8         drain_sigerr[0x1];
 	u8         cmdif_checksum[0x2];
 	u8         sigerr_cqe[0x1];
-- 
2.14.4
