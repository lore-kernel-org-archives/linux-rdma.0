From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/{cma, ucma}: Refactor to have
 transport specific checks
Date: Wed, 10 Jan 2018 16:37:48 -0700
Message-ID: <20180110233748.GS4518@ziepe.ca>
References: <20180108150448.29069-1-leon@kernel.org>
 <20180108150448.29069-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108150448.29069-5-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 08, 2018 at 05:04:46PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Code is refactored to perform transport specific checks for OPA, IB,
> RoCE to be done in core routine. Wherever possible, it is better to avoid
> spreading transport specific code in multiple kernel modules.
> 
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/core/cma.c  | 11 ++++++++++-
>  drivers/infiniband/core/ucma.c |  9 +--------
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index f1e425da926d..68223bd56b53 100644
> +++ b/drivers/infiniband/core/cma.c
> @@ -2522,14 +2522,23 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
>  		     struct sa_path_rec *path_rec)
>  {
>  	struct rdma_id_private *id_priv;
> +	struct sa_path_rec *in_path_rec;
> +	struct sa_path_rec opa;
>  	int ret;
>  
> +	if (rdma_cap_opa_ah(id->device, id->port_num)) {
> +		sa_convert_path_ib_to_opa(&opa, path_rec);
> +		in_path_rec = &opa;
> +	} else {
> +		in_path_rec = path_rec;
> +	}
> +
>  	id_priv = container_of(id, struct rdma_id_private, id);
>  	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
>  			   RDMA_CM_ROUTE_RESOLVED))
>  		return -EINVAL;
>  
> -	id->route.path_rec = kmemdup(path_rec, sizeof(*path_rec),
> +	id->route.path_rec = kmemdup(in_path_rec, sizeof(*in_path_rec),
>  				     GFP_KERNEL);
>  	if (!id->route.path_rec) {
>  		ret = -ENOMEM;
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 6d32af27bac6..7b25226b608e 100644
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1227,14 +1227,7 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
>  	sa_path.rec_type = SA_PATH_REC_TYPE_IB;
>  	ib_sa_unpack_path(path_data->path_rec, &sa_path);
>  
> -	if (rdma_cap_opa_ah(ctx->cm_id->device, ctx->cm_id->port_num)) {
> -		struct sa_path_rec opa;
> -
> -		sa_convert_path_ib_to_opa(&opa, &sa_path);
> -		ret = rdma_set_ib_path(ctx->cm_id, &opa);
> -	} else {
> -		ret = rdma_set_ib_path(ctx->cm_id, &sa_path);
> -	}
> +	ret = rdma_set_ib_path(ctx->cm_id, &sa_path);


No, this is not right

sa_convert_path_ib_to_opa is misnamed and the usage here is arguably
misplaced.

It is converting the internal OPA path record into a compability path
record. The ONLY place a compatability path record should be used is
at the uapi boundary when copying to userspace.

It is certainly not the right direction to have the core APIs
degrade the path record.

If anything should be fixed here, it is to move the degradation closer
to the actual copy_to_user.

Why was it put here anyhow? I don't see a uapi boundary?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
