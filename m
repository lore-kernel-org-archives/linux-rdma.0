From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 6/6] IB/core: remove ib_get_dma_mr
Date: Mon, 29 Aug 2016 10:32:02 -0500
Message-ID: <013401d2020a$7d3e7760$77bb6620$@opengridcomputing.com>
References: <1472464943-29450-1-git-send-email-hch@lst.de> <1472464943-29450-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> We now only use it from ib_alloc_pd to create a local DMA lkey if the
> device doesn't provide one, or a global rkey if the ULP requests it.
> 
> This patch removes ib_get_dma_mr and open codes the functionality in
> ib_alloc_pd so that we can simply the code and prevent abuse of the

nit: simply -> simplify


> functionality.  As a side effect we can also simplify things by removing
> the valid access bit check, and the PD refcounting.
> 
> In the future I hope to also remove the per-PD global MR entirely by
> shifting this work into the HW drivers, as one step towards avoiding
> the struct ib_mr overload for various different use cases.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
