From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 23/29] IB/mlx4: Propagate pkey and guid change port management events to slaves
Date: Mon, 11 Jun 2012 13:46:04 +0300
Message-ID: <1339411570-4689-24-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

pkey change and guid change events are not of interest to all slaves,
but only to those slaves which "see" the table slots whose contents
have change.

For example, if the guid at port 1, index 5 has changed in the
PPF, we wish to propagate the gid-change event only to the function
which has that guid index mapped to its port/guid table (in this case
it is slave #5). Other functions should not get the event,
since the event does not affect them.

Similarly with pkeys -- pkey change events are forwarded
only to slaves which have that pkey index mapped to their
virtual pkey table.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c        |  185 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/fw.c |    6 +
 2 files changed, 188 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 5f2bd05..a72afe9 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -54,6 +54,15 @@ enum {
 #define MLX4_TUN_IS_RECV(a)  (((a) >>  MLX4_TUN_SEND_WRID_SHIFT) & 0x1)
 #define MLX4_TUN_WRID_QPN(a) (((a) >> MLX4_TUN_QPN_SHIFT) & 0x3)
 
+ /* Port mgmt change event handling */
+
+#define GET_BLK_PTR_FROM_EQE(eqe) be32_to_cpu(eqe->event.port_mgmt_change.params.tbl_change_info.block_ptr)
+#define GET_MASK_FROM_EQE(eqe) be32_to_cpu(eqe->event.port_mgmt_change.params.tbl_change_info.tbl_entries_mask)
+#define NUM_IDX_IN_PKEY_TBL_BLK 32
+#define GUID_TBL_ENTRY_SIZE 8	   /* size in bytes */
+#define GUID_TBL_BLK_NUM_ENTRIES 8
+#define GUID_TBL_BLK_SIZE (GUID_TBL_ENTRY_SIZE * GUID_TBL_BLK_NUM_ENTRIES)
+
 struct mlx4_mad_rcv_buf {
 	struct ib_grh grh;
 	u8 payload[256];
@@ -81,6 +90,8 @@ __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
 		cpu_to_be64(0xff00000000000000LL);
 }
 
+static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
+				int block, u32 change_bitmap);
 static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num);
 static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num);
 
@@ -200,6 +211,9 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 	struct ib_event event;
 	struct ib_port_info *pinfo;
 	u16 lid;
+	__be16 *base;
+	u32 bn, pkey_change_bitmap;
+	int i;
 
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
@@ -225,7 +239,35 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			event.device	       = ibdev;
 			event.event	       = IB_EVENT_PKEY_CHANGE;
 			event.element.port_num = port_num;
-			ib_dispatch_event(&event);
+			if (!mlx4_is_mfunc(dev->dev)) {
+				ib_dispatch_event(&event);
+				break;
+			}
+
+			bn  = be32_to_cpu(((struct ib_smp *)mad)->attr_mod) & 0xFFFF;
+			base = (__be16 *) &(((struct ib_smp *)mad)->data[0]);
+			pkey_change_bitmap = 0;
+			for (i = 0; i < 32; i++) {
+				mlx4_ib_dbg("PKEY[%d] = x%x\n",
+					    i + bn*32, be16_to_cpu(base[i]));
+				if (be16_to_cpu(base[i]) !=
+				    dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32]) {
+					pkey_change_bitmap |= (1 << i);
+					dev->pkeys.phys_pkey_cache[port_num - 1][i + bn*32] =
+						be16_to_cpu(base[i]);
+				}
+			}
+			mlx4_ib_dbg("PKEY Change event: port=%d, "
+				    "block=0x%x, change_bitmap=0x%x\n",
+				    port_num, bn, pkey_change_bitmap);
+
+			if (pkey_change_bitmap) {
+				ib_dispatch_event(&event);
+				if (mlx4_is_master(dev->dev) &&
+				    !dev->sriov.is_going_down)
+					__propagate_pkey_ev(dev, port_num, bn,
+							    pkey_change_bitmap);
+			}
 			break;
 
 		case IB_SMP_ATTR_GUID_INFO:
@@ -239,11 +281,55 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 				ib_dispatch_event(&event);
 			}
 			break;
+			/*if master, notify relevant slaves*/
+			if (mlx4_is_master(dev->dev) &&
+			    !dev->sriov.is_going_down) {
+				bn = be32_to_cpu(((struct ib_smp *)mad)->attr_mod);
+				mlx4_ib_update_cache_on_guid_change(dev, bn, port_num,
+								    (u8 *)(&((struct ib_smp *)mad)->data));
+				mlx4_ib_notify_slaves_on_guid_change(dev, bn, port_num,
+								     (u8 *)(&((struct ib_smp *)mad)->data));
+			}
+
 		default:
 			break;
 		}
 }
 
+static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
+				int block, u32 change_bitmap)
+{
+	int i, ix, slave, err;
+	int have_event = 0;
+
+	for (slave = 0; slave < dev->dev->caps.sqp_demux; slave++) {
+		if (slave == dev->dev->caps.function)
+			continue;
+		if (!mlx4_is_slave_active(dev->dev, slave))
+			continue;
+
+		have_event = 0;
+		for (i = 0; i < 32; i++) {
+			if (!(change_bitmap & (1 << i)))
+				continue;
+			for (ix = 0;
+			     ix < dev->dev->caps.pkey_table_len[port_num]; ix++) {
+				if (dev->pkeys.virt2phys_pkey[slave][port_num - 1]
+				    [ix] == i + 32 * block) {
+					err = mlx4_gen_pkey_eqe(dev->dev, slave, port_num);
+					mlx4_ib_dbg("propagate_pkey_ev: slave %d,"
+						    " port %d, ix %d (%d)",
+						    slave, port_num, ix, err);
+					have_event = 1;
+					break;
+				}
+			}
+			if (have_event)
+				break;
+		}
+	}
+}
+
 static void node_desc_override(struct ib_device *dev,
 			       struct ib_mad *mad)
 {
@@ -777,6 +863,10 @@ static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num)
 	event.event		= IB_EVENT_LID_CHANGE;
 
 	ib_dispatch_event(&event);
+
+	if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down)
+		mlx4_gen_slaves_port_mgt_ev(dev->dev, port_num,
+					    MLX4_EQ_PORT_INFO_LID_CHANGE_MASK);
 }
 
 static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num)
@@ -791,12 +881,22 @@ static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num)
 	if (mlx4_is_master(dev->dev)) {
 		mlx4_ib_invalidate_all_guid_record(dev, port_num);
 
-		if (!dev->sriov.is_going_down)
+		if (!dev->sriov.is_going_down) {
 			mlx4_ib_mcg_port_cleanup(&dev->sriov.demux[port_num - 1], 0);
+			mlx4_gen_slaves_port_mgt_ev(dev->dev, port_num,
+						    MLX4_EQ_PORT_INFO_CLIENT_REREG_MASK);
+		}
 	}
 	ib_dispatch_event(&event);
 }
 
+static void propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
+			      struct mlx4_eqe *eqe)
+{
+	__propagate_pkey_ev(dev, port_num, GET_BLK_PTR_FROM_EQE(eqe),
+			    GET_MASK_FROM_EQE(eqe));
+}
+
 static void handle_pkey_change_event(struct mlx4_eqe *eqe,
 				     struct mlx4_ib_dev *dev)
 {
@@ -807,6 +907,9 @@ static void handle_pkey_change_event(struct mlx4_eqe *eqe,
 	event.event	       = IB_EVENT_PKEY_CHANGE;
 	event.element.port_num = port_num;
 
+	if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down)
+		propagate_pkey_ev(dev, port_num, eqe);
+
 	ib_dispatch_event(&event);
 }
 
@@ -820,16 +923,92 @@ static inline void handle_master_sm_change_event(struct mlx4_ib_dev *dev,
 	update_sm_ah(dev, port_num, lid, sl);
 }
 
+static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_num,
+				      u32 guid_tbl_blk_num, u32 change_bitmap)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad  = NULL;
+	u16 i;
+
+	if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
+		return;
+
+	in_mad  = kmalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad) {
+		mlx4_ib_warn(&dev->ib_dev, "failed to allocate memory for guid info mads\n");
+		goto out;
+	}
+
+	guid_tbl_blk_num  *= 4;
+
+	for (i = 0; i < 4; i++) {
+		if (change_bitmap && (!((change_bitmap >> (8 * i)) & 0xff)))
+			continue;
+		memset(in_mad, 0, sizeof *in_mad);
+		memset(out_mad, 0, sizeof *out_mad);
+
+		in_mad->base_version  = 1;
+		in_mad->mgmt_class    = IB_MGMT_CLASS_SUBN_LID_ROUTED;
+		in_mad->class_version = 1;
+		in_mad->method        = IB_MGMT_METHOD_GET;
+		in_mad->attr_id       = IB_SMP_ATTR_GUID_INFO;
+		in_mad->attr_mod      = cpu_to_be32(guid_tbl_blk_num + i);
+
+		if (mlx4_MAD_IFC(dev,
+				 MLX4_MAD_IFC_IGNORE_KEYS | MLX4_MAD_IFC_NET_VIEW,
+				 port_num, NULL, NULL, in_mad, out_mad)) {
+			mlx4_ib_warn(&dev->ib_dev, "Failed in get GUID INFO MAD_IFC\n");
+			goto out;
+		}
+
+		mlx4_ib_update_cache_on_guid_change(dev, guid_tbl_blk_num + i,
+						    port_num,
+						    (u8 *)(&((struct ib_smp *)out_mad)->data));
+		mlx4_ib_notify_slaves_on_guid_change(dev, guid_tbl_blk_num + i,
+						     port_num,
+						     (u8 *)(&((struct ib_smp *)out_mad)->data));
+	}
+
+out:
+	if (in_mad)
+		kfree(in_mad);
+
+	if (out_mad)
+		kfree(out_mad);
+
+	return;
+}
+
 static void handle_guid_change_event(struct mlx4_ib_dev *dev,
 				     struct mlx4_eqe *eqe)
 {
 	struct ib_event event;
+	u32 tbl_block;
+	u32 change_bitmap;
 	u8 port = eqe->event.port_mgmt_change.port;
 
 	event.device	       = &dev->ib_dev;
 	event.event	       = IB_EVENT_GID_CHANGE;
 	event.element.port_num = port;
-	ib_dispatch_event(&event);
+	/* The mfunc master's GUID is always the default GUID
+	   and will never change, so there's no need to dispatch the event */
+	if (!mlx4_is_mfunc(dev->dev) || mlx4_is_slave(dev->dev)) {
+		event.device	       = &dev->ib_dev;
+		event.event	       = IB_EVENT_GID_CHANGE;
+		event.element.port_num = port;
+		ib_dispatch_event(&event);
+
+		return;
+	}
+
+	/*if master, notify relevant slaves*/
+	if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down) {
+		tbl_block = GET_BLK_PTR_FROM_EQE(eqe);
+		change_bitmap = GET_MASK_FROM_EQE(eqe);
+
+		handle_slaves_guid_change(dev, port, tbl_block, change_bitmap);
+	}
 }
 
 void handle_port_mgmt_change_event(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index af34b73..b3110d0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -727,6 +727,7 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 			       struct mlx4_cmd_mailbox *outbox,
 			       struct mlx4_cmd_info *cmd)
 {
+	u64	flags;
 	int	err = 0;
 	u8	field;
 
@@ -735,6 +736,11 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		return err;
 
+	/* add port mng change event capability unconditionally to slaves */
+	MLX4_GET(flags, outbox->buf, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
+	flags |= MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV;
+	MLX4_PUT(outbox->buf, flags, QUERY_DEV_CAP_EXT_FLAGS_OFFSET);
+
 	/* For guests, report Blueflame disabled */
 	MLX4_GET(field, outbox->buf, QUERY_DEV_CAP_BF_OFFSET);
 	field &= 0x7f;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
