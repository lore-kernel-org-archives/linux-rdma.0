From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v5 01/17] net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap
Date: Tue,  2 Jul 2019 13:02:30 +0300
Message-ID: <20190702100246.17382-2-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add rts2rts_qp_counters_set_id field in hca cap so that RTS2RTS
qp modification can be used to change the counter of a QP.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e3c154b573a2..16348528fef6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1028,7 +1028,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cc_modify_allowed[0x1];
 	u8         start_pad[0x1];
 	u8         cache_line_128byte[0x1];
-	u8         reserved_at_165[0xa];
+	u8         reserved_at_165[0x4];
+	u8         rts2rts_qp_counters_set_id[0x1];
+	u8         reserved_at_16a[0x5];
 	u8         qcam_reg[0x1];
 	u8         gid_table_size[0x10];
 
-- 
2.20.1
