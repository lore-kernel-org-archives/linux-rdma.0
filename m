From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Refactor mlx5_esw_query_functions for
 modularity
Date: Wed, 3 Jul 2019 07:39:30 +0000
Message-ID: <20190703073909.14965-4-saeedm@mellanox.com>
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

Functions change event output data size changes when functions other
than VFs will be enabled in HCA CAP.
With current API, multiple callers needs to align, calculate accurate
size of the output data depending on number on non VF functions enabled
in the device.
Instead of duplicating such math at multiple places, refactor
mlx5_esw_query_functions() to return raw output allocated by itself.

Caller must free the allocated memory using kvfree() as described in the
function comment section.
This hides calcuation within mlx5_esw_query_functions() and provides
simpler API.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 38 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  8 ++--
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 15 +++++---
 4 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 9137a8390216..62954265b57c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1715,14 +1715,34 @@ static int eswitch_vport_event(struct notifier_bloc=
k *nb,
 	return NOTIFY_OK;
 }
=20
-int mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outl=
en)
+/**
+ * mlx5_esw_query_functions - Returns raw output about functions state
+ * @dev:	Pointer to device to query
+ *
+ * mlx5_esw_query_functions() allocates and returns functions changed
+ * raw output memory pointer from device on success. Otherwise returns ERR=
_PTR.
+ * Caller must free the memory using kvfree() when valid pointer is return=
ed.
+ */
+const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
+	int outlen =3D MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] =3D {};
+	u32 *out;
+	int err;
+
+	out =3D kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return ERR_PTR(-ENOMEM);
=20
 	MLX5_SET(query_esw_functions_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_FUNCTIONS);
=20
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	if (!err)
+		return out;
+
+	kvfree(out);
+	return ERR_PTR(err);
 }
=20
 static void mlx5_eswitch_event_handlers_register(struct mlx5_eswitch *esw)
@@ -2527,8 +2547,7 @@ bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *=
dev0,
=20
 void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int nu=
m_vfs)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
-	int err;
+	const u32 *out;
=20
 	WARN_ON_ONCE(esw->mode !=3D MLX5_ESWITCH_NONE);
=20
@@ -2537,8 +2556,11 @@ void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswi=
tch *esw, const int num_vfs)
 		return;
 	}
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	if (!err)
-		esw->esw_funcs.num_vfs =3D MLX5_GET(query_esw_functions_out, out,
-						  host_params_context.host_num_of_vfs);
+	out =3D mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(out))
+		return;
+
+	esw->esw_funcs.num_vfs =3D MLX5_GET(query_esw_functions_out, out,
+					  host_params_context.host_num_of_vfs);
+	kvfree(out);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index f59183440d7f..d2d33a9893bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -403,7 +403,7 @@ bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0,
 bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 			       struct mlx5_core_dev *dev1);
=20
-int mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outl=
en);
+const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev);
=20
 #define MLX5_DEBUG_ESWITCH_MASK BIT(3)
=20
@@ -560,10 +560,9 @@ static inline int  mlx5_eswitch_enable(struct mlx5_esw=
itch *esw, int mode) { ret
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct =
mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev=
) { return false; }
-static inline int
-mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outlen)
+static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *de=
v)
 {
-	return -EOPNOTSUPP;
+	return ERR_PTR(-EOPNOTSUPP);
 }
=20
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw=
, const int num_vfs) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 42c0db585561..74ab7bd264ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2075,19 +2075,19 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *=
esw, const u32 *out)
=20
 static void esw_functions_changed_event_handler(struct work_struct *work)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
 	struct mlx5_host_work *host_work;
 	struct mlx5_eswitch *esw;
-	int err;
+	const u32 *out;
=20
 	host_work =3D container_of(work, struct mlx5_host_work, work);
 	esw =3D host_work->esw;
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	if (err)
+	out =3D mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(out))
 		goto out;
=20
 	esw_vfs_changed_event_handler(esw, out);
+	kvfree(out);
 out:
 	kfree(host_work);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sriov.c
index 547d0be9025e..61fcfd8b39b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -197,22 +197,25 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev)
=20
 static u16 mlx5_get_max_vfs(struct mlx5_core_dev *dev)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
 	u16 host_total_vfs;
-	int err;
+	const u32 *out;
=20
 	if (mlx5_core_is_ecpf_esw_manager(dev)) {
-		err =3D mlx5_esw_query_functions(dev, out, sizeof(out));
-		host_total_vfs =3D MLX5_GET(query_esw_functions_out, out,
-					  host_params_context.host_total_vfs);
+		out =3D mlx5_esw_query_functions(dev);
=20
 		/* Old FW doesn't support getting total_vfs from esw func
 		 * but supports getting it from pci_sriov.
 		 */
-		if (!err && host_total_vfs)
+		if (IS_ERR(out))
+			goto done;
+		host_total_vfs =3D MLX5_GET(query_esw_functions_out, out,
+					  host_params_context.host_total_vfs);
+		kvfree(out);
+		if (host_total_vfs)
 			return host_total_vfs;
 	}
=20
+done:
 	return pci_sriov_get_totalvfs(dev->pdev);
 }
=20
--=20
2.21.0
