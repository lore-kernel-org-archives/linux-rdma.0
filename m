From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH mlx5-next 06/18] {net, RDMA}/mlx5: Rename encap to reformat packet
Date: Mon, 16 Jul 2018 11:22:53 +0300
Message-ID: <20180716082305.11744-7-leon@kernel.org>
References: <20180716082305.11744-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Renames all encap mlx5_{core,ib} code to use the new naming of packet
reformat. No functional change is introduced. This is done because the
original naming didn't reflect correctly the operation being done by
this action. For example not only can we encapsulate a packet,
but also decapsulate it.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c                  |  6 +--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  8 +--
 .../mellanox/mlx5/core/diag/fs_tracepoint.h        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 46 ++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  8 +--
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   | 63 ++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    | 13 ++---
 include/linux/mlx5/fs.h                            |  4 +-
 include/linux/mlx5/mlx5_ifc.h                      | 50 ++++++++---------
 13 files changed, 110 insertions(+), 98 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 953785c608a9..a82a9453db3f 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -286,7 +286,7 @@ static bool devx_is_obj_create_cmd(const void *in)
 	case MLX5_CMD_OP_CREATE_FLOW_TABLE:
 	case MLX5_CMD_OP_CREATE_FLOW_GROUP:
 	case MLX5_CMD_OP_ALLOC_FLOW_COUNTER:
-	case MLX5_CMD_OP_ALLOC_ENCAP_HEADER:
+	case MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT:
 	case MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT:
 	case MLX5_CMD_OP_CREATE_SCHEDULING_ELEMENT:
 	case MLX5_CMD_OP_ADD_VXLAN_UDP_DPORT:
@@ -629,9 +629,9 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode,
 			 MLX5_CMD_OP_DEALLOC_FLOW_COUNTER);
 		break;
-	case MLX5_CMD_OP_ALLOC_ENCAP_HEADER:
+	case MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT:
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode,
-			 MLX5_CMD_OP_DEALLOC_ENCAP_HEADER);
+			 MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT);
 		break;
 	case MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT:
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 7dd878b00196..2497ea8752f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -307,7 +307,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_MODIFY_FLOW_TABLE:
 	case MLX5_CMD_OP_SET_FLOW_TABLE_ENTRY:
 	case MLX5_CMD_OP_SET_FLOW_TABLE_ROOT:
-	case MLX5_CMD_OP_DEALLOC_ENCAP_HEADER:
+	case MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT:
 	case MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT:
 	case MLX5_CMD_OP_FPGA_DESTROY_QP:
 	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
@@ -422,7 +422,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_QUERY_FLOW_TABLE_ENTRY:
 	case MLX5_CMD_OP_ALLOC_FLOW_COUNTER:
 	case MLX5_CMD_OP_QUERY_FLOW_COUNTER:
-	case MLX5_CMD_OP_ALLOC_ENCAP_HEADER:
+	case MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT:
 	case MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT:
 	case MLX5_CMD_OP_FPGA_CREATE_QP:
 	case MLX5_CMD_OP_FPGA_MODIFY_QP:
@@ -594,8 +594,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(DEALLOC_FLOW_COUNTER);
 	MLX5_COMMAND_STR_CASE(QUERY_FLOW_COUNTER);
 	MLX5_COMMAND_STR_CASE(MODIFY_FLOW_TABLE);
-	MLX5_COMMAND_STR_CASE(ALLOC_ENCAP_HEADER);
-	MLX5_COMMAND_STR_CASE(DEALLOC_ENCAP_HEADER);
+	MLX5_COMMAND_STR_CASE(ALLOC_PACKET_REFORMAT_CONTEXT);
+	MLX5_COMMAND_STR_CASE(DEALLOC_PACKET_REFORMAT_CONTEXT);
 	MLX5_COMMAND_STR_CASE(ALLOC_MODIFY_HEADER_CONTEXT);
 	MLX5_COMMAND_STR_CASE(DEALLOC_MODIFY_HEADER_CONTEXT);
 	MLX5_COMMAND_STR_CASE(FPGA_CREATE_QP);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
index 09f178a3fcab..0ccbe4109fa4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.h
@@ -133,7 +133,7 @@ TRACE_EVENT(mlx5_fs_del_fg,
 	{MLX5_FLOW_CONTEXT_ACTION_DROP,		 "DROP"},\
 	{MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,	 "FWD"},\
 	{MLX5_FLOW_CONTEXT_ACTION_COUNT,	 "CNT"},\
-	{MLX5_FLOW_CONTEXT_ACTION_ENCAP,	 "ENCAP"},\
+	{MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID, "PACKET_REFORMAT"},\
 	{MLX5_FLOW_CONTEXT_ACTION_DECAP,	 "DECAP"},\
 	{MLX5_FLOW_CONTEXT_ACTION_MOD_HDR,	 "MOD_HDR"},\
 	{MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH,	 "VLAN_PUSH"},\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 844d32d5c29f..2e550e328873 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -123,7 +123,7 @@ struct mlx5e_encap_entry {
 	 */
 	struct hlist_node encap_hlist;
 	struct list_head flows;
-	u32 encap_id;
+	u32 packet_reformat_id;
 	struct ip_tunnel_info tun_info;
 	unsigned char h_dest[ETH_ALEN];	/* destination eth addr	*/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74601f9d1c28..1e8b27942426 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -681,7 +681,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		.action = attr->action,
 		.has_flow_tag = true,
 		.flow_tag = attr->flow_tag,
-		.encap_id = 0,
+		.packet_reformat_id = 0,
 	};
 	struct mlx5_fc *counter = NULL;
 	struct mlx5_flow_handle *rule;
@@ -829,7 +829,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5e_priv *out_priv;
 	int err;

-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_ENCAP) {
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID) {
 		out_dev = __dev_get_by_index(dev_net(priv->netdev),
 					     attr->parse_attr->mirred_ifindex);
 		err = mlx5e_attach_encap(priv, &parse_attr->tun_info,
@@ -885,7 +885,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 err_mod_hdr:
 	mlx5_eswitch_del_vlan_action(esw, attr);
 err_add_vlan:
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_ENCAP)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID)
 		mlx5e_detach_encap(priv, flow);
 err_attach_encap:
 	return rule;
@@ -906,7 +906,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,

 	mlx5_eswitch_del_vlan_action(esw, attr);

-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_ENCAP) {
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID) {
 		mlx5e_detach_encap(priv, flow);
 		kvfree(attr->parse_attr);
 	}
@@ -923,9 +923,9 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int err;

-	err = mlx5_encap_alloc(priv->mdev, e->tunnel_type,
-			       e->encap_size, e->encap_header,
-			       &e->encap_id);
+	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
+					 e->encap_size, e->encap_header,
+					 &e->packet_reformat_id);
 	if (err) {
 		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %d\n",
 			       err);
@@ -936,7 +936,7 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,

 	list_for_each_entry(flow, &e->flows, encap) {
 		esw_attr = flow->esw_attr;
-		esw_attr->encap_id = e->encap_id;
+		esw_attr->packet_reformat_id = e->packet_reformat_id;
 		flow->rule[0] = mlx5_eswitch_add_offloaded_rule(esw, &esw_attr->parse_attr->spec, esw_attr);
 		if (IS_ERR(flow->rule[0])) {
 			err = PTR_ERR(flow->rule[0]);
@@ -979,7 +979,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,

 	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
 		e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
-		mlx5_encap_dealloc(priv->mdev, e->encap_id);
+		mlx5_packet_reformat_dealloc(priv->mdev, e->packet_reformat_id);
 	}
 }

@@ -1050,7 +1050,7 @@ static void mlx5e_detach_encap(struct mlx5e_priv *priv,
 		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);

 		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-			mlx5_encap_dealloc(priv->mdev, e->encap_id);
+			mlx5_packet_reformat_dealloc(priv->mdev, e->packet_reformat_id);

 		hash_del_rcu(&e->encap_hlist);
 		kfree(e->encap_header);
@@ -2252,7 +2252,7 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
 		return -ENOMEM;

 	switch (e->tunnel_type) {
-	case MLX5_HEADER_TYPE_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
 		fl4.flowi4_proto = IPPROTO_UDP;
 		fl4.fl4_dport = tun_key->tp_dst;
 		break;
@@ -2292,7 +2292,7 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
 	read_unlock_bh(&n->lock);

 	switch (e->tunnel_type) {
-	case MLX5_HEADER_TYPE_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
 		gen_vxlan_header_ipv4(out_dev, encap_header,
 				      ipv4_encap_size, e->h_dest, ttl,
 				      fl4.daddr,
@@ -2312,8 +2312,9 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
 		goto out;
 	}

-	err = mlx5_encap_alloc(priv->mdev, e->tunnel_type,
-			       ipv4_encap_size, encap_header, &e->encap_id);
+	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
+					 ipv4_encap_size, encap_header,
+					 &e->packet_reformat_id);
 	if (err)
 		goto destroy_neigh_entry;

@@ -2357,7 +2358,7 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
 		return -ENOMEM;

 	switch (e->tunnel_type) {
-	case MLX5_HEADER_TYPE_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
 		fl6.flowi6_proto = IPPROTO_UDP;
 		fl6.fl6_dport = tun_key->tp_dst;
 		break;
@@ -2398,7 +2399,7 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
 	read_unlock_bh(&n->lock);

 	switch (e->tunnel_type) {
-	case MLX5_HEADER_TYPE_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
 		gen_vxlan_header_ipv6(out_dev, encap_header,
 				      ipv6_encap_size, e->h_dest, ttl,
 				      &fl6.daddr,
@@ -2419,8 +2420,9 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
 		goto out;
 	}

-	err = mlx5_encap_alloc(priv->mdev, e->tunnel_type,
-			       ipv6_encap_size, encap_header, &e->encap_id);
+	err = mlx5_packet_reformat_alloc(priv->mdev, e->tunnel_type,
+					 ipv6_encap_size, encap_header,
+					 &e->packet_reformat_id);
 	if (err)
 		goto destroy_neigh_entry;

@@ -2472,7 +2474,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,

 	if (mlx5e_vxlan_lookup_port(up_priv, be16_to_cpu(key->tp_dst)) &&
 	    MLX5_CAP_ESW(priv->mdev, vxlan_encap_decap)) {
-		tunnel_type = MLX5_HEADER_TYPE_VXLAN;
+		tunnel_type = MLX5_REFORMAT_TYPE_L2_TO_VXLAN;
 	} else {
 		netdev_warn(priv->netdev,
 			    "%d isn't an offloaded vxlan udp dport\n", be16_to_cpu(key->tp_dst));
@@ -2515,7 +2517,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	list_add(&flow->encap, &e->flows);
 	*encap_dev = e->out_dev;
 	if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-		attr->encap_id = e->encap_id;
+		attr->packet_reformat_id = e->packet_reformat_id;
 	else
 		err = -EAGAIN;

@@ -2598,7 +2600,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 				parse_attr->mirred_ifindex = out_dev->ifindex;
 				parse_attr->tun_info = *info;
 				attr->parse_attr = parse_attr;
-				action |= MLX5_FLOW_CONTEXT_ACTION_ENCAP |
+				action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID |
 					  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 					  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 				/* attr->out_rep is resolved when we handle encap */
@@ -2756,7 +2758,7 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 		flow->flags |= MLX5E_TC_FLOW_OFFLOADED;

 	if (!(flow->flags & MLX5E_TC_FLOW_ESWITCH) ||
-	    !(flow->esw_attr->action & MLX5_FLOW_CONTEXT_ACTION_ENCAP))
+	    !(flow->esw_attr->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID))
 		kvfree(parse_attr);

 	err = rhashtable_insert_fast(tc_ht, &flow->node, tc_ht_params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index f63dfbcd29fe..d2c877de523b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1748,7 +1748,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->enabled_vports = 0;
 	esw->mode = SRIOV_NONE;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
-	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, encap) &&
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
 	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b174da2884c5..824348e715a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -260,7 +260,7 @@ struct mlx5_esw_flow_attr {
 	u16	vlan_vid;
 	u8	vlan_prio;
 	bool	vlan_handled;
-	u32	encap_id;
+	u32	packet_reformat_id;
 	u32	mod_hdr_id;
 	u8	match_level;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 53718080d262..e73d04efc8bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -122,8 +122,8 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_id = attr->mod_hdr_id;

-	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_ENCAP)
-		flow_act.encap_id = attr->encap_id;
+	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID)
+		flow_act.packet_reformat_id = attr->packet_reformat_id;

 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, i);
 	if (IS_ERR(rule))
@@ -524,7 +524,7 @@ static int esw_create_offloads_fast_fdb_table(struct mlx5_eswitch *esw)
 		esw_size >>= 1;

 	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
-		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP |
+		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);

 	fdb = mlx5_create_auto_grouped_flow_table(root_ns, FDB_FAST_PATH,
@@ -1240,7 +1240,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8 encap)
 		return err;

 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
-	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, encap) ||
+	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
 	     !MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap)))
 		return -EOPNOTSUPP;

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 615063757c3d..f3e6e532491e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -152,7 +152,7 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,
 				      struct mlx5_flow_table *next_ft,
 				      unsigned int *table_id, u32 flags)
 {
-	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
+	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
 	int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {0};
 	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)]   = {0};
@@ -171,7 +171,7 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,

 	MLX5_SET(create_flow_table_in, in, flow_table_context.decap_en,
 		 en_decap);
-	MLX5_SET(create_flow_table_in, in, flow_table_context.encap_en,
+	MLX5_SET(create_flow_table_in, in, flow_table_context.reformat_en,
 		 en_encap);

 	switch (op_mod) {
@@ -344,7 +344,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,

 	MLX5_SET(flow_context, in_flow_context, flow_tag, fte->action.flow_tag);
 	MLX5_SET(flow_context, in_flow_context, action, fte->action.action);
-	MLX5_SET(flow_context, in_flow_context, encap_id, fte->action.encap_id);
+	MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
+		 fte->action.packet_reformat_id);
 	MLX5_SET(flow_context, in_flow_context, modify_header_id,
 		 fte->action.modify_id);

@@ -588,16 +589,16 @@ void mlx5_cmd_fc_bulk_get(struct mlx5_core_dev *dev,
 	*bytes = MLX5_GET64(traffic_counter, stats, octets);
 }

-int mlx5_encap_alloc(struct mlx5_core_dev *dev,
-		     int header_type,
-		     size_t size,
-		     void *encap_header,
-		     u32 *encap_id)
+int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
+			       int reformat_type,
+			       size_t size,
+			       void *reformat_data,
+			       u32 *packet_reformat_id)
 {
 	int max_encap_size = MLX5_CAP_ESW(dev, max_encap_header_size);
-	u32 out[MLX5_ST_SZ_DW(alloc_encap_header_out)];
-	void *encap_header_in;
-	void *header;
+	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)];
+	void *packet_reformat_context_in;
+	void *reformat;
 	int inlen;
 	int err;
 	u32 *in;
@@ -608,39 +609,47 @@ int mlx5_encap_alloc(struct mlx5_core_dev *dev,
 		return -EINVAL;
 	}

-	in = kzalloc(MLX5_ST_SZ_BYTES(alloc_encap_header_in) + size,
+	in = kzalloc(MLX5_ST_SZ_BYTES(alloc_packet_reformat_context_in) + size,
 		     GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;

-	encap_header_in = MLX5_ADDR_OF(alloc_encap_header_in, in, encap_header);
-	header = MLX5_ADDR_OF(encap_header_in, encap_header_in, encap_header);
-	inlen = header - (void *)in  + size;
+	packet_reformat_context_in = MLX5_ADDR_OF(alloc_packet_reformat_context_in,
+						  in, packet_reformat_context);
+	reformat = MLX5_ADDR_OF(packet_reformat_context_in,
+				packet_reformat_context_in,
+				reformat_data);
+	inlen = reformat - (void *)in  + size;

 	memset(in, 0, inlen);
-	MLX5_SET(alloc_encap_header_in, in, opcode,
-		 MLX5_CMD_OP_ALLOC_ENCAP_HEADER);
-	MLX5_SET(encap_header_in, encap_header_in, encap_header_size, size);
-	MLX5_SET(encap_header_in, encap_header_in, header_type, header_type);
-	memcpy(header, encap_header, size);
+	MLX5_SET(alloc_packet_reformat_context_in, in, opcode,
+		 MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT);
+	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
+		 reformat_data_size, size);
+	MLX5_SET(packet_reformat_context_in, packet_reformat_context_in,
+		 reformat_type, reformat_type);
+	memcpy(reformat, reformat_data, size);

 	memset(out, 0, sizeof(out));
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));

-	*encap_id = MLX5_GET(alloc_encap_header_out, out, encap_id);
+	*packet_reformat_id = MLX5_GET(alloc_packet_reformat_context_out,
+				       out, packet_reformat_id);
 	kfree(in);
 	return err;
 }

-void mlx5_encap_dealloc(struct mlx5_core_dev *dev, u32 encap_id)
+void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
+				  u32 packet_reformat_id)
 {
-	u32 in[MLX5_ST_SZ_DW(dealloc_encap_header_in)];
-	u32 out[MLX5_ST_SZ_DW(dealloc_encap_header_out)];
+	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)];
+	u32 out[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_out)];

 	memset(in, 0, sizeof(in));
-	MLX5_SET(dealloc_encap_header_in, in, opcode,
-		 MLX5_CMD_OP_DEALLOC_ENCAP_HEADER);
-	MLX5_SET(dealloc_encap_header_in, in, encap_id, encap_id);
+	MLX5_SET(dealloc_packet_reformat_context_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT);
+	MLX5_SET(dealloc_packet_reformat_context_in, in, packet_reformat_id,
+		 packet_reformat_id);

 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 68653ca76a11..c359d24927b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1398,7 +1398,7 @@ static bool check_conflicting_actions(u32 action1, u32 action2)
 		return false;

 	if (xored_actions & (MLX5_FLOW_CONTEXT_ACTION_DROP  |
-			     MLX5_FLOW_CONTEXT_ACTION_ENCAP |
+			     MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID |
 			     MLX5_FLOW_CONTEXT_ACTION_DECAP |
 			     MLX5_FLOW_CONTEXT_ACTION_MOD_HDR  |
 			     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b076ce14c48c..e16f6e6e03e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -170,12 +170,13 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
-int mlx5_encap_alloc(struct mlx5_core_dev *dev,
-		     int header_type,
-		     size_t size,
-		     void *encap_header,
-		     u32 *encap_id);
-void mlx5_encap_dealloc(struct mlx5_core_dev *dev, u32 encap_id);
+int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
+			       int reformat_type,
+			       size_t size,
+			       void *reformat_data,
+			       u32 *packet_reformat_id);
+void mlx5_packet_reformat_dealloc(struct mlx5_core_dev *dev,
+				  u32 packet_reformat_id);

 bool mlx5_lag_intf_add(struct mlx5_interface *intf, struct mlx5_priv *priv);

diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index e95ea05565f1..6166df1eaeac 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -45,7 +45,7 @@ enum {
 };

 enum {
-	MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP = BIT(0),
+	MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT = BIT(0),
 	MLX5_FLOW_TABLE_TUNNEL_EN_DECAP = BIT(1),
 };

@@ -158,7 +158,7 @@ struct mlx5_flow_act {
 	u32 action;
 	bool has_flow_tag;
 	u32 flow_tag;
-	u32 encap_id;
+	u32 packet_reformat_id;
 	u32 modify_id;
 	uintptr_t esp_id;
 	struct mlx5_fs_vlan vlan;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1b94fcc0109a..059ec97e7b32 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -243,8 +243,8 @@ enum {
 	MLX5_CMD_OP_DEALLOC_FLOW_COUNTER          = 0x93a,
 	MLX5_CMD_OP_QUERY_FLOW_COUNTER            = 0x93b,
 	MLX5_CMD_OP_MODIFY_FLOW_TABLE             = 0x93c,
-	MLX5_CMD_OP_ALLOC_ENCAP_HEADER            = 0x93d,
-	MLX5_CMD_OP_DEALLOC_ENCAP_HEADER          = 0x93e,
+	MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT = 0x93d,
+	MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT = 0x93e,
 	MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT   = 0x940,
 	MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT = 0x941,
 	MLX5_CMD_OP_QUERY_MODIFY_HEADER_CONTEXT   = 0x942,
@@ -336,7 +336,7 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         modify_root[0x1];
 	u8         identified_miss_table_mode[0x1];
 	u8         flow_table_modify[0x1];
-	u8         encap[0x1];
+	u8         reformat[0x1];
 	u8         decap[0x1];
 	u8         reserved_at_9[0x1];
 	u8         pop_vlan[0x1];
@@ -596,7 +596,7 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vxlan_encap_decap[0x1];
 	u8         nvgre_encap_decap[0x1];
 	u8         reserved_at_22[0x9];
-	u8         log_max_encap_headers[0x5];
+	u8         log_max_packet_reformat_context[0x5];
 	u8         reserved_2b[0x6];
 	u8         max_encap_header_size[0xa];

@@ -2386,7 +2386,7 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_DROP      = 0x2,
 	MLX5_FLOW_CONTEXT_ACTION_FWD_DEST  = 0x4,
 	MLX5_FLOW_CONTEXT_ACTION_COUNT     = 0x8,
-	MLX5_FLOW_CONTEXT_ACTION_ENCAP     = 0x10,
+	MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID = 0x10,
 	MLX5_FLOW_CONTEXT_ACTION_DECAP     = 0x20,
 	MLX5_FLOW_CONTEXT_ACTION_MOD_HDR   = 0x40,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_POP  = 0x80,
@@ -2417,7 +2417,7 @@ struct mlx5_ifc_flow_context_bits {
 	u8         reserved_at_a0[0x8];
 	u8         flow_counter_list_size[0x18];

-	u8         encap_id[0x20];
+	u8         packet_reformat_id[0x20];

 	u8         modify_header_id[0x20];

@@ -4790,19 +4790,19 @@ struct mlx5_ifc_query_eq_in_bits {
 	u8         reserved_at_60[0x20];
 };

-struct mlx5_ifc_encap_header_in_bits {
+struct mlx5_ifc_packet_reformat_context_in_bits {
 	u8         reserved_at_0[0x5];
-	u8         header_type[0x3];
+	u8         reformat_type[0x3];
 	u8         reserved_at_8[0xe];
-	u8         encap_header_size[0xa];
+	u8         reformat_data_size[0xa];

 	u8         reserved_at_20[0x10];
-	u8         encap_header[2][0x8];
+	u8         reformat_data[2][0x8];

-	u8         more_encap_header[0][0x8];
+	u8         more_reformat_data[0][0x8];
 };

-struct mlx5_ifc_query_encap_header_out_bits {
+struct mlx5_ifc_query_packet_reformat_context_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];

@@ -4810,38 +4810,38 @@ struct mlx5_ifc_query_encap_header_out_bits {

 	u8         reserved_at_40[0xa0];

-	struct mlx5_ifc_encap_header_in_bits encap_header[0];
+	struct mlx5_ifc_packet_reformat_context_in_bits packet_reformat_context[0];
 };

-struct mlx5_ifc_query_encap_header_in_bits {
+struct mlx5_ifc_query_packet_reformat_context_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];

 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];

-	u8         encap_id[0x20];
+	u8         packet_reformat_id[0x20];

 	u8         reserved_at_60[0xa0];
 };

-struct mlx5_ifc_alloc_encap_header_out_bits {
+struct mlx5_ifc_alloc_packet_reformat_context_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];

 	u8         syndrome[0x20];

-	u8         encap_id[0x20];
+	u8         packet_reformat_id[0x20];

 	u8         reserved_at_60[0x20];
 };

 enum {
-	MLX5_HEADER_TYPE_VXLAN = 0x0,
-	MLX5_HEADER_TYPE_NVGRE = 0x1,
+	MLX5_REFORMAT_TYPE_L2_TO_VXLAN = 0x0,
+	MLX5_REFORMAT_TYPE_L2_TO_NVGRE = 0x1,
 };

-struct mlx5_ifc_alloc_encap_header_in_bits {
+struct mlx5_ifc_alloc_packet_reformat_context_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];

@@ -4850,10 +4850,10 @@ struct mlx5_ifc_alloc_encap_header_in_bits {

 	u8         reserved_at_40[0xa0];

-	struct mlx5_ifc_encap_header_in_bits encap_header;
+	struct mlx5_ifc_packet_reformat_context_in_bits packet_reformat_context;
 };

-struct mlx5_ifc_dealloc_encap_header_out_bits {
+struct mlx5_ifc_dealloc_packet_reformat_context_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];

@@ -4862,14 +4862,14 @@ struct mlx5_ifc_dealloc_encap_header_out_bits {
 	u8         reserved_at_40[0x40];
 };

-struct mlx5_ifc_dealloc_encap_header_in_bits {
+struct mlx5_ifc_dealloc_packet_reformat_context_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];

 	u8         reserved_20[0x10];
 	u8         op_mod[0x10];

-	u8         encap_id[0x20];
+	u8         packet_reformat_id[0x20];

 	u8         reserved_60[0x20];
 };
@@ -6971,7 +6971,7 @@ struct mlx5_ifc_create_flow_table_out_bits {
 };

 struct mlx5_ifc_flow_table_context_bits {
-	u8         encap_en[0x1];
+	u8         reformat_en[0x1];
 	u8         decap_en[0x1];
 	u8         reserved_at_2[0x2];
 	u8         table_miss_action[0x4];
