From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 17:54:59 -0500
Message-ID: <016c01d0c33f$1b082920$51187b60$@opengridcomputing.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <55AD5B48.3010906@talpey.com> <20150720210544.GA9655@obsidianresearch.com> <015501d0c334$3f1c2830$bd547890$@opengridcomputing.com> <20150720221333.GA11356@obsidianresearch.com> <015e01d0c33d$82b44ce0$881ce6a0$@opengridcomputing.com> <20150720225414.GA12442@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720225414.GA12442-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, July 20, 2015 5:54 PM
> To: Steve Wise
> Cc: 'Tom Talpey'; 'Chuck Lever'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
> 
> On Mon, Jul 20, 2015 at 05:43:34PM -0500, Steve Wise wrote:
> > > Yah, that seems much better.. With the patch set I am working on this
> > > will mean all ULPs will fail to create a kernel PD on cxgb3 if the
> > > above triggers. If our error handling works that should just make it
> > > unuable from kernel space which is what we need to see..
> 
> > What about user PDs?  We need that to work for cxgb3.
> 
> Only in-kernel uses call ib_alloc_pd
> 
> The user flow calls ib_uverbs_alloc_pd which calls the driver
> directly.
>

Ok good.  Thanks!


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
