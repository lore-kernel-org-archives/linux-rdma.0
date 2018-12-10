From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/10] IB/mlx5: Simplify netdev unbinding
Date: Sun,  9 Dec 2018 19:04:41 -0800
Message-ID: <20181210030442.7543-10-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

When dealing with netdev unregister events, we just need to
know that this is our currently bounded netdev. There's no
need to do any further checks/queries.

This patch doesn't change any functionality.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2560996fce79..fd8cbf58f0bf 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -172,7 +172,6 @@ static int mlx5_netdev_event(struct notifier_block *this,
 
 	switch (event) {
 	case NETDEV_REGISTER:
-	case NETDEV_UNREGISTER:
 		write_lock(&roce->netdev_lock);
 		if (ibdev->rep) {
 			struct mlx5_eswitch *esw = ibdev->mdev->priv.eswitch;
@@ -181,15 +180,20 @@ static int mlx5_netdev_event(struct notifier_block *this,
 			rep_ndev = mlx5_ib_get_rep_netdev(esw,
 							  ibdev->rep->vport);
 			if (rep_ndev == ndev)
-				roce->netdev = (event == NETDEV_UNREGISTER) ?
-					NULL : ndev;
+				roce->netdev = ndev;
 		} else if (ndev->dev.parent == &mdev->pdev->dev) {
-			roce->netdev = (event == NETDEV_UNREGISTER) ?
-				NULL : ndev;
+			roce->netdev = ndev;
 		}
 		write_unlock(&roce->netdev_lock);
 		break;
 
+	case NETDEV_UNREGISTER:
+		write_lock(&roce->netdev_lock);
+		if (roce->netdev == ndev)
+			roce->netdev = NULL;
+		write_unlock(&roce->netdev_lock);
+		break;
+
 	case NETDEV_CHANGE:
 	case NETDEV_UP:
 	case NETDEV_DOWN: {
-- 
2.19.2
