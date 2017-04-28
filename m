From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma] infiniband: call ipv6 route lookup via the stub interface
Date: Fri, 28 Apr 2017 11:20:01 +0200
Message-ID: <09d4a8a81a499ab61ed6883ae1aa17c5fa0a5b49.1493368728.git.pabeni@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The infiniband address handle can be triggered to resolve an ipv6
address in response to MAD packets, regardless of the ipv6
module being disabled via the kernel command line argument.

That will cause a call into the ipv6 routing code, which is not
initialized, and a conseguent oops.

This commit addresses the above issue replacing the direct lookup
call with an indirect one via the ipv6 stub, which is properly
initialized according to the ipv6 status (e.g. if ipv6 is
disabled, the routing lookup fails gracefully)

Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0f58f46..8fd108d 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -444,8 +444,8 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 	fl6.saddr = src_in->sin6_addr;
 	fl6.flowi6_oif = addr->bound_dev_if;
 
-	dst = ip6_route_output(addr->net, NULL, &fl6);
-	if ((ret = dst->error))
+	ret = ipv6_stub->ipv6_dst_lookup(addr->net, NULL, &dst, &fl6);
+	if (ret < 0)
 		goto put;
 
 	rt = (struct rt6_info *)dst;
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
