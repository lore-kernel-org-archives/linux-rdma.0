From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 08/18] net/mlx5: Allow passing a namespace on packet reformat allocation
Date: Mon, 16 Jul 2018 11:22:55 +0300
Message-ID: <20180716082305.11744-9-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Currently we attach packet reformat actions only to the FDB namespace,
in preparation to be able to attach it to different namespaces, add the
ability to pass the namespace as a parameter.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1e8b27942426..81bfed3d3db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -925,6 +925,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,

 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 e->encap_size, e->encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->packet_reformat_id);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %d\n",
@@ -2314,6 +2315,7 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,

 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv4_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->packet_reformat_id);
 	if (err)
 		goto destroy_neigh_entry;
@@ -2422,6 +2424,7 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,

 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv6_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->packet_reformat_id);
 	if (err)
 		goto destroy_neigh_entry;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index f3e6e532491e..41958bb10f69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -593,16 +593,22 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
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
