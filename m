From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/mlx5: Set unique device name on LAG
Date: Sun, 18 Sep 2016 13:08:15 +0300
Message-ID: <1474193296-28062-5-git-send-email-leon@kernel.org>
References: <1474193296-28062-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474193296-28062-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IB bond device name is now 'mlx5_bond_X', instead of
'mlx5_X'.

Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1373650..c46884b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2754,6 +2754,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	struct mlx5_ib_dev *dev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
+	const char *name;
 	int err;
 	int i;
 
@@ -2786,7 +2787,12 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	MLX5_INIT_DOORBELL_LOCK(&dev->uar_lock);
 
-	strlcpy(dev->ib_dev.name, "mlx5_%d", IB_DEVICE_NAME_MAX);
+	if (!mlx5_lag_is_active(mdev))
+		name = "mlx5_%d";
+	else
+		name = "mlx5_bond_%d";
+
+	strlcpy(dev->ib_dev.name, name, IB_DEVICE_NAME_MAX);
 	dev->ib_dev.owner		= THIS_MODULE;
 	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	dev->ib_dev.local_dma_lkey	= 0 /* not supported for now */;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
