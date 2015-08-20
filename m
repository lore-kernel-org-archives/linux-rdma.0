From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB: remove xrc_remote_srq_num from struct ib_send_wr
Date: Thu, 20 Aug 2015 11:57:28 +0300
Message-ID: <55D59678.6090107@dev.mellanox.co.il>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440002254-795-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/19/2015 7:37 PM, Christoph Hellwig wrote:
> The field is only initialized in mlx, but never used.
>
> If we want to add proper XRC support it should be done with a new
> struct ib_xrc_wr.
>
> This shrinks the various WR structures by another 4 bytes.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx5/qp.c | 1 -
>   include/rdma/ib_verbs.h         | 1 -
>   2 files changed, 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 04df156..83a290f 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2634,7 +2634,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>   		switch (ibqp->qp_type) {
>   		case IB_QPT_XRC_INI:
>   			xrc = seg;
> -			xrc->xrc_srqn = htonl(wr->xrc_remote_srq_num);
>   			seg += sizeof(*xrc);
>   			size += sizeof(*xrc) / 16;
>   			/* fall through */
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 9b29c78..b855189 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1100,7 +1100,6 @@ struct ib_send_wr {
>   		__be32		imm_data;
>   		u32		invalidate_rkey;
>   	} ex;
> -	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
>   };
>
>   struct ib_rdma_wr {
>

Looks OK to me,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This will need Eli's ack though...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
