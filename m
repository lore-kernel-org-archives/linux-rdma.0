From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc 0/2] IB/hfi1: Fixes for rc or next if too late
Date: Thu, 31 May 2018 14:47:35 -0400
Message-ID: <b9791f286ef1be4def5085353a9ee7975957b2d8.camel@redhat.com>
References: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0akAO6ajHo7u/BBvG5a/"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180531182633.26542.10152.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-0akAO6ajHo7u/BBvG5a/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-05-31 at 11:29 -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
>=20
> We have two more late breaking fix up patches. The DMA_RTAIL fix is the m=
ore
> serious of the two. I realize we are at the tail end of 4.17 so I would n=
ot be
> against holding off till 4.18 for these, but if there is another rdma
> pull request we may want to tack these on.
>=20
> ---
>=20
> Kaike Wan (1):
>       IB/hfi1: Ensure VL index is within bounds
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Fix user context tail allocation for DMA_RTAIL
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c     |    8 ++++----
>  drivers/infiniband/hw/hfi1/file_ops.c |    2 +-
>  drivers/infiniband/hw/hfi1/init.c     |    9 ++++-----
>  drivers/infiniband/hw/hfi1/sdma.c     |   12 +++---------
>  4 files changed, 12 insertions(+), 19 deletions(-)
>=20
> --
> -Denny

Hi Denny,

These two patches look fine in terms of the patches themselves.  In
terms of whether to put them in for-rc or for-next, what's the
consequences of hitting each of these bugs?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-0akAO6ajHo7u/BBvG5a/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsQQ0cACgkQuCajMw5X
L92xlw//Z3+0ugbctK83x1xXqiuFsjFaDHTtc5v5ZRajQ9p++Dmr1RdlLlZOcQS8
IQO9MJHlfYjx/vm3/fFPsy22r22nTLaDSr8kuiZfuD3X00KQRKdAWB1pdELmQgS5
Hs0Ns9SLM8GBeShpNnnLG5gFWifMD6AnoShB8DTAjhhjigxZvq0r7xKsH6dLN5nE
HvoAteD7AYw7S+r4WpneEzEj8rm/xNjYO2B9/mgein98z7fp9p5HdHphOcic6MBn
KkcFM8KVmRZV+fS7W0Ta44YhE85gmOfwLwGHkBxyj+dZ/8EJzDxlt/uB+xZId9RD
ypYmUHPaaEL/FtwklSpaCWtATTwwCCtXx4wSRzl+S4eU3BsHTIpV8euvOVW5Qt2m
rpvQZ1SzBD7EPwZHKCvhppVAhuLlO30traaxVnDZXkaQRINMc3O0E93sKwDGapUJ
tN3p2L9anJ83HabqM7P5q7/Lloix3VafOQmK1SymUggyijROy5WA6TX0RLkgjZB0
XZVtslhUjThd1AoXxGPxhR0cQqb/eJN5v86+EbsSFX23WdsIum1KvOcsBoHEFKqn
Oy+f6eStu51mN7JYxMBJ9z28jPq0QOKRIdekJ3DHQbOzYLYGRweNp/ybFTa5X6f+
dV0Z4SMD6XOEGOz0EdQEZp3EbsrjhKkFdMWVScAmKu6DwbSjSeM=
=CTSe
-----END PGP SIGNATURE-----

--=-0akAO6ajHo7u/BBvG5a/--
