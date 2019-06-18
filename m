From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 05/12] net/mlx5: Report a CQ error event only when a handler was set
Date: Tue, 18 Jun 2019 20:15:33 +0300
Message-ID: <20190618171540.11729-6-leon@kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618171540.11729-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Report a CQ error event only when a handler was set.

This enables mlx5_ib to not set a handler upon CQ creation and use some
other mechanism to get this event as of other events by the
mlx5_eq_notifier_register API.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index a7a8bf73e465..316fbed81470 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -503,7 +503,8 @@ static int cq_err_event_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	cq->event(cq, type);
+	if (cq->event)
+		cq->event(cq, type);
 
 	mlx5_cq_put(cq);
 
-- 
2.20.1
