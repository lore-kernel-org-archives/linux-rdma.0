From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx: Expose max_fmr to ib_query_device
Date: Thu, 29 Oct 2015 19:21:45 +0200
Message-ID: <563255A9.1050705@dev.mellanox.co.il>
References: <1446134879-20456-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446134879-20456-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,

The title prefix should be IB/mlx4:

> Expose max_fmr so it will be available to ULPs.
> max_fmr is num_mpts minus reserved.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index efecdf0..4f9ff35 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -475,6 +475,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>   	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
>   	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
>   					   props->max_mcast_grp;
> +	props->max_fmr = dev->dev->caps.num_mpts - dev->dev->caps.reserved_mrws;

Umm, this looks like a capability that needs to communicated from the
device. Perhaps this needs to be added to CX3 FW? Or?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
