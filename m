From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 29 Nov 2018 22:52:51 +0000
Message-ID: <20181129225240.GA2179@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

First rc pull request

This is a bit later than usual for our first -rc but I'm not seeing
anything worry-some in the RDMA tree right now. Quiet so far this -rc
cycle, only a few internal driver related bugs and a small series
fixing ODP bugs found by more advanced testing.

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 7bca603a69c0c239654a8f0bcb99e1a60b30040c:

  RDMA/mlx5: Initialize return variable in case pagefault was skipped (2018-11-29 15:16:45 -0700)

----------------------------------------------------------------
First rc pull request

A set of small driver and core code fixes:

- Small series fixing longtime user triggerable bugs in the
  ODP processing inside mlx5 and core code

- Various small driver malfunctions and crashes (use after, free, error
  unwind, implementation bugs)

- A misfunction of the RDMA GID cache that can be triggered by the
  administrator

----------------------------------------------------------------
Artemy Kovalyov (3):
      IB/mlx5: Skip non-ODP MR when handling a page fault
      IB/umem: Set correct address to the invalidation function
      IB/mlx5: Fix page fault handling for MW

Kamal Heib (1):
      RDMA/rdmavt: Fix rvt_create_ah function signature

Leon Romanovsky (1):
      RDMA/mlx5: Initialize return variable in case pagefault was skipped

Majd Dibbiny (1):
      RDMA/mlx5: Fix fence type for IB_WR_LOCAL_INV WR

Michael Guralnik (1):
      IB/mlx5: Avoid load failure due to unknown link width

Parav Pandit (1):
      RDMA/core: Add GIDs while changing MAC addr only for registered ndev

Sagi Grimberg (1):
      iser: set sector for ambiguous mr status errors

Selvin Xavier (2):
      RDMA/bnxt_re: Fix system hang when registration with L2 driver fails
      RDMA/bnxt_re: Avoid accessing the device structure after it is freed

Yishai Hadas (1):
      net/mlx5: Fix XRC SRQ umem valid bits

Yixian Liu (1):
      RDMA/hns: Bugfix pbl configuration for rereg mr

Yonatan Cohen (1):
      IB/mlx5: Fix XRC QP support after introducing extended atomic

 drivers/infiniband/core/roce_gid_mgmt.c    |   6 +-
 drivers/infiniband/core/umem_odp.c         |  20 ++---
 drivers/infiniband/hw/bnxt_re/main.c       |   3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 128 ++++++++++++++---------------
 drivers/infiniband/hw/mlx5/main.c          |  29 +++----
 drivers/infiniband/hw/mlx5/odp.c           |  10 +++
 drivers/infiniband/hw/mlx5/qp.c            |  22 ++---
 drivers/infiniband/sw/rdmavt/ah.c          |   4 +-
 drivers/infiniband/sw/rdmavt/ah.h          |   3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c   |   7 +-
 include/linux/mlx5/mlx5_ifc.h              |  12 ++-
 11 files changed, 121 insertions(+), 123 deletions(-)

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlwAbbQACgkQOG33FX4g
mxp8qA/6Ag6znaRCHWIbRYSEWymYjJ1fxSX5wwAhdNX7Rmr0lu4u0+UPdYfjPdoH
0m5YJSLW2QavvXrykipClW+tnvAv+Y9G8nfRUQ42v/V0YEEko2hjQ/2hxu7cJzSB
dtqYKD/DfRUkaIBuAXYU64V5pR+/cYXVDj3+6e4AoX0YfrxjlWtwIjU8iWvgeb7A
+UnmR5jkq34d+TPmSpDq6myadjcIsNlDoNZh72y+mlbESLX90T1xSegCRlxeFxsP
9Ri7PckIWUQae9LxKBbwcmHL8pFslxR4YQLz2QyaQh7nzRxk+d9uQSozhdNDQ3Nr
oDiksGx4LbqnoU9swbNVZNfNZOhOesh6I6tsWKUDpqObJZ1kzRViW4K56Q5WcQ0T
Fi800b62Sw7pMgdPK3RIneA8GXKqRd7gTYG19iLTD0ZDAMO0soP+ccvxVJ5qk5pU
VQEk18UvCvoF5xKQuefT5pehr0lEKdtuSo/I9ZODwoszIHtng7CT9l8lfbyKGNPV
SgMNwe4rJBchbp8tTDTa+OHOxfqpI4C8lBgvZ7FdPa3Bi67hEtdeGl9YJXnnz1mX
HbmDLQLPLxSssI6abWq0n2wB6sF9JGMvW4/1Jq3ajcqnaa9P+gZdh5VSxaLDJ5ya
YDWU9n4BL4JB9OUpNBsrdS7a+QBo6tGc2DrAKvmdeOYgWzO3p6s=
=V5h+
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
