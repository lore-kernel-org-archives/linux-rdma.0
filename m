From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2 03/17] IB/mlx4: Improve size determinations in six
 functions
Date: Fri, 21 Apr 2017 20:28:37 +0200
Message-ID: <fb208e64-72b4-6457-671f-7d01c0e96bcf@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 21 Apr 2017 11:33:43 +0200

Replace the specification of data types by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/mlx4/mad.c  | 6 +++---
 drivers/infiniband/hw/mlx4/main.c | 7 +++----
 drivers/infiniband/hw/mlx4/qp.c   | 4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 61bd81baeb29..ea4892b0f39e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1607,7 +1607,7 @@ static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
 		return -ENOMEM;
 
 	tun_qp->tx_ring = kcalloc(MLX4_NUM_TUNNEL_BUFS,
-				  sizeof (struct mlx4_ib_tun_tx_buf),
+				  sizeof(*tun_qp->tx_ring),
 				  GFP_KERNEL);
 	if (!tun_qp->tx_ring) {
 		kfree(tun_qp->ring);
@@ -1948,7 +1948,7 @@ static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int port,
 	struct mlx4_ib_demux_pv_ctx *ctx;
 
 	*ret_ctx = NULL;
-	ctx = kzalloc(sizeof (struct mlx4_ib_demux_pv_ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -2150,7 +2150,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 	int i;
 
 	ctx->tun = kcalloc(dev->dev->caps.sqp_demux,
-			   sizeof (struct mlx4_ib_demux_pv_ctx *), GFP_KERNEL);
+			   sizeof(*ctx->tun), GFP_KERNEL);
 	if (!ctx->tun)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 30a70fa95fec..0ac670765466 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2804,9 +2804,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	}
 	if (mlx4_is_bonded(dev))
 		for (i = 1; i < ibdev->num_ports ; ++i) {
-			new_counter_index =
-					kmalloc(sizeof(struct counter_index),
-						GFP_KERNEL);
+			new_counter_index = kmalloc(sizeof(*new_counter_index),
+						    GFP_KERNEL);
 			if (!new_counter_index)
 				goto err_counter;
 			new_counter_index->index = counter_index;
@@ -3085,7 +3084,7 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		return;
 
 	for (i = 0; i < ports; i++) {
-		dm[i] = kmalloc(sizeof (struct mlx4_ib_demux_work), GFP_ATOMIC);
+		dm[i] = kmalloc(sizeof(*dm[i]), GFP_ATOMIC);
 		if (!dm[i]) {
 			while (--i >= 0)
 				kfree(dm[i]);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 1d9d949c66d0..9269cd503443 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -691,14 +691,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI ||
 		    (qp_type & (MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_SMI_OWNER |
 				MLX4_IB_QPT_PROXY_GSI | MLX4_IB_QPT_TUN_SMI_OWNER))) {
-			sqp = kzalloc(sizeof (struct mlx4_ib_sqp), gfp);
+			sqp = kzalloc(sizeof(*sqp), gfp);
 			if (!sqp)
 				return -ENOMEM;
 			qp = &sqp->qp;
 			qp->pri.vid = 0xFFFF;
 			qp->alt.vid = 0xFFFF;
 		} else {
-			qp = kzalloc(sizeof (struct mlx4_ib_qp), gfp);
+			qp = kzalloc(sizeof(*qp), gfp);
 			if (!qp)
 				return -ENOMEM;
 			qp->pri.vid = 0xFFFF;
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
