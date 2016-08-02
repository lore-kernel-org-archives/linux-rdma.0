From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: Use AF_INET for sin_family field
Date: Tue, 02 Aug 2016 13:06:08 -0400
Message-ID: <1470157568.18081.14.camel@redhat.com>
References: <20160704125744.GA16796@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Ef6xByUp0zxShzPjy45/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704125744.GA16796@amitoj-Inspiron-3542>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julia.lawall-L2FTfq7BK8M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Ef6xByUp0zxShzPjy45/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-07-04 at 18:27 +0530, Amitoj Kaur Chawla wrote:
> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.=C2=A0=C2=A0Also the
> values
> of PF_INET and AF_INET are the same.
>=20
> The Coccinelle semantic patch that makes this change is as follows:
>=20
> // <smpl>
> @@
> struct sockaddr_in sip;
> @@
>=20
> (
> sip.sin_family =3D=3D
> - PF_INET
> + AF_INET
> >=20
> >=20
> sip.sin_family !=3D
> - PF_INET
> + AF_INET
> >=20
> >=20
> sip.sin_family =3D
> - PF_INET
> + AF_INET
> )
> // </smpl>
>=20
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/hw/cxgb3/iwch_cm.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-Ef6xByUp0zxShzPjy45/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNMAAAoJELgmozMOVy/daYsQAIJBWlB66j9iBc1/5JGL1EYU
sO3SprBERYZpdUoDrmneDkuM11MfmsdkKWWTE+buZIniZD78Xqv4kyBPlvnTXmiG
M56Wwh9PfDBcZ/AyaqJjsuVmUvvHPIwtcJZDFmI0UtYheq/a4GLg4rX7okOmV7ze
9iTfBaVYHk2XoaxNx9yC/tO2MXNOSKTBG+6oRDX2PYR9fMxtpa/pY7d86VQqMO3E
oq3m0dgU18KjUblboR/Kl/wKDu4CtkUMf7GMxGioV4P2Ew/B6/CVEWs+ikYoEETg
JIJ5Cv9S5CA/y5sHU1zsiwuyA2vZl8ZlK0kaoywqc3BjNGU2kw7WANSakb1vHa6r
le80AwWGFhj3606elkTJpMlv6k3Nh73VGvr3S32qlSEjb9+PEF+4x23kU9TgyAwZ
HSuSDQOGhff5IK2+lCbbnFLkd+W0SW8Oi7dEk3gBa1JkQ2nWYfZNrhZJ7r5FBelX
dn42simDHT+PJIzzmu/iIqIQ7h3haGGJwycELXnD0UKbs6kGuG5gxtOrmuOig8yz
a9E1PvaJow+nYitSsfDU0jkmHTFuZMB4lHxRUa/0Y/IDIOKuTvVw3VmKxALcE6cJ
epX7vwS14Bgt8Qr9iSf5RF4E2bzMSILGDbut8XHc1xJMDzMRzNhlcp60gTO5Ap8y
rbeyeZ0suKzG73se5Nee
=rI4U
-----END PGP SIGNATURE-----

--=-Ef6xByUp0zxShzPjy45/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
