From: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] rdma: copy the saddr if it is already resolved
Date: Fri,  9 Jun 2017 16:19:25 +0530
Message-ID: <20170609104925.28927-1-rajur@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The recent changes to addr6_resolve() to call ipv6 route lookup via
the stub interface broke cxgb4/ipv6. If the source address is already
resolved by ipv6_dst_lookup() then the check ipv6_addr_any(&fl6.saddr)
would fail; consequently, copying saddr to the src_in buffer is omitted.

This commit addresses the above issue by moving the copy code out of
the ipv6_addr_any() block in addr6_resolve().

Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 02971e239a18..c32477907765 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -454,11 +454,11 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 					 &fl6.daddr, 0, &fl6.saddr);
 		if (ret)
 			goto put;
-
-		src_in->sin6_family = AF_INET6;
-		src_in->sin6_addr = fl6.saddr;
 	}
 
+	src_in->sin6_family = AF_INET6;
+	src_in->sin6_addr = fl6.saddr;
+
 	/* If there's a gateway and type of device not ARPHRD_INFINIBAND, we're
 	 * definitely in RoCE v2 (as RoCE v1 isn't routable) set the network
 	 * type accordingly.
-- 
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
