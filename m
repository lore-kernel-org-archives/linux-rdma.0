From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 15:30:29 -0700
Message-ID: <1256164230.12075.31.camel@wilder.ibm.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
	<20091019234329.GC9643@obsidianresearch.com>
	<676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
	<20091020003344.GA14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20091020003344.GA14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mon, 2009-10-19 at 18:33 -0600, Jason Gunthorpe wrote:

> Well, that makes more sense, but it still pretty strange to match the
> IP list like that, the proper thing is to query RT6_TABLE_LOCAL, like
> the IPv4 case does.
> 
> Anyhow, couldn't the whole addr_resolve_local routine be replaced with
> something like this in addr_resolve_remote:
>  if (rt->idev == init_net->loopback_dev)
>     rdma_translate_ip(rt->rt_src, dev_addr, NULL);
> 
> for IPv4 and similar for IPv6?
> 
> That does query the proper RT_TABLEs to determine if the IP is local
> and then we get the searching and ip_dev_find only for the case where
> the address is definitely looped back. Much closer to how the IP stack
> works normally.
> 
> Jason

Jason, Sean
I have separated the patches into three to make them simpler to discuss.
One patch fixes the handling of link-local address in
addr6_resolve_remote(). The second patch fixes the bugs in
addr_resolve_local().  The 3d patch I am posting now for discussion.

This patch,  as Jason's suggested,  moves the function of addr_resolve_local() into addr4_resolve_remote()
and addr6_resolve_remote().  It eliminates the need for addr_resolve_local(). 

 drivers/infiniband/core/addr.c |   99 +++++++--------------------------------
 1 files changed, 18 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index bd07803..f7a5861 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -233,6 +233,14 @@ static int addr4_resolve_remote(struct sockaddr_in *src_in,
 	if (ret)
 		goto out;
 
+	if (rt->idev->dev == init_net.loopback_dev){
+		ret = rdma_translate_ip((struct sockaddr *)dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
+				MAX_ADDR_LEN);
+		goto put;
+	}
+
 	/* If the device does ARP internally, return 'done' */
 	if (rt->idev->dev->flags & IFF_NOARP) {
 		rdma_copy_addr(addr, rt->idev->dev, NULL);
@@ -282,6 +290,14 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 	if (!dst)
 		return ret;
 
+	if (dst->dev == init_net.loopback_dev) {
+		ret=rdma_translate_ip((struct sockaddr *)dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
+				MAX_ADDR_LEN);
+		goto release;
+	}
+
 	if (dst->dev->flags & IFF_NOARP) {
 		ret = rdma_copy_addr(addr, dst->dev, NULL);
 	} else {
@@ -289,7 +305,7 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 		if (neigh && (neigh->nud_state & NUD_VALID))
 			ret = rdma_copy_addr(addr, neigh->dev, neigh->ha);
 	}
-
+release:
 	dst_release(dst);
 	return ret;
 }
@@ -352,82 +368,6 @@ static void process_req(struct work_struct *work)
 	}
 }
 
-static int addr_resolve_local(struct sockaddr *src_in,
-			      struct sockaddr *dst_in,
-			      struct rdma_dev_addr *addr)
-{
-	struct net_device *dev;
-	int ret;
-
-	switch (dst_in->sa_family) {
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
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
-	{
-		struct in6_addr *a;
-
-		for_each_netdev(&init_net, dev)
-			if (ipv6_chk_addr(&init_net,
-					  &((struct sockaddr_in6 *) dst_in)->sin6_addr,
-					  dev, 1))
-				break;
-
-		if (!dev)
-			return -EADDRNOTAVAIL;
-
-		a = &((struct sockaddr_in6 *) src_in)->sin6_addr;
-
-		if (ipv6_addr_any(a)) {
-			src_in->sa_family = dst_in->sa_family;
-			((struct sockaddr_in6 *) src_in)->sin6_addr =
-				((struct sockaddr_in6 *) dst_in)->sin6_addr;
-			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
-		} else if (ipv6_addr_loopback(a)) {
-			ret = rdma_translate_ip(dst_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		} else  {
-			ret = rdma_translate_ip(src_in, addr);
-			if (!ret)
-				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
-		}
-		break;
-	}
-#endif
-
-	default:
-		ret = -EADDRNOTAVAIL;
-		break;
-	}
-
-	return ret;
-}
-
 int rdma_resolve_ip(struct rdma_addr_client *client,
 		    struct sockaddr *src_addr, struct sockaddr *dst_addr,
 		    struct rdma_dev_addr *addr, int timeout_ms,
@@ -455,10 +395,7 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	src_in = (struct sockaddr *) &req->src_addr;
 	dst_in = (struct sockaddr *) &req->dst_addr;
 
-	req->status = addr_resolve_local(src_in, dst_in, addr);
-	if (req->status == -EADDRNOTAVAIL)
-		req->status = addr_resolve_remote(src_in, dst_in, addr);
-
+	req->status = addr_resolve_remote(src_in, dst_in, addr);
 	switch (req->status) {
 	case 0:
 		req->timeout = jiffies;
