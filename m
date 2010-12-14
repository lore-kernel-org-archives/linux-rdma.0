From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4/ib: Fix WARNING: at lib/swiotlb.c:562
Date: Tue, 14 Dec 2010 18:41:24 +0200
Message-ID: <4D079E34.5070003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


mlx4_ib_free_cq_buf() should not be called under spin_lock_irq
as dma_free_coherent() needs irqs enabled

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
  drivers/infiniband/hw/mlx4/cq.c |    9 ++++++++-
  1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5a219a2..e8df155 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -397,10 +397,14 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
  		cq->resize_buf = NULL;
  		cq->resize_umem = NULL;
  	} else {
+		struct mlx4_ib_cq_buf tmp_buf;
+		int tmp_cqe = 0;
+
  		spin_lock_irq(&cq->lock);
  		if (cq->resize_buf) {
  			mlx4_ib_cq_resize_copy_cqes(cq);
-			mlx4_ib_free_cq_buf(dev, &cq->buf, cq->ibcq.cqe);
+			tmp_buf = cq->buf;
+			tmp_cqe = cq->ibcq.cqe;
  			cq->buf      = cq->resize_buf->buf;
  			cq->ibcq.cqe = cq->resize_buf->cqe;

@@ -408,6 +412,9 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
  			cq->resize_buf = NULL;
  		}
  		spin_unlock_irq(&cq->lock);
+
+		if (tmp_cqe)
+			mlx4_ib_free_cq_buf(dev, &tmp_buf, tmp_cqe);
  	}

  	goto out;
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
