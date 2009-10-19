From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Mon, 19 Oct 2009 17:43:29 -0600
Message-ID: <20091019234329.GC9643@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255992430.12075.7.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2009 at 03:47:09PM -0700, David J. Wilder wrote:

> +++ b/drivers/infiniband/core/addr.c
> @@ -278,6 +278,21 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
>  	fl.nl_u.ip6_u.daddr = dst_in->sin6_addr;
>  	fl.nl_u.ip6_u.saddr = src_in->sin6_addr;
>  
> +	if (ipv6_addr_type(&src_in->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
> +		if (!src_in->sin6_scope_id)
> +			return -EINVAL;
> +		fl.oif = src_in->sin6_scope_id;
> +	}

Seeing it all together like this make it clear this test needs to move
up the call chain and test the sockaddr passed from userspace, not
the one created by addr_resolve_local. Probably somewhere along the
rdma_resolve_addr -> cma_bind_addr -> rmda_bind_addr ->
rdma_translate_ip path. Maybe rdma_translate_ip should use and check
the scope as a temporary hack?

BTW, while researching the above comment, I'm not certain your last
patch is at all correct:

commit 85f20b39fd44310a163a9b33708fea57f08a4e40
    RDMA/addr: Fix resolution of local IPv6 addresses
    
    This patch allows a local IPv6 address to be resolved by rdma_cm.
    
    To reproduce the problem:
    
     $ rping -s -v -a ::0  &
     $ rping -c -v -a <IPv6 address local to this system>
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -393,7 +393,7 @@ static int addr_resolve_local(struct sockaddr *src_in,
 
                for_each_netdev(&init_net, dev)
                        if (ipv6_chk_addr(&init_net,
-                                         &((struct sockaddr_in6 *) addr)->sin6_addr,
+                                         &((struct sockaddr_in6 *) dst_in)->sin6_addr,
                                          dev, 1))
                                break;

I can believe it fixes the case you describe (ie loopback) but
matching the *dest* IP against the local interface's IP list cannot
possibly be right.

The primary problem is that for_each_netdev/ipv6_chk_addr is NOT the
same as ip_dev_find. ip_dev_find is a routing lookup, ipv6_chk_addr
compares the local address list. Not at all the same. I don't see a
route lookup helper for ipv6, so you have to code full flowi lookup.

With your change I expect ipv6 is 100% broken now for non loop cases?

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
