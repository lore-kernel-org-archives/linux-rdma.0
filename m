From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/8] verbs: Annoate ibv_wc helpers with endian
Date: Thu, 13 Jul 2017 09:50:57 +0300
Message-ID: <20170713065057.GH1528@mtr-leonro.local>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NP12RPW2Q08TId7w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499894262-10761-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NP12RPW2Q08TId7w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2017 at 03:17:35PM -0600, Jason Gunthorpe wrote:
> This follows the scheme of used in the wc by introducing a
> ibv_wc_read_invalidated_rkey to access the host endian
> invalidated_rkey value with proper annotations.
>
> This is just an inline wrapper to allow sparse to work sensibly,
> not really a good reason to add another driver entry point.
>
> Fixes: 32186550 ("verbs: Add be annotations to public headers")
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libibverbs/man/ibv_create_cq_ex.3 |  5 ++++-
>  libibverbs/verbs.h                | 13 +++++++++++--
>  2 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_creat=
e_cq_ex.3
> index 7dfbef28d2413b..e943e0e266c582 100644
> --- a/libibverbs/man/ibv_create_cq_ex.3
> +++ b/libibverbs/man/ibv_create_cq_ex.3
> @@ -104,9 +104,12 @@ Below members and functions are used in order to pol=
l the current completion. Th
>  .BI "uint32_t ibv_wc_read_byte_len(struct ibv_cq_ex " "*cq"); \c
>   Get the vendor error from the current completion.
>
> -.BI "uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex " "*cq"); \c
> +.BI "__be32 ibv_wc_read_imm_data(struct ibv_cq_ex " "*cq"); \c
>   Get the immediate data field from the current completion.
>
> +.BI "uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex " "*cq"); \c
> + Get the rkey invalided by the SEND_INVAL from the current completion.
> +
>  .BI "uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex " "*cq"); \c
>   Get the QP number field from the current completion.
>
> diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
> index 4f0765e0476db8..997ef248b26b62 100644
> --- a/libibverbs/verbs.h
> +++ b/libibverbs/verbs.h
> @@ -1093,7 +1093,7 @@ struct ibv_cq_ex {
>  	enum ibv_wc_opcode (*read_opcode)(struct ibv_cq_ex *current);
>  	uint32_t (*read_vendor_err)(struct ibv_cq_ex *current);
>  	uint32_t (*read_byte_len)(struct ibv_cq_ex *current);
> -	uint32_t (*read_imm_data)(struct ibv_cq_ex *current);
> +	__be32 (*read_imm_data)(struct ibv_cq_ex *current);

The functions which use this function call are still uint32_t:
=E2=9E=9C  rdma-core git:(master) =E2=9C=97 grep mlx4_cq_read_wc_imm_data *=
 -rI
providers/mlx4/cq.c:static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_=
ex *ibcq)
providers/mlx4/cq.c:		cq->ibv_cq.read_imm_data =3D mlx4_cq_read_wc_imm_data;
=E2=9E=9C  rdma-core git:(master) =E2=9C=97 grep mlx5_cq_read_wc_imm_data *=
 -rI
providers/mlx5/cq.c:static inline uint32_t mlx5_cq_read_wc_imm_data(struct =
ibv_cq_ex *ibcq)
providers/mlx5/cq.c:		cq->ibv_cq.read_imm_data =3D mlx5_cq_read_wc_imm_data;

>  	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
>  	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
>  	int (*read_wc_flags)(struct ibv_cq_ex *current);
> @@ -1141,11 +1141,20 @@ static inline uint32_t ibv_wc_read_byte_len(struc=
t ibv_cq_ex *cq)
>  	return cq->read_byte_len(cq);
>  }
>
> -static inline uint32_t ibv_wc_read_imm_data(struct ibv_cq_ex *cq)
> +static inline __be32 ibv_wc_read_imm_data(struct ibv_cq_ex *cq)

Doesn't this change break user applications?

>  {
>  	return cq->read_imm_data(cq);
>  }
>
> +static inline uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex *cq)
> +{
> +#ifdef __CHECKER__
> +	return (__attribute__((force)) uint32_t)cq->read_imm_data(cq);
> +#else
> +	return cq->read_imm_data(cq);
> +#endif
> +}

I don't think that those __CHECKER__ ifdefs should be part of the code.
They are part of infrastructure to support development of library, but
are not required for the user of that library.

> +
>  static inline uint32_t ibv_wc_read_qp_num(struct ibv_cq_ex *cq)
>  {
>  	return cq->read_qp_num(cq);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NP12RPW2Q08TId7w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnGFEACgkQ5GN7iDZy
WKeADw/8DbK7WArqzIUMBfYRKG8ApXZ9yUOEPULlOUvRHOKqV8sduSLRHUuBoHsd
TnB0PX1+67Ztutrr1IvwvZylrSJLXypqPmHUZBpKyO9Tq9eCk1Mpu2ypyLr9dmls
D4XFGV+43VhRe1cVUIlX138OUZDWdJijB95uGdFyi0SwC/qLJhe/PQUiJwLM9hvf
7NXWMpB2BjvVCqIyJZ7fnN/7imOdhobkbXPMDZKj3/SftwhksvLm1aCoJqrtLJR+
YAszChK3HMTXiaNPlpoKjbRt8kKwmwiESTBtSCmvctw4miqknNbyrzsvUfDL2pRN
pdObMLb1hEJfwmKmj4k306w1KHVJxHq42SZUWEHjPgR9LgM1daCaynOIZHiEJazR
Me2s1G9/DrB4ry1MXakJEJ1edVzf8F3utlhwMo9MsBQ0VJk3YgDRICATV41g7C/R
B6VryYCcn7SheOGs6M6IkHQ1etYM2RVxrxW6JDxWPcmmb50dXn1mrINRC4lId1If
AjWN8ARmaGSB5yb2LS5mcEQxEYBxQmcuGPPk3SccJZ9wQ468yWfPEDRhIx/mrjF3
h33K8I7gy710YlvY9UP2rqT40oRyoVcv5+YPOGqOYsKiHPRn+qaufUAcP+89vdEQ
EAS5X6TwevIqCal5ek7DzX//k1BvBIdWV1uBnSuNefWFScjBFl8=
=jdXf
-----END PGP SIGNATURE-----

--NP12RPW2Q08TId7w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
