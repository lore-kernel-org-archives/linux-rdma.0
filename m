From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:16:59 -0500
Message-ID: <015101d0c331$69e31d10$3da95730$@opengridcomputing.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <55AD5B48.3010906@talpey.com> <20150720210544.GA9655@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720210544.GA9655-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Monday, July 20, 2015 4:06 PM
> To: Tom Talpey; Steve Wise
> Cc: Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
> 
> On Mon, Jul 20, 2015 at 01:34:16PM -0700, Tom Talpey wrote:
> > On 7/20/2015 12:03 PM, Chuck Lever wrote:
> > >All HCA providers have an ib_get_dma_mr() verb. Thus
> > >rpcrdma_ia_open() will either grab the device's local_dma_key if one
> > >is available, or it will call ib_get_dma_mr() which is a 100%
> > >guaranteed fallback.
> >
> > I recall that in the past, some providers did not support mapping
> > all of the machine's potential physical memory with a single dma_mr.
> > If an rnic did/does not support 44-ish bits of length per region,
> > for example.
> 
> Looks like you are right, but the standard in kernel is to require
> ib_get_dma_mr, if the HCA can't do that, then it cannot be used on a
> big memory machine with kernel ULPs.
> 
> Looking deeper, both amso1100 and cxgb3 seem limited to 32 bits of
> physical memory, and silently break all kernel ULPs if they are used
> on a modern machine with > 4G.
> 
> Is that right Steve?
>

Yes.
 
> Based on that, should we remove the cxgb3 driver as well? Or at least
> can you fix it up to at least fail get_dma_mr if there is too much
> ram?
> 

I would like to keep cxgb3 around.  I can add code to fail if the memory is > 32b.  Do you know how I get the amount of available
ram?

What is the process again to remove a driver?  I can remove amso...


 
> Everything else looked Ok.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
