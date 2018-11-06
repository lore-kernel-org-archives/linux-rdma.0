From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Tue, 06 Nov 2018 17:10:53 -0500
Message-ID: <581ad7a59e00c7ee01a65940637df25ad826041c.camel@redhat.com>
References: <20181031102028.9142-1-leon@kernel.org>
         <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
         <20181106220206.GC30490@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LG1UiX8uaVEOQKHNXJhc"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181106220206.GC30490@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-LG1UiX8uaVEOQKHNXJhc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-11-06 at 22:02 +0000, Jason Gunthorpe wrote:
> On Tue, Nov 06, 2018 at 04:31:08PM -0500, Doug Ledford wrote:
> > On Wed, 2018-10-31 at 12:20 +0200, Leon Romanovsky wrote:
> > > From: Yishai Hadas <yishaih@mellanox.com>
> > >=20
> > > Adapt XRC SRQ to the latest HW specification with fixed definition
> > > around umem valid bits. The previous definition relied on a bit which
> > > was taken for other purposes in legacy FW.
> > >=20
> > > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > Hi Doug, Jason
> > >=20
> > > This commit fixes code sent in this merge window, so I'm not marking =
it
> > > with any rdma-rc/rdma-next. It will be better to be sent during this =
merge
> > > window if you have extra pull request to issue, or as a -rc material,=
 if
> > > not.
> > >=20
> > > BTW, we didn't combine reserved fields, because our convention is to =
align such
> > > fields to 32 bits for better readability.
> > >=20
> > > Thanks
> >=20
> > This looks fine.  Let me know when it's in the mlx5-next tree to pull.
>=20
> It needs to go to -rc...=20
>=20
> This needs a mlx5-rc branch for this I guess?

I don't think so.  As long as it's the first commit in mlx5-next, and
mlx5-next is 4.20-rc1 based, then pulling this commit into the -rc tree
will only pull the single commit.  Then when we pull into for-next for
the first time, we will get this in for-next too.  That seems best to
me.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-LG1UiX8uaVEOQKHNXJhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlviEW0ACgkQuCajMw5X
L91u4g/+LPE6B84x53vrcwDHMipNMJ9sYk1Gqyr84l5/hx8mKXUiLmFwcyGgE0d8
6ACjm+N4sRv5xIOBN9/kFJJZ8mg6kNNQTqI/gSxZf9AR+OT+SnVbLPEbWk8JgNik
4nqmthwKp9C+h/ibePmz+r+36dRQ7NMzMwUSmRcafXzKBfBqvKWXnIy6cV+GRSJa
OTWltDqpaiQPeKCGQN5JvwuBjp2+YD7+PB5bcl/eGa4cCT1H1Q6bzo1nRmbfuQir
pJM9nn9FKIgJ+JDov1QgwZrn7uKzNntgjSO3l4XZPBmSni+q4XBakg2vwiBTWU8g
zshmmvE3J827bNpC4ca3jLD7LDsHNVuRXZoz762KS8FohOph784UF49gfeYAytnY
sZ9tC5wz9/qenPNnz88zdS4Tvgi92V4TJZLV6RuJi+q1NL7PsNCqpekYQH+n6Wof
bKeSzXAQco03+Mmsqe4/J/6A6l+5Fh9JSeozGOQSqEjwY7IhYqXupVoau/QwfIsH
sO0csSjMoJfdbytoT8ji8ebghwGhHLvdjTHRAEIqrUP+OMiqn07Kep9MGJyjQdeV
1aImP3fVRUTnimHUOCY3VEkJFBynfldpi4qpPcLBemZTjJH4ZMORXaxnaFtx4cVj
oxAG/eTLWNCqUH/3CqvfhIjeM9apIre7AFEuyK9lPqmomT42EQo=
=zTjE
-----END PGP SIGNATURE-----

--=-LG1UiX8uaVEOQKHNXJhc--
