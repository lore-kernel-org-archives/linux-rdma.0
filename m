From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not enabled
Date: Sun, 15 Jan 2017 20:15:00 +0200
Message-ID: <20170115181500.4465-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

If IPV6 has not been enabled in the underlying kernel, we must avoid
calling IPV6 procedures in rdma_cm.ko.

This requires using "IS_ENABLED(CONFIG_IPV6)" in "if" statements
surrounding any code which calls external IPV6 procedures.

In the instance fixed here, procedure cma_bind_addr() called
ipv6_addr_type() -- which resulted in calling external procedure
__ipv6_addr_type().

Fixes: 6c26a77124ff ("RDMA/cma: fix IPv6 address resolution")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2+
Cc: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index bd8d051..e19f19c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2822,7 +2822,8 @@ static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	if (!src_addr || !src_addr->sa_family) {
 		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
 		src_addr->sa_family = dst_addr->sa_family;
-		if (dst_addr->sa_family == AF_INET6) {
+		if (IS_ENABLED(CONFIG_IPV6) &&
+		    dst_addr->sa_family == AF_INET6) {
 			struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *) src_addr;
 			struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *) dst_addr;
 			src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
