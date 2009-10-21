From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 17:08:45 -0600
Message-ID: <20091021230845.GR14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
	<20091019234329.GC9643@obsidianresearch.com>
	<676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
	<20091020003344.GA14520@obsidianresearch.com>
	<1256164230.12075.31.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1256164230.12075.31.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 03:30:29PM -0700, David J. Wilder wrote:

> addr6_resolve_remote(). The second patch fixes the bugs in
> addr_resolve_local().  The 3d patch I am posting now for discussion.
> 
> This patch, as Jason's suggested, moves the function of
> addr_resolve_local() into addr4_resolve_remote() and
> addr6_resolve_remote().  It eliminates the need for
> addr_resolve_local().

This looks exactly like what I was thinking of - have you tested this?

If it is OK, I'd make it the first in the series.

There were two things I was not sure about in my example.
 1) Is 'init_net.loopback_dev' the correct reference for the loop device? Or
    is it something like dev_net(rt->idev->dev)->loopback_dev ?

    I'm sensing it may be the latter, but can't investigate right now
    Donno much about this new namespace stuff really

 2) Was rt->idev->dev the right choice for the ipv4 case? Or is it
    rt->u.dst.dev ?

    The TCP case kinda looks like
int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
        tmp = ip_route_connect(&rt, nexthop, inet->saddr,
                               RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
                               IPPROTO_TCP,
                               inet->sport, usin->sin_port, sk, 1);
        sk_setup_caps(sk, &rt->u.dst);

void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
        __sk_dst_set(sk, dst);

    And all later things key off the sk_get_dst. So I'm thinking
    that u.dst.dev might be correct.

    I have no idea what the difference is though (can't look too hard
    right now)

The main other fixup I see is to remove
                ret = cma_bind_addr(id, src_addr, dst_addr);

>From rdma_resolve_addr and rely on the routing lookup in
addr_resolve_remote called by addr_resolve_ip to setup the bind device
from the routing lookup. (This is what I mentioned in my last email)

Which then lets you fixup the checking and handling of the
sin6_scopeid on the source address - and fixes the main other routing
difference against the TCP stack.

Thanks for working on this!

Jason
