From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next 02/11] net/mlx5: E-Switch, Refactor load/unload of representors
Date: Tue, 19 Dec 2017 12:33:31 -0800
Message-ID: <20171219203340.2600-3-saeedm@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219203340.2600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Refactor the load/unload stages for better code reuse.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 66 +++++++++++++---------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 230b05842cb0..139da9f3cc70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -768,12 +768,47 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
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
@@ -791,25 +826,13 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
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
@@ -850,16 +873,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw)
 
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
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
