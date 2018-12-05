From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 4/4] net/mlx5: Move flow counters data structures from flow steering header
Date: Wed,  5 Dec 2018 15:08:10 -0800
Message-ID: <20181205230810.1886-5-saeedm@mellanox.com>
References: <20181205230810.1886-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205230810.1886-1-saeedm@mellanox.com>
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
 .../net/ethernet/mellanox/mlx5/core/fs_core.h | 24 -------------------
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 24 +++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index b51ad217da32..186566b521f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -36,7 +36,6 @@
 #include <linux/refcount.h>
 #include <linux/mlx5/fs.h>
 #include <linux/rhashtable.h>
-#include <linux/llist.h>
 
 /* FS_TYPE_PRIO_CHAINS is a PRIO that will have namespaces only,
  * and those are in parallel to one another when going over them to connect
@@ -145,29 +144,6 @@ struct mlx5_flow_table {
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
index 32accd6b041b..b2574c28defa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -33,6 +33,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include <linux/rbtree.h>
+#include <linux/llist.h>
 #include "mlx5_core.h"
 #include "fs_core.h"
 #include "fs_cmd.h"
@@ -41,6 +42,29 @@
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
