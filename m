From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Wed, 21 Oct 2009 17:46:52 -0600
Message-ID: <20091021234652.GT14520@obsidianresearch.com>
References: <1255992430.12075.7.camel@wilder.ibm.com> <20091019234329.GC9643@obsidianresearch.com> <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com> <20091020003344.GA14520@obsidianresearch.com> <1256164230.12075.31.camel@wilder.ibm.com> <9D257695083141E79685CB2B260D7D7C@amr.corp.intel.com> <20091021233639.GS14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091021233639.GS14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2009 at 05:36:39PM -0600, Jason Gunthorpe wrote:

> > >-		if (ipv4_is_zeronet(src_ip)) {
> 
> Looks like:
> $ ip route get 10.0.0.11
> local 10.0.0.11 dev lo  src 10.0.0.11 
>     cache <local>  mtu 16436 advmss 16396 hoplimit 64
> 
> trips through the if == loopback and does
> 'rdma_translate_ip(10.0.0.11)'
> 
> Same as the old code (little different path, but seems to give the
> same result)

Oops, there is a little woopsie here:

Dave:

+	if (rt->idev->dev == init_net.loopback_dev){
+		ret = rdma_translate_ip((struct sockaddr *)dst_in, addr);
+		if (!ret)
+			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
+				MAX_ADDR_LEN);
+		goto put;
+	}
+

The 'goto put' will skip over the source address assignment step.

Maybe move this:

        if (!src_ip) {
                src_in->sin_family = dst_in->sin_family;
                src_in->sin_addr.s_addr = rt->rt_src;
        }

Up above your if (rt->idev)

And similarly for v6.

Also add a src_in = rt->rt_src assignment for v6.

I'd also remove the test for 0 address, just do it unconditionally
(IIRC routing table always returns src if src is not 0)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
