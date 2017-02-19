From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: remove the unnecessary memory free
Date: Sun, 19 Feb 2017 08:55:35 -0500
Message-ID: <1487512535.86943.109.camel@redhat.com>
References: <1486709322-19362-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NlfoyHiYxtcsM7IG4NoI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486709322-19362-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-NlfoyHiYxtcsM7IG4NoI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-02-10 at 01:48 -0500, Zhu Yanjun wrote:
> In the function ipoib_cm_nonsrq_init_rx, the memory is not
> allocated successfully. It is not necessary to free it.
>=20
> CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-NlfoyHiYxtcsM7IG4NoI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaPXAAoJELgmozMOVy/dB/8P/iyOUU/k+vCXFH5rab4DCxPh
F0hYKCxtju5TAS1RlN9W9zeBlWHfw+maMoXsokC9boa3g2/WnoOkceNRDWo6Q2X3
UYaDtVdplX/9Qj0g3A1iSczml+t3MV6HG/Do/6f8ldaR9WQLYgMnvA+A1czbDAVk
fsviNTUtPudYPkzbbhMNjiXOdTEPbrmirUwOd4k70mPufBHIOtMwkeDkhMeRfXhU
034v8lUvv44/4EGp1hw96FUkdwtEoMN8/zTu1d+4aGYcP2g/Pm9s4L/urt27A+r/
+54DXo0yHc9QKMuOkAfZXwKBOWReNGqOFpEM2XNB1ec0FPV1Rla4dZ9oO2HKShLP
DcKdi8rGuRwnPJeEl9OO57X0z6OpaxvmpB6/vY+6EcGfDGIYnOqwweRKxw9155V2
QNn/ld1p/Z5mB5iL+vLmqbE2pY6AKAm1ORGLiSIeET+diis7vCADCvhf9z5EpC4w
/nTv25WXt8gRIT6vx6ygBoiX9PO8KLS9P3oJnwcyGsc4QIau17QsZPCxlceXuePe
s6fJHmXqfrjepUuzdALkGSYFXStGAO+F66ftMmYf8/rNSOHVjYpLSaC3JA0LjQig
ow+QkGGEL2oSjeLeFmNd6BTfzvSMwuoKlQUsdrnkIYs3r+hmLq/kVS+BpNFqdIqJ
lgb+vvszaRUY7vy/LgK4
=IMFz
-----END PGP SIGNATURE-----

--=-NlfoyHiYxtcsM7IG4NoI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
