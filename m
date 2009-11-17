From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/9] ib/addr: verify source and destination address families match
Date: Mon, 16 Nov 2009 16:00:19 -0800
Message-ID: <4329E49DC571489C9F9498770613E42D@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rdma_resolve_ip is never called with a NULL src_addr, so we just need
to verify that the source and destination address families match.

Signed-of-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index ccc0f91..f5baf0b 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -461,8 +461,10 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	if (!req)
 		return -ENOMEM;
 
-	if (src_addr)
-		memcpy(&req->src_addr, src_addr, ip_addr_size(src_addr));
+	if (src_addr->sa_family != dst_addr->sa_family)
+		return -EINVAL;
+
+	memcpy(&req->src_addr, src_addr, ip_addr_size(src_addr));
 	memcpy(&req->dst_addr, dst_addr, ip_addr_size(dst_addr));
 	req->addr = addr;
 	req->callback = callback;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
