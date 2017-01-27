From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/cma: Fix reversed test
Date: Fri, 27 Jan 2017 14:24:58 -0500
Message-ID: <1485545098.2432.9.camel@redhat.com>
References: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jcGVzXBXU2GVz3KCyQYQ"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170127131535.19918-1-christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-jcGVzXBXU2GVz3KCyQYQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-27 at 14:15 +0100, Christophe JAILLET wrote:
> This test looks reverted.
> We should log an error message only if 'ib_attach_mcast()' fails.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>=C2=A0

You are right, thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-jcGVzXBXU2GVz3KCyQYQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYi56KAAoJELgmozMOVy/dU9cQAMIsCef+cum/kHX6l07dOkSo
zbWqKisw3n9quMqsIPtg06a/Dv5iwhgDJo7tiApGguoeVln9HsG6TUuKGCGh4+U0
93WlC1W8ifxTe8PY2ISZq4S0sDxzUKU1oe7ZB9Jwpjchtw5MtQ4jRYiCyJMYBhDn
e+V5lEaXB16sZwJJQHGi8F2y3VrSPuvpVfG/wTv6sd2gkgch50DgvZxMObCKL6K9
Uxq8t6eG+jJTDl1s+RHj5nhNzR+Y8pbbym2L3v5rLba3N6v0jw/oF6sDR60DiBPz
4jzzH75HCbiVtMfB9e9A7/vqXlQpagB3UQZ0uZm3W4BML9NlfWY3g5qvJeRcYArv
KH/j4f1i92nv5HffpmIHQFdHDKTdshyJzGpM7HQLpIpjbTb0phpha4LvCHwr7n2b
dnTjLADLxDA7sC8xAXPhLj/yf+/ZTDJcoWaT0m5u3lhf5SZIs9SB3BCf+oC62Ex4
WdgnvHtLHJdCOtnUllB+9FvLwHXvrz7nGuVU8Mopd9v+HqD0DrRAoyBWSl+46X0x
Gj7pIOEVBcVfNgxLHnO4dvPvPJDTv8gei4BZtJJNrB9yPAGj2v4esu5PYJDfBCQc
ycPQbXhv93o1CQwHCXIhRuya9rvS6XQwVjSwdXbWYGVwIGauEkthgarIzHTw2agE
SqUipNvdY73YTnc6mceb
=QtvV
-----END PGP SIGNATURE-----

--=-jcGVzXBXU2GVz3KCyQYQ--

