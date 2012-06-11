From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 28/29] IB/mlx4: Miscellaneous adjustments to SRIOV IB support
Date: Mon, 11 Jun 2012 13:46:09 +0300
Message-ID: <1339411570-4689-29-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
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

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c  |    6 +++++-
 drivers/infiniband/hw/mlx4/main.c |   26 ++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 6f74335..76212bd 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -713,7 +713,9 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	if (!out_mad->mad_hdr.status) {
 		if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_PORT_MNG_CHG_EV))
 			smp_snoop(ibdev, port_num, in_mad, prev_lid);
-		node_desc_override(ibdev, out_mad);
+		/* slaves get node desc from FW */
+		if (!mlx4_is_slave(to_mdev(ibdev)->dev))
+			node_desc_override(ibdev, out_mad);
 	}
 
 	/* set return bit in status of directed route responses */
@@ -796,6 +798,8 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {
+	if (mad_send_wc->send_buf->context[0])
+		ib_destroy_ah(mad_send_wc->send_buf->context[0]);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 14bb028..444c2fb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -146,7 +146,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
-	props->vendor_part_id	   = be16_to_cpup((__be16 *) (out_mad->data + 30));
+	props->vendor_part_id	   = dev->dev->pdev->device;
 	props->hw_ver		   = be32_to_cpup((__be32 *) (out_mad->data + 32));
 	memcpy(&props->sys_image_guid, out_mad->data +	4, 8);
 
@@ -485,6 +485,9 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	if (!(mask & IB_DEVICE_MODIFY_NODE_DESC))
 		return 0;
 
+	if (mlx4_is_slave(to_mdev(ibdev)->dev))
+		return -EOPNOTSUPP;
+
 	spin_lock(&to_mdev(ibdev)->sm_lock);
 	memcpy(ibdev->node_desc, props->node_desc, 64);
 	spin_unlock(&to_mdev(ibdev)->sm_lock);
@@ -500,7 +503,7 @@ static int mlx4_ib_modify_device(struct ib_device *ibdev, int mask,
 	memset(mailbox->buf, 0, 256);
 	memcpy(mailbox->buf, props->node_desc, 64);
 	mlx4_cmd(to_mdev(ibdev)->dev, mailbox->dma, 1, 0,
-		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
+		 MLX4_CMD_SET_NODE, MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
 
 	mlx4_free_cmd_mailbox(to_mdev(ibdev)->dev, mailbox);
 
@@ -880,6 +883,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
+	dev->dev->rev_id = be32_to_cpup((__be32 *) (out_mad->data + 32));
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
@@ -969,7 +973,7 @@ static void update_gids_task(struct work_struct *work)
 
 	err = mlx4_cmd(dev, mailbox->dma, MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
 		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B,
-		       MLX4_CMD_NATIVE);
+		       MLX4_CMD_WRAPPED);
 	if (err)
 		pr_warn("set port command failed\n");
 	else {
@@ -1362,10 +1366,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
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
@@ -1577,7 +1583,11 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
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
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
