From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/5] IB/mlx5: Merge vports flow steering during LAG
Date: Sun, 18 Sep 2016 20:48:01 +0300
Message-ID: <1474220884-21341-3-git-send-email-leon@kernel.org>
References: <1474220884-21341-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474220884-21341-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is done in two steps:
1) Issuing CREATE_VPORT_LAG in order to have Ethernet traffic from
both ports arriving on PF0 root flowtable, so we will be able to catch
all raw-eth traffic on PF0.
2) Creation of LAG demux flowtable in order to direct all non-raw-eth
traffic back to its source port, assuring that normal Ethernet
traffic "jumps" to the root flowtable of its RX port (non-LAG behavior).

Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 49 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e2cdd93..acb1891 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2529,6 +2529,47 @@ static void get_dev_fw_str(struct ib_device *ibdev, char *str,
 		       fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
 }
 
+static int mlx5_roce_lag_init(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(mdev,
+								 MLX5_FLOW_NAMESPACE_LAG);
+	struct mlx5_flow_table *ft;
+	int err;
+
+	if (!ns || !mlx5_lag_is_active(mdev))
+		return 0;
+
+	err = mlx5_cmd_create_vport_lag(mdev);
+	if (err)
+		return err;
+
+	ft = mlx5_create_lag_demux_flow_table(ns, 0, 0);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_destroy_vport_lag;
+	}
+
+	dev->flow_db.lag_demux_ft = ft;
+	return 0;
+
+err_destroy_vport_lag:
+	mlx5_cmd_destroy_vport_lag(mdev);
+	return err;
+}
+
+static void mlx5_roce_lag_cleanup(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_core_dev *mdev = dev->mdev;
+
+	if (dev->flow_db.lag_demux_ft) {
+		mlx5_destroy_flow_table(dev->flow_db.lag_demux_ft);
+		dev->flow_db.lag_demux_ft = NULL;
+
+		mlx5_cmd_destroy_vport_lag(mdev);
+	}
+}
+
 static void mlx5_remove_roce_notifier(struct mlx5_ib_dev *dev)
 {
 	if (dev->roce.nb.notifier_call) {
@@ -2552,8 +2593,15 @@ static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 	if (err)
 		goto err_unregister_netdevice_notifier;
 
+	err = mlx5_roce_lag_init(dev);
+	if (err)
+		goto err_disable_roce;
+
 	return 0;
 
+err_disable_roce:
+	mlx5_nic_vport_disable_roce(dev->mdev);
+
 err_unregister_netdevice_notifier:
 	mlx5_remove_roce_notifier(dev);
 	return err;
@@ -2561,6 +2609,7 @@ err_unregister_netdevice_notifier:
 
 static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
 {
+	mlx5_roce_lag_cleanup(dev);
 	mlx5_nic_vport_disable_roce(dev->mdev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a59034a..d06ae88 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -156,6 +156,7 @@ struct mlx5_ib_flow_handler {
 
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
+	struct mlx5_flow_table		*lag_demux_ft;
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
 	 * only single add/removal of flow steering rule could be done
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
