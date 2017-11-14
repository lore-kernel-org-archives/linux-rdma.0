From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 21/31] RDMA/core: Avoid redundant memcpy in resolving address
Date: Tue, 14 Nov 2017 14:52:08 +0200
Message-ID: <20171114125218.20477-22-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rdma_resolve_ip works on the rdma_dev_addr pointer even from worker
thread context. Therefore there is no need to store that in context.
At the same time, resolve_cb() callback function invokes memcpy on
source and destination addresses which are essentially same.
Therefore both are removed.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index da4469c38eac..6679dd43fe08 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -744,7 +744,6 @@ void rdma_addr_cancel(struct rdma_dev_addr *addr)
 EXPORT_SYMBOL(rdma_addr_cancel);
 
 struct resolve_cb_context {
-	struct rdma_dev_addr *addr;
 	struct completion comp;
 	int status;
 };
@@ -752,9 +751,6 @@ struct resolve_cb_context {
 static void resolve_cb(int status, struct sockaddr *src_addr,
 	     struct rdma_dev_addr *addr, void *context)
 {
-	if (!status)
-		memcpy(((struct resolve_cb_context *)context)->addr,
-		       addr, sizeof(struct rdma_dev_addr));
 	((struct resolve_cb_context *)context)->status = status;
 	complete(&((struct resolve_cb_context *)context)->comp);
 }
@@ -780,7 +776,6 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 	dev_addr.bound_dev_if = ndev->ifindex;
 	dev_addr.net = &init_net;
 
-	ctx.addr = &dev_addr;
 	init_completion(&ctx.comp);
 	ret = rdma_resolve_ip(&self, &sgid_addr._sockaddr, &dgid_addr._sockaddr,
 			&dev_addr, 1000, resolve_cb, &ctx);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
