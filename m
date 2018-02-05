From: Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 2/2] net/mlx5: fix affinity mask for completion vectors
Date: Mon,  5 Feb 2018 16:29:52 +0200
Message-ID: <1517840992-29813-2-git-send-email-maxg@mellanox.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, jgg@mellanox.com, sagi@grimberg.me
Cc: vladimirk@mellanox.com, Max Gurtovoy <maxg@mellanox.com>, stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Add an offset to ignore private mlx5 vectors.

Fixes: 05e0cc84e00c ("net/mlx5: Fix get vector affinity helper function")
Cc: <stable@vger.kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 include/linux/mlx5/driver.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a061042..9bab9d3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1229,6 +1229,7 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
+/* Returns the affinity mask of a completion vector */
 static inline const struct cpumask *
 mlx5_get_vector_affinity(struct mlx5_core_dev *dev, int vector)
 {
@@ -1238,7 +1239,7 @@ enum {
 	int eqn;
 	int err;
 
-	err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
+	err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, &irq);
 	if (err)
 		return NULL;
 
-- 
1.8.3.1
