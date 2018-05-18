From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 03/15] IB/mlx5: Use 'kvfree()' for memory allocated by 'kvzalloc()'
Date: Thu, 17 May 2018 18:22:46 -0700
Message-ID: <20180518012258.26968-4-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
free it.

Fixes: 1cbe6fc86ccfe ("IB/mlx5: Add support for CQE compressing")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 77d257ec899b..6d52ea03574e 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -849,7 +849,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	return 0;
 
 err_cqb:
-	kfree(*cqb);
+	kvfree(*cqb);
 
 err_db:
 	mlx5_ib_db_unmap_user(to_mucontext(context), &cq->db);
-- 
2.17.0
