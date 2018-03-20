From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Tue, 20 Mar 2018 17:17:47 -0600
Message-ID: <20180320231747.GA9216@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Fourth pull request for -rc.

Not much exciting here, almost entirely syzkaller fixes. This is going to
be on ongoing theme for some time, I think. Both Google and Mellanox are now
running syzkaller on different parts of the user API.

The following changes since commit 28e9091e3119933c38933cb8fc48d5618eb784c8:

  RDMA/mlx5: Fix integer overflow while resizing CQ (2018-03-09 18:10:48 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to e8980d67d6017c8eee8f9c35f782c4bd68e004c9:

  RDMA/ucma: Ensure that CM_ID exists prior to access it (2018-03-20 11:07:21 -0600)

----------------------------------------------------------------
Fourth pull request for 4.16-rc

- Many bug fixes related to syzkaller from Leon Romanovsky.
  These are still for the mlx driver and ucma interface.
- Fix a situation with port reuse for iWarp, discovered during scale-up
  testing
- Bug fixes for the profile and restrack patches accepted during this merge
  window
- Compile warning cleanups from Arnd, this is apparently the last warning
  to make 32 bit builds quite.

----------------------------------------------------------------
Arnd Bergmann (2):
      infiniband: qplib_fp: fix pointer cast
      infiniband: bnxt_re: use BIT_ULL() for 64-bit bit masks

Boris Pismenny (2):
      IB/mlx5: Fix out-of-bounds read in create_raw_packet_qp_rq
      IB/mlx5: Fix integer overflows in mlx5_ib_create_srq

Leon Romanovsky (7):
      RDMA/mlx5: Fix crash while accessing garbage pointer and freed memory
      RDMA/ucma: Fix access to non-initialized CM_ID object
      RDMA/ucma: Don't allow join attempts for unsupported AF family
      RDMA/ucma: Check AF family prior resolving address
      RDMA/ucma: Fix use-after-free access in ucma_close
      RDMA/verbs: Remove restrack entry from XRCD structure
      RDMA/ucma: Ensure that CM_ID exists prior to access it

Mark Bloch (1):
      IB/mlx5: Fix cleanup order on unload

Tatyana Nikolova (1):
      RDMA/core: Do not use invalid destination in determining port reuse

 drivers/infiniband/core/cma.c            | 15 ++++++++-----
 drivers/infiniband/core/ucma.c           | 36 +++++++++++++++++++++++---------
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  4 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |  4 ++--
 drivers/infiniband/hw/mlx5/main.c        | 21 +++++++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  3 ++-
 drivers/infiniband/hw/mlx5/mr.c          | 12 +++++++----
 drivers/infiniband/hw/mlx5/qp.c          | 23 +++++++++++++-------
 drivers/infiniband/hw/mlx5/srq.c         | 15 +++++++------
 include/linux/mlx5/driver.h              |  4 ++--
 include/rdma/ib_verbs.h                  |  4 ----
 12 files changed, 90 insertions(+), 53 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJasZaYAAoJEDht9xV+IJsaJn8P/RFgTjGlR71ysQ7h3QrGbf84
7LIq3vN1RGXN3H586OPqc3hMYbIfxIV2qTiusXP9DTGREdyl2c/MSzM42t3VlNKj
UFMM2tqYr73aAHwnPlRENRPddNI9Ju7ring+IZNKh9foVcHrXf604UNyVU8kEEak
SHxM0jj8nfvrtvtMJmOSV9VKu2rME/zbpfFa9Ch63Ze9+wO5ogyfsrKasIhNfLhQ
vaucDgvdt+BqQvI3ka/TrUp03rOw1hAfmKxtC4tIeQosseC6levCSWCiP2xnoFHI
GAXtEPidL/dP/dzmZdhBObEFS7JODuuh5sG3sBze5QcrClPUHMjMrlpH/1rxt4Gi
MksXqN6cObke6z5y6MOZ1ygLFskdOR/L6T2rBuZD7A1bS+AqQrxu4PMANR+U8scy
a7MsnBSiXm20m+UT+bYKdU2WLjW0S97sFQl2FKVTPgzn8SwVixeyqoZRaSifnYht
5jhiiV5ebmAeGbOMGS0IhemtHTkYk0ldZ7NuyBOmlLTW8yoq6//fEp8AVZ/HDCu+
20fpWC8f+l3Ln+coTtFoMswVRn9HqxIlSKCG210CIvNj5iM9mJ4k//I2hs+q5KGo
HWX7oryFLlRhFUtsRUhhuKdlnVzH8S82qZGHK0F4sZIX/k9FgneS32avwPGBVyWm
B5FXQ0aeKSJfxAjJx0EX
=EQhT
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
