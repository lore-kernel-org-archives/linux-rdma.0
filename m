From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v3 02/14] net/mlx5: Use flow counter pointer as input to the query function
Date: Thu, 31 May 2018 16:43:29 +0300
Message-ID: <20180531134341.18441-3-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

This allows to un-expose the details of struct mlx5_fc and keep
it internal to the core driver as it used to be.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c     | 15 ++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c |  4 ++--
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9a24314b817a..bb9665b7e8e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2104,21 +2104,18 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	struct mlx5_vport *vport = &esw->vports[vport_idx];
 	u64 rx_discard_vport_down, tx_discard_vport_down;
 	u64 bytes = 0;
-	u16 idx = 0;
 	int err = 0;
 
 	if (!vport->enabled || esw->mode != SRIOV_LEGACY)
 		return 0;
 
-	if (vport->egress.drop_counter) {
-		idx = vport->egress.drop_counter->id;
-		mlx5_fc_query(dev, idx, &stats->rx_dropped, &bytes);
-	}
+	if (vport->egress.drop_counter)
+		mlx5_fc_query(dev, vport->egress.drop_counter,
+			      &stats->rx_dropped, &bytes);
 
-	if (vport->ingress.drop_counter) {
-		idx = vport->ingress.drop_counter->id;
-		mlx5_fc_query(dev, idx, &stats->tx_dropped, &bytes);
-	}
+	if (vport->ingress.drop_counter)
+		mlx5_fc_query(dev, vport->ingress.drop_counter,
+			      &stats->tx_dropped, &bytes);
 
 	if (!MLX5_CAP_GEN(dev, receive_discard_vport_down) &&
 	    !MLX5_CAP_GEN(dev, transmit_discard_vport_down))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index b6da322a8016..d589dbbc72a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -233,7 +233,7 @@ void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      unsigned long delay);
 void mlx5_fc_update_sampling_interval(struct mlx5_core_dev *dev,
 				      unsigned long interval);
-int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
+int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes);
 
 int mlx5_init_fs(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b7ab929d5f8e..f5cb3fa5d8cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -312,10 +312,10 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	}
 }
 
-int mlx5_fc_query(struct mlx5_core_dev *dev, u16 id,
+int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes)
 {
-	return mlx5_cmd_fc_query(dev, id, packets, bytes);
+	return mlx5_cmd_fc_query(dev, counter->id, packets, bytes);
 }
 
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
-- 
2.14.3
