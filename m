From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/2] RDMA/core: add support for iWarp multicast acceleration
 over IB_QPT_RAW_ETY QP type
Date: Mon, 10 May 2010 10:51:40 -0500
Message-ID: <4BE82B8C.8080103@opengridcomputing.com>
References: <20100430165249.1386.73960.stgit@gkslx010.igk.intel.com> <20100430165348.1386.77503.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100430165348.1386.77503.stgit-dAdtdUp2yJRU7keBU/FxOFDQ4js95KgL@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

Do you have thoughts on this change?  It is useful along with the 
IBV_QPT_RAW_ETY type added to libibverbs for cxgb devices too.

Steve.

miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> The patch enables usage of attach_mcast()/detach_mcast driver
> specific verbs for iWARP devices.
>
> IB path is unchanged.
> iWARP path adds checking for raw ethernet QP type
>
> Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>
>
> ---
>
>  drivers/infiniband/core/verbs.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
>
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index a7da9be..b5023f2 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -887,9 +887,17 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
>  {
>  	if (!qp->device->attach_mcast)
>  		return -ENOSYS;
> -	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
> -		return -EINVAL;
>  
> +	switch (qp->device->node_type) {
> +	case RDMA_TRANSPORT_IB:
> +		if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
> +			return -EINVAL;
> +		break;
> +	case RDMA_TRANSPORT_IWARP:
> +		if (qp->qp_type != IB_QPT_RAW_ETY)
> +			return -EINVAL;
> +		break;
> +	}
>  	return qp->device->attach_mcast(qp, gid, lid);
>  }
>  EXPORT_SYMBOL(ib_attach_mcast);
> @@ -898,9 +906,17 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
>  {
>  	if (!qp->device->detach_mcast)
>  		return -ENOSYS;
> -	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
> -		return -EINVAL;
>  
> +	switch (qp->device->node_type) {
> +	case RDMA_TRANSPORT_IB:
> +		if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
> +			return -EINVAL;
> +		break;
> +	case RDMA_TRANSPORT_IWARP:
> +		if (qp->qp_type != IB_QPT_RAW_ETY)
> +			return -EINVAL;
> +		break;
> +	}
>  	return qp->device->detach_mcast(qp, gid, lid);
>  }
>  EXPORT_SYMBOL(ib_detach_mcast);
>
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
