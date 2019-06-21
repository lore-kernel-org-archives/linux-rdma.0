From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Date: Fri, 21 Jun 2019 11:49:56 -0400
Message-ID: <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-dsnFBwleYpJojgxQ5ys9"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190613083819.6998-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <michal.kalderon@marvell.com>, ariel.elior@marvell.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-dsnFBwleYpJojgxQ5ys9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-06-13 at 11:38 +0300, Michal Kalderon wrote:
> This patch series used the doorbell overflow recovery mechanism
> introduced in
> commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
> for rdma ( RoCE and iWARP )
>=20
> rdma-core pull request #493
>=20
> Changes from V2:
> - Don't use long-lived kmap. Instead use user-trigger mmap for the
>   doorbell recovery entries.
> - Modify dpi_addr to be denoted with __iomem and avoid redundant
>   casts
>=20
> Changes from V1:
> - call kmap to map virtual address into kernel space
> - modify db_rec_delete to be void
> - remove some cpu_to_le16 that were added to previous patch which are
>   correct but not related to the overflow recovery mechanism. Will be
>   submitted as part of a different patch
>=20
>=20
> Michal Kalderon (3):
>   qed*: Change dpi_addr to be denoted with __iomem
>   RDMA/qedr: Add doorbell overflow recovery support
>   RDMA/qedr: Add iWARP doorbell recovery support
>=20
>  drivers/infiniband/hw/qedr/main.c          |   2 +-
>  drivers/infiniband/hw/qedr/qedr.h          |  27 +-
>  drivers/infiniband/hw/qedr/verbs.c         | 387
> ++++++++++++++++++++++++-----
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c |   6 +-
>  include/linux/qed/qed_rdma_if.h            |   2 +-
>  include/uapi/rdma/qedr-abi.h               |  25 ++
>  6 files changed, 378 insertions(+), 71 deletions(-)
>=20

Hi Michal,

In patch 2 and 3 both, you still have quite a few casts to (u8 __iomem
*).  Why not just define the struct elements as u8 __iomem * instead of
void __iomem * and avoid all the casts?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-dsnFBwleYpJojgxQ5ys9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0M/KQACgkQuCajMw5X
L91UWw//RDPqDJyB9yRh6Hp1fiLklEqPg4ActjxLNqTy8dTC7ptZhB23B5chNdeZ
eDXcrnrq80Li9Gc1zRW9Zrt214PHr8o08Br1GfhKMC6LCDebqK5RVDO6rV/hCNIt
QL3cScpKQBDwuUqpKCd4DmS/jDbdSPRSxl41r2LxzhJE8vNBnhdCtTsGUmXaD+ew
iRc3L+fbqQ9Lb5pbnL5LTlYIMF1kfWIB8bRbPd81efCRXMrDVStGGEDR4h+Obfbk
a8ej6vefDDALftxs4IjxrUvMW5CRid/tpy00dsbVmRWzIbmnvjaDYQfX0s57Fc+I
JImrePFMs85BVifPkfpfzVMCwTfUhKcaiy3B8LjniEGqyRloaM2F3A7Kx8sOmg3p
FG54KyScc1VJBoxP7Cu/gvyAeiJHopuTEGvNQMbQ0Q1ed69+Krg03eVzdGZss9H4
0bq2qf/Tce8VqDadB7S3Ru1EWeUqQtmM8LyNMaOngadGe7+U2ncfV5bsfGEciTG/
CPseTH6ch1IGwp1RyK+lFQlftbSjPqY37WtdGMuPqP2E/E5QrgQBWeFztItcG1ji
7cRKGNNg03wSut0oPwII2B0bRw5TT83nULXQALmi5zw7NhZkC5QaebbykZvs27xd
LOrGZobjf1AdqK5vst5Rmp5+cx3N8Ey8YDMx//gueWqiRsjIDDc=
=CAEI
-----END PGP SIGNATURE-----

--=-dsnFBwleYpJojgxQ5ys9--
