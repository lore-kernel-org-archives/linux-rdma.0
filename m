From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next v1 0/4] Scatter to CQE
Date: Tue, 16 Oct 2018 14:39:01 -0400
Message-ID: <f59c18d5d4d02d93d3e918f93b8a4a81bdf6e5a6.camel@redhat.com>
References: <20181009090515.25223-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-dYt+U22FQM4J+cYpJnyu"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181009090515.25223-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-dYt+U22FQM4J+cYpJnyu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-10-09 at 12:05 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Changelog v0->v1:
>  * Changed patch #3 to use check_mask function from rdma-core instead def=
ine.
>=20
> -------------------------------------------------------------------------=
-
> From Yonatan,
>=20
> Scatter to CQE is a HW offload feature that saves PCI writes by
> scattering the payload to the CQE.
>=20
> The feature depends on the CQE size and if the CQE size is 64B, it will
> work for payload smaller than 32. If the CQE size is 128B, it will work f=
or
> payload smaller than 64.
>=20
> The feature works for responder and requestor:
> 1. For responder, if the payload is small as required above, the data
> will be part of the CQE, and thus we save another PCI transaction the rec=
v buffers.
> 2. For requestor, this can be used to get the RDMA_READ response and
> RDMA_ATOMIC response in the CQE. This feature is already supported in ups=
tream.
>=20
> As part of this series, we are adding support for DC transport type and
> ability to enable the feature (force enable) in the requestor when SQ
> is not configured to signal all WRs.
>=20
> Thanks
>=20
> Yonatan Cohen (4):
>   net/mlx5: Expose DC scatter to CQE capability bit
>   IB/mlx5: Support scatter to CQE for DC transport type
>   IB/mlx5: Verify that driver supports user flags
>   IB/mlx5: Allow scatter to CQE without global signaled WRs
>=20
>  drivers/infiniband/hw/mlx5/cq.c      |  2 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
>  drivers/infiniband/hw/mlx5/qp.c      | 93 ++++++++++++++++++++++++++++--=
------
>  include/linux/mlx5/mlx5_ifc.h        |  3 +-
>  include/uapi/rdma/mlx5-abi.h         |  1 +
>  5 files changed, 79 insertions(+), 22 deletions(-)
>=20
> --
> 2.14.4
>=20


Hi Leon,

This series looks fine.  Let me know when the net/mlx5 portion has been
committed.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-dYt+U22FQM4J+cYpJnyu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvGMEUACgkQuCajMw5X
L90ivg/9Ht2pvsLAO2QtcR/st9PuCA2n8g4SLgZfHd0k1lrxBMp2GNeopvrLgkcb
3C6qqAFoxhyv5zvZcITv2sD9cR/H8Er++iPhYof3cqJ+OlOAu/f3AmITwQ1wsVJW
IseBJJliqMKquUi9U88yJzSzjx3h0CyO4Bl/PU4Kp9usXVYbSRCSd7b9RGOD+XzI
RNh38G1QeURz99rG8qzgROPbTsW6CRiOg+rPOQc8IouienjsD17RbkLCWQj1Jvcc
j5QL+dopbj2VoNcwMR82FaPt9TVdG5DywGKrCT+lMlXwmb/41ZEjJwWYR515Arck
XshgrX7toSOu45culoxHdPNVHBMyLOWWXsRynDzd+Rgs5qM3iJv0c2c7UTpH8RFF
9J/s3o9YWEzcpmRrjqgD9TG5y5IStwSiAMCFWel7xcQMDyylR5qe44wPPIhacz2/
dNfHEM8JtrpIcjdRu2AvqBoNxmdgCO8sCNtHJDZT6669jEBSeNulMKKAEOqhDDxk
+zTE9v3NyZweMNDxpoiUiZDqal4rLdCatTLIhsuywEhhDQUYWKNuXWW5Wl4KZtrP
PK3PQNR/JEqMoIzzkfWaA2xgIeQfVXADwquc1fgUYeDMd7pT/zhuR1pgn6YirKqQ
EgN3uGQFpusBFYZusssf4bc3rjyvnOYPb0fXjRgn9l97MvcA/CQ=
=g2xY
-----END PGP SIGNATURE-----

--=-dYt+U22FQM4J+cYpJnyu--
