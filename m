From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
Date: Wed, 27 Jul 2016 14:39:40 +0300
Message-ID: <20160727113940.GH4628@leon.nu>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
 <1469607893-10657-2-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469607893-10657-2-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 01:24:52AM -0700, Yuval Shaia wrote:
> No need to return int if function always returns 0
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cq.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4=
/cq.c
> index 9f8b516..4c2e1b0 100644
> --- a/drivers/infiniband/hw/mlx4/cq.c
> +++ b/drivers/infiniband/hw/mlx4/cq.c
> @@ -576,8 +576,8 @@ static int mlx4_ib_ipoib_csum_ok(__be16 status, __be1=
6 checksum)
>  		checksum =3D=3D cpu_to_be16(0xffff);
>  }
> =20
> -static int use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq,=
 struct ib_wc *wc,
> -			   unsigned tail, struct mlx4_cqe *cqe, int is_eth)
> +static void use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq=
, struct ib_wc *wc,
> +			    unsigned tail, struct mlx4_cqe *cqe, int is_eth)
>  {
>  	struct mlx4_ib_proxy_sqp_hdr *hdr;
> =20
> @@ -600,8 +600,6 @@ static int use_tunnel_data(struct mlx4_ib_qp *qp, str=
uct mlx4_ib_cq *cq, struct
>  		wc->slid        =3D be16_to_cpu(hdr->tun.slid_mac_47_32);
>  		wc->sl          =3D (u8) (be16_to_cpu(hdr->tun.sl_vid) >> 12);
>  	}
> -
> -	return 0;
>  }
> =20
>  static void mlx4_ib_qp_sw_comp(struct mlx4_ib_qp *qp, int num_entries,
> @@ -853,8 +851,9 @@ repoll:
>  			if ((*cur_qp)->mlx4_ib_qp_type &
>  			    (MLX4_IB_QPT_PROXY_SMI_OWNER |
>  			     MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
> -				return use_tunnel_data(*cur_qp, cq, wc, tail,
> -						       cqe, is_eth);
> +				use_tunnel_data(*cur_qp, cq, wc, tail, cqe,
> +						is_eth);
> +				return 0;

Yeah, kbuild spotted excellent point.
It should be guarded by {}

return X -> { X; return 0; }

>  		}
> =20
>  		wc->slid	   =3D be16_to_cpu(cqe->rlid);
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmJ18AAoJEORje4g2clin5GkQAJbZcwxpiThDXrrDmdhvAz8S
wbxOK15BY7RTUW3QCA0yqMxoYnVBH9OgrboFrMDMNxz7YXfktkC4MYT7/17Ytjmi
0vMF3Do7wWNgW5EqDtbDAyB1IHm1ztRN2Ca5g7J2cnSVL6xJgBBRoRqhWbsMEZpV
bXT71/EInMBLAc67anb5MOis7rXQiTjwC8snvxIH4utDgueXmB/U7rRJp60Slz/9
VOJlMC7g7GBuTlw7Rnzm6FgS+wok8hmkFkqVx/IE20Lv2n4Mh4QXCnNEkWx/h+8Q
RzoI6JznON/NKgBAAsL4rUsUxCRVQ8eK+J6Bp+RNoc5y740a4DfJhlmjkbCRUuFS
nbP1zgYDQRXWXXXngCpx+N9STDoSgJMXtdzFxNnlO6c0uriM7lv2ef7Z4wPyUnXp
tb3p/xa/DMlJT6CRS6bC0QMShMOuf6B8ARMT4J6mdwgIWmptx6Zart7Gnpd30GXB
fV8QDJSUrYSDDxiknE21mqFfO5uexT4n/PzCmZsr5w1rDRHlh0bcVqx86m1kKZkx
kgC2Ltl5SHuWZOOUiLxSaq5TZx8qRbS2p9m1FswmPqJkedWsngQIYdtjrlqb1l06
audSr/nm1i7FxITBhgK/SrlpCymzFTlou6xHvwMI2UJrd4bYdPcYamCubYttwV/j
7o3LUrLUqv8mOBTy9syo
=G5wK
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
