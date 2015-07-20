From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:54:14 -0600
Message-ID: <20150720225414.GA12442@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com>
 <20150720210544.GA9655@obsidianresearch.com>
 <015501d0c334$3f1c2830$bd547890$@opengridcomputing.com>
 <20150720221333.GA11356@obsidianresearch.com>
 <015e01d0c33d$82b44ce0$881ce6a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <015e01d0c33d$82b44ce0$881ce6a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 05:43:34PM -0500, Steve Wise wrote:
> > Yah, that seems much better.. With the patch set I am working on this
> > will mean all ULPs will fail to create a kernel PD on cxgb3 if the
> > above triggers. If our error handling works that should just make it
> > unuable from kernel space which is what we need to see..

> What about user PDs?  We need that to work for cxgb3.

Only in-kernel uses call ib_alloc_pd

The user flow calls ib_uverbs_alloc_pd which calls the driver
directly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
