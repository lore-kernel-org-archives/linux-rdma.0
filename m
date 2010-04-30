From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH] mlx4: Fix chunk sg list overflow in mlx4_alloc_icm()
Date: Fri, 30 Apr 2010 13:21:31 +0200
Message-ID: <20100430132131.0d829b3c@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  If the number of sg entries in the ICM chunk reaches MLX4_ICM_CHUNK_LEN,
we must set chunk = NULL __even__ for coherent mappings (as is done for
mthca). Otherwise we may overflow the sg list.

Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 drivers/net/mlx4/icm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
index 57288ca..ef62f17 100644
--- a/drivers/net/mlx4/icm.c
+++ b/drivers/net/mlx4/icm.c
@@ -175,9 +175,10 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 
 				if (chunk->nsg <= 0)
 					goto fail;
+			}
 
+			if (chunk->npages == MLX4_ICM_CHUNK_LEN)
 				chunk = NULL;
-			}
 
 			npages -= 1 << cur_order;
 		} else {
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
