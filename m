From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/9 v3] ib/addr: verify source and destination address families match
Date: Thu, 19 Nov 2009 08:42:33 -0800
Message-ID: <43664E6645FF46A68C1A575E0E0D1263@amr.corp.intel.com>
References: <4329E49DC571489C9F9498770613E42D@amr.corp.intel.com> <75A0BA738B5E4574AC17BB674109FBB2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75A0BA738B5E4574AC17BB674109FBB2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a source address is provided, verify that the address family matches
that of the destination address.  If the source is not specified, use the
same address family as the destination.

Signed-of-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
change from v2:
Continue to support src_addr being NULL.
Fix memory leak introduced by first patch.  Free req on failure.

change from v1:
spell 'off' correctly in signed-off-by line

 drivers/infiniband/core/addr.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 788a02e..b59ba7c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -461,18 +461,27 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	if (!req)
 		return -ENOMEM;
 
-	if (src_addr)
-		memcpy(&req->src_addr, src_addr, ip_addr_size(src_addr));
-	memcpy(&req->dst_addr, dst_addr, ip_addr_size(dst_addr));
+	src_in = (struct sockaddr *) &req->src_addr;
+	dst_in = (struct sockaddr *) &req->dst_addr;
+
+	if (src_addr) {
+		if (src_addr->sa_family != dst_addr->sa_family) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		memcpy(src_in, src_addr, ip_addr_size(src_addr));
+	} else {
+		src_in->sa_family = dst_addr->sa_family;
+	}
+
+	memcpy(dst_in, dst_addr, ip_addr_size(dst_addr));
 	req->addr = addr;
 	req->callback = callback;
 	req->context = context;
 	req->client = client;
 	atomic_inc(&client->refcount);
 
-	src_in = (struct sockaddr *) &req->src_addr;
-	dst_in = (struct sockaddr *) &req->dst_addr;
-
 	req->status = addr_resolve_local(src_in, dst_in, addr);
 	if (req->status == -EADDRNOTAVAIL)
 		req->status = addr_resolve_remote(src_in, dst_in, addr);
@@ -490,10 +499,12 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	default:
 		ret = req->status;
 		atomic_dec(&client->refcount);
-		kfree(req);
-		break;
+		goto err;
 	}
 	return ret;
+err:
+	kfree(req);
+	return ret;
 }
 EXPORT_SYMBOL(rdma_resolve_ip);
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
