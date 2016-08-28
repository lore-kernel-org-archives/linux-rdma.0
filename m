From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/7] IB/mlx5: Increase flow table reference count in create rule
Date: Sun, 28 Aug 2016 14:16:33 +0300
Message-ID: <1472382994-32091-7-git-send-email-leon@kernel.org>
References: <1472382994-32091-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move the reference count increasing of flow table to be in
create_flow_rule, it will increase the reference count for each rule
creation and not for each flow.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ed524d7..fc2ff93 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1745,6 +1745,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 		goto free;
 	}
 
+	ft_prio->refcount++;
 	handler->prio = ft_prio;
 
 	ft_prio->flow_table = ft;
@@ -1769,6 +1770,7 @@ static struct mlx5_ib_flow_handler *create_dont_trap_rule(struct mlx5_ib_dev *de
 					       flow_attr, dst);
 		if (IS_ERR(handler_dst)) {
 			mlx5_del_flow_rule(handler->rule);
+			ft_prio->refcount--;
 			kfree(handler);
 			handler = handler_dst;
 		} else {
@@ -1831,6 +1833,7 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 						 dst);
 		if (IS_ERR(handler_ucast)) {
 			mlx5_del_flow_rule(handler->rule);
+			ft_prio->refcount--;
 			kfree(handler);
 			handler = handler_ucast;
 		} else {
@@ -1897,7 +1900,6 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 		goto destroy_ft;
 	}
 
-	ft_prio->refcount++;
 	mutex_unlock(&dev->flow_db.lock);
 	kfree(dst);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
