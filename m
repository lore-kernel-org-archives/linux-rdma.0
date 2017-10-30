From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/3] IB/mlx5: Assign send CQ and recv CQ of UMR QP
Date: Mon, 30 Oct 2017 14:23:13 +0200
Message-ID: <20171030122315.21924-2-leon@kernel.org>
References: <20171030122315.21924-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030122315.21924-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The UMR's QP is created by calling mlx5_ib_create_qp directly, and
therefore the send CQ and the recv CQ on the ibqp weren't assigned.

Assign them right after calling the mlx5_ib_create_qp to assure
that any access to those pointers will work as expected and won't
crash the system as might happen as part of reset flow.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 552f7bd4ecc3..5aff1e33d984 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3097,6 +3097,8 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
 	qp->qp_type    = MLX5_IB_QPT_REG_UMR;
+	qp->send_cq    = init_attr->send_cq;
+	qp->recv_cq    = init_attr->recv_cq;
 
 	attr->qp_state = IB_QPS_INIT;
 	attr->port_num = 1;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
