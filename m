From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Correct values for max_recv_sge, max_send_sge
Date: Thu, 10 Nov 2016 18:47:54 +0200
Message-ID: <20161110164754.GF28957@leon.nu>
References: <20161110032639.7460-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161110032639.7460-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 09, 2016 at 09:26:39PM -0600, Henry Orosco wrote:
> When creating QPs, ensure init_attr->cap.max_recv_sge
> is clipped to MAX_FRAG_COUNT.
>
> Expose MAX_FRAG_COUNT for max_recv_sge and max_send_sge in
> i40iw_query_qp().
>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> index 6329c97..d06fe593 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> @@ -610,6 +610,9 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
>  	if (init_attr->cap.max_send_sge > I40IW_MAX_WQ_FRAGMENT_COUNT)
>  		init_attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
>
> +	if (init_attr->cap.max_recv_sge > I40IW_MAX_WQ_FRAGMENT_COUNT)
> +		init_attr->cap.max_recv_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
> +

Just personal preference,
init_attr->cap.max_recv_sge = min(init_attr->cap.max_recv_sge, I40IW_MAX_WQ_FRAGMENT_COUNT);

Looks good,
Reviewed-By: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>  	memset(&init_info, 0, sizeof(init_info));
>
>  	sq_size = init_attr->cap.max_send_wr;
> @@ -815,8 +818,9 @@ static int i40iw_query_qp(struct ib_qp *ibqp,
>  	attr->qp_access_flags = 0;
>  	attr->cap.max_send_wr = qp->qp_uk.sq_size;
>  	attr->cap.max_recv_wr = qp->qp_uk.rq_size;
> -	attr->cap.max_recv_sge = 1;
>  	attr->cap.max_inline_data = I40IW_MAX_INLINE_DATA_SIZE;
> +	attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
> +	attr->cap.max_recv_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
>  	init_attr->event_handler = iwqp->ibqp.event_handler;
>  	init_attr->qp_context = iwqp->ibqp.qp_context;
>  	init_attr->send_cq = iwqp->ibqp.send_cq;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJKS6AAoJEORje4g2clinlrYQAKgoD1t1XgufBdrWqB9PCHds
vDuSqsORz0iJZtDn2Qc02uQKLMS0JojhoS/afvMPaeKGSRv8s9MZ4gRjNdG4jC/6
0PvE7mscUVM9Jpceeq/b7/fcfP1Cd4Jp3xJjTuaDPVl9As+v4yJ0FR3EVYxNE1U9
FysR2/qC/cwlnkObP0K/m2MTPHYP37ozUnCkinf30wic1N0m9yb1TTlSn4/1E8B4
BwjiYepAmaSz5f9bXN4kJblGrVAK3a1JP0N2SNqyDZ9AydFVD1hFqsje1UIbmYyT
Thzi/vjMaB174LSMxz3nal5cMf57YgZpuXR0oQAymsYs4Ynmxfa7jjIe8PWhSqd8
PwKXkMBhxT4YkzdOPtICpSNASS+AB6uksVFrxRGCSCv98FV1AtTIaWdW6HJeaYv3
M7bWHUIMechnuv+XKWgFv6QB9R/yKWQXfuq5TKwW00F+fHa+gQpWcVFWFohHfHgI
WyEiIeoXgKT92JaG7Dg9oHlY+m1GjnFxXFKyaDh+a+sRMGOb5pzaXy9zR2Xb4Az9
n+PUAdCnyzQ0k22/uwJqjvSYSYzXvSwyQ8MkZNkpD6GJF2oMmQZyUWjcIzFDsdeP
DxoYoc1Sd7WbF/gMOqe/M1RCeiphQyOirdRXWRItxIIugKBnd8F2sQuXLuuoKLps
NaVLk0VSmwfMEZ1YTwX7
=2And
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
