From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 3/9] net/mlx4_core: Set initial admin GUIDs for VFs
Date: Wed,  1 Apr 2015 14:55:51 +0300
Message-ID: <1427889357-16078-4-git-send-email-ogerlitz@mellanox.com>
References: <1427889357-16078-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427889357-16078-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To have out of the box experience, the PF generates random GUIDs who
serve as the initial admin values.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c |   15 +++++++++++++++
 include/linux/mlx4/device.h               |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 20b3c7b..778de74 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2255,6 +2255,7 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 				priv->mfunc.master.vf_oper[i].vport[port].state.default_vlan = MLX4_VGT;
 				priv->mfunc.master.vf_oper[i].vport[port].vlan_idx = NO_INDX;
 				priv->mfunc.master.vf_oper[i].vport[port].mac_idx = NO_INDX;
+				mlx4_set_random_admin_guid(dev, i, port);
 			}
 			spin_lock_init(&s_state->lock);
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 6d1f10e..ee1180b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2245,6 +2245,21 @@ __be64 mlx4_get_admin_guid(struct mlx4_dev *dev, int entry, int port)
 }
 EXPORT_SYMBOL_GPL(mlx4_get_admin_guid);
 
+void mlx4_set_random_admin_guid(struct mlx4_dev *dev, int entry, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	__be64 guid;
+
+	/* hw GUID */
+	if (entry == 0)
+		return;
+
+	get_random_bytes((char *)&guid, sizeof(guid));
+	guid &= ~(cpu_to_be64(1ULL << 56));
+	guid |= cpu_to_be64(1ULL << 57);
+	priv->mfunc.master.vf_admin[entry].vport[port].guid = guid;
+}
+
 static int mlx4_setup_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 2a4d92c..f0b65e6 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1340,6 +1340,7 @@ void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
 void mlx4_set_admin_guid(struct mlx4_dev *dev, __be64 guid, int entry,
 			 int port);
 __be64 mlx4_get_admin_guid(struct mlx4_dev *dev, int entry, int port);
+void mlx4_set_random_admin_guid(struct mlx4_dev *dev, int entry, int port);
 int mlx4_flow_attach(struct mlx4_dev *dev,
 		     struct mlx4_net_trans_rule *rule, u64 *reg_id);
 int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
