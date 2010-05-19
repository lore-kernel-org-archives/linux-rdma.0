From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma: Copy iWARP route information.
Date: Wed, 19 May 2010 16:58:50 -0500
Message-ID: <4BF45F1A.4010707@opengridcomputing.com>
References: <20100510154656.22415.47740.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100510154656.22415.47740.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland/Sean, is this ok for 2.6.35?


Steve Wise wrote:
> For iWARP rdma_cm ids, the "route" information is the L2 src and
> next hop addresses.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
>  drivers/infiniband/core/ucma.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index ac7edc2..0498383 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -583,6 +583,16 @@ static void ucma_copy_ib_route(struct rdma_ucm_query_route_resp *resp,
>  	}
>  }
>  
> +static void ucma_copy_iw_route(struct rdma_ucm_query_route_resp *resp,
> +			       struct rdma_route *route)
> +{
> +	struct rdma_dev_addr *dev_addr;
> +
> +	dev_addr = &route->addr.dev_addr;
> +	rdma_addr_get_dgid(dev_addr, (union ib_gid *) &resp->ib_route[0].dgid);
> +	rdma_addr_get_sgid(dev_addr, (union ib_gid *) &resp->ib_route[0].sgid);
> +}
> +
>  static ssize_t ucma_query_route(struct ucma_file *file,
>  				const char __user *inbuf,
>  				int in_len, int out_len)
> @@ -621,6 +631,9 @@ static ssize_t ucma_query_route(struct ucma_file *file,
>  	case RDMA_TRANSPORT_IB:
>  		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
>  		break;
> +	case RDMA_TRANSPORT_IWARP:
> +		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
> +		break;
>  	default:
>  		break;
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
