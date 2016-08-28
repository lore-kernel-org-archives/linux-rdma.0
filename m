From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/7] IB/mlx5: Save flow table priority handler instead of index
Date: Sun, 28 Aug 2016 14:16:31 +0300
Message-ID: <1472382994-32091-5-git-send-email-leon@kernel.org>
References: <1472382994-32091-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Saving the flow table priority object's pointer in the flow handle
is necessary for downstream patches since the sniffer flow table isn't
placed at the standard flow_db structure but in a different database.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a0fc19c..049c1a0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1623,7 +1623,7 @@ static int mlx5_ib_destroy_flow(struct ib_flow *flow_id)
 	}
 
 	mlx5_del_flow_rule(handler->rule);
-	put_flow_table(dev, &dev->flow_db.prios[handler->prio], true);
+	put_flow_table(dev, handler->prio, true);
 	mutex_unlock(&dev->flow_db.lock);
 
 	kfree(handler);
@@ -1745,7 +1745,7 @@ static struct mlx5_ib_flow_handler *create_flow_rule(struct mlx5_ib_dev *dev,
 		goto free;
 	}
 
-	handler->prio = ft_prio - dev->flow_db.prios;
+	handler->prio = ft_prio;
 
 	ft_prio->flow_table = ft;
 free:
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a59034a..a24cc20 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -150,7 +150,7 @@ struct mlx5_ib_flow_prio {
 struct mlx5_ib_flow_handler {
 	struct list_head		list;
 	struct ib_flow			ibflow;
-	unsigned int			prio;
+	struct mlx5_ib_flow_prio	*prio;
 	struct mlx5_flow_rule	*rule;
 };
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
