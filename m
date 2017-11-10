From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Annotate r2 and stag as __be32
Date: Fri, 10 Nov 2017 13:05:56 -0500
Message-ID: <1510337156.3735.7.camel@redhat.com>
References: <20171025201019.7367-1-leon@kernel.org>
         <037e01d34dcd$845c1ce0$8d1456a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VY2NnlhYWb2AubB05TTS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <037e01d34dcd$845c1ce0$8d1456a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-VY2NnlhYWb2AubB05TTS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-10-25 at 15:12 -0500, Steve Wise wrote:
> >=20
> > Chelsio cxgb4 HW is big-endian, hence there is need to properly
> > annotate r2 and stag fields as __be32 and not __u32 to fix the
> > following sparse warnings.
> >=20
> >   drivers/infiniband/hw/cxgb4/qp.c:614:16:
> >     warning: incorrect type in assignment (different base types)
> >       expected unsigned int [unsigned] [usertype] r2
> >       got restricted __be32 [usertype] <noident>
> >   drivers/infiniband/hw/cxgb4/qp.c:615:18:
> >     warning: incorrect type in assignment (different base types)
> >       expected unsigned int [unsigned] [usertype] stag
> >       got restricted __be32 [usertype] <noident>
> >=20
> > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Looks fine. Thanks Leon!
>=20
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-VY2NnlhYWb2AubB05TTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF6oQACgkQuCajMw5X
L91CUxAAq+6a4l91RmeP9AIdEtQSDHZHChZ/m6R+iSkMpgc803ZCBeJBqzlroryr
wYW4Jsqged2qqxCYaTKAkrfyxog7enhr/d7l2ArNcl2/UbJXpZTBv0ASTiRqpAVk
o2A0ve0+YMxGBLIJm6Mzg4YdqjnALe+WujOw5LTocF7OJIFbopfTrvQo0QMxC+KH
xCBQMJz3vYOEeyY/D5W/KzIwbUxUx5UwOiiOa2eWDKsP3NifKPwbJXz7t/Se6g6i
BAxe1LPUANq3Q4OeqlcHihq8Agpsa3syFKV2kmCIotTGBoFnpz7xEkCoYdexNOJR
DSakrTK6jzOi1lSxXJdquoMNVd0rbrazw3SNnNL81I3vyxansQxgzzZ5fTIbmwbt
qUg3FMo6aQVo1lkVy78VYdQemnIZQdDBI8k8ozmw+6QxHi1qPMIH9pJVSJ0WGJcS
LQ488LWmD1otKPDFsSJhl1O3pmbJ2SsOieVdwO9KpuDtls9wpsKFPeai/GiMhHZa
2VaQzEYq1fM6pK7818p+lv5rniobiNUicGL3AL1F6hzIkPrIZhIeZwhT/3LgEZLY
IMQjS4yDNTDTs00nqTx7lRF3ZgaFZtR6x1F1LH20sAf3YbN0gf1QahxZ6zbEYTse
eFTHYMERxXQE7p0hPf13MrX1lTd6exHXsVg7AIAlVymCshRluHQ=
=trOX
-----END PGP SIGNATURE-----

--=-VY2NnlhYWb2AubB05TTS--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
