From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx4: Remove unused variable from function declaration
Date: Wed, 25 Jan 2017 20:26:18 +0200
Message-ID: <20170125182618.24899-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove unused netw_view parameter from eth_link_query_port() function.

Reported-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Doug,

This patch was generated on top of Or's patch series.

Thanks
---
 drivers/infiniband/hw/mlx4/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ba6af84cc236..211cbbe9ccd1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -678,7 +678,7 @@ static u8 state_to_phys_state(enum ib_port_state state)
 }

 static int eth_link_query_port(struct ib_device *ibdev, u8 port,
-			       struct ib_port_attr *props, int netw_view)
+			       struct ib_port_attr *props)
 {

 	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
@@ -745,7 +745,7 @@ int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,

 	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
 		ib_link_query_port(ibdev, port, props, netw_view) :
-				eth_link_query_port(ibdev, port, props, netw_view);
+				eth_link_query_port(ibdev, port, props);

 	return err;
 }
--
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
