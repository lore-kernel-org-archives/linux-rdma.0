From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB: remove xrc_remote_srq_num from struct ib_send_wr
Date: Wed, 19 Aug 2015 11:48:55 -0600
Message-ID: <20150819174855.GD22646@obsidianresearch.com>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440002254-795-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 06:37:34PM +0200, Christoph Hellwig wrote:
> The field is only initialized in mlx, but never used.
> 
> If we want to add proper XRC support it should be done with a new
> struct ib_xrc_wr.
> 
> This shrinks the various WR structures by another 4 bytes.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I've never really been entirely clear on how much of this stuff needs
to be kernel side. Even the switch doesn't really make alot of sense..

> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2634,7 +2634,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  		switch (ibqp->qp_type) {
>  		case IB_QPT_XRC_INI:
>  			xrc = seg;
> -			xrc->xrc_srqn = htonl(wr->xrc_remote_srq_num);


Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
