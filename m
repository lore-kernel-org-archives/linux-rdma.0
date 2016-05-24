From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Tue, 24 May 2016 11:22:50 -0600
Message-ID: <20160524172250.GD8037@obsidianresearch.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
 <20160518222857.GB23835@obsidianresearch.com>
 <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
 <20160519180552.GA26130@obsidianresearch.com>
 <065c01d1b1ff$e1e149f0$a5a3ddd0$@opengridcomputing.com>
 <20160519192805.GA32668@obsidianresearch.com>
 <b4eb5c63-9f20-b927-ebc8-f8016accc93c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b4eb5c63-9f20-b927-ebc8-f8016accc93c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 20, 2016 at 11:44:14AM +0200, Gabriele Svelto wrote:
> On 19/05/2016 21:28, Jason Gunthorpe wrote:
> > Yes, we probably should have had a 'memcpy to wc' verbs helper that
> > did the best possible wc copy and prompt flush rather than the mess
> > with wc_wmb and open coded memcpy. IIRC there is some way to do this
> > with xmm non temporal cache line stores that is even better???
> 
> Non-temporal stores will go straight to memory IIRC. With many modern
> HCAs being able to read data directly out of the last-level cache of the
> processor they could end up being a suboptimal choice.

We are not talking about memory backed write for DMA, but batching a
MMIO write into a 64 byte burst. non-temporal stores would seem to be
the best way to do that?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
