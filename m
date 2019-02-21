From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 21 Feb 2019 23:07:20 +0000
Message-ID: <20190221230714.GA10656@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Small set of three regression fixing patches, things are looking
pretty good here. Thanks

The following changes since commit 8834f5600cf3c8db365e18a3d5cac2c2780c81e5:

  Linux 5.0-rc5 (2019-02-03 13:48:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to f09ef134a7ca3f0d2ce485a757f5b79809ebb803:

  iw_cxgb4: cq/qp mask depends on bar2 pages in a host page (2019-02-15 09:39:39 -0700)

----------------------------------------------------------------
Third 5.0 rc pull request

Three smallish patches fixing regressions in v5.0:

- Fix cxgb4 to work again with non-4k page sizes

- NULL pointer oops in SRP during sg_reset

----------------------------------------------------------------
Bart Van Assche (1):
      RDMA/srp: Rework SCSI device reset handling

Raju Rangoju (2):
      cxgb4: Export sge_host_page_size to ulds
      iw_cxgb4: cq/qp mask depends on bar2 pages in a host page

 drivers/infiniband/hw/cxgb4/device.c           | 15 +++++++++++++--
 drivers/infiniband/ulp/srp/ib_srp.c            | 10 ----------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h |  1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlxvLx8ACgkQOG33FX4g
mxoAfQ//fkI0f1urZsjloSiXrxiuQ2wRd6uHEywTtwVwWuad34WsvAvodQllnS+h
AesDPOa4L1+RlSWQ+vZ1Mc+JmNNqZBADg7uFguf0nyeuO/Fbyhgi+C4rXrV/pSUT
lhlgznAX9psj2KrV465D8uOrAj3LIfcARoqKeQuMMgnX13ld7paBAySQc4dlvc1L
e2VGVDYz6j7XgY91+iCu1cddhlyUleGyP0Q4x0TVRWAWmviMMKgXFhM0Xl5R7z3q
Y4NukzCAXC2lMDwT84NJdBg3pxqQk73V2QB2kKaTjVD4k4wqWD7zja+IeU5exygN
zYMJqIa4/M85lJASuNCZ3pL8Y7eHiYnG0Ng8IVr28YhDL8mY/c96OJRmINP9H4kX
4QVNa47tow2tNz6CSwcqQLJbgS4tQrEb1NZuxJsP6ACL1sLa0Q8S/ocTW6R6exJe
fXEM4/P2S3lrx5l0r9hwo5LWlSWxzde7sNtSt78KLFAJAQYLfEJdeBmHfo7VniU6
QFKDGLQXZ+FCTvqE9rTUnR1f+EniWPQddaaBeLNPO3IENaR4TEI08QZzJFhAlaEZ
LX04Q4noRWBmhkulRgT45ytdcFWC1OlIJ4UVFJlbCajO7Imc4kD6wleMr8uGdrUi
/YUuidQlgfKe4aCEDqmQUnRXiERE0oXr0H64Pdp/AtPDPV6e+MY=
=/Qn6
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
