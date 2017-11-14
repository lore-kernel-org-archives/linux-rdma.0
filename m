From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 05/31] IB/mlx4: Remove unused ibpd parameter
Date: Tue, 14 Nov 2017 14:51:52 +0200
Message-ID: <20171114125218.20477-6-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Alfasi <ereza-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Alfasi <ereza-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove unused ibpd parameter from create_qp_rss() function.

Signed-off-by: Erez Alfasi <ereza-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 013049bcdb53..dc1c61745ad8 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -725,7 +725,7 @@ static int set_qp_rss(struct mlx4_ib_dev *dev, struct mlx4_ib_rss *rss_ctx,
 	return 0;
 }
 
-static int create_qp_rss(struct mlx4_ib_dev *dev, struct ib_pd *ibpd,
+static int create_qp_rss(struct mlx4_ib_dev *dev,
 			 struct ib_qp_init_attr *init_attr,
 			 struct mlx4_ib_create_qp_rss *ucmd,
 			 struct mlx4_ib_qp *qp)
@@ -848,7 +848,7 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
 	qp->pri.vid = 0xFFFF;
 	qp->alt.vid = 0xFFFF;
 
-	err = create_qp_rss(to_mdev(pd->device), pd, init_attr, &ucmd, qp);
+	err = create_qp_rss(to_mdev(pd->device), init_attr, &ucmd, qp);
 	if (err) {
 		kfree(qp);
 		return ERR_PTR(err);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
