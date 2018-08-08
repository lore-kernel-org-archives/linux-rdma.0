From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 6/6] net/mlx5: Reduce command polling interval
Date: Wed,  8 Aug 2018 16:23:53 -0700
Message-ID: <20180808232353.15514-7-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eli Cohen <eli@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Use cond_resched() instead of usleep_range() to decrease the time
between polling attempts thus reducing overall driver load time.

Below is a comparison before and after the change, of loading eight
virtual functions.

Before:
real    0m8.785s
user    0m0.093s
sys     0m0.090s

After:
real    0m5.730s
user    0m0.097s
sys     0m0.087s

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 041c18faea46..fac5dd04578c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -211,7 +211,7 @@ static void poll_timeout(struct mlx5_cmd_work_ent *ent)
 			ent->ret = 0;
 			return;
 		}
-		usleep_range(5000, 10000);
+		cond_resched();
 	} while (time_before(jiffies, poll_end));
 
 	ent->ret = -ETIMEDOUT;
-- 
2.17.0
