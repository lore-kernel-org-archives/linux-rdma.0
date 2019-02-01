From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 1 Feb 2019 17:41:11 +0000
Message-ID: <20190201174106.GA25156@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Second rc pull request

Still expecting some more bug fixes for new stuff merged in 5.0, but
at this rate that stuff is looking likely to go into 5.1.

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 7b21b69ab203136fdc153c7707fa6c409e523c2e:

  IB/uverbs: Fix OOPs in uverbs_user_mmap_disassociate (2019-01-29 13:57:22 -0700)

----------------------------------------------------------------
Second 5.0 rc pull request

Still not much going on, the usual set of OOP's and driver updates this time.

- Fix two uapi breakage regressions in mlx5 drivers

- Various oops fixes in hfi1, mlx4, umem, uverbs, and ipoib

- A protocol bug fix for hfi1 preventing it from implementing the verbs
  API properly, and a compatability fix for EXEC STACK user programs

- Fix missed refcounting in the 'advise_mr' patches merged this
  cycle.

- Fix wrong use of the uABI in the hns SRQ patches merged this cycle.

----------------------------------------------------------------
Artemy Kovalyov (1):
      RDMA/umem: Add missing initialization of owning_mm

Brian Welty (1):
      IB/{hfi1, qib}: Fix WC.byte_len calculation for UD_SEND_WITH_IMM

Feras Daoud (1):
      IB/ipoib: Fix for use-after-free in ipoib_cm_tx_start

Jack Morgenstein (1):
      IB/mlx4: Fix using wrong function to destroy sqp AHs under SRIOV

Jason Gunthorpe (2):
      RDMA/device: Expose ib_device_try_get(()
      IB/mlx5: Fix how advise_mr() launches async work

Lijun Ou (1):
      RDMA/hns: Update the kernel header file of hns

Mark Bloch (2):
      RDMA/mlx5: Fix check for supported user flags when creating a QP
      RDMA/mlx5: Fix flow creation on representors

Michael J. Ruhl (1):
      IB/hfi1: Remove overly conservative VM_EXEC flag check

Mike Marciniszyn (1):
      IB/hfi1: Add limit test for RC/UC send via loopback

Yishai Hadas (3):
      IB/uverbs: Fix OOPs upon device disassociation
      IB/uverbs: Fix ioctl query port to consider device disassociation
      IB/uverbs: Fix OOPs in uverbs_user_mmap_disassociate

 drivers/infiniband/core/core_priv.h               |  1 -
 drivers/infiniband/core/device.c                  | 13 +++++++++---
 drivers/infiniband/core/umem_odp.c                |  3 +++
 drivers/infiniband/core/uverbs_main.c             | 25 +++++++++++++++--------
 drivers/infiniband/core/uverbs_std_types_device.c |  8 +++++++-
 drivers/infiniband/hw/hfi1/file_ops.c             |  2 +-
 drivers/infiniband/hw/hfi1/ud.c                   |  1 -
 drivers/infiniband/hw/hns/hns_roce_srq.c          | 10 +++++++--
 drivers/infiniband/hw/mlx4/mad.c                  |  6 +++---
 drivers/infiniband/hw/mlx5/flow.c                 |  3 +--
 drivers/infiniband/hw/mlx5/odp.c                  | 10 ++++-----
 drivers/infiniband/hw/mlx5/qp.c                   | 16 ++++++++-------
 drivers/infiniband/hw/qib/qib_ud.c                |  1 -
 drivers/infiniband/sw/rdmavt/qp.c                 |  7 ++++++-
 drivers/infiniband/ulp/ipoib/ipoib.h              |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |  3 +--
 include/rdma/ib_verbs.h                           | 24 ++++++++++++++++++++--
 include/uapi/rdma/hns-abi.h                       |  5 +++++
 18 files changed, 97 insertions(+), 42 deletions(-)

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlxUhK8ACgkQOG33FX4g
mxpmNhAAmSLASZl//oihgybO2fez3/V5VLEhBcOpJf3bHDf0XYE83fjrZzrFE3EO
dujw2Zb9Xpe4r21ejQwgpHMeHmqgrzplk0Lmk2xGEK3lEUNIGz+SX7PDr7J9IcWm
ojw31ySL4l0GmqUYQVTbQFUg1aNa+1ewa2CRRtlusM8BlrY+A6DrhnNpgLPVBJ2K
rvOc69Sp/UBb7MLgopT94PBEpT1SvRiCH5D360Vw6u0nMvW4h5P7OfHab3jMbgy1
LpkbjmTdZnNHdM0J47Bk2dnU7ATu4C4bpCoZhlrefJPItg7wdt+DZo1y833vk/Ah
c+uDyBhaLsuZIJCve5er8P0RcC5/10mI51HSTap3uQHIxYkD45XED/h45qlRsuJQ
SypLy5lAuVXmMcgUYxBXde/BFXoBlHJwAWOqGGDRobW7PtOp+s5L7Ca06DQ4vbPy
nB0yun7lGxfSfet0mMV/b4ifPH8boe3ekpAS9mbwoVZQjAy7yXs+SUYOZcWF/qDD
Nc3dsxkzBr5wpTUjNLKHpiAblrCMZJCujWg7nHbYWABAKBtWphXK9/xBWyBSXVwe
B+S8Ke5iG2sBdbmqAYZTgWRpHOIok9nkY9YTYljX8gQjVObxh5vviHL9VDmQChL2
ZkFP5zI+Mqy9OhJkO08HgZVgA/1dgaBOEgpl27AVgkLoVaCNlko=
=PCvs
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
