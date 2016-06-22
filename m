From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/11] IB/mlx4: Fix memory leak if QP creation failed
Date: Wed, 22 Jun 2016 17:27:31 +0300
Message-ID: <1466605652-24798-11-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

When RC, UC, or RAW QPs are created, a qp object is allocated (kzalloc).
If at a later point (in procedure create_qp_common) the qp creation fails,
this qp object must be freed.

Fixes: 1ffeb2eb8be99 ("IB/mlx4: SR-IOV IB context objects and proxy/tunnel SQP support")
Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4cd7bd2..83067e7 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1191,8 +1191,10 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 	{
 		err = create_qp_common(to_mdev(pd->device), pd, init_attr,
 				       udata, 0, &qp, gfp);
-		if (err)
+		if (err) {
+			kfree(qp);
 			return ERR_PTR(err);
+		}
 
 		qp->ibqp.qp_num = qp->mqp.qpn;
 		qp->xrcdn = xrcdn;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
