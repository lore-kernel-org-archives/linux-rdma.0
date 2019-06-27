From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 87/87] ethernet: mlx4: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:42:27 +0800
Message-ID: <20190627174227.4726-1-huangfq.daxian@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index a5be27772b8e..c790a5fcea73 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1013,8 +1013,6 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 
 		dma_list[i] = t;
 		eq->page_list[i].map = t;
-
-		memset(eq->page_list[i].buf, 0, PAGE_SIZE);
 	}
 
 	eq->eqn = mlx4_bitmap_alloc(&priv->eq_table.bitmap);
-- 
2.11.0
