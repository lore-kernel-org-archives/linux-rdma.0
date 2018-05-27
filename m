From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Exposing a new mini-CQE format
Date: Sun, 27 May 2018 13:42:32 +0300
Message-ID: <20180527104234.17261-2-leon@kernel.org>
References: <20180527104234.17261-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180527104234.17261-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc@mellanox.com>

The new mini-CQE format includes byte-count, checksum
and stride index.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ee8e5a0d0acf..1ea2827e94be 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1160,7 +1160,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         flex_parser_protocols[0x20];
 	u8         reserved_at_560[0x20];
 
-	u8         reserved_at_580[0x3d];
+	u8         reserved_at_580[0x3c];
+	u8         mini_cqe_resp_stride_index[0x1];
 	u8         cqe_128_always[0x1];
 	u8         cqe_compression_128[0x1];
 	u8         cqe_compression[0x1];
-- 
2.14.3
