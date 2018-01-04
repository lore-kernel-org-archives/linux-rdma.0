From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 08/15] IB/mlx5: Implement dual port functionality in query routines
Date: Thu,  4 Jan 2018 11:06:38 +0200
Message-ID: <20180104090645.4901-9-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Port operations must be routed to their native mlx5_core_dev. A
multiport RoCE device registers itself as having 2 ports even before a
2nd port is affiliated. If an unaffilated port is queried use capability
information from the master port, these values are the same.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 102 +++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0ff6da1b885f..59e26901d935 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -359,16 +359,30 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
+	bool put_mdev = true;
 	u16 qkey_viol_cntr;
 	u32 eth_prot_oper;
+	u8 mdev_port_num;
 	int err;
 
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num, &mdev_port_num);
+	if (!mdev) {
+		/* This means the port isn't affiliated yet. Get the
+		 * info for the master port instead.
+		 */
+		put_mdev = false;
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+		port_num = 1;
+	}
+
 	/* Possible bad flows are checked before filling out props so in case
 	 * of an error it will still be zeroed out.
 	 */
-	err = mlx5_query_port_eth_proto_oper(mdev, &eth_prot_oper, port_num);
+	err = mlx5_query_port_eth_proto_oper(mdev, &eth_prot_oper,
+					     mdev_port_num);
 	if (err)
-		return err;
+		goto out;
 
 	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
 				 &props->active_width);
@@ -384,12 +398,16 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	props->state            = IB_PORT_DOWN;
 	props->phys_state       = 3;
 
-	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev, &qkey_viol_cntr);
+	mlx5_query_nic_vport_qkey_viol_cntr(mdev, &qkey_viol_cntr);
 	props->qkey_viol_cntr = qkey_viol_cntr;
 
+	/* If this is a stub query for an unaffiliated port stop here */
+	if (!put_mdev)
+		goto out;
+
 	ndev = mlx5_ib_get_netdev(device, port_num);
 	if (!ndev)
-		return 0;
+		goto out;
 
 	if (mlx5_lag_is_active(dev->mdev)) {
 		rcu_read_lock();
@@ -412,7 +430,10 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	dev_put(ndev);
 
 	props->active_mtu	= min(props->max_mtu, ndev_ib_mtu);
-	return 0;
+out:
+	if (put_mdev)
+		mlx5_ib_put_native_port_mdev(dev, port_num);
+	return err;
 }
 
 static int set_roce_addr(struct mlx5_ib_dev *dev, u8 port_num,
@@ -1221,7 +1242,22 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 	}
 
 	if (!ret && props) {
-		count = mlx5_core_reserved_gids_count(to_mdev(ibdev)->mdev);
+		struct mlx5_ib_dev *dev = to_mdev(ibdev);
+		struct mlx5_core_dev *mdev;
+		bool put_mdev = true;
+
+		mdev = mlx5_ib_get_native_port_mdev(dev, port, NULL);
+		if (!mdev) {
+			/* If the port isn't affiliated yet query the master.
+			 * The master and slave will have the same values.
+			 */
+			mdev = dev->mdev;
+			port = 1;
+			put_mdev = false;
+		}
+		count = mlx5_core_reserved_gids_count(mdev);
+		if (put_mdev)
+			mlx5_ib_put_native_port_mdev(dev, port);
 		props->gid_tbl_len -= count;
 	}
 	return ret;
@@ -1246,20 +1282,43 @@ static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 
 }
 
-static int mlx5_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
-			      u16 *pkey)
+static int mlx5_query_hca_nic_pkey(struct ib_device *ibdev, u8 port,
+				   u16 index, u16 *pkey)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev;
+	bool put_mdev = true;
+	u8 mdev_port_num;
+	int err;
 
+	mdev = mlx5_ib_get_native_port_mdev(dev, port, &mdev_port_num);
+	if (!mdev) {
+		/* The port isn't affiliated yet, get the PKey from the master
+		 * port. For RoCE the PKey tables will be the same.
+		 */
+		put_mdev = false;
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+	}
+
+	err = mlx5_query_hca_vport_pkey(mdev, 0, mdev_port_num, 0,
+					index, pkey);
+	if (put_mdev)
+		mlx5_ib_put_native_port_mdev(dev, port);
+
+	return err;
+}
+
+static int mlx5_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			      u16 *pkey)
+{
 	switch (mlx5_get_vport_access_method(ibdev)) {
 	case MLX5_VPORT_ACCESS_METHOD_MAD:
 		return mlx5_query_mad_ifc_pkey(ibdev, port, index, pkey);
 
 	case MLX5_VPORT_ACCESS_METHOD_HCA:
 	case MLX5_VPORT_ACCESS_METHOD_NIC:
-		return mlx5_query_hca_vport_pkey(mdev, 0, port,  0, index,
-						 pkey);
+		return mlx5_query_hca_nic_pkey(ibdev, port, index, pkey);
 	default:
 		return -EINVAL;
 	}
@@ -1298,23 +1357,32 @@ static int set_port_caps_atomic(struct mlx5_ib_dev *dev, u8 port_num, u32 mask,
 				u32 value)
 {
 	struct mlx5_hca_vport_context ctx = {};
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
 	int err;
 
-	err = mlx5_query_hca_vport_context(dev->mdev, 0,
-					   port_num, 0, &ctx);
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num, &mdev_port_num);
+	if (!mdev)
+		return -ENODEV;
+
+	err = mlx5_query_hca_vport_context(mdev, 0, mdev_port_num, 0, &ctx);
 	if (err)
-		return err;
+		goto out;
 
 	if (~ctx.cap_mask1_perm & mask) {
 		mlx5_ib_warn(dev, "trying to change bitmask 0x%X but change supported 0x%X\n",
 			     mask, ctx.cap_mask1_perm);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	ctx.cap_mask1 = value;
 	ctx.cap_mask1_perm = mask;
-	err = mlx5_core_modify_hca_vport_context(dev->mdev, 0,
-						 port_num, 0, &ctx);
+	err = mlx5_core_modify_hca_vport_context(mdev, 0, mdev_port_num,
+						 0, &ctx);
+
+out:
+	mlx5_ib_put_native_port_mdev(dev, port_num);
 
 	return err;
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
