From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Wed, 17 Jan 2018 20:34:43 -0500
Message-ID: <1516239283.3403.297.camel@redhat.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
         <1516231986.3403.296.camel@redhat.com> <1516232517.2820.93.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lDaZE9EoSfDCxdNF7QzC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516232517.2820.93.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-lDaZE9EoSfDCxdNF7QzC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-17 at 23:41 +0000, Bart Van Assche wrote:
> On Wed, 2018-01-17 at 18:33 -0500, Doug Ledford wrote:
> > The first 11
> > patches of this series seem standalone and can go in now at this point.=
=20
> > Would you agree?  If so, I'll pull those in while we discuss the
> > configuration stuff.
>=20
> Hello Doug,
>=20
> Please consider the first thirteen patches instead of only the first 11.
> Neither patch 12 nor patch 13 introduces any code that controls which RDM=
A/CM
> initiators are allowed to log in.

I'm fine with that.  Patches 1-13 applied (with some tweaks to the
commit messages here and there).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-lDaZE9EoSfDCxdNF7QzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpf+bQACgkQuCajMw5X
L91xeBAAt2gN12o2Acc4lrPiael8Cb/mpbzSm1V+NF55JTQTwR7mZLcY+cuho2+k
68DPCr9wvSmeqvzHwfiBq+LxFmUz7l+WBicDqr9gUMJN1GuyijO+SfsQzRodyR/m
f8TIcYDv5b2+96Aky4NkbF1aY+VWUfNgqnbl2y+ElZE6Nue71HiNZNvA+nO8G/IU
b+PHahwerRTbTOY9Gqwn2blMiRJmq8Z6OP07pkiFxZFwKa6fRRUoFmb/8KlW90Rp
aW4g7ZEOZKu+7Fs+aMO12V0spOX3RLOayeRAPECu5ObgwRgJvqnMJsIBY13XPAel
qBvEijJoK+f2O8HFDUlQPe0YYm1rcBWYYvFm8QRJ1xMZIJ55E7nyuAGidlLj8xrj
HpqbbIz9WGc+NPJrObCbqKOVjCQ2m4fKSM6CVJbjvG5e7r/FmUfc8zenqill4nNd
R6C59j+Qvv/WfCfZ6FCwmc6c3XJMUItxC+KLZ0eRAV6Qb3dqvJzDGU7NINKM/O7e
L8wEwqo81UykbzxUS4s/sE33x+jxMxkC2GAZLmHRjNaImEiRlPIEgOQ0BttwYtxd
HO4kJVHKKtXiynh3NwNWKrac4rhZFSZSydWxYV6lBXA1ThB18+98ChIdXtNLV1Ck
Y5AdMjrnYb0CN8HkW9AKAHBmecugosBJyHDLdPD+68hpXd6xsN0=
=ak+p
-----END PGP SIGNATURE-----

--=-lDaZE9EoSfDCxdNF7QzC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
