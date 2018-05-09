From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] iw_cxgb4: Fix an error handling path in
 'c4iw_get_dma_mr()'
Date: Wed, 09 May 2018 11:09:37 -0400
Message-ID: <1525878577.11756.380.camel@redhat.com>
References: <20180508054427.10697-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tu8UbiFGbtEvy150MBQD"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508054427.10697-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, swise@chelsio.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-tu8UbiFGbtEvy150MBQD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-08 at 07:44 +0200, Christophe JAILLET wrote:
> The error handling path of 'c4iw_get_dma_mr()' does not free resources
> in the correct order.
> If an error occures, it can leak 'mhp->wr_waitp'.
>=20
> Fixes: a3f12da0e99a ("iw_cxgb4: allocate wait object for each memory obje=
ct")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to for-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-tu8UbiFGbtEvy150MBQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrzDzEACgkQuCajMw5X
L93N1RAAndYlgYvHUI1z7oeyyb3p1oaay0oX1mDBohcOYRUAG3vkmvtPl4/pXyXY
9ZpNIzqiTmAAM3xDQHsbPeRJA7CjA2cFDUiT8/jlQWBH1r1iqC/LL7GH4ix47tLS
fsJkl1j1NgSzPCdA0R5cqiA1XkNjUSknexKPKF487ngfFFISaycy2BrzlGY+M03O
isCuGq0fRK3XjpVJfwgyv7+xG5SVf+plnUszsXtIf1BwhXlmLLCARAUmQx1W4bue
D+Y469uI5eVo6bqi1ng8trp6UeiUhl4GFvua/CQs6+uoMB6IqZ6MpBrF6FVWhrWU
G7bRSbu5MHdxyrWxv9z2kqYtMQ5Boa7jOV/9CQH/pY/4MHrGghFv87MMd77bckUY
hHYUEmdntuqhIdKTj8SHZXcH7MfmwpNS0i3f6Wbm0GWvN0y9nJH9iAHEXXLnBflR
eoSLC9Dmgwm3SpyMZzQRK34PjwYNwXgskrl6Z/A+B8JUfs+YXXiCoSqk9S4mTdX5
duZSAoeu2OceSZ0kVL+6ILzZ3xi2ntFegZreoA3LuytT+m4cAyU6Z6R4AmcSBlnj
blMmwUeRGQHedjKqoRrZH8IFzclfSfy5VnKemvt1TEeANUiF0JMjnz4q9/PvTxyV
rpp8cZKKoooz8TNtIGbr50dlCZ9+oRR/IciXd/MiCyrLUTNsyPI=
=KOUl
-----END PGP SIGNATURE-----

--=-tu8UbiFGbtEvy150MBQD--
