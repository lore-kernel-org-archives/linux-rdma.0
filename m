From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V3 02/11] net/mlx5: E-Switch, Refactor load/unload of representors
Date: Fri, 29 Dec 2017 01:23:05 +0200
Message-ID: <20171228232314.13678-3-saeedm@mellanox.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171228232314.13678-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Refactor the load/unload stages for better code reuse.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 66 +++++++++++++---------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7e15854c1087..26fbc50ddc6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -767,12 +767,47 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 	return 0;
 }
 
-int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
+static void esw_offloads_unload_reps(struct mlx5_eswitch *esw, int nvports)
+{
+	struct mlx5_eswitch_rep *rep;
+	int vport;
+
+	for (vport = nvports - 1; vport >= 0; vport--) {
+		rep = &esw->offloads.vport_reps[vport];
+		if (!rep->valid)
+			continue;
+
+		rep->unload(esw, rep);
+	}
+}
+
+static int esw_offloads_load_reps(struct mlx5_eswitch *esw, int nvports)
 {
 	struct mlx5_eswitch_rep *rep;
 	int vport;
 	int err;
 
+	for (vport = 0; vport < nvports; vport++) {
+		rep = &esw->offloads.vport_reps[vport];
+		if (!rep->valid)
+			continue;
+
+		err = rep->load(esw, rep);
+		if (err)
+			goto err_reps;
+	}
+
+	return 0;
+
+err_reps:
+	esw_offloads_unload_reps(esw, vport);
+	return err;
+}
+
+int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
+{
+	int err;
+
 	/* disable PF RoCE so missed packets don't go through RoCE steering */
 	mlx5_dev_list_lock();
 	mlx5_remove_dev_by_protocol(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
@@ -790,25 +825,13 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
 	if (err)
 		goto create_fg_err;
 
-	for (vport = 0; vport < nvports; vport++) {
-		rep = &esw->offloads.vport_reps[vport];
-		if (!rep->valid)
-			continue;
-
-		err = rep->load(esw, rep);
-		if (err)
-			goto err_reps;
-	}
+	err = esw_offloads_load_reps(esw, nvports);
+	if (err)
+		goto err_reps;
 
 	return 0;
 
 err_reps:
-	for (vport--; vport >= 0; vport--) {
-		rep = &esw->offloads.vport_reps[vport];
-		if (!rep->valid)
-			continue;
-		rep->unload(esw, rep);
-	}
 	esw_destroy_vport_rx_group(esw);
 
 create_fg_err:
@@ -849,16 +872,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw)
 
 void esw_offloads_cleanup(struct mlx5_eswitch *esw, int nvports)
 {
-	struct mlx5_eswitch_rep *rep;
-	int vport;
-
-	for (vport = nvports - 1; vport >= 0; vport--) {
-		rep = &esw->offloads.vport_reps[vport];
-		if (!rep->valid)
-			continue;
-		rep->unload(esw, rep);
-	}
-
+	esw_offloads_unload_reps(esw, nvports);
 	esw_destroy_vport_rx_group(esw);
 	esw_destroy_offloads_table(esw);
 	esw_destroy_offloads_fdb_tables(esw);
-- 
2.13.0
