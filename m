From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/6] net/mlx5: Use lowercase 'X' for hex values
Date: Wed, 12 Dec 2018 19:11:36 -0800
Message-ID: <20181213031141.12783-2-saeedm@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Apparently gcc is cool with upper case '0X' but it is not commonly used.
Replace '0X' with lowercase '0x' in mlx5_ifc.h file.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 60c1d49eb40c..a56bd3b1f579 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3865,16 +3865,16 @@ enum {
 };
 
 enum mlx5_monitor_counter_ppcnt {
-	MLX5_QUERY_MONITOR_PPCNT_IN_RANGE_LENGTH_ERRORS      = 0X0,
-	MLX5_QUERY_MONITOR_PPCNT_OUT_OF_RANGE_LENGTH_FIELD   = 0X1,
-	MLX5_QUERY_MONITOR_PPCNT_FRAME_TOO_LONG_ERRORS       = 0X2,
-	MLX5_QUERY_MONITOR_PPCNT_FRAME_CHECK_SEQUENCE_ERRORS = 0X3,
-	MLX5_QUERY_MONITOR_PPCNT_ALIGNMENT_ERRORS            = 0X4,
-	MLX5_QUERY_MONITOR_PPCNT_IF_OUT_DISCARDS             = 0X5,
+	MLX5_QUERY_MONITOR_PPCNT_IN_RANGE_LENGTH_ERRORS      = 0x0,
+	MLX5_QUERY_MONITOR_PPCNT_OUT_OF_RANGE_LENGTH_FIELD   = 0x1,
+	MLX5_QUERY_MONITOR_PPCNT_FRAME_TOO_LONG_ERRORS       = 0x2,
+	MLX5_QUERY_MONITOR_PPCNT_FRAME_CHECK_SEQUENCE_ERRORS = 0x3,
+	MLX5_QUERY_MONITOR_PPCNT_ALIGNMENT_ERRORS            = 0x4,
+	MLX5_QUERY_MONITOR_PPCNT_IF_OUT_DISCARDS             = 0x5,
 };
 
 enum {
-	MLX5_QUERY_MONITOR_Q_COUNTER_RX_OUT_OF_BUFFER     = 0X4,
+	MLX5_QUERY_MONITOR_Q_COUNTER_RX_OUT_OF_BUFFER     = 0x4,
 };
 
 struct mlx5_ifc_monitor_counter_output_bits {
@@ -4780,7 +4780,7 @@ enum {
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_OUTER_HEADERS    = 0x0,
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS  = 0x1,
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_INNER_HEADERS    = 0x2,
-	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2 = 0X3,
+	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2 = 0x3,
 };
 
 struct mlx5_ifc_query_flow_group_out_bits {
-- 
2.19.2
