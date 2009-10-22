From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Thu, 22 Oct 2009 14:12:21 -0700
Message-ID: <1256245942.12075.46.camel@wilder.ibm.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
	 <20091019234329.GC9643@obsidianresearch.com>
	 <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
	 <20091020003344.GA14520@obsidianresearch.com>
	 <1256164230.12075.31.camel@wilder.ibm.com>
	 <20091021230845.GR14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021230845.GR14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Wed, 2009-10-21 at 17:08 -0600, Jason Gunthorpe wrote:


> This looks exactly like what I was thinking of - have you tested this?

Yes I did do some testing, but that brings up a good question.  I am not
sure I know what all should be tested?  I am running rping with
different destination address (and scoping).  On the ipv4 side:
rping -c -a <ip-of-my-ib0-interface>
rping -c -a <ip-of-remote-nodes-ib0-interface>

For ipv6 I ran what I described previously.  What I do need to do is add
the option to rping to specify a source address and run it with various
address.  Any help you can give defining what exactly needs to be tested
would be appreciated. 
 
> 
> If it is OK, I'd make it the first in the series.
> 
> There were two things I was not sure about in my example.
>  1) Is 'init_net.loopback_dev' the correct reference for the loop device? Or
>     is it something like dev_net(rt->idev->dev)->loopback_dev ?
> 
>     I'm sensing it may be the latter, but can't investigate right now
>     Donno much about this new namespace stuff really

I think you may be correct I will look at that closer.  I did explicitly
verify the test worked in both cases.
 
> 
>  2) Was rt->idev->dev the right choice for the ipv4 case? Or is it
>     rt->u.dst.dev ?
> 
>     The TCP case kinda looks like
> int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>         tmp = ip_route_connect(&rt, nexthop, inet->saddr,
>                                RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
>                                IPPROTO_TCP,
>                                inet->sport, usin->sin_port, sk, 1);
>         sk_setup_caps(sk, &rt->u.dst);
> 
> void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
>         __sk_dst_set(sk, dst);
> 
>     And all later things key off the sk_get_dst. So I'm thinking
>     that u.dst.dev might be correct.
> 
>     I have no idea what the difference is though (can't look too hard
>     right now)
> 
> The main other fixup I see is to remove
>                 ret = cma_bind_addr(id, src_addr, dst_addr);
> 
> From rdma_resolve_addr and rely on the routing lookup in
> addr_resolve_remote called by addr_resolve_ip to setup the bind device
> from the routing lookup. (This is what I mentioned in my last email)
> 
> Which then lets you fixup the checking and handling of the
> sin6_scopeid on the source address - and fixes the main other routing
> difference against the TCP stack.
> 
> Thanks for working on this!
> 
> Jason

Lots of discussion :) I will go through the mails, address the comments
and post the entire series of patches.

Thanks for all your input.

Dave. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
