From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] IB/rxe: fix error code in rxe_srq_from_init()
Date: Mon, 13 Jun 2016 16:20:30 +0300
Message-ID: <20160613132030.GK5408@leon.nu>
References: <20160613065341.GA5993@mwanda>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160613065341.GA5993@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 13, 2016 at 09:53:41AM +0300, Dan Carpenter wrote:
> If copy_to_user() fails then it returns the number of bytes not copied.
> It would be between 1-4 here.  Later the callers dereference it leading
> to an Oops.
>=20
> It was sort of hard to fix this without making the code confusing so I
> did a little cleanup.
>=20
> Fixes: 443c15d23220 ('IB/rxe: Shared Receive Queue (SRQ) manipulation fun=
ctions')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks Dan,
I applied it on topic/rxe.

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXXrMeAAoJEORje4g2clindlYP/1yBKrOwu5jlK6GL6Gml/IKZ
S28sHMwG9tXWfGu3dGnwuRJUm/E5ORZLQx3qoUSiw7J/NX2kaywi1oKeAPiwYU16
zB8zHlPVLp+P7de0AWsHVaKa+9zDugaVWH1KjQe0prNTvOVVupnu3AhEAba8MEJs
imOla3X4VYqRM4BXV0sWh1bOI0+zasULWT1BRH5YdYqGYgMTljZXGcZEyDs2+COx
IPilQJaAZzOVaketY98mf6YIg6DI2rWhhGpyrJTpOABYiR5+/gY/nXwNX5KpsqJd
+M4Qes1lb4aXRvxyujKfUsLGdembHbpcpB5z/biHz8E8xRAWgb6rWSe39IfRUNQg
rbd57tyr09SJyz5enewj/jSb/W4OLaWH8GFLeMyjfmMRZ70qqmepOuSabUAUmlna
LTj0cXgBrSa0ZbRnAdRUu8UCElQUjN+M0syuCX+EKwJWqRkZLvhRRozbD/UWGv3q
LgkzSfYgTAoX872iaf+ycQRjTbZxwde61FR3HG3hkvKv8gEbS0U7elE+cJe6Yx3q
calSoiENXljptGTjbcoymUnNUn4VGIaPbQFo5GvEcuA1dekcxj+qYBvq+WsyBXQW
DGP6v5ZUOGfW7DqyCbOK6nDpHro0WsQ8jJV1ZZ+ROHMECbw6o7ssMws4htUa5/nL
tpSrbX0AuvqzRKHv5iUA
=1/De
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
