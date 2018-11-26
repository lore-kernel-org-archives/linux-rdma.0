From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/13] net/mlx5: Allow forwarding event type general event as is
Date: Mon, 26 Nov 2018 14:39:03 -0800
Message-ID: <20181126223908.15988-9-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

FW general event is used by mlx5_ib for RQ delay drop timeout event
handling, in this patch we allow to forward FW general event type to mlx5
notifiers chain so mlx5_ib can handle it and to deprecate the software
version of it.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index ab66f5d65a04..735a9b038a73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -36,6 +36,7 @@ static struct mlx5_nb events_nbs_ref[] = {
 
 	/* Events to be forwarded (as is) to mlx5 core interfaces (mlx5e/mlx5_ib) */
 	{.nb.notifier_call = forward_event,   .event_type = MLX5_EVENT_TYPE_PORT_CHANGE },
+	{.nb.notifier_call = forward_event,   .event_type = MLX5_EVENT_TYPE_GENERAL_EVENT },
 };
 
 struct mlx5_events {
-- 
2.19.1
