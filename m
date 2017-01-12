From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/nes: use designated initializers
Date: Thu, 12 Jan 2017 12:07:00 -0500
Message-ID: <1484240820.123135.4.camel@redhat.com>
References: <20161217010316.GA140509@beast>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-S44M7CiH/XLMJa8p2+Px"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161217010316.GA140509@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-S44M7CiH/XLMJa8p2+Px
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-12-16 at 17:03 -0800, Kees Cook wrote:
> Prepare to mark sensitive kernel structures for randomization by
> making
> sure they're using designated initializers. These were identified
> during
> allyesconfig builds of x86, arm, and arm64, with most initializer
> fixes
> extracted from grsecurity.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-S44M7CiH/XLMJa8p2+Px
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7e0AAoJELgmozMOVy/dsSwP+QGcw37F26QCezAAiYcEnoPo
2Q8cjlDmnQQD5RRmmb8vlQS4Rb5yaPfrIiWBQtmjYH+pqkmCWzLBQKIWsn+Eatpl
mOHky+3tqgcNA/n1yGhZ9+rfM+AupNQQkl7YyTcDot4NZ74jGG/VnA+ccaygkzO+
AMcZ4kFFvEn5L1/fXbj+dcZnos65nxDe58AZIJwbbH353N0njgC3xWWIvXOLunJx
OaxLooEeHYG1dL8LXb084C/jXA0EAHn2FgCaUBkP4chUVHqR97P1z3z4yashlE0i
pv2pW484WqSqpVkLdhJrJ5YhEC3r/FYf7tqAukdsr7ZNJtz9gtUUXTGEPeNgWAbE
UObAEOjlIGJf4gCAD6HgrKEJRci/RnBPEyF76P2i96ggoO40rT26g/bbP7ym+E61
2hx+C+WQgRhfNNRa8Nnyo9e7bssoK8a769VJSILboZvlkFDzLPLLC0YYjDBbUCCT
HSmtXD/plz0ka1Srvx2vN8Au+N6S/M6VGFMulKglxctYBFyoOKmsZjERdF/pdBIT
g0VgXcM4cyfnohKv4UKMF/gKX3wDtWj9EA2LIgxj7xSVivh62sWl3dBd0ubVbvkH
FkzoZWaCgEt3zvF2fclYXm+ztfm3oFZI7dkBz9+uwYrfh7hplhnvh6yRERxg8yjK
cqSn7kPxjZjk4Y90veWP
=BVIj
-----END PGP SIGNATURE-----

--=-S44M7CiH/XLMJa8p2+Px--
