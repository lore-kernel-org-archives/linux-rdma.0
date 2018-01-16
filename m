From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v4 3/7] RDMA: Annotate create QP callers
Date: Tue, 16 Jan 2018 17:03:56 -0600
Message-ID: <017301d38f1e$497ce8b0$dc76ba10$@opengridcomputing.com>
References: <20180115151255.30167-1-leon@kernel.org> <20180115151255.30167-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115151255.30167-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Update all callers to provide owner name through QP attribute
> structure and connect create_qp with helper which supports
> resource tracking.
> 
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c              | 1 +
>  drivers/infiniband/core/mad.c              | 1 +
>  drivers/infiniband/core/uverbs_cmd.c       | 3 +--
>  drivers/infiniband/core/verbs.c            | 4 ++--
>  drivers/infiniband/hw/mlx4/mad.c           | 1 +
>  drivers/infiniband/hw/mlx4/qp.c            | 1 +
>  drivers/infiniband/hw/mlx5/gsi.c           | 2 ++
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c    | 4 +++-
>  drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 1 +
>  drivers/infiniband/ulp/srp/ib_srp.c        | 1 +
>  drivers/infiniband/ulp/srpt/ib_srpt.c      | 1 +
>  net/smc/smc_ib.c                           | 1 +
>  12 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 30d1c32a816f..3810716ea65e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -858,6 +858,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct
> ib_pd *pd,
>  		return -EINVAL;
> 
>  	qp_init_attr->port_num = id->port_num;
> +	strncpy(qp_init_attr->comm, "rdma-cm", TASK_COMM_LEN);


I think the above strncpy should be done only if the caller of
rdma_create_qp() didn't fill in qp_init_attr->comm.  IE if the caller ULP
fills it out, we want to see it.  Otherwise all kernel ULPs end up being
"rdma-cm"...

Stevo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
