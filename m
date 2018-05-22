From: Doug Ledford <dledford@redhat.com>
Subject: Re: [pull request][for-next 00/15] Mellanox, mlx5 core and netdev
 updates 2018-05-17
Date: Tue, 22 May 2018 14:48:07 -0400
Message-ID: <cf6ef8736d365508237fde4de4180581471066a3.camel@redhat.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
         <20180518.130351.456975805564832525.davem@davemloft.net>
         <feff55e081cc69a774de885ec9df0ac844a4e098.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Ox/yNcsmJW9I9WCfWoeZ"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <feff55e081cc69a774de885ec9df0ac844a4e098.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "davem@davemloft.net" <davem@davemloft.net>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-Ox/yNcsmJW9I9WCfWoeZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-05-18 at 20:33 +0000, Saeed Mahameed wrote:
> On Fri, 2018-05-18 at 13:03 -0400, David Miller wrote:
> > From: Saeed Mahameed <saeedm@mellanox.com>
> > Date: Thu, 17 May 2018 18:22:43 -0700
> >=20
> > > Below you can find two pull requests,
> > >=20
> > > 1. mlx5 core updates to be shared for both netdev and RDMA,
> > > (patches 1..9)
> > >  which is based on the last mlx5-next pull request
> > > =20
> > > The following changes since commit
> > > a8408f4e6db775e245f20edf12b13fd58cc03a1c:
> > >=20
> > >   net/mlx5: fix spelling mistake: "modfiy" -> "modify" (2018-05-04
> > > 12:11:51 -0700)
> > >=20
> > > are available in the Git repository at:
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git
> > > tags/mlx5-updates-2018-05-17
> > >=20
> > > for you to fetch changes up to
> > > 10ff5359f883412728ba816046ee3a696625ca02:
> > >=20
> > >   net/mlx5e: Explicitly set source e-switch in offloaded TC rules
> > > (2018-05-17 14:17:35 -0700)
> > >=20
> > > 2. mlx5e netdev updates only for net-next branch (patches 10..15)
> > > based on net-next
> > > and the above pull request.
> > >=20
> > > The following changes since commit
> > > 538e2de104cfb4ef1acb35af42427bff42adbe4d:
> > >=20
> > >   Merge branch 'net-Allow-more-drivers-with-COMPILE_TEST' (2018-05-
> > > 17 17:11:07 -0400)
> > >=20
> > > are available in the Git repository at:
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> > > tags/mlx5e-updates-2018-05-17
> > >=20
> > > for you to fetch changes up to
> > > a228060a7c9ab88597eeac131e4578595d5d46ae:
> > >=20
> > >   net/mlx5e: Add HW vport counters to representor ethtool stats
> > > (2018-05-17 17:48:54 -0700)
> > >=20
> > > Dave, for your convenience you can either pull 1. and then 2. or
> > > pull 2.
> > > directly.
> >=20
> > Looks good.
> >=20
> > I pulled 1 then I pulled 2.  That seemed to work well.  Particularly
> > it allowed me to capture the two different merge commit messages one
> > by one.
> >=20
> > Is this basically how you want to handle things moving forward?
> >=20
>=20
> Thanks Dave !
> Basically yes, we want to avoid sending netdev related patches to rdma,
> and vice versa.
> Unlike the previous "shared code" procedure, this is a more natural way
> to do things, since the mlx5 core is a shared arena, we want to
> maintain it separate from netdev and rdma.
>=20
> Before, Leon and I needed to sync before each release and create a
> "shared code" pull requests that includes everything (core/rdma/netdev)
> that was conflicting in the core arena.

I've pulled tag #1.  Thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Ox/yNcsmJW9I9WCfWoeZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsEZecACgkQuCajMw5X
L9197w/9GvCAyPoTumacNNSo/obz6gDIrE6bt6C5A7AKiXWTCWgV+ShEVhiS/z0g
AzFexkhUbEWZKZXvwZAa0ZF2RJlwEXsEPOqFjWbuJB3MNLM0ZfwkhSaDQexeM9eo
6xsClT9Vq2QTLMZiyzqP+eHemRAzYwoKYfyVFEF0o1nR7uOB91m9PmGbpsAxFlNs
Kqyp92Y8iIRbWAHQpXnR2X9GizwvxtzT+olzWbAMIMe40o4973s9M/TZaiX1GpNj
wWFff8d0PvBNixEygxDrj1ixFm/nxL+Nx7t8Q0BHUWJ00GEkZtGuvavSIDuLaI9K
sVXNNDBhzbeLngBjAG7lZs7gRWkuiL/hBvaKE62TWRGHfLZ3LXD46mQay67uQPQQ
ldJ2Sn7BCBdFeNa+uk6eatXitNMOoBN8CdzWFw4Z848+xf9nUTCzWRxUf0zQflNg
D0PUZNGP9BmmD+KjS6I+c9bLOSR5geD9DxQdMb6PfIEn2wgsfVDw3/KvU4MIoaLm
9/EOjjFGi6plWVYhXe2Fot9M1T7c1AqsKz5Hm24VtA08n4mbwHm0ZCY/s45EB0MJ
VXasmuoz28WbamRmmKqNzbe9b4wE6bW4eCl51qnYNscj8IPM7ioaWmECo+AvYHYP
mZtVvH89DsOy/PF/UVZ+TK5DRCBngMxbdaSTNPi/qXcSzOsAaQ4=
=OS0+
-----END PGP SIGNATURE-----

--=-Ox/yNcsmJW9I9WCfWoeZ--
