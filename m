From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too many
 SGEs
Date: Thu, 28 Jul 2016 08:22:46 +0300
Message-ID: <20160728052246.GM4628@leon.nu>
References: <20160727193718.29482.73416.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W4pDZ/VvazBYHhxQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727193718.29482.73416.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--W4pDZ/VvazBYHhxQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 03:38:36PM -0400, Chuck Lever wrote:
> Other similar functions (mlx5_ib_post_recv being the closest)
> return EINVAL in this case.
>=20
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks Chuck,
You are absolutely right, it should be EINVAL error.
Do you mind if I submit it by myself together with other mlx5 fixes?

Looks ok, except title :)
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
> Hi Matan, Leon-
>=20
> I noticed this nit while debugging a problem in xprtrdma.
>=20
>  drivers/infiniband/hw/mlx5/qp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5=
/qp.c
> index ce0a7ab..b0e5498 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3436,7 +3436,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib=
_send_wr *wr,
>  		num_sge =3D wr->num_sge;
>  		if (unlikely(num_sge > qp->sq.max_gs)) {
>  			mlx5_ib_warn(dev, "\n");
> -			err =3D -ENOMEM;
> +			err =3D -EINVAL;
>  			*bad_wr =3D wr;
>  			goto out;
>  		}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--W4pDZ/VvazBYHhxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmZamAAoJEORje4g2clinHyYQAILH9jVmCyyF4pVRw9wZkPIO
rIw4BYDCUhDhZnJRlI1Wv6LISAWetrJtxsTrdUTBgeF2EP0ItPttmWXxNppqs7Yp
zjtHcZlI5/xUZjix0RmKSmHCvIe/QisPM6ofwRK1X+b6FiEgSajb1aH1ggfTDHIf
M5ryckgv8opqg3tk5tJYw03ChDe8JjDxGFfv7wuT7davPFIjA4AuPDR6IltvHHzL
hhPPE3BHAPEKhW86Trq5LGCk0WmHn0knXthkNybOf7wDU4G2XqyyPBMdokF74QfT
iGzfHB151LJvtPCkVp+65tqYiGW+5wpwH8lN9yCKbvEAKsBKtEXN/FpAigHwR4Qd
ZDQFkbSBN4N6HdR7qDhk3IrbXMYaFsvjL7NHb0ZYMo4/Kvt+AWoBx3mc11LU0fWt
GEaJmo43YWUijpIN3SQu8ac6Ar2Y9FrfUmWH60i04lGU4k9aPq8Pi6PMkgoqKtyf
aXHtEs8aJXFXlD1om6zqw+WmXCZxbw9bCJGWh91y2ybL+h5QLjQEGsEXrrMaB7IS
nE8o/4A7+gJvTKrCjIAki+SIdfYatot27FVABTedhEAxMahJLH1OMrjJ7q8swy67
VCabr42dlNcekNKT95J6Cz9qpxl3u7APFnKEEps/i8mhxUvjyx5XSdtNXrHQ0JvA
yY288kPIYd/4I9vQ9wqO
=rIRR
-----END PGP SIGNATURE-----

--W4pDZ/VvazBYHhxQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
