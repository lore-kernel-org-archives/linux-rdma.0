From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 09/15] net/mlx5: Pass a namespace for packet reformat ID allocation
Date: Tue, 28 Aug 2018 14:18:48 +0300
Message-ID: <20180828111854.14367-10-leon@kernel.org>
References: <20180828111854.14367-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828111854.14367-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Currently we attach packet reformat actions only to the FDB namespace.
In preparation to be able to use that for NIC steering, pass the actual
namespace as a parameter.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c    | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3df8f2b90908..8cac8e9c8c63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -925,6 +925,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 e->encap_size, e->encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %d\n",
@@ -2389,6 +2390,7 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv4_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err)
 		goto destroy_neigh_entry;
@@ -2500,6 +2502,7 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
 
 	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
 					 ipv6_encap_size, encap_header,
+					 MLX5_FLOW_NAMESPACE_FDB,
 					 &e->encap_id);
 	if (err)
 		goto destroy_neigh_entry;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 4539b709db20..cc9537891e39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -600,16 +600,22 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 			       int reformat_type,
 			       size_t size,
 			       void *reformat_data,
+			       enum mlx5_flow_namespace_type namespace,
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
index f3c8f51cc9c2..66a5dd5a6cbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -39,6 +39,7 @@
 #include <linux/if_link.h>
 #include <linux/firmware.h>
 #include <linux/mlx5/cq.h>
+#include <linux/mlx5/fs.h>
 
 #define DRIVER_NAME "mlx5_core"
 #define DRIVER_VERSION "5.0-0"
@@ -173,6 +174,7 @@ int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
 			       int reformat_type,
 			       size_t size,
 			       void *reformat_data,
+			       enum mlx5_flow_namespace_type namespace,
 			       u32 *packet_reformat_id);
 void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
 				  u32 packet_reformat_id);
-- 
2.14.4
