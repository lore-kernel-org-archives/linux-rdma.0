From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: Suppress memory allocations warnings in
 kmalloc->__vmalloc flows
Date: Thu, 24 Dec 2015 00:22:23 -0500
Message-ID: <567B810F.2090702@redhat.com>
References: <1450337513-22609-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TkHKmgjLsKNvrNRFUd1E1i86m8JSwPM9s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450337513-22609-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TkHKmgjLsKNvrNRFUd1E1i86m8JSwPM9s
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/17/2015 02:31 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Failure in kmalloc memory allocations will throw a warning about it.
> Such warnings are not needed anymore, since in commit 0ef2f05c7e02
> ("IB/mlx4: Use vmalloc for WR buffers when needed"), fallback mechanism=

> from kmalloc() to __vmalloc() was added.
>=20
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c  | 6 ++++--
>  drivers/infiniband/hw/mlx4/srq.c | 3 ++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
> index 13eaaf45288f..dc86975fe1a9 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -796,11 +796,13 @@ static int create_qp_common(struct mlx4_ib_dev *d=
ev, struct ib_pd *pd,
>  		if (err)
>  			goto err_mtt;
> =20
> -		qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp);
> +		qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64),
> +					gfp | __GFP_NOWARN);
>  		if (!qp->sq.wrid)
>  			qp->sq.wrid =3D __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
>  						gfp, PAGE_KERNEL);
> -		qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(u64), gfp);
> +		qp->rq.wrid =3D kmalloc(qp->rq.wqe_cnt * sizeof(u64),
> +					gfp | __GFP_NOWARN);
>  		if (!qp->rq.wrid)
>  			qp->rq.wrid =3D __vmalloc(qp->rq.wqe_cnt * sizeof(u64),
>  						gfp, PAGE_KERNEL);
> diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/m=
lx4/srq.c
> index 8d133c40fa0e..f416c7463827 100644
> --- a/drivers/infiniband/hw/mlx4/srq.c
> +++ b/drivers/infiniband/hw/mlx4/srq.c
> @@ -171,7 +171,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,=

>  		if (err)
>  			goto err_mtt;
> =20
> -		srq->wrid =3D kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
> +		srq->wrid =3D kmalloc(srq->msrq.max * sizeof(u64),
> +					GFP_KERNEL | __GFP_NOWARN);
>  		if (!srq->wrid) {
>  			srq->wrid =3D __vmalloc(srq->msrq.max * sizeof(u64),
>  					      GFP_KERNEL, PAGE_KERNEL);
>=20

Applied with some edits to the commit message, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TkHKmgjLsKNvrNRFUd1E1i86m8JSwPM9s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe4EPAAoJELgmozMOVy/d628P/jgZbaI3BJSsmvcvSwc3Ghog
8Vp7rXr3eU8CyzOqhcpXQHH9WR6QZuMpEeU4YXH27kV51203e1KZycItL+V+3sbP
TVkjNJ1m9SWR+eSK2esVq4FHPSqrY0jN4MjlIRQgSJujX+jWBwiLgi4ZfS6U1sug
je4c8ipn4yse7PejMWPSMTNsQCiDRb5krLIfJknh8cYXD5qQSYpLJt9bQ6rMlWNg
jxLbQNmVA2eOl/RHFBvcSrNa+StiCPC7Ypco56blcCfiMELhGxxmGit5pCVIOHir
FTbMrw9ez/jksAVFXu3lfPsKsIpulpbUJTCt03Y86+Iq3Gm1DwWBAL9MRtSyagHa
bZzxtTFbw4tr26k8dNcllJpTzsqLcKsWgDD0R3uiyFcUoCrbJr/hIW5bYA5ULvr8
6osVeRtkuxi3Ef+J/nZiMQUbokg50SlaBIR/cTvpQUjNyMIEFyHrmV6CFJGs6SXc
trNNERMhhdgyHunI4lqwDvKnJ4nmT7ft5q/dpKwq4iafKa8dK9F0+7cuvbVmqPQR
eq/y2HDCsyZu1Fi10ziQWc/cuSuaQ8tBZkgagZOUQ4oHNda9On40unGWIpU/OnMu
LGgCnEijQSy21jtauO5v+ydipUiUWg2IONBe5r3RIDWgmnJA9+N1EI/VQiJmJrBp
3SgEIbvo8HV0aiCPAKhO
=10e3
-----END PGP SIGNATURE-----

--TkHKmgjLsKNvrNRFUd1E1i86m8JSwPM9s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
