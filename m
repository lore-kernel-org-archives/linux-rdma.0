From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/cma: Potential NULL dereference in cma_id_from_event
Date: Mon, 21 Sep 2015 16:02:02 +0300
Message-ID: <1442840522-12691-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the lookup of a listening ID failed for an AF_IB request, the code
would try to call dev_put() on a NULL net_dev.

Fixes: be688195bd08 ("IB/cma: Fix net_dev reference leak with failed
requests")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b1ab13f3e182..b92a3c2c060b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1302,7 +1302,7 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
 	bind_list = cma_ps_find(rdma_ps_from_service_id(req.service_id),
 				cma_port_from_service_id(req.service_id));
 	id_priv = cma_find_listener(bind_list, cm_id, ib_event, &req, *net_dev);
-	if (IS_ERR(id_priv)) {
+	if (IS_ERR(id_priv) && *net_dev) {
 		dev_put(*net_dev);
 		*net_dev = NULL;
 	}
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
