From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Add hardware definitions for dump_fill_mkey
Date: Tue, 19 Jun 2018 08:47:23 +0300
Message-ID: <20180619054724.32677-3-leon@kernel.org>
References: <20180619054724.32677-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180619054724.32677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

MLX5 IB HCA offers the memory key, dump_fill_mkey to boost
performance by forcing local HCA operations to skip the PCI bus
access,

This patch adds needed hardware definitions.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 00b539303f5d..b4302ccb63a6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -889,7 +889,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_eq_sz[0x8];
 	u8         reserved_at_e8[0x2];
 	u8         log_max_mkey[0x6];
-	u8         reserved_at_f0[0xc];
+	u8         reserved_at_f0[0x8];
+	u8         dump_fill_mkey[0x1];
+	u8         reserved_at_fa[0x3];
 	u8         log_max_eq[0x4];
 
 	u8         max_indirection[0x8];
-- 
2.14.4
