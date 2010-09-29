From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libmlx4: Fix bug in mlx4_set_sq_sizes()
Date: Wed, 29 Sep 2010 12:09:09 +0200
Message-ID: <20100929100909.GB4960@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

mlx4_set_sq_sizes() calcualtes wqe_size from sq.wqe_shift by perofrming a shift
left. This However, this yields a results which is a power of 2 which is not
true when we use up the max possible WQE size. Fix this by using a min() on the
evaluated value and the max wqe size.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 src/mlx4.h |    2 ++
 src/qp.c   |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index 5223697..0d03e8e 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -367,4 +367,6 @@ int mlx4_alloc_av(struct mlx4_pd *pd, struct ibv_ah_attr *attr,
 		   struct mlx4_ah *ah);
 void mlx4_free_av(struct mlx4_ah *ah);
 
+#define min(a, b) (a < b ? a : b)
+
 #endif /* MLX4_H */
diff --git a/src/qp.c b/src/qp.c
index 6ceb3ef..b70c54a 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -622,7 +622,8 @@ void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 {
 	int wqe_size;
 
-	wqe_size = (1 << qp->sq.wqe_shift) - sizeof (struct mlx4_wqe_ctrl_seg);
+	wqe_size = min((1 << qp->sq.wqe_shift), MLX4_MAX_WQE_SIZE) -
+		sizeof (struct mlx4_wqe_ctrl_seg);
 	switch (type) {
 	case IBV_QPT_UD:
 		wqe_size -= sizeof (struct mlx4_wqe_datagram_seg);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
