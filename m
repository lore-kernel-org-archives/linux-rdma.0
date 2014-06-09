From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH] IB/mlx4: fix gfp passing in create_qp_common()
Date: Mon, 9 Jun 2014 16:36:33 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1406091634480.20782@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are two kzalloc() calls which were not converted to use value of gfp 
passed to create_qp_common() instead of using hardcoded GFP_KERNEL in 
40f2287bd583 ("IB/mlx4: Implement IB_QP_CREATE_USE_GFP_NOIO"). Fix this by 
passing gfp value down properly.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 78fc4c3..5b0cb8e 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -674,14 +674,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI ||
 		    (qp_type & (MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_SMI_OWNER |
 				MLX4_IB_QPT_PROXY_GSI | MLX4_IB_QPT_TUN_SMI_OWNER))) {
-			sqp = kzalloc(sizeof (struct mlx4_ib_sqp), GFP_KERNEL);
+			sqp = kzalloc(sizeof (struct mlx4_ib_sqp), gfp);
 			if (!sqp)
 				return -ENOMEM;
 			qp = &sqp->qp;
 			qp->pri.vid = 0xFFFF;
 			qp->alt.vid = 0xFFFF;
 		} else {
-			qp = kzalloc(sizeof (struct mlx4_ib_qp), GFP_KERNEL);
+			qp = kzalloc(sizeof (struct mlx4_ib_qp), gfp);
 			if (!qp)
 				return -ENOMEM;
 			qp->pri.vid = 0xFFFF;
-- 
Jiri Kosina
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
