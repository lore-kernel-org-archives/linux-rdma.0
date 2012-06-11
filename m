From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 11/29] net/mlx4_core: Allow guests to support IB ports
Date: Mon, 11 Jun 2012 13:45:52 +0300
Message-ID: <1339411570-4689-12-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify mlx4_dev_cap to allow IB support when SRIOV is active.
Modify mlx4_slave_cap to set the "rdma-supported" bit in its
flags area, and pass that to the guests (this is done in
QUERY_FUNC_CAP and its wrapper).

However, Do not yet activate IB support (i.e., do not yet remove the
error return at the start of mlx4_ib_add in the mlx4_ib driver).

In addition, set "protected fmr supported" bit to zero in the
QUERY_FUNC_CAP wrapper.

Finally, in the QUERY_FUNC_CAP wrapper, we needed to add code
which checks for the port type (IB or Ethernet).  Previously,
this was not an issue, since only Ethernet ports were supported.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c   |   78 +++++++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/main.c |   26 +++-------
 2 files changed, 59 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index ee9d6b0..5549f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -174,6 +174,7 @@ int mlx4_QUERY_FUNC_CAP_wrapper(struct mlx4_dev *dev, int slave,
 #define QUERY_FUNC_CAP_FLAGS_OFFSET		0x0
 #define QUERY_FUNC_CAP_NUM_PORTS_OFFSET		0x1
 #define QUERY_FUNC_CAP_PF_BHVR_OFFSET		0x4
+#define QUERY_FUNC_CAP_FMR_OFFSET		0x8
 #define QUERY_FUNC_CAP_QP_QUOTA_OFFSET		0x10
 #define QUERY_FUNC_CAP_CQ_QUOTA_OFFSET		0x14
 #define QUERY_FUNC_CAP_SRQ_QUOTA_OFFSET		0x18
@@ -183,25 +184,44 @@ int mlx4_QUERY_FUNC_CAP_wrapper(struct mlx4_dev *dev, int slave,
 #define QUERY_FUNC_CAP_MAX_EQ_OFFSET		0x2c
 #define QUERY_FUNC_CAP_RESERVED_EQ_OFFSET	0X30
 
+#define QUERY_FUNC_CAP_FMR_FLAG			0x80
+#define QUERY_FUNC_CAP_FLAG_RDMA		0x40
+#define QUERY_FUNC_CAP_FLAG_ETH			0x80
+
+/* when opcode modifier = 1 */
 #define QUERY_FUNC_CAP_PHYS_PORT_OFFSET		0x3
+#define QUERY_FUNC_CAP_RDMA_PROPS_OFFSET	0x8
 #define QUERY_FUNC_CAP_ETH_PROPS_OFFSET		0xc
 
+#define QUERY_FUNC_CAP_ETH_PROPS_FORCE_MAC	0x40
+#define QUERY_FUNC_CAP_ETH_PROPS_FORCE_VLAN	0x80
+
+#define QUERY_FUNC_CAP_RDMA_PROPS_FORCE_PHY_WQE_GID 0x80
+
 	if (vhcr->op_modifier == 1) {
 		field = vhcr->in_modifier;
 		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_PHYS_PORT_OFFSET);
 
-		field = 0; /* ensure fvl bit is not set */
+		field = 0;
+		/* ensure force vlan and force mac bits are not set */
 		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_ETH_PROPS_OFFSET);
+		/* ensure that phy_wqe_gid bit is not set */
+		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_RDMA_PROPS_OFFSET);
+
 	} else if (vhcr->op_modifier == 0) {
-		field = 1 << 7; /* enable only ethernet interface */
+		/* enable rdma and ethernet interfaces */
+		field = (QUERY_FUNC_CAP_FLAG_ETH | QUERY_FUNC_CAP_FLAG_RDMA);
 		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_FLAGS_OFFSET);
 
 		field = dev->caps.num_ports;
 		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_NUM_PORTS_OFFSET);
 
-		size = 0; /* no PF behavious is set for now */
+		size = 0; /* no PF behaviour is set for now */
 		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_PF_BHVR_OFFSET);
 
+		field = 0; /* protected FMR support not available as yet */
+		MLX4_PUT(outbox->buf, field, QUERY_FUNC_CAP_FMR_OFFSET);
+
 		size = dev->caps.num_qps;
 		MLX4_PUT(outbox->buf, size, QUERY_FUNC_CAP_QP_QUOTA_OFFSET);
 
@@ -254,11 +274,12 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev *dev, struct mlx4_func_cap *func_cap)
 	outbox = mailbox->buf;
 
 	MLX4_GET(field, outbox, QUERY_FUNC_CAP_FLAGS_OFFSET);
-	if (!(field & (1 << 7))) {
-		mlx4_err(dev, "The host doesn't support eth interface\n");
+	if (!(field & (QUERY_FUNC_CAP_FLAG_ETH | QUERY_FUNC_CAP_FLAG_RDMA))) {
+		mlx4_err(dev, "The host supports neither eth nor rdma interfaces\n");
 		err = -EPROTONOSUPPORT;
 		goto out;
 	}
+	func_cap->flags = field;
 
 	MLX4_GET(field, outbox, QUERY_FUNC_CAP_NUM_PORTS_OFFSET);
 	func_cap->num_ports = field;
@@ -297,17 +318,27 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev *dev, struct mlx4_func_cap *func_cap)
 		if (err)
 			goto out;
 
-		MLX4_GET(field, outbox, QUERY_FUNC_CAP_ETH_PROPS_OFFSET);
-		if (field & (1 << 7)) {
-			mlx4_err(dev, "VLAN is enforced on this port\n");
-			err = -EPROTONOSUPPORT;
-			goto out;
-		}
+		if (dev->caps.port_type[i] == MLX4_PORT_TYPE_ETH) {
+			MLX4_GET(field, outbox, QUERY_FUNC_CAP_ETH_PROPS_OFFSET);
+			if (field & QUERY_FUNC_CAP_ETH_PROPS_FORCE_VLAN) {
+				mlx4_err(dev, "VLAN is enforced on this port\n");
+				err = -EPROTONOSUPPORT;
+				goto out;
+			}
 
-		if (field & (1 << 6)) {
-			mlx4_err(dev, "Force mac is enabled on this port\n");
-			err = -EPROTONOSUPPORT;
-			goto out;
+			if (field & QUERY_FUNC_CAP_ETH_PROPS_FORCE_MAC) {
+				mlx4_err(dev, "Force mac is enabled on this port\n");
+				err = -EPROTONOSUPPORT;
+				goto out;
+			}
+		} else if (dev->caps.port_type[i] == MLX4_PORT_TYPE_IB) {
+			MLX4_GET(field, outbox, QUERY_FUNC_CAP_RDMA_PROPS_OFFSET);
+			if (field & QUERY_FUNC_CAP_RDMA_PROPS_FORCE_PHY_WQE_GID) {
+				mlx4_err(dev, "phy_wqe_gid is "
+					 "enforced on this ib port\n");
+				err = -EPROTONOSUPPORT;
+				goto out;
+			}
 		}
 
 		MLX4_GET(field, outbox, QUERY_FUNC_CAP_PHYS_PORT_OFFSET);
@@ -701,12 +732,7 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	u8 port_type;
 	int err;
 
-#define MLX4_PORT_SUPPORT_IB		(1 << 0)
-#define MLX4_PORT_SUGGEST_TYPE		(1 << 3)
-#define MLX4_PORT_DEFAULT_SENSE		(1 << 4)
-#define MLX4_VF_PORT_ETH_ONLY_MASK	(0xff & ~MLX4_PORT_SUPPORT_IB & \
-					 ~MLX4_PORT_SUGGEST_TYPE & \
-					 ~MLX4_PORT_DEFAULT_SENSE)
+#define MLX4_VF_PORT_NO_LINK_SENSE_MASK	0xE0
 
 	err = mlx4_cmd_box(dev, 0, outbox->dma, vhcr->in_modifier, 0,
 			   MLX4_CMD_QUERY_PORT, MLX4_CMD_TIME_CLASS_B,
@@ -722,12 +748,10 @@ int mlx4_QUERY_PORT_wrapper(struct mlx4_dev *dev, int slave,
 		MLX4_GET(port_type, outbox->buf,
 			 QUERY_PORT_SUPPORTED_TYPE_OFFSET);
 
-		/* Allow only Eth port, no link sensing allowed */
-		port_type &= MLX4_VF_PORT_ETH_ONLY_MASK;
-
-		/* check eth is enabled for this port */
-		if (!(port_type & 2))
-			mlx4_dbg(dev, "QUERY PORT: eth not supported by host");
+		/* No link sensing allowed */
+		port_type &= MLX4_VF_PORT_NO_LINK_SENSE_MASK;
+		/* set port type to currently operating port type */
+		port_type |= (dev->caps.port_type[vhcr->in_modifier] & 0x3);
 
 		MLX4_PUT(outbox->buf, port_type,
 			 QUERY_PORT_SUPPORTED_TYPE_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index ff7332f..bfa8e59 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -288,29 +288,19 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 			/* if only ETH is supported - assign ETH */
 			if (dev->caps.supported_type[i] == MLX4_PORT_TYPE_ETH)
 				dev->caps.port_type[i] = MLX4_PORT_TYPE_ETH;
-			/* if only IB is supported,
-			 * assign IB only if SRIOV is off*/
+			/* if only IB is supported, assign IB */
 			else if (dev->caps.supported_type[i] ==
-				 MLX4_PORT_TYPE_IB) {
-				if (dev->flags & MLX4_FLAG_SRIOV)
-					dev->caps.port_type[i] =
-						MLX4_PORT_TYPE_NONE;
-				else
-					dev->caps.port_type[i] =
-						MLX4_PORT_TYPE_IB;
-			/* if IB and ETH are supported,
-			 * first of all check if SRIOV is on */
-			} else if (dev->flags & MLX4_FLAG_SRIOV)
-				dev->caps.port_type[i] = MLX4_PORT_TYPE_ETH;
+				 MLX4_PORT_TYPE_IB)
+				dev->caps.port_type[i] = MLX4_PORT_TYPE_IB;
 			else {
-				/* In non-SRIOV mode, we set the port type
-				 * according to user selection of port type,
-				 * if usere selected none, take the FW hint */
-				if (port_type_array[i-1] == MLX4_PORT_TYPE_NONE)
+				/* if IB and ETH are supported, we set the port
+				 * type according to user selection of port type;
+				 * if user selected none, take the FW hint */
+				if (port_type_array[i - 1] == MLX4_PORT_TYPE_NONE)
 					dev->caps.port_type[i] = dev->caps.suggested_type[i] ?
 						MLX4_PORT_TYPE_ETH : MLX4_PORT_TYPE_IB;
 				else
-					dev->caps.port_type[i] = port_type_array[i-1];
+					dev->caps.port_type[i] = port_type_array[i - 1];
 			}
 		}
 		/*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
