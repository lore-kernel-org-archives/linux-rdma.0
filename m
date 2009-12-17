From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] mlx4_ib: initialize SRQ scatter entries when creating an SRQ
Date: Thu, 17 Dec 2009 17:15:43 +0200
Message-ID: <200912171715.43254.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As in the mthca-memfree driver, need to initialize SRQ WQE scatter entries to the
invalid lkey at work queue creation time.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index d425652..403ccbc 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -130,6 +130,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 	} else {
+		struct mlx4_wqe_data_seg *scatter;
+
 		err = mlx4_db_alloc(dev->dev, &srq->db, 0);
 		if (err)
 			goto err_srq;
@@ -149,6 +151,11 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 			next = get_wqe(srq, i);
 			next->next_wqe_index =
 				cpu_to_be16((i + 1) & (srq->msrq.max - 1));
+
+			for (scatter = (void *) (next + 1);
+			     (void *) scatter < (void *) next + desc_size;
+			     ++scatter)
+				scatter->lkey = cpu_to_be32(MLX4_INVALID_LKEY);
 		}
 
 		err = mlx4_mtt_init(dev->dev, srq->buf.npages, srq->buf.page_shift,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
