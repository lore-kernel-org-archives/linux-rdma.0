From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 18/22] IB/mlx4: Miscellaneous adjustments to SRIOV IB support
Date: Fri,  3 Aug 2012 11:40:54 +0300
Message-ID: <1343983258-6268-19-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. allow only master to change node description
2. prevent ah leakage in send mads
3. take device part number from PCI structure, so that
   guests see the VF part number (and not the PF part number)
4. place the device revision ID into caps structure at startup
5. SET_PORT in update_gids_task needs to go through wrapper on master.
6. in mlx4_ib_event, PORT_MGMT_EVENT needs be handled in a work queue
   on the master, since it propagates events to slaves using GEN_EQE
7. Do not support FMR on slaves.
8. Add spinlock to slave_event(), since it is called both in interrupt
   context and in process context (due to 6 above, and also if smp_snoop
   is used).
   This fix was found and implemented by Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c          |    6 +++++-
 drivers/infiniband/hw/mlx4/main.c         |   26 ++++++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |    1 +
 drivers/net/ethernet/mellanox/mlx4/eq.c   |    8 ++++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 5 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index ec64077..cee7bf6 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -705,7 +705,9 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	if (!out_mad->mad_hdr.status) {
 		if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV))
 			smp_snoop(ibdev, port_num, in_mad, prev_lid);
-		node_desc_override(ibdev, out_mad);
+		/* slaves get node desc from FW */
+		if (!mlx4_is_slave(to_mdev(ibdev)->dev))
+			node_desc_override(ibdev, out_mad);
 	}
 
 	/* set return bit in status of directed route responses */
@@ -788,6 +790,8 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {
+	if (mad_send_wc->send_buf->context[0])
+		ib_destroy_ah(mad_send_wc->send_buf->context[0]);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 778fdb8..1166379 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -138,7 +138,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
-	props->vendor_part_id	   = be16_to_cpup((__be16 *) (out_mad->data + 30));
+	props->vendor_part_id	   = dev->dev->pdev->device;
 	props->hw_ver		   = be32_to_cpup((__be32 *) (out_mad->data + 32));
 	memcpy(&props->sys_image_guid, out_mad->data +	4, 8);
 
@@ -477,6 +477,9 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
 		return 0;
 
+	if (mlx4_is_slave(to_mdev(ibdev)->dev))
+		return -EOPNOTSUPP;
+
 	spin_lock_irqsave(&to_mdev(ibdev)->sm_lock, flags);
 	memcpy(ibdev->node_desc, props->node_desc, 64);
 	spin_unlock_irqrestore(&to_mdev(ibdev)->sm_lock, flags);
@@ -492,7 +495,7 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	memset(mailbox->buf, 0, 256);
 	memcpy(mailbox->buf, props->node_desc, 64);
 	mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
-		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
+		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
 
 	mlx4_free_cmd_mailbox(to_mdev(ibdev)->dev, mailbox);
 
@@ -920,6 +923,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
+	dev->dev->rev_id = be32_to_cpup((__be32 *) (out_mad->data + 32));
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
@@ -1008,7 +1012,7 @@ static void update_gids_task(struct work_struct *work)
 
 	err = mlx4_cmd(dev, mailbox->dma, MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
 		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
-		       MLX4_CMD_NATIVE);
+		       MLX4_CMD_WRAPPED);
 	if (err)
 		pr_warn("set port command failed\n");
 	else {
@@ -1399,10 +1403,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
 
-	ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
-	ibdev->ib_dev.map_phys_fmr	= mlx4_ib_map_phys_fmr;
-	ibdev->ib_dev.unmap_fmr		= mlx4_ib_unmap_fmr;
-	ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
+	if (!mlx4_is_slave(ibdev->dev)) {
+		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
+		ibdev->ib_dev.map_phys_fmr	= mlx4_ib_map_phys_fmr;
+		ibdev->ib_dev.unmap_fmr		= mlx4_ib_unmap_fmr;
+		ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
+	}
 
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) {
 		ibdev->ib_dev.alloc_xrcd = mlx4_ib_alloc_xrcd;
@@ -1614,7 +1620,11 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 		INIT_WORK(&ew->work, handle_port_mgmt_change_event);
 		memcpy(&ew->ib_eqe, eqe, sizeof *eqe);
 		ew->ib_dev = ibdev;
-		handle_port_mgmt_change_event(&ew->work);
+		/* need to queue only for port owner, which uses GEN_EQE */
+		if (mlx4_is_master(dev))
+			queue_work(wq, &ew->work);
+		else
+			handle_port_mgmt_change_event(&ew->work);
 		return;
 
 	case MLX4_DEV_EVENT_SLAVE_INIT:
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index c13e988..9717002 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1712,6 +1712,7 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 		INIT_WORK(&priv->mfunc.master.slave_flr_event_work,
 			  mlx4_master_handle_slave_flr);
 		spin_lock_init(&priv->mfunc.master.slave_state_lock);
+		spin_lock_init(&priv->mfunc.master.slave_eq.event_lock);
 		priv->mfunc.master.comm_wq =
 			create_singlethread_workqueue("mlx4_comm");
 		if (!priv->mfunc.master.comm_wq)
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index c425826..51c7649 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -164,13 +164,16 @@ static void slave_event(struct mlx4_dev *dev, u8 slave, struct mlx4_eqe *eqe)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_slave_event_eq *slave_eq = &priv->mfunc.master.slave_eq;
-	struct mlx4_eqe *s_eqe =
-		&slave_eq->event_eqe[slave_eq->prod & (SLAVE_EVENT_EQ_SIZE - 1)];
+	struct mlx4_eqe *s_eqe;
+	unsigned long flags;
 
+	spin_lock_irqsave(&slave_eq->event_lock, flags);
+	s_eqe = &slave_eq->event_eqe[slave_eq->prod & (SLAVE_EVENT_EQ_SIZE - 1)];
 	if ((!!(s_eqe->owner & 0x80)) ^
 	    (!!(slave_eq->prod & SLAVE_EVENT_EQ_SIZE))) {
 		mlx4_warn(dev, "Master failed to generate an EQE for slave: %d. "
 			  "No free EQE on slave events queue\n", slave);
+		spin_unlock_irqrestore(&slave_eq->event_lock, flags);
 		return;
 	}
 
@@ -183,6 +186,7 @@ static void slave_event(struct mlx4_dev *dev, u8 slave, struct mlx4_eqe *eqe)
 
 	queue_work(priv->mfunc.master.comm_wq,
 		   &priv->mfunc.master.slave_event_work);
+	spin_unlock_irqrestore(&slave_eq->event_lock, flags);
 }
 
 static void mlx4_slave_event(struct mlx4_dev *dev, int slave,
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 91e5ead..5c30488 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -473,6 +473,7 @@ struct mlx4_slave_event_eq {
 	u32 eqn;
 	u32 cons;
 	u32 prod;
+	spinlock_t event_lock;
 	struct mlx4_eqe event_eqe[SLAVE_EVENT_EQ_SIZE];
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
