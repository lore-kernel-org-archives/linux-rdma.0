From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 16/31] RDMA/cma: Introduce and use helper functions to init work
Date: Tue, 14 Nov 2017 14:52:03 +0200
Message-ID: <20171114125218.20477-17-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce and user helper functions to initialize work for address
resolved and route resolved event that avoid code duplication at few
places.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 53 ++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f986597201fa..48f593bafe33 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2413,6 +2413,26 @@ static void cma_ndev_work_handler(struct work_struct *_work)
 	kfree(work);
 }
 
+static void cma_init_resolve_route_work(struct cma_work *work,
+					struct rdma_id_private *id_priv)
+{
+	work->id = id_priv;
+	INIT_WORK(&work->work, cma_work_handler);
+	work->old_state = RDMA_CM_ROUTE_QUERY;
+	work->new_state = RDMA_CM_ROUTE_RESOLVED;
+	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+}
+
+static void cma_init_resolve_addr_work(struct cma_work *work,
+				       struct rdma_id_private *id_priv)
+{
+	work->id = id_priv;
+	INIT_WORK(&work->work, cma_work_handler);
+	work->old_state = RDMA_CM_ADDR_QUERY;
+	work->new_state = RDMA_CM_ADDR_RESOLVED;
+	work->event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
+}
+
 static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 {
 	struct rdma_route *route = &id_priv->id.route;
@@ -2423,11 +2443,7 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 	if (!work)
 		return -ENOMEM;
 
-	work->id = id_priv;
-	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = RDMA_CM_ROUTE_QUERY;
-	work->new_state = RDMA_CM_ROUTE_RESOLVED;
-	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+	cma_init_resolve_route_work(work, id_priv);
 
 	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
@@ -2482,11 +2498,7 @@ static int cma_resolve_iw_route(struct rdma_id_private *id_priv, int timeout_ms)
 	if (!work)
 		return -ENOMEM;
 
-	work->id = id_priv;
-	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = RDMA_CM_ROUTE_QUERY;
-	work->new_state = RDMA_CM_ROUTE_RESOLVED;
-	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+	cma_init_resolve_route_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
 }
@@ -2540,9 +2552,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	if (!work)
 		return -ENOMEM;
 
-	work->id = id_priv;
-	INIT_WORK(&work->work, cma_work_handler);
-
 	route->path_rec = kzalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
@@ -2602,11 +2611,7 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 		goto err2;
 	}
 
-	work->old_state = RDMA_CM_ROUTE_QUERY;
-	work->new_state = RDMA_CM_ROUTE_RESOLVED;
-	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
-	work->event.status = 0;
-
+	cma_init_resolve_route_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 
 	return 0;
@@ -2786,11 +2791,7 @@ static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 	rdma_addr_get_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, &gid);
 
-	work->id = id_priv;
-	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = RDMA_CM_ADDR_QUERY;
-	work->new_state = RDMA_CM_ADDR_RESOLVED;
-	work->event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
+	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
 err:
@@ -2816,11 +2817,7 @@ static int cma_resolve_ib_addr(struct rdma_id_private *id_priv)
 	rdma_addr_set_dgid(&id_priv->id.route.addr.dev_addr, (union ib_gid *)
 		&(((struct sockaddr_ib *) &id_priv->id.route.addr.dst_addr)->sib_addr));
 
-	work->id = id_priv;
-	INIT_WORK(&work->work, cma_work_handler);
-	work->old_state = RDMA_CM_ADDR_QUERY;
-	work->new_state = RDMA_CM_ADDR_RESOLVED;
-	work->event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
+	cma_init_resolve_addr_work(work, id_priv);
 	queue_work(cma_wq, &work->work);
 	return 0;
 err:
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
