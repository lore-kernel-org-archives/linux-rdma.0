From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 07/22] {NET,IB}/mlx4: Implement QP paravirtualization and maintain phys_pkey_cache for smp_snoop
Date: Fri,  3 Aug 2012 11:40:43 +0300
Message-ID: <1343983258-6268-8-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The requires:
1. Replacing the paravirtualized pkey index (inserted
   by the guest) with the real pkey index

2. For UD qp's, placing the guest's true source gid index
   in the address path structure mgid field, and setting
   the ud_force_mgid bit so that the mgid is taken from
   the qp context and not from the WQE when posting sends.

3. For UC and RC QPs, placing the guest's true source gid index
   in the address path structure mgid field.

4. For tunnel and proxy QPs, setting the QKEY value reserved for
   that proxy/tunnel pair.

Since not all the above adjustments occur in all the QP transitions,
the QP transitions require separate wrapper functions.

Secondly, initialize the pkey virtualization table to its default
values: Master virtualized table is 1-1 with the real pkey table,
guest virtualized table has pkey index 0 mapped to the real
pkey index 0, and all the other pkey indices mapped to the
reserved (invalid) pkey at index 127.

Finally, Add logic in smp_snoop for maintaining the phys_pkey_cache.
and generating events on the master only if a pkey actually changed.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c                   |   33 +++-
 drivers/infiniband/hw/mlx4/main.c                  |   35 +++
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   12 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   11 +
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   47 +++++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  217 +++++++++++++++++++-
 include/linux/mlx4/device.h                        |    3 +
 7 files changed, 344 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d955cc4..2413a08 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -184,6 +184,10 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 {
 	struct ib_port_info *pinfo;
 	u16 lid;
+	__be16 *base;
+	u32 bn, pkey_change_bitmap;
+	int i;
+
 
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
@@ -208,8 +212,33 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			break;
 
 		case IB_SMP_ATTR_PKEY_TABLE:
-			mlx4_ib_dispatch_event(dev, port_num,
-					       IB_EVENT_PKEY_CHANGE);
+			if (!mlx4_is_mfunc(dev->dev)) {
+				mlx4_ib_dispatch_event(dev, port_num,
+						       IB_EVENT_PKEY_CHANGE);
+				break;
+			}
+
+			bn  = be32_to_cpu(((struct ib_smp *)mad)->attr_mod) & 0xFFFF;
+			base = (__be16 *) &(((struct ib_smp *)mad)->data[0]);
+			pkey_change_bitmap = 0;
+			for (i = 0; i < 32; i++) {
+				pr_debug("PKEY[%d] = x%x\n",
+					 i + bn*32, be16_to_cpu(base[i]));
+				if (be16_to_cpu(base[i]) !=
+				    dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32]) {
+					pkey_change_bitmap |= (1 << i);
+					dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32] =
+						be16_to_cpu(base[i]);
+				}
+			}
+			pr_debug("PKEY Change event: port=%d, "
+				 "block=0x%x, change_bitmap=0x%x\n",
+				 port_num, bn, pkey_change_bitmap);
+
+			if (pkey_change_bitmap)
+				mlx4_ib_dispatch_event(dev, port_num,
+						       IB_EVENT_PKEY_CHANGE);
+
 			break;
 
 		case IB_SMP_ATTR_GUID_INFO:
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 075561f..bdfd3ae 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1120,6 +1120,38 @@ static int mlx4_ib_netdev_event(struct notifier_block *this, unsigned long event
 	return NOTIFY_DONE;
 }
 
+static void init_pkeys(struct mlx4_ib_dev *ibdev)
+{
+	int port;
+	int slave;
+	int i;
+
+	if (mlx4_is_master(ibdev->dev)) {
+		for (slave = 0; slave <= ibdev->dev->num_vfs; ++slave) {
+			for (port = 1; port <= ibdev->dev->caps.num_ports; ++port) {
+				for (i = 0;
+				     i < ibdev->dev->phys_caps.pkey_phys_table_len[port];
+				     ++i) {
+					ibdev->pkeys.virt2phys_pkey[slave][port - 1][i] =
+					/* master has the identity virt2phys pkey mapping */
+						(slave == mlx4_master_func_num(ibdev->dev) || !i) ? i :
+							ibdev->dev->phys_caps.pkey_phys_table_len[port] - 1;
+					mlx4_sync_pkey_table(ibdev->dev, slave, port, i,
+							     ibdev->pkeys.virt2phys_pkey[slave][port - 1][i]);
+				}
+			}
+		}
+		/* initialize pkey cache */
+		for (port = 1; port <= ibdev->dev->caps.num_ports; ++port) {
+			for (i = 0;
+			     i < ibdev->dev->phys_caps.pkey_phys_table_len[port];
+			     ++i)
+				ibdev->pkeys.phys_pkey_cache[port-1][i] =
+					(i) ? 0 : 0xFFFF;
+		}
+	}
+}
+
 static void mlx4_ib_alloc_eqs(struct mlx4_dev *dev, struct mlx4_ib_dev *ibdev)
 {
 	char name[32];
@@ -1374,6 +1406,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	ibdev->ib_active = true;
 
+	if (mlx4_is_mfunc(ibdev->dev))
+		init_pkeys(ibdev);
+
 	return ibdev;
 
 err_notif:
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 1c2fc72..89feaed 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -905,7 +905,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_INIT2INIT_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_INIT2RTR_QP,
@@ -923,7 +923,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_RTR2RTS_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_RTS2RTS_QP,
@@ -932,7 +932,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_RTS2RTS_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SQERR2RTS_QP,
@@ -941,7 +941,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_SQERR2RTS_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_2ERR_QP,
@@ -968,7 +968,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_SQD2SQD_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_SQD2RTS_QP,
@@ -977,7 +977,7 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.out_is_imm = false,
 		.encode_slave_id = false,
 		.verify = NULL,
-		.wrapper = mlx4_GEN_QP_wrapper
+		.wrapper = mlx4_SQD2RTS_QP_wrapper
 	},
 	{
 		.opcode = MLX4_CMD_2RST_QP,
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 892f2d6..cd82607 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -427,6 +427,17 @@ int mlx4_get_parav_qkey(struct mlx4_dev *dev, u32 qpn, u32 *qkey)
 }
 EXPORT_SYMBOL(mlx4_get_parav_qkey);
 
+void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port, int i, int val)
+{
+	struct mlx4_priv *priv = container_of(dev, struct mlx4_priv, dev);
+
+	if (!mlx4_is_master(dev))
+		return;
+
+	priv->virt2phys_pkey[slave][port - 1][i] = val;
+}
+EXPORT_SYMBOL(mlx4_sync_pkey_table);
+
 int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 59ebc03..cd77a74 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -731,6 +731,8 @@ struct mlx4_priv {
 	struct io_mapping	*bf_mapping;
 	int			reserved_mtts;
 	int			fs_hash_mode;
+	u8 virt2phys_pkey[MLX4_MFUNC_MAX][MLX4_MAX_PORTS][MLX4_MAX_PORT_PKEYS];
+
 };
 
 static inline struct mlx4_priv *mlx4_priv(struct mlx4_dev *dev)
@@ -935,16 +937,61 @@ int mlx4_RST2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
 			     struct mlx4_cmd_mailbox *inbox,
 			     struct mlx4_cmd_mailbox *outbox,
 			     struct mlx4_cmd_info *cmd);
+int mlx4_INIT2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
+			      struct mlx4_vhcr *vhcr,
+			      struct mlx4_cmd_mailbox *inbox,
+			      struct mlx4_cmd_mailbox *outbox,
+			      struct mlx4_cmd_info *cmd);
 int mlx4_INIT2RTR_QP_wrapper(struct mlx4_dev *dev, int slave,
 			     struct mlx4_vhcr *vhcr,
 			     struct mlx4_cmd_mailbox *inbox,
 			     struct mlx4_cmd_mailbox *outbox,
 			     struct mlx4_cmd_info *cmd);
+int mlx4_RTR2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd);
+int mlx4_RTS2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd);
+int mlx4_SQERR2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			      struct mlx4_vhcr *vhcr,
+			      struct mlx4_cmd_mailbox *inbox,
+			      struct mlx4_cmd_mailbox *outbox,
+			      struct mlx4_cmd_info *cmd);
+int mlx4_2ERR_QP_wrapper(struct mlx4_dev *dev, int slave,
+			 struct mlx4_vhcr *vhcr,
+			 struct mlx4_cmd_mailbox *inbox,
+			 struct mlx4_cmd_mailbox *outbox,
+			 struct mlx4_cmd_info *cmd);
+int mlx4_RTS2SQD_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd);
+int mlx4_SQD2SQD_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd);
+int mlx4_SQD2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd);
 int mlx4_2RST_QP_wrapper(struct mlx4_dev *dev, int slave,
 			 struct mlx4_vhcr *vhcr,
 			 struct mlx4_cmd_mailbox *inbox,
 			 struct mlx4_cmd_mailbox *outbox,
 			 struct mlx4_cmd_info *cmd);
+int mlx4_QUERY_QP_wrapper(struct mlx4_dev *dev, int slave,
+			  struct mlx4_vhcr *vhcr,
+			  struct mlx4_cmd_mailbox *inbox,
+			  struct mlx4_cmd_mailbox *outbox,
+			  struct mlx4_cmd_info *cmd);
 
 int mlx4_GEN_EQE(struct mlx4_dev *dev, int slave, struct mlx4_eqe *eqe);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 0f36ae9..27fb4e5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -241,6 +241,15 @@ static int res_tracker_insert(struct rb_root *root, struct res_common *res)
 	return 0;
 }
 
+enum qp_transition {
+	QP_TRANS_INIT2RTR,
+	QP_TRANS_RTR2RTS,
+	QP_TRANS_RTS2RTS,
+	QP_TRANS_SQERR2RTS,
+	QP_TRANS_SQD2SQD,
+	QP_TRANS_SQD2RTS
+};
+
 /* For Debug uses */
 static const char *ResourceType(enum mlx4_resource rt)
 {
@@ -307,14 +316,41 @@ void mlx4_free_resource_tracker(struct mlx4_dev *dev,
 	}
 }
 
-static void update_ud_gid(struct mlx4_dev *dev,
-			  struct mlx4_qp_context *qp_ctx, u8 slave)
+static void update_pkey_index(struct mlx4_dev *dev, int slave,
+			      struct mlx4_cmd_mailbox *inbox)
 {
-	u32 ts = (be32_to_cpu(qp_ctx->flags) >> 16) & 0xff;
+	u8 sched = *(u8 *)(inbox->buf + 64);
+	u8 orig_index = *(u8 *)(inbox->buf + 35);
+	u8 new_index;
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int port;
+
+	port = (sched >> 6 & 1) + 1;
+
+	new_index = priv->virt2phys_pkey[slave][port - 1][orig_index];
+	*(u8 *)(inbox->buf + 35) = new_index;
+
+	mlx4_dbg(dev, "port = %d, orig pkey index = %d, "
+		 "new pkey index = %d\n", port, orig_index, new_index);
+}
+
+static void update_gid(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *inbox,
+		       u8 slave)
+{
+	struct mlx4_qp_context	*qp_ctx = inbox->buf + 8;
+	enum mlx4_qp_optpar	optpar = be32_to_cpu(*(__be32 *) inbox->buf);
+	u32			ts = (be32_to_cpu(qp_ctx->flags) >> 16) & 0xff;
 
 	if (MLX4_QP_ST_UD == ts)
 		qp_ctx->pri_path.mgid_index = 0x80 | slave;
 
+	if (MLX4_QP_ST_RC == ts || MLX4_QP_ST_UC == ts) {
+		if (optpar & MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH)
+			qp_ctx->pri_path.mgid_index = slave & 0x7F;
+		if (optpar & MLX4_QP_OPTPAR_ALT_ADDR_PATH)
+			qp_ctx->alt_path.mgid_index = slave & 0x7F;
+	}
+
 	mlx4_dbg(dev, "slave %d, new gid index: 0x%x ",
 		slave, qp_ctx->pri_path.mgid_index);
 }
@@ -1108,6 +1144,11 @@ static int valid_reserved(struct mlx4_dev *dev, int slave, int qpn)
 		(mlx4_is_master(dev) || mlx4_is_guest_proxy(dev, slave, qpn));
 }
 
+static int fw_reserved(struct mlx4_dev *dev, int qpn)
+{
+	return qpn < dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW];
+}
+
 static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 			u64 in_param, u64 *out_param)
 {
@@ -1145,7 +1186,7 @@ static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 		if (err)
 			return err;
 
-		if (!valid_reserved(dev, slave, qpn)) {
+		if (!fw_reserved(dev, qpn)) {
 			err = __mlx4_qp_alloc_icm(dev, qpn);
 			if (err) {
 				res_abort_move(dev, slave, RES_QP, qpn);
@@ -1498,7 +1539,7 @@ static int qp_free_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 		if (err)
 			return err;
 
-		if (!valid_reserved(dev, slave, qpn))
+		if (!fw_reserved(dev, qpn))
 			__mlx4_qp_free_icm(dev, qpn);
 
 		res_end_move(dev, slave, RES_QP, qpn);
@@ -1938,6 +1979,19 @@ static u32 qp_get_srqn(struct mlx4_qp_context *qpc)
 	return be32_to_cpu(qpc->srqn) & 0x1ffffff;
 }
 
+static void adjust_proxy_tun_qkey(struct mlx4_dev *dev, struct mlx4_vhcr *vhcr,
+				  struct mlx4_qp_context *context)
+{
+	u32 qpn = vhcr->in_modifier & 0xffffff;
+	u32 qkey = 0;
+
+	if (mlx4_get_parav_qkey(dev, qpn, &qkey))
+		return;
+
+	/* adjust qkey in qp context */
+	context->qkey = cpu_to_be32(qkey);
+}
+
 int mlx4_RST2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
 			     struct mlx4_vhcr *vhcr,
 			     struct mlx4_cmd_mailbox *inbox,
@@ -1990,6 +2044,8 @@ int mlx4_RST2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
 			goto ex_put_scq;
 	}
 
+	adjust_proxy_tun_qkey(dev, vhcr, qpc);
+	update_pkey_index(dev, slave, inbox);
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto ex_put_srq;
@@ -2135,6 +2191,48 @@ static int get_containing_mtt(struct mlx4_dev *dev, int slave, int start,
 	return err;
 }
 
+static int verify_qp_parameters(struct mlx4_dev *dev,
+				struct mlx4_cmd_mailbox *inbox,
+				enum qp_transition transition, u8 slave)
+{
+	u32			qp_type;
+	struct mlx4_qp_context	*qp_ctx;
+	enum mlx4_qp_optpar	optpar;
+
+	qp_ctx  = inbox->buf + 8;
+	qp_type	= (be32_to_cpu(qp_ctx->flags) >> 16) & 0xff;
+	optpar	= be32_to_cpu(*(__be32 *) inbox->buf);
+
+	switch (qp_type) {
+	case MLX4_QP_ST_RC:
+	case MLX4_QP_ST_UC:
+		switch (transition) {
+		case QP_TRANS_INIT2RTR:
+		case QP_TRANS_RTR2RTS:
+		case QP_TRANS_RTS2RTS:
+		case QP_TRANS_SQD2SQD:
+		case QP_TRANS_SQD2RTS:
+			if (slave != mlx4_master_func_num(dev))
+				/* slaves have only gid index 0 */
+				if (optpar & MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH)
+					if (qp_ctx->pri_path.mgid_index)
+						return -EINVAL;
+				if (optpar & MLX4_QP_OPTPAR_ALT_ADDR_PATH)
+					if (qp_ctx->alt_path.mgid_index)
+						return -EINVAL;
+			break;
+		default:
+			break;
+		}
+
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 int mlx4_WRITE_MTT_wrapper(struct mlx4_dev *dev, int slave,
 			   struct mlx4_vhcr *vhcr,
 			   struct mlx4_cmd_mailbox *inbox,
@@ -2622,16 +2720,123 @@ out:
 	return err;
 }
 
+int mlx4_INIT2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
+			      struct mlx4_vhcr *vhcr,
+			      struct mlx4_cmd_mailbox *inbox,
+			      struct mlx4_cmd_mailbox *outbox,
+			      struct mlx4_cmd_info *cmd)
+{
+	struct mlx4_qp_context *context = inbox->buf + 8;
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	update_pkey_index(dev, slave, inbox);
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
 int mlx4_INIT2RTR_QP_wrapper(struct mlx4_dev *dev, int slave,
 			     struct mlx4_vhcr *vhcr,
 			     struct mlx4_cmd_mailbox *inbox,
 			     struct mlx4_cmd_mailbox *outbox,
 			     struct mlx4_cmd_info *cmd)
 {
+	int err;
 	struct mlx4_qp_context *qpc = inbox->buf + 8;
 
-	update_ud_gid(dev, qpc, (u8)slave);
+	err = verify_qp_parameters(dev, inbox, QP_TRANS_INIT2RTR, slave);
+	if (err)
+		return err;
+
+	update_pkey_index(dev, slave, inbox);
+	update_gid(dev, inbox, (u8)slave);
+	adjust_proxy_tun_qkey(dev, vhcr, qpc);
+
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
+int mlx4_RTR2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd)
+{
+	int err;
+	struct mlx4_qp_context *context = inbox->buf + 8;
+
+	err = verify_qp_parameters(dev, inbox, QP_TRANS_RTR2RTS, slave);
+	if (err)
+		return err;
+
+	update_pkey_index(dev, slave, inbox);
+	update_gid(dev, inbox, (u8)slave);
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
+int mlx4_RTS2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd)
+{
+	int err;
+	struct mlx4_qp_context *context = inbox->buf + 8;
+
+	err = verify_qp_parameters(dev, inbox, QP_TRANS_RTS2RTS, slave);
+	if (err)
+		return err;
+
+	update_pkey_index(dev, slave, inbox);
+	update_gid(dev, inbox, (u8)slave);
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
+
+int mlx4_SQERR2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			      struct mlx4_vhcr *vhcr,
+			      struct mlx4_cmd_mailbox *inbox,
+			      struct mlx4_cmd_mailbox *outbox,
+			      struct mlx4_cmd_info *cmd)
+{
+	struct mlx4_qp_context *context = inbox->buf + 8;
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
+int mlx4_SQD2SQD_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd)
+{
+	int err;
+	struct mlx4_qp_context *context = inbox->buf + 8;
+
+	err = verify_qp_parameters(dev, inbox, QP_TRANS_SQD2SQD, slave);
+	if (err)
+		return err;
+
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	update_gid(dev, inbox, (u8)slave);
+	update_pkey_index(dev, slave, inbox);
+	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
+}
+
+int mlx4_SQD2RTS_QP_wrapper(struct mlx4_dev *dev, int slave,
+			    struct mlx4_vhcr *vhcr,
+			    struct mlx4_cmd_mailbox *inbox,
+			    struct mlx4_cmd_mailbox *outbox,
+			    struct mlx4_cmd_info *cmd)
+{
+	int err;
+	struct mlx4_qp_context *context = inbox->buf + 8;
+
+	err = verify_qp_parameters(dev, inbox, QP_TRANS_SQD2RTS, slave);
+	if (err)
+		return err;
 
+	adjust_proxy_tun_qkey(dev, vhcr, context);
+	update_gid(dev, inbox, (u8)slave);
+	update_pkey_index(dev, slave, inbox);
 	return mlx4_GEN_QP_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 }
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index d8004f2..8e2f03f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -927,6 +927,9 @@ int mlx4_flow_attach(struct mlx4_dev *dev,
 		     struct mlx4_net_trans_rule *rule, u64 *reg_id);
 int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id);
 
+void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port,
+			  int i, int val);
+
 int mlx4_get_parav_qkey(struct mlx4_dev *dev, u32 qpn, u32 *qkey);
 
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
