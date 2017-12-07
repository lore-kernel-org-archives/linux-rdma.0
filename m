From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-rc] iw_cxgb4: only clear the ARMED bit if a notification
 is needed
Date: Thu, 7 Dec 2017 14:16:37 -0700
Message-ID: <20171207211637.GA9479@ziepe.ca>
References: <20171201213130.1ED79E0C84@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171201213130.1ED79E0C84-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 30, 2017 at 09:41:56AM -0800, Steve Wise wrote:
> In __flush_qp(), the CQ ARMED bit was being cleared regardless of
> whether any notification is actually needed.  This resulted in the iser
> termination logic getting stuck in ib_drain_sq() because the CQ was not
> marked ARMED and thus the drain CQE notification wasn't triggered.
> 
> This new bug was exposed when this commit was merged:
> 
> commit cbb40fadd31c ("iw_cxgb4: only call the cq comp_handler when the
> cq is armed")
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>  drivers/infiniband/hw/cxgb4/qp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied to -rc, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
