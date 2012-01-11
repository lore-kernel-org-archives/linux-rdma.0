From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/6] IB/mlx4: fix wrong info returned when querying IBoE
 ports
Date: Wed, 11 Jan 2012 19:00:29 +0200
Message-ID: <alpine.LRH.2.00.1201111859390.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To issue port query, use the QUERY_(Ethernet)_PORT command instead of
MAD_IFC command as the latter attempts to query the firmware IB SMA agent,
which is irrelevant for IBoE ports. This allows to support both 10Gb/s and
40Gb/s rates (e.g in sysfs), using QDR speed (10Gb/s) and width of 1X or 4X.

Signed-off-by: Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   97 ++++++++++++++++++++-----------------
 1 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 6ff6bdf..85f6048 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -182,12 +182,27 @@ mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
 }

 static int ib_link_query_port(struct ib_device *ibdev, u8 port,
-			      struct ib_port_attr *props,
-			      struct ib_smp *in_mad,
-			      struct ib_smp *out_mad)
+			      struct ib_port_attr *props)
 {
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
 	int ext_active_speed;
-	int err;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
+	in_mad->attr_mod = cpu_to_be32(port);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL,
+				in_mad, out_mad);
+	if (err)
+		goto out;
+

 	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc		= out_mad->data[34] & 0x7;
@@ -234,15 +249,17 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 			err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
 					   NULL, NULL, in_mad, out_mad);
 			if (err)
-				return err;
+				goto out;

 			/* Checking LinkSpeedActive for FDR-10 */
 			if (out_mad->data[15] & 0x1)
 				props->active_speed = IB_SPEED_FDR10;
 		}
 	}
-
-	return 0;
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+	return err;
 }

 static u8 state_to_phys_state(enum ib_port_state state)
@@ -251,32 +268,42 @@ static u8 state_to_phys_state(enum ib_port_state state)
 }

 static int eth_link_query_port(struct ib_device *ibdev, u8 port,
-			       struct ib_port_attr *props,
-			       struct ib_smp *out_mad)
+			       struct ib_port_attr *props)
 {
-	struct mlx4_ib_iboe *iboe = &to_mdev(ibdev)->iboe;
+
+	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
+	struct mlx4_ib_iboe *iboe = &mdev->iboe;
 	struct net_device *ndev;
 	enum ib_mtu tmp;
+	struct mlx4_cmd_mailbox *mailbox;
+	int err = 0;
+
+	mailbox = mlx4_alloc_cmd_mailbox(mdev->dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	err = mlx4_cmd_box(mdev->dev, 0, mailbox->dma, port, 0,
+			   MLX4_CMD_QUERY_PORT, MLX4_CMD_TIME_CLASS_B,
+			   MLX4_CMD_WRAPPED);
+	if (err)
+		goto out;

-	props->active_width	= IB_WIDTH_1X;
+	props->active_width	=  (((u8 *)mailbox->buf)[5] == 0x40) ?
+						IB_WIDTH_4X : IB_WIDTH_1X;
 	props->active_speed	= IB_SPEED_QDR;
 	props->port_cap_flags	= IB_PORT_CM_SUP;
-	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
-	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
+	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
+	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= 1;
-	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
-	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
 	props->max_mtu		= IB_MTU_4096;
-	props->subnet_timeout	= 0;
-	props->max_vl_num	= out_mad->data[37] >> 4;
-	props->init_type_reply	= 0;
+	props->max_vl_num	= 2;
 	props->state		= IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 	props->active_mtu	= IB_MTU_256;
 	spin_lock(&iboe->lock);
 	ndev = iboe->netdevs[port - 1];
 	if (!ndev)
-		goto out;
+		goto out_unlock;

 	tmp = iboe_get_mtu(ndev->mtu);
 	props->active_mtu = tmp ? min(props->max_mtu, tmp) : IB_MTU_256;
@@ -284,41 +311,23 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= (netif_running(ndev) && netif_carrier_ok(ndev)) ?
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
-
-out:
+out_unlock:
 	spin_unlock(&iboe->lock);
-	return 0;
+out:
+	mlx4_free_cmd_mailbox(mdev->dev, mailbox);
+	return err;
 }

 static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 			      struct ib_port_attr *props)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
-
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	int err;

 	memset(props, 0, sizeof *props);

-	init_query_mad(in_mad);
-	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
-	in_mad->attr_mod = cpu_to_be32(port);
-
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
-	if (err)
-		goto out;
-
 	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
-		ib_link_query_port(ibdev, port, props, in_mad, out_mad) :
-		eth_link_query_port(ibdev, port, props, out_mad);
-
-out:
-	kfree(in_mad);
-	kfree(out_mad);
+		ib_link_query_port(ibdev, port, props) :
+				eth_link_query_port(ibdev, port, props);

 	return err;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
