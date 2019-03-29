From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 12/14] net/mlx5: Add rate limit print macros
Date: Fri, 29 Mar 2019 15:38:02 -0700
Message-ID: <20190329223804.8954-13-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Aya Levin <ayal@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add rate limited print macros for warning and info level. This protects
the system from burst of prints depleting HW resources and spamming dmesg.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 052e81974c3b..d66f4f082ef7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -83,9 +83,19 @@ do {									\
 		      __func__, __LINE__, current->pid,			\
 		      ##__VA_ARGS__)
 
+#define mlx5_core_warn_rl(__dev, format, ...)				      \
+	pr_warn_ratelimited("%s:%s:%d:(pid %d): " format, (__dev)->priv.name, \
+			   __func__, __LINE__, current->pid,		      \
+			   ##__VA_ARGS__)
+
 #define mlx5_core_info(__dev, format, ...)				\
 	pr_info("%s " format, (__dev)->priv.name, ##__VA_ARGS__)
 
+#define mlx5_core_info_rl(__dev, format, ...)				      \
+	pr_info_ratelimited("%s:%s:%d:(pid %d): " format, (__dev)->priv.name, \
+			   __func__, __LINE__, current->pid,		      \
+			   ##__VA_ARGS__)
+
 enum {
 	MLX5_CMD_DATA, /* print command payload only */
 	MLX5_CMD_TIME, /* print command execution time */
-- 
2.20.1
