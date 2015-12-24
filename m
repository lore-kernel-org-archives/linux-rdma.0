From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx4: Convert kmalloc to be kmalloc_array to fix
 checkpatch warnings
Date: Thu, 24 Dec 2015 00:22:39 -0500
Message-ID: <567B811F.2050006@redhat.com>
References: <1450337513-22609-1-git-send-email-leon@leon.nu>
 <1450337513-22609-2-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cHQlmTD1ex2oTN6238tsf5OverASTpkUL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450337513-22609-2-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cHQlmTD1ex2oTN6238tsf5OverASTpkUL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/17/2015 02:31 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Convert kmalloc to be kmalloc_array to fix warnings below:
>=20
> WARNING: Prefer kmalloc_array over kmalloc with multiply
> +               qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64),
>=20
> WARNING: Prefer kmalloc_array over kmalloc with multiply
> +               qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(u64),
>=20
> WARNING: Prefer kmalloc_array over kmalloc with multiply
> +               srq->wrid =3D kmalloc(srq->msrq.max * sizeof(u64),
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c  | 4 ++--
>  drivers/infiniband/hw/mlx4/srq.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
> index dc86975fe1a9..70de13ed9da7 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -796,12 +796,12 @@ static int create_qp_common(struct mlx4_ib_dev *d=
ev, struct ib_pd *pd,
>  		if (err)
>  			goto err_mtt;
> =20
> -		qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64),
> +		qp->sq.wrid =3D kmalloc_array(qp->sq.wqe_cnt, sizeof(u64),
>  					gfp | __GFP_NOWARN);
>  		if (!qp->sq.wrid)
>  			qp->sq.wrid =3D __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
>  						gfp, PAGE_KERNEL);
> -		qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(u64),
> +		qp->rq.wrid =3D kmalloc_array(qp->rq.wqe_cnt, sizeof(u64),
>  					gfp | __GFP_NOWARN);
>  		if (!qp->rq.wrid)
>  			qp->rq.wrid =3D __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
> diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/m=
lx4/srq.c
> index f416c7463827..68d5a5fda271 100644
> --- a/drivers/infiniband/hw/mlx4/srq.c
> +++ b/drivers/infiniband/hw/mlx4/srq.c
> @@ -171,7 +171,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,=

>  		if (err)
>  			goto err_mtt;
> =20
> -		srq->wrid =3D kmalloc(srq->msrq.max * sizeof(u64),
> +		srq->wrid =3D kmalloc_array(srq->msrq.max, sizeof(u64),
>  					GFP_KERNEL | __GFP_NOWARN);
>  		if (!srq->wrid) {
>  			srq->wrid =3D __vmalloc(srq->msrq.max * sizeof(u64),
>=20

Applied with some edits to the commit message, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cHQlmTD1ex2oTN6238tsf5OverASTpkUL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe4EfAAoJELgmozMOVy/drUYP/AzDdzjDVY8s0sMqoMUoludz
QauYRLY3uM6vFw3JVQR42RklPOpBttULNamGdce8spjm7K86y5+TI9DwxqYlNRbX
gQdclgb21pA+7JYEUt0jsHdhmzbPNYNBjidYdEWhQ6jhRTzdgVocvaH9G+9leQv8
W0awlfEp6ZiIbgZJWKcGk3WNvMklOqDcUg96dLY0/Q2TMuNgJ6dzNyvEQ1tiL+0E
uO6/fFGuWHhi5do7HWUrQKvVLNlb/0CtuERX0r/Rj0kdzhwxqrsAlFiqyWSq6mgR
ZJd614KHMyvXTbJF+N+ZrfZ2AcJXOsnSKYvILSXiuRRkpUtjnz9m4GzS4IXB8/Yf
jpzfV6aq7EK8GGANLyYknzhClkdCFTvK8UyYXVF6WJsH+2sB+Nl+eXKpvqK9iEpg
P5HlSYtcISXg1BjJM3slWhsdpHzplxnItqBT1rhaTb0/9B2DT1RuFB8PwcSjFBBT
3TNjCr/6C5xLVQEj3bJmrA+kGURn7YJK0E2uCy8w6vApEYUf/HFE7PBv7Ph+eMhk
us4UJct8r5AfW2NQ9G8HQnKx+yG6zhsF2/ReLJnPoXmAxmq44qZUUFlNW0Yqpe+0
mhN6kidlStk6CwUd+VumvVbddoOqG8VX5iqUtbUezWqPt2n1iA8BUVK/wwXQBwU7
j1iHxZCn94wzDnYExzDJ
=xgZz
-----END PGP SIGNATURE-----

--cHQlmTD1ex2oTN6238tsf5OverASTpkUL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
