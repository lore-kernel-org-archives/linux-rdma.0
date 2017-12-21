From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Remove comp_mask checks from verbs.h
Date: Thu, 21 Dec 2017 07:42:16 +0200
Message-ID: <20171221054216.GF2942@mtr-leonro.local>
References: <20171220231350.GA19130@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oAjj1ZwgLg4oRN9q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220231350.GA19130-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oAjj1ZwgLg4oRN9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 04:13:50PM -0700, Jason Gunthorpe wrote:
> In the case of ibv_create_cq_ex this duplicates a check already done
> by ibv_cmd_create_cq_ex.
>

Yes and no.

Yes, the analysis is right and it is should be fixed.
No, the ibv_cmd_create_cq_ex check is performed after we entered into
vctx->create_cq_ex(context, cq_attr) callback, which is translated into
mlx4_create_cq_ex and mlx5_create_cq_ex.

Both these functions are performing their checks of cq_attr->comp_mask,
but return different errno. I think that it is perfect timing to start
organize and unite our return errors. They should return the same errno.

mlx4:
470         if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
471                 errno = ENOTSUP;
472                 return NULL;
473         }
474
475         if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
476             cq_attr->flags & ~CREATE_CQ_SUPPORTED_FLAGS) {
477                 errno = ENOTSUP;
478                 return NULL;
479         }

mlx5:
365         if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
366                 mlx5_dbg(fp, MLX5_DBG_CQ,
367                          "Unsupported comp_mask for create_cq\n");
368                 errno = EINVAL;
369                 return NULL;
370         }

> In the case of ibv_queryrt_values_ex, there is no check in the function
> op, which is an ABI mistake. So move the check there.

ibv_queryrt_values_ex -> ibv_query_rt_values_ex

>
> comp_mask should never be tested in the inline trampolines to generate
> EINVAL as the inlines are part of the app and could be from a future
> libibverbs with an expanded comp_mask.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/verbs.h     | 8 --------
>  providers/mlx4/verbs.c | 3 +++
>  providers/mlx5/verbs.c | 3 +++
>  3 files changed, 6 insertions(+), 8 deletions(-)
>
> I missed these when reviewing the earlier patches, and now people are
> cargo-cult copying them into new APIs.
>
> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> index 775bad52601781..7b53a6f5dff51f 100644
> --- a/libibverbs/verbs.h
> +++ b/libibverbs/verbs.h
> @@ -1967,11 +1967,6 @@ struct ibv_cq_ex *ibv_create_cq_ex(struct ibv_context *context,
>  		return NULL;
>  	}
>
> -	if (cq_attr->comp_mask & ~(IBV_CQ_INIT_ATTR_MASK_RESERVED - 1)) {
> -		errno = EINVAL;
> -		return NULL;
> -	}
> -
>  	return vctx->create_cq_ex(context, cq_attr);
>  }
>
> @@ -2200,9 +2195,6 @@ ibv_query_rt_values_ex(struct ibv_context *context,
>  	if (!vctx)
>  		return ENOSYS;
>
> -	if (values->comp_mask & ~(IBV_VALUES_MASK_RESERVED - 1))
> -		return EINVAL;
> -
>  	return vctx->query_rt_values(context, values);
>  }
>
> diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
> index ec02bd4642b2d2..0a4ed1fde001eb 100644
> --- a/providers/mlx4/verbs.c
> +++ b/providers/mlx4/verbs.c
> @@ -135,6 +135,9 @@ int mlx4_query_rt_values(struct ibv_context *context,
>  	uint32_t comp_mask = 0;
>  	int err = 0;
>
> +	if (!check_comp_mask(values->comp_mask, IBV_VALUES_MASK_RAW_CLOCK))
> +		return EINVAL;
> +
>  	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
>  		uint64_t cycles;
>
> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
> index a3323fd47651a7..579c0f3402d54d 100644
> --- a/providers/mlx5/verbs.c
> +++ b/providers/mlx5/verbs.c
> @@ -108,6 +108,9 @@ int mlx5_query_rt_values(struct ibv_context *context,
>  	uint32_t comp_mask = 0;
>  	int err = 0;
>
> +	if (!check_comp_mask(values->comp_mask, IBV_VALUES_MASK_RAW_CLOCK))
> +		return EINVAL;
> +
>  	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
>  		uint64_t cycles;
>
> --
> 2.15.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oAjj1ZwgLg4oRN9q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo7SbgACgkQ5GN7iDZy
WKeezBAAk3WYRjzMY/hlGYAGE6JMacBXwNTVT7ZqO7YegqJiwU4CGGdrfmjgrT16
UI/zEB5nEeuC4WHVBGe1aUlDJtwuCv1GvuGrqi0Qfeg5fir/32LDsyi7X+e8PDbo
eresU3JZ2flLjSNpp0WaGpARA1b4RArXq8PpSFHRK2RX35sMM4ID0JW5AEUnDMCB
JkS7fVGyVxOVvv5E9bJ2e/0TGnorelwZLJh4YqlLPTkSW+5SACWZzNauGQCRCZae
HSCXTN+nrxhFnhJPUE694H4xl3BVyd8nus814CwesMU1UZkrVTjKNQquAeD/ruew
8UpVZwCLUb3zonQLGR5InUqj/deuDH1bocRQ+5vlLc+oZVqgUcEo5yP+sEYTsPt5
Gk+kWxS2BeMZvbJ3oB5VQVcSJDbgl/4pOJuO8ArGA9Poj85nByOsU5sSwskK+ak9
NpJrj1tgq8W+Ffr5HZ3TLfHtOLUXQioH4OBehG6DgXU7Y6NgahYA0SgsukhLdlml
NZY7Aq2z6AGxaRb3a+H8HCE76KfO9V6zb3ZEPxmkTkWUkmq1cmhOzmuG+FgI5rlw
4NoptAxLZj2+agzL35dz+4XxUpzmEKGKjAz1UVZlLgpOApX7KawPdCeXUdx498DG
6quo2xIDwsPPzYTYyKV+TgVm7P//raSYv2EgfM7pxjxRJVYX6/Y=
=lNVf
-----END PGP SIGNATURE-----

--oAjj1ZwgLg4oRN9q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
