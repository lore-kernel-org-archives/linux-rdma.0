From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx4] Add MR re-registeration
Date: Sun, 02 Nov 2014 14:35:58 +0200
Message-ID: <5456252E.4000605@dev.mellanox.co.il>
References: <1414920625-20479-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414920625-20479-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/2/2014 11:30 AM, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add memory re-registeration to libmlx4.
>
> Memory re-registeration is a feature that enables one to change
> the attributes of a memory region, including PD, translation
> (address and length) and access flags.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   src/mlx4.c  |    1 +
>   src/mlx4.h  |    2 ++
>   src/verbs.c |   15 +++++++++++++++
>   3 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/src/mlx4.c b/src/mlx4.c
> index 2999150..115fc9c 100644
> --- a/src/mlx4.c
> +++ b/src/mlx4.c
> @@ -92,6 +92,7 @@ static struct ibv_context_ops mlx4_ctx_ops = {
>   	.alloc_pd      = mlx4_alloc_pd,
>   	.dealloc_pd    = mlx4_free_pd,
>   	.reg_mr	       = mlx4_reg_mr,
> +	.rereg_mr      = mlx4_rereg_mr,
>   	.dereg_mr      = mlx4_dereg_mr,
>   	.create_cq     = mlx4_create_cq,
>   	.poll_cq       = mlx4_poll_cq,
> diff --git a/src/mlx4.h b/src/mlx4.h
> index d71450f..ccb363a 100644
> --- a/src/mlx4.h
> +++ b/src/mlx4.h
> @@ -363,6 +363,8 @@ int mlx4_close_xrcd(struct ibv_xrcd *xrcd);
>
>   struct ibv_mr *mlx4_reg_mr(struct ibv_pd *pd, void *addr,
>   			    size_t length, int access);
> +int mlx4_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
> +		  void *addr, size_t length, uint64_t access);
>   int mlx4_dereg_mr(struct ibv_mr *mr);
>
>   struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
> diff --git a/src/verbs.c b/src/verbs.c
> index 623d576..db97303 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -166,6 +166,21 @@ struct ibv_mr *mlx4_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
>   	return mr;
>   }
>
> +int mlx4_rereg_mr(struct ibv_mr *mr,
> +		  int flags,
> +		  struct ibv_pd *pd, void *addr,
> +		  size_t length, uint64_t access)
> +{
> +	struct ibv_rereg_mr cmd;
> +	struct ibv_rereg_mr_resp resp;
> +
> +	return ibv_cmd_rereg_mr(mr, flags, addr, length,
> +				(uintptr_t) addr,
> +				access, pd,
> +				&cmd, sizeof(cmd),
> +				&resp, sizeof(resp));
> +}
> +
>   int mlx4_dereg_mr(struct ibv_mr *mr)
>   {
>   	int ret;
>

This looks fine to me.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
