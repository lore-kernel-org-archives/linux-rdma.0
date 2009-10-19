From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Mon, 19 Oct 2009 16:47:59 -0700
Message-ID: <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091019234329.GC9643-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>@@ -393,7 +393,7 @@ static int addr_resolve_local(struct sockaddr *src_in,
>
>                for_each_netdev(&init_net, dev)
>                        if (ipv6_chk_addr(&init_net,
>-                                         &((struct sockaddr_in6 *) addr)-
>>sin6_addr,
>+                                         &((struct sockaddr_in6 *) dst_in)-
>>sin6_addr,
>                                          dev, 1))
>                                break;
>
>I can believe it fixes the case you describe (ie loopback) but
>matching the *dest* IP against the local interface's IP list cannot
>possibly be right.

The intent is to see if the destination address is local.  A source address may
not be given.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
