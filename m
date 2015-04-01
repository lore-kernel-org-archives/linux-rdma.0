From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 2/9] net/mlx4_core: Manage alias GUID per VF
Date: Wed,  1 Apr 2015 14:55:50 +0300
Message-ID: <1427889357-16078-3-git-send-email-ogerlitz@mellanox.com>
References: <1427889357-16078-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427889357-16078-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Manages alias GUIDs per VF per port in the core layer.

This is a pre-step for managing alias GUIDs in a mode that the admin
GUID is returned via ib_query_gid() regardless of whether the SM
has approved it or not.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   16 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 include/linux/mlx4/device.h               |    3 +++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 43aa767..6d1f10e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2229,6 +2229,22 @@ void mlx4_counter_free(struct mlx4_dev *dev, u32 idx)
 }
 EXPORT_SYMBOL_GPL(mlx4_counter_free);
 
+void mlx4_set_admin_guid(struct mlx4_dev *dev, __be64 guid, int entry, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	priv->mfunc.master.vf_admin[entry].vport[port].guid = guid;
+}
+EXPORT_SYMBOL_GPL(mlx4_set_admin_guid);
+
+__be64 mlx4_get_admin_guid(struct mlx4_dev *dev, int entry, int port)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	return priv->mfunc.master.vf_admin[entry].vport[port].guid;
+}
+EXPORT_SYMBOL_GPL(mlx4_get_admin_guid);
+
 static int mlx4_setup_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 0b16db0..20165fb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -512,6 +512,7 @@ struct mlx4_vport_state {
 	u32 tx_rate;
 	bool spoofchk;
 	u32 link_state;
+	__be64 guid;
 };
 
 struct mlx4_vf_admin_state {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index ab7ebec..2a4d92c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1337,6 +1337,9 @@ int mlx4_wol_write(struct mlx4_dev *dev, u64 config, int port);
 int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx);
 void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
 
+void mlx4_set_admin_guid(struct mlx4_dev *dev, __be64 guid, int entry,
+			 int port);
+__be64 mlx4_get_admin_guid(struct mlx4_dev *dev, int entry, int port);
 int mlx4_flow_attach(struct mlx4_dev *dev,
 		     struct mlx4_net_trans_rule *rule, u64 *reg_id);
 int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
