From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: E-Switch prepare functions change
 handler to be modular
Date: Wed, 3 Jul 2019 07:39:28 +0000
Message-ID: <20190703073909.14965-3-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Parav Pandit <parav@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Eswitch function change handler will service multiple type of events for
VFs and non VF functions update.
Hence, introduce and use the helper function
esw_vfs_changed_event_handler() for handling change in num VFs to improve
the code readability.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 44 ++++++++++++-------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5c8fb2597bfa..42c0db585561 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2046,38 +2046,48 @@ static void esw_offloads_steering_cleanup(struct ml=
x5_eswitch *esw)
 	esw_destroy_offloads_acl_tables(esw);
 }
=20
-static void esw_functions_changed_event_handler(struct work_struct *work)
+static void
+esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
-	struct mlx5_host_work *host_work;
-	struct mlx5_eswitch *esw;
 	bool host_pf_disabled;
-	u16 num_vfs =3D 0;
-	int err;
-
-	host_work =3D container_of(work, struct mlx5_host_work, work);
-	esw =3D host_work->esw;
+	u16 new_num_vfs;
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	num_vfs =3D MLX5_GET(query_esw_functions_out, out,
-			   host_params_context.host_num_of_vfs);
+	new_num_vfs =3D MLX5_GET(query_esw_functions_out, out,
+			       host_params_context.host_num_of_vfs);
 	host_pf_disabled =3D MLX5_GET(query_esw_functions_out, out,
 				    host_params_context.host_pf_disabled);
-	if (err || host_pf_disabled || num_vfs =3D=3D esw->esw_funcs.num_vfs)
-		goto out;
+
+	if (new_num_vfs =3D=3D esw->esw_funcs.num_vfs || host_pf_disabled)
+		return;
=20
 	/* Number of VFs can only change from "0 to x" or "x to 0". */
 	if (esw->esw_funcs.num_vfs > 0) {
 		esw_offloads_unload_vf_reps(esw, esw->esw_funcs.num_vfs);
 	} else {
-		err =3D esw_offloads_load_vf_reps(esw, num_vfs);
+		int err;
=20
+		err =3D esw_offloads_load_vf_reps(esw, new_num_vfs);
 		if (err)
-			goto out;
+			return;
 	}
+	esw->esw_funcs.num_vfs =3D new_num_vfs;
+}
+
+static void esw_functions_changed_event_handler(struct work_struct *work)
+{
+	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
+	struct mlx5_host_work *host_work;
+	struct mlx5_eswitch *esw;
+	int err;
+
+	host_work =3D container_of(work, struct mlx5_host_work, work);
+	esw =3D host_work->esw;
=20
-	esw->esw_funcs.num_vfs =3D num_vfs;
+	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
+	if (err)
+		goto out;
=20
+	esw_vfs_changed_event_handler(esw, out);
 out:
 	kfree(host_work);
 }
--=20
2.21.0
