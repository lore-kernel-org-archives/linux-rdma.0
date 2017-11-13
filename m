From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] bnxt_re: changing the ip address shouldn't affect new
 connections
Date: Mon, 13 Nov 2017 15:13:55 -0500
Message-ID: <1510604035.3735.31.camel@redhat.com>
References: <20171102210904.13020-1-sriharsha.basavapatna@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JFrlx7R/YwN+cQ5y37G7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102210904.13020-1-sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-JFrlx7R/YwN+cQ5y37G7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-03 at 02:39 +0530, Sriharsha Basavapatna wrote:
> While adding a new gid, the driver currently does not return the context
> back to the stack. A subsequent del_gid() (e.g, when ip address is change=
d)
> doesn't find the right context in the driver and it ends up dropping that
> request. This results in the HW caching a stale gid entry and traffic fai=
ls
> because of that. Fix by returning the proper context in bnxt_re_add_gid()=
.
>=20
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-JFrlx7R/YwN+cQ5y37G7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ/QMACgkQuCajMw5X
L926sRAAwsQnTJo8tVrcRitJsMLOshebEAsUJnotwiGFZFO/ZtSqvWJT6G/Z6yph
w5U8FdV0lEawJ0KkiDvYT8Pfo0YqSMn/a2ZQs8QX2kE4mJlg7Ib0e9baFWQvZ9Ox
mdIsBZR4Kq82Mz6fZ9WCTbOaWFX0Zc1GKoddh4lRqWZhj8CRWmrupo9D8DtMaJrc
F8XH4X606+xQj+hxZgwwcDHb3DFbl7ffcKUHEaPmRSlWA/UGPqaLghCjV5aM3xYZ
5pG/5wr/5tsWlYId33ehs7e51+L8VK1/VPN7oWB/WtX/k7cAF7Ljt48Fg1Rfmoy+
NSJ1S7Errkvm4f/GL4d2nK8fvgF0lsggoXnjrOuXl92XABAvy2Jc/qFEj3e+cpYa
eLkFU4kV3/KVVSnnfNn57Byje8eTwoZO7KipgprFcL0uUa+1NqkAZLaNatEbjJEZ
hX0b4ks1RnqnJEi2cPgaaJ+eCENGlL5EtE/Broc7bdnb4GdaV7n6BONNGyW9v4jX
xOLuCAVP2FzK6VICXmxXg8VKMo4o7Fnype1wlHD2MBaC9ewB0Ys5+R3FsqBbw0fW
uv/XyaqcmI9+COSLOk9Y/Z/6oO7uKdZysM4r8q/IrC8T8N/6xcqBgZNwlOvZoE12
M/LdmdB/MC7llewK+r/qBXbBcgKHmtTJG1dFW6YsgyZUoSn2FNY=
=ijix
-----END PGP SIGNATURE-----

--=-JFrlx7R/YwN+cQ5y37G7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
