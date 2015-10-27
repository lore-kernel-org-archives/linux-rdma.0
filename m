From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 27 Oct 2015 16:39:11 +0200
Message-ID: <562F8C8F.8040000@mellanox.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
 <1445938846-9240-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445938846-9240-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2015 11:40 AM, Sagi Grimberg wrote:
> mlx4 devices (ConnectX-2, ConnectX-3) can not issue
> max_sge in a single RDMA_READ request (resulting in
> a completion error). Thus, expose lower max_sge_rd
> to avoid this issue.

Sagi,

I can hear your pain when wearing the iser target driver maintainer hat.

Still, this patch is currently pure WA b/c we didn't do RCA (Root Cause 
Analysis)

Lets wait for RCA (which might yield the same patch, BTW) and keep 
suffering in LIO

Or.


>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index 3889723..46305dc 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -499,7 +499,8 @@ static int mlx4_ib_init_device_flags(struct ib_device *ibdev)
>   	ibdev->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
>   	ibdev->max_sge		   = min(dev->dev->caps.max_sq_sg,
>   					 dev->dev->caps.max_rq_sg);
> -	ibdev->max_sge_rd	   = ibdev->max_sge;
> +	/* reserve 2 sge slots for rdma reads */
> +	ibdev->max_sge_rd	   = ibdev->max_sge - 2;
>   	ibdev->max_cq		   = dev->dev->quotas.cq;
>   	ibdev->max_cqe		   = dev->dev->caps.max_cqes;
>   	ibdev->max_mr		   = dev->dev->quotas.mpt;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
