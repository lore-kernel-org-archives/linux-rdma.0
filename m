From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Mon, 19 Oct 2009 18:33:44 -0600
Message-ID: <20091020003344.GA14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <676AB781CD644CC28E1AD4951EA4EEF8-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2009 at 04:47:59PM -0700, Sean Hefty wrote:
> >@@ -393,7 +393,7 @@ static int addr_resolve_local(struct sockaddr *src_in,
> >
> >                for_each_netdev(&init_net, dev)
> >                        if (ipv6_chk_addr(&init_net,
> >-                                         &((struct sockaddr_in6 *) addr)-
> >>sin6_addr,
> >+                                         &((struct sockaddr_in6 *) dst_in)-
> >>sin6_addr,
> >                                          dev, 1))
> >                                break;
> >
> >I can believe it fixes the case you describe (ie loopback) but
> >matching the *dest* IP against the local interface's IP list cannot
> >possibly be right.
> 
> The intent is to see if the destination address is local.  A source
> address may not be given.

Well, that makes more sense, but it still pretty strange to match the
IP list like that, the proper thing is to query RT6_TABLE_LOCAL, like
the IPv4 case does.

Anyhow, couldn't the whole addr_resolve_local routine be replaced with
something like this in addr_resolve_remote:
 if (rt->idev == init_net->loopback_dev)
    rdma_translate_ip(rt->rt_src, dev_addr, NULL);

for IPv4 and similar for IPv6?

That does query the proper RT_TABLEs to determine if the IP is local
and then we get the searching and ip_dev_find only for the case where
the address is definitely looped back. Much closer to how the IP stack
works normally.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
