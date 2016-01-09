From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] IB/mlx5: Fix passing casted pointer in mlx5_query_port_roce
Date: Sat,  9 Jan 2016 13:01:19 +0200
Message-ID: <1452337279-13593-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Leon Romanovsky <leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix static checker warning:
        drivers/infiniband/hw/mlx5/main.c:149 mlx5_query_port_roce()
        warn: passing casted pointer '&props->qkey_viol_cntr' to
	'mlx5_query_nic_vport_qkey_viol_cntr()' 32 vs 16.

Fixes: 3f89a643eb29 ("IB/mlx5: Extend query_device/port to support RoCE")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5e3d3ae..890cf20 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -132,6 +132,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct net_device *ndev;
 	enum ib_mtu ndev_ib_mtu;
+	u16 qkey_viol_cntr;
 
 	memset(props, 0, sizeof(*props));
 
@@ -146,8 +147,8 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	props->state            = IB_PORT_DOWN;
 	props->phys_state       = 3;
 
-	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev,
-					    (u16 *)&props->qkey_viol_cntr);
+	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev, &qkey_viol_cntr);
+	props->qkey_viol_cntr = qkey_viol_cntr;
 
 	ndev = mlx5_ib_get_netdev(device, port_num);
 	if (!ndev)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
