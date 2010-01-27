From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4_ib: simplify retrieval of ib_device
Date: Wed, 27 Jan 2010 15:57:03 +0200
Message-ID: <20100127135703.GA31648@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

struct ib_qp  already holds a pointer to the ib device. No need to dive to the
hw device object to retrieve it.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2a97c96..b377671 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1214,7 +1214,7 @@ out:
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
-	struct ib_device *ib_dev = &to_mdev(sqp->qp.ibqp.device)->ib_dev;
+	struct ib_device *ib_dev = sqp->qp.ibqp.device;
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
 	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
 	struct mlx4_ib_ah *ah = to_mah(wr->wr.ud.ah);
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
