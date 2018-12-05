From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/4] net/mlx5: Move flow counters data structures from flow steering header
Date: Tue,  4 Dec 2018 18:03:03 -0800
Message-ID: <20181205020303.16318-5-saeedm@mellanox.com>
References: <20181205020303.16318-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

After the following flow counters API refactoring:
("net/mlx5: Use flow counter IDs and not the wrapping cache object")
flow counters private data structures mlx5_fc_cache and mlx5_fc are
redundantly exposed in fs_core.h, they have nothing to do with flow
steering core and they are private to fs_counter.c, this patch moves them
to where they belong and reduces their exposure in the driver.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.h | 23 -------------------
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 23 +++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index b51ad217da32..2dc86347af58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -145,29 +145,6 @@ struct mlx5_flow_table {
 	struct rhltable			fgs_hash;
 };
 
-struct mlx5_fc_cache {
-	u64 packets;
-	u64 bytes;
-	u64 lastuse;
-};
-
-struct mlx5_fc {
-	struct list_head list;
-	struct llist_node addlist;
-	struct llist_node dellist;
-
-	/* last{packets,bytes} members are used when calculating the delta since
-	 * last reading
-	 */
-	u64 lastpackets;
-	u64 lastbytes;
-
-	u32 id;
-	bool aging;
-
-	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
-};
-
 struct mlx5_ft_underlay_qp {
 	struct list_head list;
 	u32 qpn;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 32accd6b041b..c6c28f56aa29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -41,6 +41,29 @@
 /* Max number of counters to query in bulk read is 32K */
 #define MLX5_SW_MAX_COUNTERS_BULK BIT(15)
 
+struct mlx5_fc_cache {
+	u64 packets;
+	u64 bytes;
+	u64 lastuse;
+};
+
+struct mlx5_fc {
+	struct list_head list;
+	struct llist_node addlist;
+	struct llist_node dellist;
+
+	/* last{packets,bytes} members are used when calculating the delta since
+	 * last reading
+	 */
+	u64 lastpackets;
+	u64 lastbytes;
+
+	u32 id;
+	bool aging;
+
+	struct mlx5_fc_cache cache ____cacheline_aligned_in_smp;
+};
+
 /* locking scheme:
  *
  * It is the responsibility of the user to prevent concurrent calls or bad
-- 
2.19.2
