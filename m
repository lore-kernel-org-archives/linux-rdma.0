From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 1 Jun 2018 10:47:32 -0600
Message-ID: <20180601164732.GA21374@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Third pull request for -rc

Just 3 small last minute regressions that were found in the last week. The
Broadcom fix is a bit big for rc7, but since it is fixing driver crash
regressions that were merged via netdev into rc1, I am sending it.

The following changes since commit 55ba49cbcef37053d973f9a45bc58818c333fe13:

  RDMA/hns: Move the location for initializing tmp_len (2018-05-23 15:45:44 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to a840c93ca7582bb6c88df2345a33f979b7a67874:

  IB/core: Fix error code for invalid GID entry (2018-05-29 12:08:37 -0600)

----------------------------------------------------------------
Merge candidates for 4.17-rc

- bnxt netdev changes merged this cycle caused the bnxt RDMA driver to crash under
  certain situations
- Arnd found (several, unfortunately) kconfig problems with the patches adding
  INFINIBAND_ADDR_TRANS. Reverting this last part, will fix it more fully
  outside -rc.
- Subtle change in error code for a uapi function caused breakage in userspace.
  This was bug was subtly introduced cycle

----------------------------------------------------------------
Arnd Bergmann (1):
      IB: Revert "remove redundant INFINIBAND kconfig dependencies"

Devesh Sharma (1):
      RDMA/bnxt_re: Fix broken RoCE driver due to recent L2 driver changes

Parav Pandit (1):
      IB/core: Fix error code for invalid GID entry

 drivers/infiniband/core/cache.c            |  2 +-
 drivers/infiniband/hw/bnxt_re/main.c       | 55 ++++++++++++++++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 94 +++++++++++++++++++-----------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  3 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 61 +++++++++++++------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  3 +
 drivers/infiniband/ulp/srpt/Kconfig        |  2 +-
 drivers/nvme/host/Kconfig                  |  2 +-
 drivers/nvme/target/Kconfig                |  2 +-
 drivers/staging/lustre/lnet/Kconfig        |  2 +-
 fs/cifs/Kconfig                            |  2 +-
 net/9p/Kconfig                             |  2 +-
 net/rds/Kconfig                            |  2 +-
 net/sunrpc/Kconfig                         |  2 +-
 14 files changed, 172 insertions(+), 62 deletions(-)

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJbEXihAAoJEDht9xV+IJsa2qYP/3GB77ZPYc+joHaEjvFD8AOd
BFr91XpB1lun32b3KfRs3j9MBNLeILhLMasWnVZeQXH95x4i5oG7cQ3ItVvk5DvO
bbrjDyUl1gj496IQ0ur0SvSqFkn9+/4/+eMBw1ov9oq3J0LNoPwOLR+SPsRfo3DH
51OtZiortaF7EkJEwyUCmz3rSP0Khwqx0MSWLmAd05t1Ca9Cbsa8NFJx/zNT9c44
Oy8YsH+eGeY+Kr2Hbv4eZhD1UC8TI6ixVt2zTpHTwnbqtQXuEU1OW2zrwbVlzqAp
/VS1ZA4VamDG6h5GOQtfFVEWL5z6VYQHU6WIOq8zNMYyIjqS7kPalV9/7XmDVS98
lZC8eCe8JF8sg33bI4mmYD0aisJmzzuuRx3xmxlHm1Wb7NbwBoRqg+sC9Z7ybPcw
W3lY++c550f7zXiS0XSR1ZirlvAYQt6b5JtRLfMWNsrt9k6gQWMtE726J1tVKO4D
Da7KbGBLhrH5dioLLAngKxgTelieNe67XhVBICY2KQl9SPdgSYVyMyfcRPN5foTe
f01Vs3kOD188EJ96AGfITBZ8jGPlFijrwtbe52qY4VlYSQG9NDgOBMeIuAEy5gcG
JEjjWU9umMlyg567vKfG5I98B8pc7vZealUnyqh1j128eZ4kud8dzPAY+tjP6vp5
KqHcdkVbcRSMdVQVUyci
=SfxG
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
