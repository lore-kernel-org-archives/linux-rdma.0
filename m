From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
Date: Tue, 06 Nov 2018 16:34:04 -0500
Message-ID: <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
         <20181101073412.GQ3974@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xF+pCoJdhHQPP7mzVYF8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101073412.GQ3974@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Joe Perches <joe@perches.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-xF+pCoJdhHQPP7mzVYF8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-11-01 at 09:34 +0200, Leon Romanovsky wrote:
> On Thu, Nov 01, 2018 at 12:24:08AM -0700, Joe Perches wrote:
> > The line continuations unintentionally add whitespace so
> > instead use coalesced formats to remove the whitespace.
> >=20
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >=20
> > v2: Remove excess space after %u
> >=20
> >  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Applied, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-xF+pCoJdhHQPP7mzVYF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlviCMwACgkQuCajMw5X
L90r+g/+Jmdkw3PjfGgZm0CAjbhF0TdDMCc3RnpVCdJmRxQF7kVCHPJCBcX4PDlM
ODVXyWqgKE9n8itHTL+am85ioG5jxeJwriOLW4ei0OdKzbSQ//eR0DJMJB89EYVl
rUVGWLCFOjDjqoN3zIUm4U9beZM7/gkgtNE5X9XEE/JkaHvdRTiwPTgyBDmz1r7J
UgvfU5LLg6AJIrjcRuIxkZ5I2pzkEcUt0Tnh16+81va0mEQAxDZrTXcaiz9lItGS
FPw86v+I3YkaKC5nuQekmRVn9yHimS7WJZih+F61gCKFmVEBSJAoAp/QL82AIUll
kdWct31aZF4Dw6FyHxGuAI1NGvaevr0rCmOt+jIfp/cYpyXQKdAJoEPDH3cFTQJm
NTeKhrMVuIrNFmf2W/CIyETLG6ohLDzQCqfQBdnBpmnr8aDFaQlgL6HXyalqlfxz
JKzUtWn1QgYVEiQRw+JMrcuPXWthyZgDXrY7RwhO7CH4jNg30TmAXTpO+9WEH6Uv
Vwk31T6PmXZyrqE5CuQ+fX9HUIYnlPqaNvGAFgqBxeAWOccpVFQLkCxozLykGa5t
9a2Hs8NsVrVfsxh2JkQvcJksP7XgmXHMKWNhyK2bsMry07bgr6zigolt/yFO+6Cc
3bRxR6NIAm87Q3CQ0BSWA0LavGTthh1+9bqR1UM1LC05/xoNwzA=
=1u0t
-----END PGP SIGNATURE-----

--=-xF+pCoJdhHQPP7mzVYF8--
