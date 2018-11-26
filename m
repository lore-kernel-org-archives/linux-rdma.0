From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 13/13] net/mlx5: Debug print for forwarded async events
Date: Mon, 26 Nov 2018 14:39:08 -0800
Message-ID: <20181126223908.15988-14-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Print a debug message for every async FW event forwarded to mlx5
interfaces (mlx5e netdev and mlx5_ib rdma module).

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 9e6e216faac3..e92df7020a26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -229,7 +229,10 @@ static int forward_event(struct notifier_block *nb, unsigned long event, void *d
 {
 	struct mlx5_event_nb *event_nb = mlx5_nb_cof(nb, struct mlx5_event_nb, nb);
 	struct mlx5_events   *events   = event_nb->ctx;
+	struct mlx5_eqe      *eqe      = data;
 
+	mlx5_core_dbg(events->dev, "Async eqe type %s, subtype (%d) forward to interfaces\n",
+		      eqe_type_str(eqe->type), eqe->sub_type);
 	atomic_notifier_call_chain(&events->nh, event, data);
 	return NOTIFY_OK;
 }
-- 
2.19.1
