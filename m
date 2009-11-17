From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/9] ib/addr: simplify resolving IPv4 addresses
Date: Mon, 16 Nov 2009 16:07:26 -0800
Message-ID: <AD17449F0C4E4FE7B20C32412F077C00@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Merge resolve local/remote address resolution into a single
data flow to ensure consistent access and use of the local routing
tables.

Based on work from:
David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |   81 +++++++++++-----------------------------
 1 files changed, 23 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 4febc0e..07c2944 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -184,17 +184,6 @@ static void addr_send_arp(struct sockaddr *dst_in)
 	memset(&fl, 0, sizeof fl);
 
 	switch (dst_in->sa_family) {
-	case AF_INET:
-		fl.nl_u.ip4_u.daddr =
-			((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
-
-		if (ip_route_output_key(&init_net, &rt, &fl))
-			return;
-
-		neigh_event_send(rt->u.dst.neighbour, NULL);
-		ip_rt_put(rt);
-		break;
-
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
 	{
@@ -215,9 +204,9 @@ static void addr_send_arp(struct sockaddr *dst_in)
 	}
 }
 
-static int addr4_resolve_remote(struct sockaddr_in *src_in,
-			       struct sockaddr_in *dst_in,
-			       struct rdma_dev_addr *addr)
+static int addr4_resolve(struct sockaddr_in *src_in,
+			 struct sockaddr_in *dst_in,
+			 struct rdma_dev_addr *addr)
 {
 	__be32 src_ip = src_in->sin_addr.s_addr;
 	__be32 dst_ip = dst_in->sin_addr.s_addr;
@@ -235,6 +224,16 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	if (ret)
 		goto out;
 
+	src_in->sin_family = AF_INET;
+	src_in->sin_addr.s_addr = rt->rt_src;
+
+	if (rt->idev->dev->flags & IFF_LOOPBACK) {
+		ret = rdma_translate_ip((struct sockaddr *) dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr, MAX_ADDR_LEN);
+		goto put;
+	}
+
 	/* If the device does ARP internally, return 'done' */
 	if (rt->idev->dev->flags & IFF_NOARP) {
 		rdma_copy_addr(addr, rt->idev->dev, NULL);
@@ -242,21 +241,14 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	}
 
 	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, rt->idev->dev);
-	if (!neigh) {
+	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
+		neigh_event_send(rt->u.dst.neighbour, NULL);
 		ret = -ENODATA;
+		if (neigh)
+			goto release;
 		goto put;
 	}
 
-	if (!(neigh->nud_state & NUD_VALID)) {
-		ret = -ENODATA;
-		goto release;
-	}
-
-	if (!src_ip) {
-		src_in->sin_family = dst_in->sin_family;
-		src_in->sin_addr.s_addr = rt->rt_src;
-	}
-
 	ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
 release:
 	neigh_release(neigh);
@@ -305,12 +297,12 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 }
 #endif
 
-static int addr_resolve_remote(struct sockaddr *src_in,
-				struct sockaddr *dst_in,
-				struct rdma_dev_addr *addr)
+static int addr_resolve(struct sockaddr *src_in,
+			struct sockaddr *dst_in,
+			struct rdma_dev_addr *addr)
 {
 	if (src_in->sa_family == AF_INET) {
-		return addr4_resolve_remote((struct sockaddr_in *) src_in,
+		return addr4_resolve((struct sockaddr_in *) src_in,
 			(struct sockaddr_in *) dst_in, addr);
 	} else
 		return addr6_resolve_remote((struct sockaddr_in6 *) src_in,
@@ -330,8 +322,7 @@ static void process_req(struct work_struct *work)
 		if (req->status == -ENODATA) {
 			src_in = (struct sockaddr *) &req->src_addr;
 			dst_in = (struct sockaddr *) &req->dst_addr;
-			req->status = addr_resolve_remote(src_in, dst_in,
-							  req->addr);
+			req->status = addr_resolve(src_in, dst_in, req->addr);
 			if (req->status && time_after_eq(jiffies, req->timeout))
 				req->status = -ETIMEDOUT;
 			else if (req->status == -ENODATA)
@@ -363,32 +354,6 @@ static int addr_resolve_local(struct sockaddr *src_in,
 	int ret;
 
 	switch (dst_in->sa_family) {
-	case AF_INET:
-	{
-		__be32 src_ip = ((struct sockaddr_in *) src_in)->sin_addr.s_addr;
-		__be32 dst_ip = ((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
-
-		dev = ip_dev_find(&init_net, dst_ip);
-		if (!dev)
-			return -EADDRNOTAVAIL;
-
-		if (ipv4_is_zeronet(src_ip)) {
-			src_in->sa_family = dst_in->sa_family;
-			((struct sockaddr_in *) src_in)->sin_addr.s_addr = dst_ip;
-			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
-		} else if (ipv4_is_loopback(src_ip)) {
-			ret = rdma_translate_ip(dst_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		} else {
-			ret = rdma_translate_ip(src_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		}
-		dev_put(dev);
-		break;
-	}
-
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
 	{
@@ -466,7 +431,7 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 
 	req->status = addr_resolve_local(src_in, dst_in, addr);
 	if (req->status == -EADDRNOTAVAIL)
-		req->status = addr_resolve_remote(src_in, dst_in, addr);
+		req->status = addr_resolve(src_in, dst_in, addr);
 
 	switch (req->status) {
 	case 0:



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
