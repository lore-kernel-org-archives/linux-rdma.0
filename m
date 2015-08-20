From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/10] IB/mlx5: Support RoCE
Date: Thu, 20 Aug 2015 19:46:29 +0300
Message-ID: <1440089189-3361-11-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Advertise RoCE support for IB/core layer and set the hardware to
work in RoCE mode.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 48 +++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 27dab5d..3e2e24e8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1586,6 +1586,32 @@ static void destroy_dev_resources(struct mlx5_ib_resources *devr)
 	mlx5_ib_dealloc_pd(devr->p0);
 }
 
+static u32 get_core_cap_flags(struct ib_device *ibdev)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, 1);
+	u8 l3_type_cap = MLX5_CAP_ROCE(dev->mdev, l3_type);
+	u8 roce_version_cap = MLX5_CAP_ROCE(dev->mdev, roce_version);
+	u32 ret = 0;
+
+	if (ll == IB_LINK_LAYER_INFINIBAND)
+		return RDMA_CORE_PORT_IBA_IB;
+
+	if (!(l3_type_cap & MLX5_ROCE_L3_TYPE_IPV4_CAP))
+		return 0;
+
+	if (!(l3_type_cap & MLX5_ROCE_L3_TYPE_IPV6_CAP))
+		return 0;
+
+	if (roce_version_cap & MLX5_ROCE_VERSION_1_CAP)
+		ret |= RDMA_CORE_PORT_IBA_ROCE;
+
+	if (roce_version_cap & MLX5_ROCE_VERSION_2_CAP)
+		ret |= RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+
+	return ret;
+}
+
 static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable)
 {
@@ -1598,7 +1624,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	immutable->core_cap_flags = get_core_cap_flags(ibdev);
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
@@ -1606,13 +1632,28 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 {
+	int err;
+
 	rwlock_init(&dev->roce.netdev_lock);
 	dev->roce.nb.notifier_call = mlx5_netdev_event;
-	return register_netdevice_notifier(&dev->roce.nb);
+	err = register_netdevice_notifier(&dev->roce.nb);
+	if (err)
+		return err;
+
+	err = mlx5_nic_vport_enable_roce(dev->mdev);
+	if (err)
+		goto err_unregister_netdevice_notifier;
+
+	return 0;
+
+err_unregister_netdevice_notifier:
+	unregister_netdevice_notifier(&dev->roce.nb);
+	return err;
 }
 
 static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
 {
+	mlx5_nic_vport_disable_roce(dev->mdev);
 	unregister_netdevice_notifier(&dev->roce.nb);
 }
 
@@ -1627,8 +1668,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
-	/* don't create IB instance over Eth ports, no RoCE yet! */
-	if (ll == IB_LINK_LAYER_ETHERNET)
+	if ((ll == IB_LINK_LAYER_ETHERNET) && !MLX5_CAP_GEN(mdev, roce))
 		return NULL;
 
 	printk_once(KERN_INFO "%s", mlx5_version);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
