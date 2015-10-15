From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 for-next 3/7] net/mlx4_core: Add support for filtering multicast loopback
Date: Thu, 15 Oct 2015 14:44:38 +0300
Message-ID: <1444909482-17113-4-git-send-email-eranbe@mellanox.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444909482-17113-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update device capabilities regarding HW filtering multicast loopback support.

Add MLX4_UPDATE_QP_ETH_SRC_CHECK_MC_LB attribute to mlx4_update_qp to
enable changing QP context to support filtering incoming multicast
loopback traffic according the sender's counter index.

Set the corresponding bits in QP context to force the loopback source
checks if attribute is given and HW supports it.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  6 +++++
 drivers/net/ethernet/mellanox/mlx4/qp.c            | 19 +++++++++++++-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  | 30 +++++++++++++++++-----
 include/linux/mlx4/device.h                        |  2 ++
 include/linux/mlx4/qp.h                            | 24 +++++++++++++----
 5 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index e8ec1de..b3be3a0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -155,6 +155,8 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
 		[27] = "Port beacon support",
 		[28] = "RX-ALL support",
 		[29] = "802.1ad offload support",
+		[31] = "Modifying loopback source checks using UPDATE_QP support",
+		[32] = "Loopback source checks support",
 	};
 	int i;
 
@@ -964,6 +966,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	MLX4_GET(field32, outbox, QUERY_DEV_CAP_EXT_2_FLAGS_OFFSET);
 	if (field32 & (1 << 16))
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_UPDATE_QP;
+	if (field32 & (1 << 18))
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB;
+	if (field32 & (1 << 19))
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_LB_SRC_CHK;
 	if (field32 & (1 << 26))
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_VLAN_CONTROL;
 	if (field32 & (1 << 20))
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 2026863..b162495 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -436,6 +436,23 @@ int mlx4_update_qp(struct mlx4_dev *dev, u32 qpn,
 		cmd->qp_context.pri_path.grh_mylmc = params->smac_index;
 	}
 
+	if (attr & MLX4_UPDATE_QP_ETH_SRC_CHECK_MC_LB) {
+		if (!(dev->caps.flags2
+		      & MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB)) {
+			mlx4_warn(dev,
+				  "Trying to set src check LB, but it isn't supported\n");
+			err = -ENOTSUPP;
+			goto out;
+		}
+		pri_addr_path_mask |=
+			1ULL << MLX4_UPD_QP_PATH_MASK_ETH_SRC_CHECK_MC_LB;
+		if (params->flags &
+		    MLX4_UPDATE_QP_PARAMS_FLAGS_ETH_CHECK_MC_LB) {
+			cmd->qp_context.pri_path.fl |=
+				MLX4_FL_ETH_SRC_CHECK_MC_LB;
+		}
+	}
+
 	if (attr & MLX4_UPDATE_QP_VSD) {
 		qp_mask |= 1ULL << MLX4_UPD_QP_MASK_VSD;
 		if (params->flags & MLX4_UPDATE_QP_PARAMS_FLAGS_VSD_ENABLE)
@@ -458,7 +475,7 @@ int mlx4_update_qp(struct mlx4_dev *dev, u32 qpn,
 	err = mlx4_cmd(dev, mailbox->dma, qpn & 0xffffff, 0,
 		       MLX4_CMD_UPDATE_QP, MLX4_CMD_TIME_CLASS_A,
 		       MLX4_CMD_NATIVE);
-
+out:
 	mlx4_free_cmd_mailbox(dev, mailbox);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 731423c..502f335 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -770,9 +770,12 @@ static int update_vport_qp_param(struct mlx4_dev *dev,
 			}
 		}
 
+		/* preserve IF_COUNTER flag */
+		qpc->pri_path.vlan_control &=
+			MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER;
 		if (vp_oper->state.link_state == IFLA_VF_LINK_STATE_DISABLE &&
 		    dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_UPDATE_QP) {
-			qpc->pri_path.vlan_control =
+			qpc->pri_path.vlan_control |=
 				MLX4_VLAN_CTRL_ETH_TX_BLOCK_TAGGED |
 				MLX4_VLAN_CTRL_ETH_TX_BLOCK_PRIO_TAGGED |
 				MLX4_VLAN_CTRL_ETH_TX_BLOCK_UNTAGGED |
@@ -780,12 +783,12 @@ static int update_vport_qp_param(struct mlx4_dev *dev,
 				MLX4_VLAN_CTRL_ETH_RX_BLOCK_UNTAGGED |
 				MLX4_VLAN_CTRL_ETH_RX_BLOCK_TAGGED;
 		} else if (0 != vp_oper->state.default_vlan) {
-			qpc->pri_path.vlan_control =
+			qpc->pri_path.vlan_control |=
 				MLX4_VLAN_CTRL_ETH_TX_BLOCK_TAGGED |
 				MLX4_VLAN_CTRL_ETH_RX_BLOCK_PRIO_TAGGED |
 				MLX4_VLAN_CTRL_ETH_RX_BLOCK_UNTAGGED;
 		} else { /* priority tagged */
-			qpc->pri_path.vlan_control =
+			qpc->pri_path.vlan_control |=
 				MLX4_VLAN_CTRL_ETH_TX_BLOCK_TAGGED |
 				MLX4_VLAN_CTRL_ETH_RX_BLOCK_TAGGED;
 		}
@@ -3762,9 +3765,6 @@ int mlx4_INIT2RTR_QP_wrapper(struct mlx4_dev *dev, int slave,
 	update_gid(dev, inbox, (u8)slave);
 	adjust_proxy_tun_qkey(dev, vhcr, qpc);
 	orig_sched_queue = qpc->pri_path.sched_queue;
-	err = update_vport_qp_param(dev, inbox, slave, qpn);
-	if (err)
-		return err;
 
 	err = get_res(dev, slave, qpn, RES_QP, &qp);
 	if (err)
@@ -3774,6 +3774,10 @@ int mlx4_INIT2RTR_QP_wrapper(struct mlx4_dev *dev, int slave,
 		goto out;
 	}
 
+	err = update_vport_qp_param(dev, inbox, slave, qpn);
+	if (err)
+		goto out;
+
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 out:
 	/* if no error, save sched queue value passed in by VF. This is
@@ -4208,7 +4212,9 @@ static int add_eth_header(struct mlx4_dev *dev, int slave,
 
 }
 
-#define MLX4_UPD_QP_PATH_MASK_SUPPORTED (1ULL << MLX4_UPD_QP_PATH_MASK_MAC_INDEX)
+#define MLX4_UPD_QP_PATH_MASK_SUPPORTED      (                                \
+	1ULL << MLX4_UPD_QP_PATH_MASK_MAC_INDEX                     |\
+	1ULL << MLX4_UPD_QP_PATH_MASK_ETH_SRC_CHECK_MC_LB)
 int mlx4_UPDATE_QP_wrapper(struct mlx4_dev *dev, int slave,
 			   struct mlx4_vhcr *vhcr,
 			   struct mlx4_cmd_mailbox *inbox,
@@ -4231,6 +4237,16 @@ int mlx4_UPDATE_QP_wrapper(struct mlx4_dev *dev, int slave,
 	    (pri_addr_path_mask & ~MLX4_UPD_QP_PATH_MASK_SUPPORTED))
 		return -EPERM;
 
+	if ((pri_addr_path_mask &
+	     (1ULL << MLX4_UPD_QP_PATH_MASK_ETH_SRC_CHECK_MC_LB)) &&
+		!(dev->caps.flags2 &
+		  MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB)) {
+			mlx4_warn(dev,
+				  "Src check LB for slave %d isn't supported\n",
+				   slave);
+		return -ENOTSUPP;
+	}
+
 	/* Just change the smac for the QP */
 	err = get_res(dev, slave, qpn, RES_QP, &rqp);
 	if (err) {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index baad4cb..dac6872 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -214,6 +214,8 @@ enum {
 	MLX4_DEV_CAP_FLAG2_IGNORE_FCS		= 1LL <<  28,
 	MLX4_DEV_CAP_FLAG2_PHV_EN		= 1LL <<  29,
 	MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN	= 1LL <<  30,
+	MLX4_DEV_CAP_FLAG2_UPDATE_QP_SRC_CHECK_LB = 1ULL << 31,
+	MLX4_DEV_CAP_FLAG2_LB_SRC_CHK           = 1ULL << 32,
 };
 
 enum {
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index de45a51..fe052e2 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -135,7 +135,10 @@ struct mlx4_rss_context {
 
 struct mlx4_qp_path {
 	u8			fl;
-	u8			vlan_control;
+	union {
+		u8			vlan_control;
+		u8			control;
+	};
 	u8			disable_pkey_check;
 	u8			pkey_index;
 	u8			counter_index;
@@ -156,9 +159,16 @@ struct mlx4_qp_path {
 };
 
 enum { /* fl */
-	MLX4_FL_CV      = 1 << 6,
-	MLX4_FL_ETH_HIDE_CQE_VLAN       = 1 << 2
+	MLX4_FL_CV	= 1 << 6,
+	MLX4_FL_ETH_HIDE_CQE_VLAN	= 1 << 2,
+	MLX4_FL_ETH_SRC_CHECK_MC_LB	= 1 << 1,
+	MLX4_FL_ETH_SRC_CHECK_UC_LB	= 1 << 0,
 };
+
+enum { /* control */
+	MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER	= 1 << 7,
+};
+
 enum { /* vlan_control */
 	MLX4_VLAN_CTRL_ETH_TX_BLOCK_TAGGED	= 1 << 6,
 	MLX4_VLAN_CTRL_ETH_TX_BLOCK_PRIO_TAGGED	= 1 << 5, /* 802.1p priority tag */
@@ -254,6 +264,8 @@ enum {
 	MLX4_UPD_QP_PATH_MASK_SCHED_QUEUE		= 14 + 32,
 	MLX4_UPD_QP_PATH_MASK_IF_COUNTER_INDEX		= 15 + 32,
 	MLX4_UPD_QP_PATH_MASK_FVL_RX			= 16 + 32,
+	MLX4_UPD_QP_PATH_MASK_ETH_SRC_CHECK_UC_LB	= 18 + 32,
+	MLX4_UPD_QP_PATH_MASK_ETH_SRC_CHECK_MC_LB	= 19 + 32,
 };
 
 enum { /* param3 */
@@ -436,11 +448,13 @@ enum mlx4_update_qp_attr {
 	MLX4_UPDATE_QP_VSD		= 1 << 1,
 	MLX4_UPDATE_QP_RATE_LIMIT	= 1 << 2,
 	MLX4_UPDATE_QP_QOS_VPORT	= 1 << 3,
-	MLX4_UPDATE_QP_SUPPORTED_ATTRS	= (1 << 4) - 1
+	MLX4_UPDATE_QP_ETH_SRC_CHECK_MC_LB      = 1 << 4,
+	MLX4_UPDATE_QP_SUPPORTED_ATTRS	= (1 << 5) - 1
 };
 
 enum mlx4_update_qp_params_flags {
-	MLX4_UPDATE_QP_PARAMS_FLAGS_VSD_ENABLE		= 1 << 0,
+	MLX4_UPDATE_QP_PARAMS_FLAGS_ETH_CHECK_MC_LB     = 1 << 0,
+	MLX4_UPDATE_QP_PARAMS_FLAGS_VSD_ENABLE		= 1 << 1,
 };
 
 struct mlx4_update_qp_params {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
