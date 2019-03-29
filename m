From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/14] net/mlx5: Make mlx5_core messages independent from mdev->pdev
Date: Fri, 29 Mar 2019 15:37:58 -0700
Message-ID: <20190329223804.8954-9-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>, Vu Pham <vuhuong@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Detach mlx5_core mdev messages from pci device mdev->pdev messages and
provide a better report/debug of different mlx5 device types.

This patch does not change any functionality.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 7b331674622c..052e81974c3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -48,12 +48,12 @@
 extern uint mlx5_core_debug_mask;
 
 #define mlx5_core_dbg(__dev, format, ...)				\
-	dev_dbg(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,		\
+	pr_debug("%s:%s:%d:(pid %d): " format, (__dev)->priv.name,      \
 		 __func__, __LINE__, current->pid,			\
 		 ##__VA_ARGS__)
 
 #define mlx5_core_dbg_once(__dev, format, ...)				\
-	dev_dbg_once(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
+	pr_debug_once("%s:%s:%d:(pid %d): " format, (__dev)->priv.name, \
 		     __func__, __LINE__, current->pid,			\
 		     ##__VA_ARGS__)
 
@@ -64,28 +64,27 @@ do {									\
 } while (0)
 
 #define mlx5_core_err(__dev, format, ...)				\
-	dev_err(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
+	pr_err("%s:%s:%d:(pid %d): " format, (__dev)->priv.name,        \
 		__func__, __LINE__, current->pid,	\
 	       ##__VA_ARGS__)
 
-#define mlx5_core_err_rl(__dev, format, ...)				\
-	dev_err_ratelimited(&(__dev)->pdev->dev,			\
-			   "%s:%d:(pid %d): " format,			\
-			   __func__, __LINE__, current->pid,		\
+#define mlx5_core_err_rl(__dev, format, ...)				     \
+	pr_err_ratelimited("%s:%s:%d:(pid %d): " format, (__dev)->priv.name, \
+			   __func__, __LINE__, current->pid,		     \
 			   ##__VA_ARGS__)
 
 #define mlx5_core_warn(__dev, format, ...)				\
-	dev_warn(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
+	pr_warn("%s:%s:%d:(pid %d): " format, (__dev)->priv.name,       \
 		 __func__, __LINE__, current->pid,			\
 		##__VA_ARGS__)
 
 #define mlx5_core_warn_once(__dev, format, ...)				\
-	dev_warn_once(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
+	pr_warn_once("%s:%s:%d:(pid %d): " format, (__dev)->priv.name,  \
 		      __func__, __LINE__, current->pid,			\
 		      ##__VA_ARGS__)
 
 #define mlx5_core_info(__dev, format, ...)				\
-	dev_info(&(__dev)->pdev->dev, format, ##__VA_ARGS__)
+	pr_info("%s " format, (__dev)->priv.name, ##__VA_ARGS__)
 
 enum {
 	MLX5_CMD_DATA, /* print command payload only */
-- 
2.20.1
