From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 16:17:01 -0700
Message-ID: <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>	 <20091019234329.GC9643@obsidianresearch.com>	 <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>	 <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1256164230.12075.31.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>This patch,  as Jason's suggested,  moves the function of addr_resolve_local()
>into addr4_resolve_remote()
>and addr6_resolve_remote().  It eliminates the need for addr_resolve_local().

One quick comment, remove '_remote' from function names:
addr4_resolve_remote, addr6_resolve_remote, and addr_resolve_remote

> drivers/infiniband/core/addr.c |   99 +++++++--------------------------------
> 1 files changed, 18 insertions(+), 81 deletions(-)
>
>diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
>index bd07803..f7a5861 100644
>--- a/drivers/infiniband/core/addr.c
>+++ b/drivers/infiniband/core/addr.c
>@@ -233,6 +233,14 @@ static int addr4_resolve_remote(struct sockaddr_in
>*src_in,
> 	if (ret)
> 		goto out;
>
>+	if (rt->idev->dev == init_net.loopback_dev){
>+		ret = rdma_translate_ip((struct sockaddr *)dst_in, addr);
>+		if (!ret)
>+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
>+				MAX_ADDR_LEN);
>+		goto put;
>+	}

This doesn't end up doing the same thing as what resolve_local did.  It only
matches up with the 'else if' portion below: 
 
>-static int addr_resolve_local(struct sockaddr *src_in,
>-			      struct sockaddr *dst_in,
>-			      struct rdma_dev_addr *addr)
>-{
>-	struct net_device *dev;
>-	int ret;
>-
>-	switch (dst_in->sa_family) {
>-	case AF_INET:
>-	{
>-		__be32 src_ip = ((struct sockaddr_in *)
src_in)->sin_addr.s_addr;
>-		__be32 dst_ip = ((struct sockaddr_in *)
dst_in)->sin_addr.s_addr;
>-
>-		dev = ip_dev_find(&init_net, dst_ip);
>-		if (!dev)
>-			return -EADDRNOTAVAIL;
>-
>-		if (ipv4_is_zeronet(src_ip)) {
>-			src_in->sa_family = dst_in->sa_family;
>-			((struct sockaddr_in *) src_in)->sin_addr.s_addr =
dst_ip;
>-			ret = rdma_copy_addr(addr, dev, dev->dev_addr);
>-		} else if (ipv4_is_loopback(src_ip)) {
>-			ret = rdma_translate_ip(dst_in, addr);
>-			if (!ret)
>-				memcpy(addr->dst_dev_addr, dev->dev_addr,
>MAX_ADDR_LEN);
>-		} else {
>-			ret = rdma_translate_ip(src_in, addr);
>-			if (!ret)
>-				memcpy(addr->dst_dev_addr, dev->dev_addr,
>MAX_ADDR_LEN);
>-		}

We need to handle the case where the source address is not given and provide
one.  We also need to handle the case where the source address is given, but may
not match the destination address, or even use the same RDMA device.

I didn't look at the ipv6 changes yet.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
