From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4: Fix bug in mlx4_ib_mcg_attach
Date: Tue, 8 Dec 2009 17:14:05 +0200
Message-ID: <20091208151405.GA30005@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The "!" operator has precedence over the "&" operator so parenthesis are
required to properly evaluate the user's loopback requirement.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0f6ef38..736eea0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -586,8 +586,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
 
-	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, !!mqp->flags &
-				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK);
+	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, !!(mqp->flags &
+				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK));
 	if (err)
 		return err;
 
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
