From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] libmlx4: initialize SRQ scatter entries when creating an SRQ
Date: Thu, 17 Dec 2009 17:15:40 +0200
Message-ID: <200912171715.40630.jackm@dev.mellanox.co.il>
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

As in libmthca, need to initialize SRQ WQE scatter entries to the
invalid lkey at work queue creation time.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

diff --git a/src/srq.c b/src/srq.c
index ba2ceb9..f1d1240 100644
--- a/src/srq.c
+++ b/src/srq.c
@@ -128,6 +128,7 @@ int mlx4_alloc_srq_buf(struct ibv_pd *pd, struct ibv_srq_attr *attr,
 		       struct mlx4_srq *srq)
 {
 	struct mlx4_wqe_srq_next_seg *next;
+	struct mlx4_wqe_data_seg *scatter;
 	int size;
 	int buf_size;
 	int i;
@@ -160,6 +161,11 @@ int mlx4_alloc_srq_buf(struct ibv_pd *pd, struct ibv_srq_attr *attr,
 	for (i = 0; i < srq->max; ++i) {
 		next = get_wqe(srq, i);
 		next->next_wqe_index = htons((i + 1) & (srq->max - 1));
+
+		for (scatter = (void *) (next + 1);
+		     (void *) scatter < (void *) next + (1 << srq->wqe_shift);
+		     ++scatter)
+			scatter->lkey = htonl(MLX4_INVALID_LKEY);
 	}
 
 	srq->head = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
