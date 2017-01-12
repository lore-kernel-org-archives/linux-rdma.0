From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/i40iw: use designated initializers
Date: Thu, 12 Jan 2017 12:07:23 -0500
Message-ID: <1484240843.123135.5.camel@redhat.com>
References: <20161217010542.GA140742@beast>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-oiZKbVsZfdpriXx+Sxtm"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161217010542.GA140742@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-oiZKbVsZfdpriXx+Sxtm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-12-16 at 17:05 -0800, Kees Cook wrote:
> Prepare to mark sensitive kernel structures for randomization by
> making
> sure they're using designated initializers. These were identified
> during
> allyesconfig builds of x86, arm, and arm64, with most initializer
> fixes
> extracted from grsecurity.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-oiZKbVsZfdpriXx+Sxtm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7fLAAoJELgmozMOVy/d0YEP/0b+4OTJQeo8cAEA8vdMA+NQ
qA4T41LE3OJxSkwG1eqaaGdpnbs/EPOoTbZzA1abj3FnsYruYSuLZlT+HhUIOg7i
b/vBWFTDT33w7HacySVMTEk187qUCdtZKLps6JRWsomek6vF4fuz5EvsprhWe/j/
XbQSB5wZRm6Lb7U9DHOxb3ZNcFwQqClfKxKs/M3ZGG0gU+kSHLJbLu15zRa+MicP
eQzm/RhY0UWG5JkEv13zuGjVeH7MH1j5px31ENSvnKPF+/O3nRJzucWVCj0eJP/i
ljfWjNAB9aGthyoTx2qInFvSBwi+fcnXyoNNGFs6QcomcpAPbwSlw/VXWaUTXkJ6
riawSmveFMFwLvOBwGB8ut6gcmlAvV0MB0Q4qUbv0ONIQKErX6gtCLe4H8hLHCwB
Q51HmIKFmZjY7RT/SAqs70yu4lrVQEw+jmETSBXpcXMI5C2zCcl861dn/ZvpXJhh
NnewHm+g6P4PxJBVBe0/Dyl3vdQ09RFFgdlL1krY/9xyN+8vWIsSlJEe12eg/qi5
XtEaLynIXxmCduN3pS6DoIrkr+T8zGvyH8JpEV08oH1ci7rZNYQgFtIbWW3YZkiE
ZGo+VxM1jiZJB5mHBfkteYcUpOoYLQfOwCQgloNbRjO4Nntzte0glH4sVF/3TcZF
iQg+vz6Oe6S1OOdUulR4
=yvEn
-----END PGP SIGNATURE-----

--=-oiZKbVsZfdpriXx+Sxtm--
