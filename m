From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA READ
Date: Sun, 24 Apr 2016 10:35:10 +0300
Message-ID: <20160424073510.GC7974@leon.nu>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1461352469-16504-6-git-send-email-tatyana.e.nikolova@intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461352469-16504-6-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 22, 2016 at 02:14:27PM -0500, Tatyana Nikolova wrote:
> From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> A check is added to validate the requested sge number.
> iWARP doesn't support multiple sg elements for
> RDMA READ work requests.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniba=
nd/hw/i40iw/i40iw_verbs.c
> index 2d832c7..45f70f5 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> @@ -74,7 +74,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
>  	props->max_cqe =3D iwdev->max_cqe;
>  	props->max_mr =3D iwdev->max_mr;
>  	props->max_pd =3D iwdev->max_pd;
> -	props->max_sge_rd =3D 1;
> +	props->max_sge_rd =3D I40IW_MAX_SGE_RD;
>  	props->max_qp_rd_atom =3D I40IW_MAX_IRD_SIZE;
>  	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
>  	props->atomic_cap =3D IB_ATOMIC_NONE;
> @@ -2117,6 +2117,10 @@ static int i40iw_post_send(struct ib_qp *ibqp,
>  			inv_stag =3D true;
>  			/* fall-through*/
                        ^^^^^^^^^^^^^^^^
Do you support multiple SGE for RDMA WRITE?


>  		case IB_WR_RDMA_READ:
> +			if (ib_wr->num_sge > I40IW_MAX_SGE_RD) {
> +				err =3D -EINVAL;
> +				break;
> +			}
>  			info.op_type =3D I40IW_OP_TYPE_RDMA_READ;
>  			info.op.rdma_read.rem_addr.tag_off =3D rdma_wr(ib_wr)->remote_addr;
>  			info.op.rdma_read.rem_addr.stag =3D rdma_wr(ib_wr)->rkey;
> --=20
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXHHcuAAoJEORje4g2clinTVAP/j1mXpNqHzF502Zxr/SzqbUX
gFyZTVGCG8/PPpAl7rY/u6jlnhUxQVzBzhwq29lyJ4XKcVMPH00cok/OYT7J9LlJ
4p6N6Y9D9D9NH6jXjYclKDh4eX7FDaABi74Ogb41TRFgiUkuCBul8sbw4XT9HXVj
neF04DXy5X+c97fLgfww1ajg+n/DT3++ZuB1rb4IchQGhXCmp/Pc9cYt5idUGsLI
bKdSf/l/cSvcZj9oVD71hnBYzFN7X4srEfBXEEZTeGqLxE29hOtCmkYLYkYNTul8
gY3Gl0Pqt4eaaVQmurDtTh4vrnpxP789piP0JQB7Lf4v8jRYXBuaJeB8peHTD4Rl
d/npDq7I4pUVfFvWPrdmd4wHvolH6Tdm/uKGMaIR+VvqXXLNkLrSHJpjJI+feLwn
lpuN6JhWrh5gb4FS0SkKVaLsdknfRnxPVCAAMbrYuyza2Ab1DjxL+Mt3nRwUIDNP
xrGyO7NHSZuw0OZhaNYvNM+EnZFglzSh01O98+9mG37Eiq3T6ptQWQj/v88Xs0vz
WbIDxuQQdngWRnREuwftfw5FUebhPm+8p/cYsIy4yOAxEUW6ZFUC++ljrzCWECG+
9e0umjuXHLM5vRIKnrOQvdgokm/y24gkHv5n1gy5xX/vZOcRKEh7S8/yOF4TEed6
6XUkfrbaY2gwJAEG0AhH
=N+yV
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
