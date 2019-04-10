From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 10 Apr 2019 18:46:23 +0000
Message-ID: <20190410184618.GA6370@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Second rc pull request

The following changes since commit 8c2ffd9174779014c3fe1f96d9dc3641d9175f00:

  Linux 5.1-rc2 (2019-03-24 14:02:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to d737b25b1ae0540ba13cbd45ebb9b58a1d6d7f0d:

  IB/hfi1: Do not flush send queue in the TID RDMA second leg (2019-04-10 15:09:30 -0300)

----------------------------------------------------------------
5.1 Second RC pull request

Several driver bug fixes posted in the last several weeks

- Several bug fixes for the hfi1 driver 'TID RDMA' functionality merged
  into 5.1. Since TID RDMA is on by default these all seem to be
  regressions.

- Wrong software permission checks on memory in mlx5

- Memory leak in vmw_pvrdma during driver remove

- Several bug fixes for hns driver features merged into 5.1

----------------------------------------------------------------
Kaike Wan (5):
      IB/hfi1: Failed to drain send queue when QP is put into error state
      IB/hfi1: Clear the IOWAIT pending bits when QP is put into error state
      IB/hfi1: Eliminate opcode tests on mr deref
      IB/hfi1: Fix the allocation of RSM table
      IB/hfi1: Do not flush send queue in the TID RDMA second leg

Kamal Heib (1):
      RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove

Lijun Ou (1):
      RDMA/hns: Fix bug that caused srq creation to fail

Moni Shoua (1):
      IB/mlx5: Reset access mask when looping inside page fault handler

Yangyang Li (1):
      RDMA/hns: Bugfix for SCC hem free

 drivers/infiniband/hw/hfi1/chip.c              | 26 +++++++++++++++------
 drivers/infiniband/hw/hfi1/qp.c                |  4 +++-
 drivers/infiniband/hw/hfi1/rc.c                |  4 ++--
 drivers/infiniband/hw/hfi1/tid_rdma.c          | 31 +++++++-------------------
 drivers/infiniband/hw/hns/hns_roce_hem.c       |  6 +++--
 drivers/infiniband/hw/hns/hns_roce_mr.c        |  4 ++--
 drivers/infiniband/hw/hns/hns_roce_qp.c        |  3 ---
 drivers/infiniband/hw/mlx5/odp.c               |  3 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |  2 ++
 9 files changed, 42 insertions(+), 41 deletions(-)

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlyuOfcACgkQOG33FX4g
mxpNXRAAiJwNLggwfD3C90U4f/yXq7aAAEQjjbnu0q0LYkkAO+11OTyyu3X9maWr
Lyz4kZI4SUcW/cQNq04r0thMU7bmwJeifmiTTUVAn8KTisvbfHg7/4DAg1uOR+pf
1QamYCqwN4tYZuFpBEzn9nkOEeuN+ZplgLHwJLOMBKk9BIuJx1HhSoqvWr9UZjZm
Y7x8fWBmkgFB9p1xLzRznepxTZLL/r6YMRQxLeVVuTDmTqJ9Qz35oMi3fspHpPaD
v9isrQfrAYlxKePhk+cDcxE04FhTw2m63qUIiG0R2/f9npJiHfIkMebXX0gqhE1g
OzUUyMXY2d8F4V6J/Rt7Gje7colHLadFl4jYKEwMzJTcRBa+/XqfqVkVcrmQNI2D
d6GqWGmw6bW9YA8FV0jzh+7N5wPqYPC4kmAvScWuEpFIKde7dFxM6un4xq9fDJr0
0XzlialrNBLu79RjqPVKjkyfrjoKiByFB5grLq3gDMolyF6fQklp0fualRpJklfE
NrM6fjo6HHW0426ETZdbONnZPDFm6AV8o1KqcEEweHzK+gXW7IjWQVlELek7grls
LQVoQ6ZDDcsR3G2qJG4P+8R/S3lTxTsXvqSsA+tDgmCsZmcK1c7w+mv7B5D09tSo
wYT5xVhhr3Sxme8cBijJ6TUEm+sBnSUUBb1ytl7YniDrONPRwIY=
=gApV
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
