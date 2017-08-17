From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v3 23/24] RDMA/mlx4: Properly annotate link layer variable
Date: Thu, 17 Aug 2017 15:50:54 +0300
Message-ID: <20170817125055.31424-24-leon@kernel.org>
References: <20170817125055.31424-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The rdma_port_get_link_layer() returns enum rdma_link_layer as
a return value, hence it is better to store the return value in
specially annotated variable and not in int.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2874d8790570..8c6ccc392d87 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2732,19 +2732,17 @@ enum {
 static int _mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			      int attr_mask, struct ib_udata *udata)
 {
+	enum rdma_link_layer ll = IB_LINK_LAYER_UNSPECIFIED;
 	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
 	struct mlx4_ib_qp *qp = to_mqp(ibqp);
 	enum ib_qp_state cur_state, new_state;
 	int err = -EINVAL;
-	int ll;
 	mutex_lock(&qp->mutex);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
-		ll = IB_LINK_LAYER_UNSPECIFIED;
-	} else {
+	if (cur_state != new_state || cur_state != IB_QPS_RESET) {
 		int port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
 		ll = rdma_port_get_link_layer(&dev->ib_dev, port);
 	}
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
