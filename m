From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/bnxt_re: Delete unsupported modify_port function
Date: Mon, 5 Jun 2017 11:25:58 +0300
Message-ID: <20170605082557.GA17987@yuvallap>
References: <20170601062434.22566-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170601062434.22566-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 01, 2017 at 09:24:34AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> There is no need to return always zero for function which is not
> supported. The IB stack treats uninitialized ib_device->functions as
> not implemented.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 17 -----------------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h |  3 ---
>  drivers/infiniband/hw/bnxt_re/main.c     |  1 -
>  3 files changed, 21 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7ba9e699d7ab..c2a12b8fe8fb 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -271,23 +271,6 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>  	return 0;
>  }
> 
> -int bnxt_re_modify_port(struct ib_device *ibdev, u8 port_num,
> -			int port_modify_mask,
> -			struct ib_port_modify *port_modify)
> -{
> -	switch (port_modify_mask) {
> -	case IB_PORT_SHUTDOWN:
> -		break;
> -	case IB_PORT_INIT_TYPE:
> -		break;
> -	case IB_PORT_RESET_QKEY_CNTR:
> -		break;
> -	default:
> -		break;
> -	}
> -	return 0;
> -}
> -
>  int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
>  			       struct ib_port_immutable *immutable)
>  {
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> index 5c3d71765454..4e8d9010f112 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> @@ -129,9 +129,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
>  			  struct ib_device_modify *device_modify);
>  int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
>  		       struct ib_port_attr *port_attr);
> -int bnxt_re_modify_port(struct ib_device *ibdev, u8 port_num,
> -			int port_modify_mask,
> -			struct ib_port_modify *port_modify);
>  int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
>  			       struct ib_port_immutable *immutable);
>  int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index 5d355401179b..6951f4b688d1 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -473,7 +473,6 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
>  	ibdev->modify_device		= bnxt_re_modify_device;
> 
>  	ibdev->query_port		= bnxt_re_query_port;
> -	ibdev->modify_port		= bnxt_re_modify_port;
>  	ibdev->get_port_immutable	= bnxt_re_get_port_immutable;
>  	ibdev->query_pkey		= bnxt_re_query_pkey;
>  	ibdev->query_gid		= bnxt_re_query_gid;
> --
> 2.12.2

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
