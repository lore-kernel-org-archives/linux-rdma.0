From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/11] IB: provide better access flags for fast
	registrations
Date: Mon, 23 Nov 2015 16:49:17 +0100
Message-ID: <20151123154917.GA12906@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <1448214409-7729-12-git-send-email-hch@lst.de> <EE465F12-A5F6-4C95-A77C-199DFF8F77BD@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EE465F12-A5F6-4C95-A77C-199DFF8F77BD-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 10:09:05AM -0500, Chuck Lever wrote:
> Out of curiosity, why are you keeping the IB_ACCESS flags?

We'll still need them for all kinds of other use cases
(ib_get_dma_mr, userspace MRs, qp_access_flags).

> It would be more efficient for providers to convert the
> scope information directly into native permissions.

For the FR mapping path I'd expect the maintained drivers
to eventually do a direct translation.  But I'd much rather
let the maintainers implement that instead of doing it
in a global search and replace.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
