From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1] IB/CMA: Fix to handle global/non-linklocal IPv6 address in cma_check_linklocal()
Date: Sat, 16 Nov 2013 09:30:01 +0530
Message-ID: <490f7bb9-cfb2-4225-abd7-c0441878330f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Even if the addr is not a linklocal address, the code treats it as such
and assigns the bound dev addr to the scope id of the address which is invalid.
Fix by checking if it's a link local address first and return 0 if not.

Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
Incorporated comments from Philip and Sean Hefty.

 drivers/infiniband/core/cma.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index dab4b41..7f8ee93 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2466,8 +2466,11 @@ static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
 		return 0;
 
 	sin6 = (struct sockaddr_in6 *) addr;
-	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
-	    !sin6->sin6_scope_id)
+
+	if (!(ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL))
+		return 0;
+
+	if (!sin6->sin6_scope_id)
 			return -EINVAL;
 
 	dev_addr->bound_dev_if = sin6->sin6_scope_id;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
