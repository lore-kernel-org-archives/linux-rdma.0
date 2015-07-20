From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 15:05:44 -0600
Message-ID: <20150720210544.GA9655@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AD5B48.3010906-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 01:34:16PM -0700, Tom Talpey wrote:
> On 7/20/2015 12:03 PM, Chuck Lever wrote:
> >All HCA providers have an ib_get_dma_mr() verb. Thus
> >rpcrdma_ia_open() will either grab the device's local_dma_key if one
> >is available, or it will call ib_get_dma_mr() which is a 100%
> >guaranteed fallback.
> 
> I recall that in the past, some providers did not support mapping
> all of the machine's potential physical memory with a single dma_mr.
> If an rnic did/does not support 44-ish bits of length per region,
> for example.

Looks like you are right, but the standard in kernel is to require
ib_get_dma_mr, if the HCA can't do that, then it cannot be used on a
big memory machine with kernel ULPs.

Looking deeper, both amso1100 and cxgb3 seem limited to 32 bits of
physical memory, and silently break all kernel ULPs if they are used
on a modern machine with > 4G.

Is that right Steve?

Based on that, should we remove the cxgb3 driver as well? Or at least
can you fix it up to at least fail get_dma_mr if there is too much
ram?

Everything else looked Ok.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
