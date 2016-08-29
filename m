From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: move unsafe global rkey handling to the RDMA core
Date: Mon, 29 Aug 2016 10:42:55 -0600
Message-ID: <20160829164255.GD23557@obsidianresearch.com>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472464943-29450-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 29, 2016 at 12:02:17PM +0200, Christoph Hellwig wrote:
> This fairly simply series adds support to ib_alloc_pd to create the unsafe
> global rkey in the IB core, and then switches over all ULPs to use that
> functionality instead of using ib_get_dma_mr directly, and consequently
> removes ib_get_dma_mr now that all global registrations are done in the
> core code.
> 
> The advantage is that abuses of ib_get_dma_mr are more easily prevented,
> and use of the global unsafe rkey is more visible and auditable.
> 
> I'm also pondering removing the get_dma_mr methods and moving the global
> registrations into the ->alloc_pd methods, but I'll need to investigate
> how that will work out first.

This looks good to me:

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
