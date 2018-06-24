From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 07/12] RDMA/umem: Don't check for negative return value of dma_map_sg_attrs()
Date: Sun, 24 Jun 2018 11:23:48 +0300
Message-ID: <20180624082353.16138-8-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

dma_map_sg_attrs() returns 0 on error and can't return negative number
(ensured by BUG_ON), so don't check for being negative value.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 54ab6335c48d..498f59bb4989 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -206,7 +206,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 				  DMA_BIDIRECTIONAL,
 				  dma_attrs);
 
-	if (umem->nmap <= 0) {
+	if (!umem->nmap) {
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.14.4
