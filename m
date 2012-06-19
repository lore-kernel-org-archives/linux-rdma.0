From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 09/29] net/mlx4_core: For SRIOV, initialize ib port-capabilities for all slaves
Date: Tue, 19 Jun 2012 11:21:41 +0300
Message-ID: <1340094121-14858-10-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under SRIOV-IB, each slave has its own separate copy of the port-capabilities
flags.  Thus, for example, the master can run a subnet manager
(which causes the IS_SM bit to be set in the master's port capabilities)
without affecting the port capabilities seen by the slaves
(i.e., the IS_SM bit will be seen as cleared in the slaves).

Also added static inline mlx4_master_func_num() to enhance
readability of the code.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   11 +++++++++++
 include/linux/mlx4/device.h               |    5 +++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index ee6f4fe..00953f4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1477,6 +1477,17 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 					  "with caps = 0\n", port, err);
 			dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
 
+			/* initialize per-slave default ib port capabilities */
+			if (mlx4_is_master(dev)) {
+				int i;
+				for (i = 0; i < dev->num_slaves; i++) {
+					if (i == mlx4_master_func_num(dev))
+						continue;
+					priv->mfunc.master.slave_state[i].ib_cap_mask[port] =
+							ib_port_default_caps;
+				}
+			}
+
 			if (mlx4_is_mfunc(dev))
 				dev->caps.port_ib_mtu[port] = IB_MTU_2048;
 			else
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 560b220..7fbdc89 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -633,6 +633,11 @@ struct mlx4_init_port_param {
 
 void handle_port_mgmt_change_event(struct work_struct *work);
 
+static inline int mlx4_master_func_num(struct mlx4_dev *dev)
+{
+	return dev->caps.function;
+}
+
 static inline int mlx4_is_master(struct mlx4_dev *dev)
 {
 	return dev->flags & MLX4_FLAG_MASTER;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
