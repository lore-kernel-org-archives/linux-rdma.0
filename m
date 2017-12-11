From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-rc] iw_cxgb4: only insert drain cqes if wq is flushed
Date: Mon, 11 Dec 2017 15:46:04 -0700
Message-ID: <20171211224604.GA14716@ziepe.ca>
References: <20171206200809.AF14C87CA@linode.aoot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171206200809.AF14C87CA-4JwuKsrtP3INXE9Dec0ohg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 27, 2017 at 01:16:32PM -0800, Steve Wise wrote:
> Only insert our special drain CQEs to support ib_drain_sq/rq() after
> the wq is flushed. Otherwise, existing but not yet polled CQEs can be
> returned out of order to the user application.  This can happen when the
> QP has exited RTS but not yet flushed the QP, which can happen during
> a normal close (vs abortive close).
> 
> In addition never count the drain CQEs when determining how many CQEs
> need to be synthesized during the flush operation.  This latter issue
> should never happen if the QP is properly flushed before inserting the
> drain CQE, but I wanted to avoid corrupting the CQ state.  So we handle
> it and log a warning once.
> 
> Fixes: 4fe7c2962e11 ("iw_cxgb4: refactor sq/rq drain logic")
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  drivers/infiniband/hw/cxgb4/cq.c |  5 +++++
>  drivers/infiniband/hw/cxgb4/qp.c | 14 ++++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)

Thanks applied to -rc

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
