From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 1/1] RDMA/core: create struct ib_port_cache
Date: Tue, 24 Jan 2017 16:32:01 -0500
Message-ID: <1485293521.43764.83.camel@redhat.com>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
         <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
         <20170113150103.GP20392@mtr-leonro.local>
         <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
         <20170115085014.GB20392@mtr-leonro.local>
         <f08926e7-54c1-fa48-2105-308f82ddcc23@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MCrl+xaGDc+ohC81X0jw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f08926e7-54c1-fa48-2105-308f82ddcc23-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-MCrl+xaGDc+ohC81X0jw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-17 at 10:11 +0100, Jack Wang wrote:
> As Jason suggested, we have 4 elements for per port arrays,
> it's better to have a separate structure to represent them.
>=20
> It simplifies code a bit, ~ 30 lines of code less :)
>=20
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

v3 of your patch was applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-MCrl+xaGDc+ohC81X0jw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8fRAAoJELgmozMOVy/dgJcP/06pQtVnS8zN0DRYhjimC0OG
XseDe96itwYCSzv8RN/dfduHzTSetZ9uiJwuxMRmvrsael50qKmJ4P8cXhYyVEbl
Ex5JUbVY6RS6QNNW1McwEwhvksw78onqpdhzUn2DApaN/wyfpnx7pHvyW85+d1vH
nRiVdxJ0GAgnJt5V+61zirglaM0b/Juux8DJ8Brs5DmOBS6SSM0ZO3dT6mY6D4HR
6Env16WcGAQAduq/7oyZLOlwVZfPGMjKXhM1EL6BM+7bc5jPfiRHLnWTCyBXeGZa
Q9N3ks2uEpNjpDjNftCVO8oTY+A2STnp+tTmMf7mb/9HxQ5Cn6S7oA3HWP1CSmRP
RaiX/6wvFwskuMANwsCQa0bN8kEyp+vGmdkCVgV1a1KBNcPCLhOptwf/0wv6eEZg
yd5B88dTxkA2bovT/rWihZHDTefdLXH/AVgO1KZYLSVMneG+W7pU/hYkBsgWwboH
QWNAtXeGS2Ueq6/WxpyH7vENW7xOj34Yv3CgqkJhM6vqNQ+FAM2BkWMcG6Lg4yVn
4t8vJ3ws/Dh70MepnFsfGG/IT7SqyxJ2C/CAFXpblzlZZw+57w6Mbb/3a8url8SW
GD+iBJG8EMpno02YMtDKtHIz2Y4kAei+SgKTpbEnnWOw1bT5EmzCFhCk5+WiQeta
mWngXkktpCF7I1JdvGuZ
=Dyut
-----END PGP SIGNATURE-----

--=-MCrl+xaGDc+ohC81X0jw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
