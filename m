From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 09/27] net/mlx5: Pass a namespace for packet reformat ID allocation
Date: Sun, 29 Jul 2018 15:58:47 +0300
Message-ID: <20180729125905.31989-10-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Currently we attach packet reformat actions only to the FDB namespace.
In preparation to be able to use that for NIC steering, pass the actual
namespace as a parameter.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ec787e8a0be4..f111bf08f2be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -925,6 +925,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 e->encap_size, e->encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %d\n",
@@ -2314,6 +2315,7 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv4_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err)
 		goto destroy_neigh_entry;
@@ -2422,6 +2424,7 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv6_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err)
 		goto destroy_neigh_entry;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 4539b709db20..d686668a8d52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -600,16 +600,22 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 			       int reformat_type,
 			       size_t size,
 			       void *reformat_data,
+			       int namespace,
 			       u32 *packet_reformat_id)
 {
-	int max_encap_size = MLX5_CAP_ESW(dev, max_encap_header_size);
 	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)];
 	void *packet_reformat_context_in;
+	int max_encap_size;
 	void *reformat;
 	int inlen;
 	int err;
 	u32 *in;
 
+	if (namespace == MLX5_FLOW_NAMESPACE_FDB)
+		max_encap_size = MLX5_CAP_ESW(dev, max_encap_header_size);
+	else
+		max_encap_size = MLX5_CAP_FLOWTABLE(dev, max_encap_header_size);
+
 	if (size > max_encap_size) {
 		mlx5_core_warn(dev, "encap size %zd too big, max supported is %d\n",
 			       size, max_encap_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index e16f6e6e03e1..0f3d9942d1a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -174,6 +174,7 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 			       int reformat_type,
 			       size_t size,
 			       void *reformat_data,
+			       int namespace,
 			       u32 *packet_reformat_id);
 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 				  u32 packet_reformat_id);
-- 
2.14.4
