From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/6] IB/core: Add missing check for addr_resolve callback return value
Date: Thu, 27 Oct 2016 16:36:29 +0300
Message-ID: <1477575391-20134-5-git-send-email-leon@kernel.org>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575391-20134-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When calling rdma_resolve_ip inside rdma_addr_find_l2_eth_by_grh,
the return status of the request was ignored in the callback function
causing a successful return and an empty dmac.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index b136d3a..0f58f46 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -699,13 +699,16 @@ EXPORT_SYMBOL(rdma_addr_cancel);
 struct resolve_cb_context {
 	struct rdma_dev_addr *addr;
 	struct completion comp;
+	int status;
 };
 
 static void resolve_cb(int status, struct sockaddr *src_addr,
 	     struct rdma_dev_addr *addr, void *context)
 {
-	memcpy(((struct resolve_cb_context *)context)->addr, addr, sizeof(struct
-				rdma_dev_addr));
+	if (!status)
+		memcpy(((struct resolve_cb_context *)context)->addr,
+		       addr, sizeof(struct rdma_dev_addr));
+	((struct resolve_cb_context *)context)->status = status;
 	complete(&((struct resolve_cb_context *)context)->comp);
 }
 
@@ -743,6 +746,10 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 
 	wait_for_completion(&ctx.comp);
 
+	ret = ctx.status;
+	if (ret)
+		return ret;
+
 	memcpy(dmac, dev_addr.dst_dev_addr, ETH_ALEN);
 	dev = dev_get_by_index(&init_net, dev_addr.bound_dev_if);
 	if (!dev)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
