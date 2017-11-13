From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 4/5] mlx5: Add support for ibv_parent
 domain and its related verbs
Date: Mon, 13 Nov 2017 13:03:20 -0700
Message-ID: <20171113200320.GE22610@ziepe.ca>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-5-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510522903-6838-5-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 12, 2017 at 11:41:42PM +0200, Yishai Hadas wrote:

> @@ -319,6 +319,9 @@ struct mlx5_buf {
>  struct mlx5_pd {
>  	struct ibv_pd			ibv_pd;
>  	uint32_t			pdn;
> +	int 				is_parent_domain;
> +	struct ibv_td			*td;
> +	struct ibv_pd			*protection_domain;

is_parent_domain can just be protection_domain != NULL

> +struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
> +			struct ibv_parent_domain_init_attr *attr)
> +{
> +	struct mlx5_pd	*pd;
> +
> +	pd = calloc(1, sizeof *pd);
> +	if (!pd)
> +		return NULL;
> +
> +	pd->is_parent_domain = 1;
> +	pd->td = attr->td;
> +	pd->protection_domain= attr->pd;

Don't we need some kind of ref counting here?

What is the intention for the final version of this patch?

Are you going to do
  pd->ibv_pd = *attr->pd;

During create?

Or change every call site very roughly like like..

inline struct mlx5_pd *resolve_pd(struct ibv_pd *pd)
{
   if (pd->protection_domain)
      return pd->protection_domain;
   return pd;
}

mlx5_foo(struct ibv_pd *arg_pd)
{
    struct mlx5_pd *pd = resolve_pd(arg_pd);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
