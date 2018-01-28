From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 6/8] RDMA/core: Add resource tracking for
 create and destroy PDs
Date: Sun, 28 Jan 2018 13:48:58 -0700
Message-ID: <20180128204858.GI23869@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128091725.13103-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128091725.13103-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 11:17:23AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Track create and destroy operations of PD objects.
> 
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>  drivers/infiniband/core/uverbs_cmd.c | 2 ++
>  drivers/infiniband/core/verbs.c      | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 3e95acd29de7..256934d1f64f 100644
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -340,6 +340,8 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
>  	uobj->object = pd;
>  	memset(&resp, 0, sizeof resp);
>  	resp.pd_handle = uobj->id;
> +	pd->res.type = RDMA_RESTRACK_PD;
> +	rdma_restrack_add(&pd->res);

This pattern happens a lot, any reason not to add type to the
signature of rdma_restrack_add ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
