From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/13] IB/mlx5: Handle raw delay drop general event
Date: Mon, 26 Nov 2018 14:39:04 -0800
Message-ID: <20181126223908.15988-10-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Handle FW general event rq delay drop as it was received from FW via mlx5
notifiers API, instead of handling the processed software version of that
event. After this patch we can safely remove all software processed FW
events types and definitions.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a0668b923f78..7e6af18e7d82 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4236,6 +4236,18 @@ static void delay_drop_handler(struct work_struct *work)
 	mutex_unlock(&delay_drop->lock);
 }
 
+static void handle_general_event(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
+				 struct ib_event *ibev)
+{
+	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
+		schedule_work(&ibdev->delay_drop.delay_drop_work);
+		break;
+	default: /* do nothing */
+		return;
+	}
+}
+
 static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
 			      struct ib_event *ibev)
 {
@@ -4308,9 +4320,9 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		if (handle_port_change(ibdev, work->param, &ibev))
 			goto out;
 		break;
-	case MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT:
-		schedule_work(&ibdev->delay_drop.delay_drop_work);
-		goto out;
+	case MLX5_EVENT_TYPE_GENERAL_EVENT:
+		handle_general_event(ibdev, work->param, &ibev);
+		/* fall through */
 	default:
 		goto out;
 	}
-- 
2.19.1
