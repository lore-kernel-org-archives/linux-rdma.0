From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] i40iw: silence an uninitialized variable warning
Date: Tue, 24 Jan 2017 16:24:49 -0500
Message-ID: <1485293089.43764.76.camel@redhat.com>
References: <20170118103452.GA12778@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-X8yYiUXImVwfTsLxOagP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118103452.GA12778@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-X8yYiUXImVwfTsLxOagP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 13:34 +0300, Dan Carpenter wrote:
> These can be used without being uninitialized but it's only a
> printk()
> so it's not the end of the world.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c
> b/drivers/infiniband/hw/i40iw/i40iw_main.c
> index 2728af3..7b78a17 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_main.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
> @@ -561,7 +561,7 @@ static enum i40iw_status_code
> i40iw_create_cqp(struct i40iw_device *iwdev)
> =C2=A0	struct i40iw_sc_dev *dev =3D &iwdev->sc_dev;
> =C2=A0	struct i40iw_cqp_init_info cqp_init_info;
> =C2=A0	struct i40iw_cqp *cqp =3D &iwdev->cqp;
> -	u16 maj_err, min_err;
> +	u16 maj_err =3D 0, min_err =3D 0;
> =C2=A0	int i;
> =C2=A0
> =C2=A0	cqp->cqp_requests =3D kcalloc(sqsize, sizeof(*cqp-
> >cqp_requests), GFP_KERNEL);

Thanks for the patch, but I dropped this in in lieu of the patch to
make cqp_create always set both error codes.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-X8yYiUXImVwfTsLxOagP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8YhAAoJELgmozMOVy/dqIoP/1DGurmMHgdAJusfLX82MzfV
ItqSqiXtE7C5n0QQz87pKrQWZPIotVgE5sJvnmLfUD7FOPCdgqZmHMDeI755FM+B
gnD/rPt2y8brLaMg1H7hVirlAb7h+Jv+KLWImb/cbARAeKnEhtohQB6NqbIygFUi
1U+UAvWeOkA+VZcXt/yxltjcAKiZZsZg00gO1fRmYDsR2uWglJOEEeKZpJlOaFhc
5bcK2dJ1gu9/mNbMzRT3xMRR0fFdOJ+ftnMwq8sAamr/tvEh6SGkvzJPzQjenlfb
PSg9JyMzEhpZrY9lRjuy/nIkQV2QUKEqbLjOj2O4fP1otyaTeIhPZL/e+e0jIBeH
lBVfzMzN8DooQq2jIrlnSrSo7ei2UbhkioCIK1b30YV5lyYluj8uyPwmjg2iocj1
Kzb9l/E3K2jq/Fgvv+Xzinr9OgZH2om2bG6BAuwARC1h4Qyx/Kx87m2Ipw6+zwNc
eY556+dSkBvO8mBj446+n1O/KDClN0Xls+T87Qcqc0nDQiywkF1daLcIuvok27JS
/AK4esbaMOwUbAfbx2mgyfdvuHO2fi3Ig4u5/A4U5bVTc7c4N1ykVNYWUsZ1jWDz
2hs8J5duri5+ILbNukbivyFmMCtVTk7iawpDvjd3xuvWawNKIkTeghO8KGs1i/VV
VKBeh9Rx1LLaOoO3fFpj
=C/9s
-----END PGP SIGNATURE-----

--=-X8yYiUXImVwfTsLxOagP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
