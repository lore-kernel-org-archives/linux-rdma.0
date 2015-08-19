From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Wed, 19 Aug 2015 11:46:14 -0600
Message-ID: <20150819174614.GC22646@obsidianresearch.com>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440002254-795-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 06:37:32PM +0200, Christoph Hellwig wrote:
> We have many WR opcodes that are only supported in kernel space
> and/or require optional information to be copied into the WR
> structure.  Reject all those not explicitly handled so that we
> can't pass invalid information to drivers.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>  drivers/infiniband/core/uverbs_cmd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Oh yes, this is absolutely needed for -stable.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

AFAIK, this path is rarely (never?) actually used. I think all the
drivers we have can post directly from userspace.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
