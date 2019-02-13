From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 02/15] net/mlx5: Use consistent vport num argument type
Date: Tue, 12 Feb 2019 22:55:33 -0800
Message-ID: <20190213065546.3013-3-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Use u16 for vport number, which matches how hardware refers to this
argument throughout commands.

This patch doesn't change any functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 32 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  8 ++---
 include/linux/mlx5/vport.h                    |  8 ++---
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index a44ea7b85614..d7382892e81c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -52,7 +52,7 @@ enum {
 struct vport_addr {
 	struct l2addr_node     node;
 	u8                     action;
-	u32                    vport;
+	u16                    vport;
 	struct mlx5_flow_handle *flow_rule;
 	bool mpfs; /* UC MAC was added to MPFs */
 	/* A flag indicating that mac was added due to mc promiscuous vport */
@@ -115,7 +115,7 @@ static int modify_esw_vport_context_cmd(struct mlx5_core_dev *dev, u16 vport,
 	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
 
-static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u32 vport,
+static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 				  u16 vlan, u8 qos, u8 set_flags)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {0};
@@ -152,7 +152,7 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u32 vport,
 
 /* E-Switch FDB */
 static struct mlx5_flow_handle *
-__esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u32 vport, bool rx_rule,
+__esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u16 vport, bool rx_rule,
 			 u8 mac_c[ETH_ALEN], u8 mac_v[ETH_ALEN])
 {
 	int match_header = (is_zero_ether_addr(mac_c) ? 0 :
@@ -215,7 +215,7 @@ __esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u32 vport, bool rx_rule,
 }
 
 static struct mlx5_flow_handle *
-esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u8 mac[ETH_ALEN], u32 vport)
+esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u8 mac[ETH_ALEN], u16 vport)
 {
 	u8 mac_c[ETH_ALEN];
 
@@ -224,7 +224,7 @@ esw_fdb_set_vport_rule(struct mlx5_eswitch *esw, u8 mac[ETH_ALEN], u32 vport)
 }
 
 static struct mlx5_flow_handle *
-esw_fdb_set_vport_allmulti_rule(struct mlx5_eswitch *esw, u32 vport)
+esw_fdb_set_vport_allmulti_rule(struct mlx5_eswitch *esw, u16 vport)
 {
 	u8 mac_c[ETH_ALEN];
 	u8 mac_v[ETH_ALEN];
@@ -237,7 +237,7 @@ esw_fdb_set_vport_allmulti_rule(struct mlx5_eswitch *esw, u32 vport)
 }
 
 static struct mlx5_flow_handle *
-esw_fdb_set_vport_promisc_rule(struct mlx5_eswitch *esw, u32 vport)
+esw_fdb_set_vport_promisc_rule(struct mlx5_eswitch *esw, u16 vport)
 {
 	u8 mac_c[ETH_ALEN];
 	u8 mac_v[ETH_ALEN];
@@ -377,7 +377,7 @@ typedef int (*vport_addr_action)(struct mlx5_eswitch *esw,
 static int esw_add_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 {
 	u8 *mac = vaddr->node.addr;
-	u32 vport = vaddr->vport;
+	u16 vport = vaddr->vport;
 	int err;
 
 	/* Skip mlx5_mpfs_add_mac for PFs,
@@ -409,7 +409,7 @@ static int esw_add_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 static int esw_del_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 {
 	u8 *mac = vaddr->node.addr;
-	u32 vport = vaddr->vport;
+	u16 vport = vaddr->vport;
 	int err = 0;
 
 	/* Skip mlx5_mpfs_del_mac for PFs,
@@ -438,7 +438,7 @@ static void update_allmulti_vports(struct mlx5_eswitch *esw,
 				   struct esw_mc_addr *esw_mc)
 {
 	u8 *mac = vaddr->node.addr;
-	u32 vport_idx = 0;
+	u16 vport_idx = 0;
 
 	for (vport_idx = 0; vport_idx < esw->total_vports; vport_idx++) {
 		struct mlx5_vport *vport = &esw->vports[vport_idx];
@@ -485,7 +485,7 @@ static int esw_add_mc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 	struct hlist_head *hash = esw->mc_table;
 	struct esw_mc_addr *esw_mc;
 	u8 *mac = vaddr->node.addr;
-	u32 vport = vaddr->vport;
+	u16 vport = vaddr->vport;
 
 	if (!esw->fdb_table.legacy.fdb)
 		return 0;
@@ -525,7 +525,7 @@ static int esw_del_mc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 	struct hlist_head *hash = esw->mc_table;
 	struct esw_mc_addr *esw_mc;
 	u8 *mac = vaddr->node.addr;
-	u32 vport = vaddr->vport;
+	u16 vport = vaddr->vport;
 
 	if (!esw->fdb_table.legacy.fdb)
 		return 0;
@@ -564,7 +564,7 @@ static int esw_del_mc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 
 /* Apply vport UC/MC list to HW l2 table and FDB table */
 static void esw_apply_vport_addr_list(struct mlx5_eswitch *esw,
-				      u32 vport_num, int list_type)
+				      u16 vport_num, int list_type)
 {
 	struct mlx5_vport *vport = &esw->vports[vport_num];
 	bool is_uc = list_type == MLX5_NVPRT_LIST_TYPE_UC;
@@ -599,7 +599,7 @@ static void esw_apply_vport_addr_list(struct mlx5_eswitch *esw,
 
 /* Sync vport UC/MC list from vport context */
 static void esw_update_vport_addr_list(struct mlx5_eswitch *esw,
-				       u32 vport_num, int list_type)
+				       u16 vport_num, int list_type)
 {
 	struct mlx5_vport *vport = &esw->vports[vport_num];
 	bool is_uc = list_type == MLX5_NVPRT_LIST_TYPE_UC;
@@ -686,7 +686,7 @@ static void esw_update_vport_addr_list(struct mlx5_eswitch *esw,
 /* Sync vport UC/MC list from vport context
  * Must be called after esw_update_vport_addr_list
  */
-static void esw_update_vport_mc_promisc(struct mlx5_eswitch *esw, u32 vport_num)
+static void esw_update_vport_mc_promisc(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_vport *vport = &esw->vports[vport_num];
 	struct l2addr_node *node;
@@ -721,7 +721,7 @@ static void esw_update_vport_mc_promisc(struct mlx5_eswitch *esw, u32 vport_num)
 }
 
 /* Apply vport rx mode to HW FDB table */
-static void esw_apply_vport_rx_mode(struct mlx5_eswitch *esw, u32 vport_num,
+static void esw_apply_vport_rx_mode(struct mlx5_eswitch *esw, u16 vport_num,
 				    bool promisc, bool mc_promisc)
 {
 	struct esw_mc_addr *allmulti_addr = &esw->mc_promisc;
@@ -764,7 +764,7 @@ static void esw_apply_vport_rx_mode(struct mlx5_eswitch *esw, u32 vport_num,
 }
 
 /* Sync vport rx mode from vport context */
-static void esw_update_vport_rx_mode(struct mlx5_eswitch *esw, u32 vport_num)
+static void esw_update_vport_rx_mode(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_vport *vport = &esw->vports[vport_num];
 	int promisc_all = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 9b150ce9d315..9a928eb48522 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -255,7 +255,7 @@ int mlx5_modify_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 mtu)
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_mtu);
 
 int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
-				  u32 vport,
+				  u16 vport,
 				  enum mlx5_list_type list_type,
 				  u8 addr_list[][ETH_ALEN],
 				  int *list_size)
@@ -373,7 +373,7 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_mac_list);
 
 int mlx5_query_nic_vport_vlans(struct mlx5_core_dev *dev,
-			       u32 vport,
+			       u16 vport,
 			       u16 vlans[],
 			       int *size)
 {
@@ -526,7 +526,7 @@ int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid)
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_node_guid);
 
 int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
-				    u32 vport, u64 node_guid)
+				    u16 vport, u64 node_guid)
 {
 	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
 	void *nic_vport_context;
@@ -827,7 +827,7 @@ int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 EXPORT_SYMBOL_GPL(mlx5_query_hca_vport_node_guid);
 
 int mlx5_query_nic_vport_promisc(struct mlx5_core_dev *mdev,
-				 u32 vport,
+				 u16 vport,
 				 int *promisc_uc,
 				 int *promisc_mc,
 				 int *promisc_all)
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 9c694808c212..1654b911cdb2 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -60,7 +60,7 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 					   u64 *system_image_guid);
 int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid);
 int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
-				    u32 vport, u64 node_guid);
+				    u16 vport, u64 node_guid);
 int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
 					u16 *qkey_viol_cntr);
 int mlx5_query_hca_vport_gid(struct mlx5_core_dev *dev, u8 other_vport,
@@ -78,7 +78,7 @@ int mlx5_query_hca_vport_system_image_guid(struct mlx5_core_dev *dev,
 int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 				   u64 *node_guid);
 int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
-				  u32 vport,
+				  u16 vport,
 				  enum mlx5_list_type list_type,
 				  u8 addr_list[][ETH_ALEN],
 				  int *list_size);
@@ -87,7 +87,7 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 				   u8 addr_list[][ETH_ALEN],
 				   int list_size);
 int mlx5_query_nic_vport_promisc(struct mlx5_core_dev *mdev,
-				 u32 vport,
+				 u16 vport,
 				 int *promisc_uc,
 				 int *promisc_mc,
 				 int *promisc_all);
@@ -96,7 +96,7 @@ int mlx5_modify_nic_vport_promisc(struct mlx5_core_dev *mdev,
 				  int promisc_mc,
 				  int promisc_all);
 int mlx5_query_nic_vport_vlans(struct mlx5_core_dev *dev,
-			       u32 vport,
+			       u16 vport,
 			       u16 vlans[],
 			       int *size);
 int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
-- 
2.20.1
