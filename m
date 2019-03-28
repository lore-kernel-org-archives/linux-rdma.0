From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 02/12] net/mlx5: E-Switch, add a new prio to be used by the RDMA side
Date: Thu, 28 Mar 2019 15:27:32 +0200
Message-ID: <20190328132742.12070-3-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Create a new prio in the FDB, it will be used when inserting steering rules
into the FDB from the RDMA side. We create a new PRIO so rules from the
net side and rules from the RDMA side won't be inserted to the same PRIO,
each side has it's own sandbox to play in.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 +++++++
 include/linux/mlx5/fs.h                           | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f34515d03a3b..f0b460879c91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2516,6 +2516,13 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	if (!steering->fdb_sub_ns)
 		return -ENOMEM;
 
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BYPASS_PATH,
+				  1);
+	if (IS_ERR(maj_prio)) {
+		err = PTR_ERR(maj_prio);
+		goto out_err;
+	}
+
 	levels = 2 * FDB_MAX_PRIO * (FDB_MAX_CHAIN + 1);
 	maj_prio = fs_create_prio_chained(&steering->fdb_root_ns->ns,
 					  FDB_FAST_PATH,
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 3eeb04154317..fd91df3a4e09 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -76,6 +76,7 @@ enum mlx5_flow_namespace_type {
 };
 
 enum {
+	FDB_BYPASS_PATH,
 	FDB_FAST_PATH,
 	FDB_SLOW_PATH,
 };
-- 
2.20.1
