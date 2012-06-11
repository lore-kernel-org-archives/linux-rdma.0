From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 18/29] {NET,IB}/mlx4: MAD_IFC paravirtualization
Date: Mon, 11 Jun 2012 13:45:59 +0300
Message-ID: <1339411570-4689-19-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The MAD_IFC firmware command fulfills two functions.

In the first case, it is used in the QP0/QP1 MAD-handling flow to
obtain information from the FW (for answering queries), and for
setting variables in the HCA (MAD SET packets).

In this function, MAD_IFC should provide the FW (physical) view
of the data.  This is the view that OpenSM needs for its functioning.
We call this the "network view".

In the second case, MAD_IFC is used by various verbs to obtain data
regarding the local HCA (e.g., ib_query_device() ).
We call this the "host view".

This data needs to be paravirtualized.

MAD_IFC thus needs a wrapper function, and also needs another flag
indicating whether it should provide the network view (when it is
called by ib_process_mad in special-qp packet handling), or the
host view (when it is called while implementing a verb).

There are currently 2 flag parameters in mlx4_MAD_IFC already:
ignore_bkey and ignore_mkey.  These two parameters are replaced
by a single "mad_ifc_flags" parameter, with different bits set
for each flag.  A third flag is added: "network-view/host-view".

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c         |   20 ++--
 drivers/infiniband/hw/mlx4/main.c        |   64 +++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h     |   14 +++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c |  162 ++++++++++++++++++++++++++++++
 4 files changed, 234 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 25a9244..aa7ee21 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -78,7 +78,7 @@ struct mlx4_rcv_tunnel_mad {
 static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num);
 static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num);
 
-int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
+int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
 		 void *in_mad, void *response_mad)
 {
@@ -105,10 +105,13 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 	 * Key check traps can't be generated unless we have in_wc to
 	 * tell us where to send the trap.
 	 */
-	if (ignore_mkey || !in_wc)
+	if ((mad_ifc_flags & MLX4_MAD_IFC_IGNORE_MKEY) || !in_wc)
 		op_modifier |= 0x1;
-	if (ignore_bkey || !in_wc)
+	if ((mad_ifc_flags & MLX4_MAD_IFC_IGNORE_BKEY) || !in_wc)
 		op_modifier |= 0x2;
+	if (mlx4_is_mfunc(dev->dev) &&
+	    (mad_ifc_flags & MLX4_MAD_IFC_NET_VIEW || in_wc))
+		op_modifier |= 0x8;
 
 	if (in_wc) {
 		struct {
@@ -141,10 +144,10 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 		in_modifier |= in_wc->slid << 16;
 	}
 
-	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma,
-			   in_modifier, op_modifier,
+	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma, in_modifier,
+			   mlx4_is_master(dev->dev) ? (op_modifier & ~0x8) : op_modifier,
 			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C,
-			   MLX4_CMD_NATIVE);
+			   (op_modifier & 0x8) ? MLX4_CMD_NATIVE : MLX4_CMD_WRAPPED);
 
 	if (!err)
 		memcpy(response_mad, outmailbox->buf, 256);
@@ -589,8 +592,9 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		prev_lid = pattr.lid;
 
 	err = mlx4_MAD_IFC(to_mdev(ibdev),
-			   mad_flags & IB_MAD_IGNORE_MKEY,
-			   mad_flags & IB_MAD_IGNORE_BKEY,
+			   (mad_flags & IB_MAD_IGNORE_MKEY ? MLX4_MAD_IFC_IGNORE_MKEY : 0) |
+			   (mad_flags & IB_MAD_IGNORE_BKEY ? MLX4_MAD_IFC_IGNORE_BKEY : 0) |
+			   MLX4_MAD_IFC_NET_VIEW,
 			   port_num, in_wc, in_grh, in_mad, out_mad);
 	if (err)
 		return IB_MAD_RESULT_FAILURE;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 213d459..84cbd0a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -106,7 +106,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	err = mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS,
+			   1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
@@ -190,11 +191,12 @@ mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
 }
 
 static int ib_link_query_port(struct ib_device *ibdev, u8 port,
-			      struct ib_port_attr *props)
+			      struct ib_port_attr *props, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
 	int ext_active_speed;
+	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
@@ -206,7 +208,10 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
 	in_mad->attr_mod = cpu_to_be32(port);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL,
+	if (mlx4_is_mfunc(to_mdev(ibdev)->dev) && netw_view)
+		mad_ifc_flags |= MLX4_MAD_IFC_NET_VIEW;
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), mad_ifc_flags, port, NULL, NULL,
 				in_mad, out_mad);
 	if (err)
 		goto out;
@@ -219,7 +224,10 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= out_mad->data[32] & 0xf;
 	props->phys_state	= out_mad->data[33] >> 4;
 	props->port_cap_flags	= be32_to_cpup((__be32 *) (out_mad->data + 20));
-	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
+	if (netw_view)
+		props->gid_tbl_len = out_mad->data[50];
+	else
+		props->gid_tbl_len = to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= to_mdev(ibdev)->dev->caps.pkey_table_len[port];
 	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
@@ -252,7 +260,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		in_mad->attr_id = MLX4_ATTR_EXTENDED_PORT_INFO;
 		in_mad->attr_mod = cpu_to_be32(port);
 
-		err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
+		err = mlx4_MAD_IFC(to_mdev(ibdev), mad_ifc_flags, port,
 				   NULL, NULL, in_mad, out_mad);
 		if (err)
 			goto out;
@@ -278,7 +286,7 @@ static u8 state_to_phys_state(enum ib_port_state state)
 }
 
 static int eth_link_query_port(struct ib_device *ibdev, u8 port,
-			       struct ib_port_attr *props)
+			       struct ib_port_attr *props, int netw_view)
 {
 
 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
@@ -328,20 +336,27 @@ out:
 	return err;
 }
 
-static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
-			      struct ib_port_attr *props)
+int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+			 struct ib_port_attr *props, int netw_view)
 {
 	int err;
 
 	memset(props, 0, sizeof *props);
 
 	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
-		ib_link_query_port(ibdev, port, props) :
-				eth_link_query_port(ibdev, port, props);
+		ib_link_query_port(ibdev, port, props, netw_view) :
+				eth_link_query_port(ibdev, port, props, netw_view);
 
 	return err;
 }
 
+static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+			      struct ib_port_attr *props)
+{
+	/* returns host view */
+	return __mlx4_ib_query_port(ibdev, port, props, 0);
+}
+
 static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			       union ib_gid *gid)
 {
@@ -358,7 +373,8 @@ static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
 	in_mad->attr_mod = cpu_to_be32(port);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	err = mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS, port,
+			   NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
@@ -368,7 +384,8 @@ static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	in_mad->attr_id  = IB_SMP_ATTR_GUID_INFO;
 	in_mad->attr_mod = cpu_to_be32(index / 8);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	err = mlx4_MAD_IFC(to_mdev(ibdev), MLX4_MAD_IFC_IGNORE_KEYS, port,
+			   NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
@@ -399,11 +416,12 @@ static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 		return iboe_query_gid(ibdev, port, index, gid);
 }
 
-static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-			      u16 *pkey)
+int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			 u16 *pkey, int netw_view)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
+	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
@@ -415,7 +433,11 @@ static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	in_mad->attr_id  = IB_SMP_ATTR_PKEY_TABLE;
 	in_mad->attr_mod = cpu_to_be32(index / 32);
 
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (mlx4_is_mfunc(to_mdev(ibdev)->dev) && netw_view)
+		mad_ifc_flags |= MLX4_MAD_IFC_NET_VIEW;
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), mad_ifc_flags, port, NULL, NULL,
+			   in_mad, out_mad);
 	if (err)
 		goto out;
 
@@ -427,6 +449,11 @@ out:
 	return err;
 }
 
+static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
+{
+	return __mlx4_ib_query_pkey(ibdev, port, index, pkey, 0);
+}
+
 static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 				 struct ib_device_modify *props)
 {
@@ -808,6 +835,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
+	int mad_ifc_flags = MLX4_MAD_IFC_IGNORE_KEYS;
 	int err = -ENOMEM;
 
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
@@ -817,8 +845,10 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 
 	init_query_mad(in_mad);
 	in_mad->attr_id = IB_SMP_ATTR_NODE_DESC;
+	if (mlx4_is_master(dev->dev))
+		mad_ifc_flags |= MLX4_MAD_IFC_NET_VIEW;
 
-	err = mlx4_MAD_IFC(dev, 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	err = mlx4_MAD_IFC(dev, mad_ifc_flags, 1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
@@ -826,7 +856,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 
 	in_mad->attr_id = IB_SMP_ATTR_NODE_INFO;
 
-	err = mlx4_MAD_IFC(dev, 1, 1, 1, NULL, NULL, in_mad, out_mad);
+	err = mlx4_MAD_IFC(dev, mad_ifc_flags, 1, NULL, NULL, in_mad, out_mad);
 	if (err)
 		goto out;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 058881f..69a42d4 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -184,6 +184,14 @@ enum mlx4_ib_qp_type {
 	MLX4_IB_QPT_TUN_GSI,
 };
 
+enum mlx4_ib_mad_ifc_flags {
+	MLX4_MAD_IFC_IGNORE_MKEY	= 1,
+	MLX4_MAD_IFC_IGNORE_BKEY	= 2,
+	MLX4_MAD_IFC_IGNORE_KEYS	= (MLX4_MAD_IFC_IGNORE_MKEY |
+					   MLX4_MAD_IFC_IGNORE_BKEY),
+	MLX4_MAD_IFC_NET_VIEW		= 4,
+};
+
 enum {
 	MLX4_NUM_TUNNEL_BUFS		= 256,
 };
@@ -520,7 +528,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		      struct ib_recv_wr **bad_wr);
 
-int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
+int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
 		 void *in_mad, void *response_mad);
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
@@ -535,6 +543,10 @@ int mlx4_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list, int npages,
 			 u64 iova);
 int mlx4_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx4_ib_fmr_dealloc(struct ib_fmr *fmr);
+int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+			 struct ib_port_attr *props, int netw_view);
+int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			 u16 *pkey, int netw_view);
 
 int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
 			u8 *mac, int *is_mcast, u8 port);
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index bf55be6..1a7eec4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -40,6 +40,7 @@
 
 #include <linux/mlx4/cmd.h>
 #include <linux/semaphore.h>
+#include <rdma/ib_smi.h>
 
 #include <asm/io.h>
 
@@ -582,6 +583,149 @@ static int mlx4_ACCESS_MEM(struct mlx4_dev *dev, u64 master_addr,
 			    MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
 }
 
+static int query_pkey_block(struct mlx4_dev *dev, u8 port, u16 index, u16 *pkey,
+			       struct mlx4_cmd_mailbox *inbox,
+			       struct mlx4_cmd_mailbox *outbox)
+{
+	struct ib_smp *in_mad = (struct ib_smp *)(inbox->buf);
+	struct ib_smp *out_mad = (struct ib_smp *)(outbox->buf);
+	int err;
+	int i;
+
+	if (index & 0x1f)
+		return -EINVAL;
+
+	in_mad->attr_mod = cpu_to_be32(index / 32);
+
+	err = mlx4_cmd_box(dev, inbox->dma, outbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C,
+			   MLX4_CMD_NATIVE);
+	if (err)
+		return err;
+
+	for (i = 0; i < 32; ++i)
+		pkey[i] = be16_to_cpu(((__be16 *) out_mad->data)[i]);
+
+	return err;
+}
+
+static int get_full_pkey_table(struct mlx4_dev *dev, u8 port, u16 *table,
+			       struct mlx4_cmd_mailbox *inbox,
+			       struct mlx4_cmd_mailbox *outbox)
+{
+	int i;
+	int err;
+
+	for (i = 0; i < dev->caps.pkey_table_len[port]; i += 32) {
+		err = query_pkey_block(dev, port, i, table + i, inbox, outbox);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+#define PORT_CAPABILITY_LOCATION_IN_SMP 20
+#define PORT_STATE_OFFSET 32
+
+static enum ib_port_state vf_port_state(struct mlx4_dev *dev, int port, int vf)
+{
+	/* will be modified when add alias_guid feature */
+	return IB_PORT_DOWN;
+}
+
+static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
+				struct mlx4_vhcr *vhcr,
+				struct mlx4_cmd_mailbox *inbox,
+				struct mlx4_cmd_mailbox *outbox,
+				struct mlx4_cmd_info *cmd)
+{
+	struct ib_smp *smp = inbox->buf;
+	u32 index;
+	u8 port;
+	u16 *table;
+	int err;
+	int vidx, pidx;
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	struct ib_smp *outsmp = outbox->buf;
+	__be16 *outtab = (__be16 *)(outsmp->data);
+	__be32 slave_cap_mask;
+	port = vhcr->in_modifier;
+
+	if (smp->base_version == 1 &&
+	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
+	    smp->class_version == 1) {
+		if (smp->method	== IB_MGMT_METHOD_GET) {
+			if (smp->attr_id == IB_SMP_ATTR_PKEY_TABLE) {
+				index = be32_to_cpu(smp->attr_mod);
+				if (port < 1 || port > dev->caps.num_ports)
+					return -EINVAL;
+				table = kzalloc(dev->caps.pkey_table_len[port] * sizeof *table, GFP_KERNEL);
+				if (!table)
+					return -ENOMEM;
+				/* need to get the full pkey table because the paravirtualized
+				 * pkeys may be scattered among several pkey blocks.
+				 */
+				err = get_full_pkey_table(dev, port, table, inbox, outbox);
+				if (!err) {
+					for (vidx = index * 32; vidx < (index + 1) * 32; ++vidx) {
+						pidx = priv->virt2phys_pkey[slave][port - 1][vidx];
+						outtab[vidx % 32] = cpu_to_be16(table[pidx]);
+					}
+				}
+				kfree(table);
+				return err;
+			}
+			if (smp->attr_id == IB_SMP_ATTR_PORT_INFO) {
+				/*get the slave specific caps:*/
+				/*do the command */
+				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
+					    vhcr->in_modifier, vhcr->op_modifier,
+					    vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
+				/* modify the response for slaves */
+				if (!err && slave != dev->caps.function) {
+					u8 *state = outsmp->data + PORT_STATE_OFFSET;
+
+					*state = (*state & 0xf0) | vf_port_state(dev, port, slave);
+					slave_cap_mask = priv->mfunc.master.slave_state[slave].ib_cap_mask[port];
+					memcpy(outsmp->data + PORT_CAPABILITY_LOCATION_IN_SMP, &slave_cap_mask, 4);
+				}
+				return err;
+			}
+			if (smp->attr_id == IB_SMP_ATTR_GUID_INFO) {
+				/* compute slave's gid block */
+				smp->attr_mod = cpu_to_be32(slave / 8);
+				/* execute cmd */
+				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
+					     vhcr->in_modifier, vhcr->op_modifier,
+					     vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
+				if (!err) {
+					/* if needed, move slave gid to index 0 */
+					if (slave % 8)
+						memcpy(outsmp->data,
+						       outsmp->data + (slave % 8) * 8, 8);
+					/* delete all other gids */
+					memset(outsmp->data + 8, 0, 56);
+				}
+				return err;
+			}
+		}
+	}
+	if (slave != dev->caps.function &&
+	    ((smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) ||
+	     (smp->mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED &&
+	      smp->method == IB_MGMT_METHOD_SET))) {
+		mlx4_err(dev, "slave %d is trying to execute a Subnet MGMT MAD, "
+			 "class 0x%x, method 0x%x for attr 0x%x. Rejecting\n",
+			 slave, smp->method, smp->mgmt_class,
+			 be16_to_cpu(smp->attr_id));
+		return -EPERM;
+	}
+	/*default:*/
+	return mlx4_cmd_box(dev, inbox->dma, outbox->dma,
+				    vhcr->in_modifier, vhcr->op_modifier,
+				    vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
+}
+
 int mlx4_DMA_wrapper(struct mlx4_dev *dev, int slave,
 		     struct mlx4_vhcr *vhcr,
 		     struct mlx4_cmd_mailbox *inbox,
@@ -1016,6 +1160,24 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.wrapper = mlx4_GEN_QP_wrapper
 	},
 	{
+		.opcode = MLX4_CMD_CONF_SPECIAL_QP,
+		.has_inbox = false,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.encode_slave_id = false,
+		.verify = NULL, /* XXX verify: only demux can do this */
+		.wrapper = NULL
+	},
+	{
+		.opcode = MLX4_CMD_MAD_IFC,
+		.has_inbox = true,
+		.has_outbox = true,
+		.out_is_imm = false,
+		.encode_slave_id = false,
+		.verify = NULL,
+		.wrapper = mlx4_MAD_IFC_wrapper
+	},
+	{
 		.opcode = MLX4_CMD_QUERY_IF_STAT,
 		.has_inbox = false,
 		.has_outbox = true,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
