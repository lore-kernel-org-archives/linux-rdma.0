From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 27 Sep 2018 12:24:32 -0600
Message-ID: <20180927182432.GA11505@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

Second rc pull request

This has a few fixes for smaller regressions introduced this cycle and
the usual various driver oops fixes.

There is one long standing race bug in the comp_channel that Steve was
able to reproduce, track down and fix.

I believe the HFI1 driver regression breakage has been fixed in
Bjorn's tree and I'm currently expecting the lingering ipoib issue to
be fixed in the netdev tree, but patches are still delayed due to
various holidays this month.

Thanks,
Jason

The following changes since commit 8f28b178f71cc56eccf2a6e2c0ace17c82f900d7:

  RDMA/mlx4: Ensure that maximal send/receive SGE less than supported by HW (2018-09-06 13:16:12 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 5c5702e259dc66e6fceed5117effab79c186e87a:

  RDMA/core: Set right entry state before releasing reference (2018-09-25 15:01:09 -0600)

----------------------------------------------------------------
Second rc pull request

- Fix a long standing race bug when destroying comp_event file descriptors

- srp, hfi1, bnxt_re: Various driver crashes from missing validation and
  other cases

- Fixes for regressions in patches merged this window in the gid cache,
  devx, ucma and uapi.

----------------------------------------------------------------
Bart Van Assche (1):
      IB/srp: Avoid that sg_reset -d ${srp_device} triggers an infinite loop

Cong Wang (1):
      ucma: fix a use-after-free in ucma_resolve_ip()

Ira Weiny (1):
      IB/hfi1: Fix SL array bounds check

Majd Dibbiny (1):
      RDMA/uverbs: Fix validity check for modify QP

Mark Bloch (1):
      IB/uverbs: Free uapi on destroy

Michael J. Ruhl (3):
      IB/hfi1: Invalid user input can result in crash
      IB/hfi1: Fix context recovery when PBC has an UnsupportedVL
      IB/hfi1: Fix destroy_qp hang after a link down

Parav Pandit (1):
      RDMA/core: Set right entry state before releasing reference

Selvin Xavier (1):
      RDMA/bnxt_re: Fix system crash during RDMA resource initialization

Steve Wise (2):
      cxgb4: fix abort_req_rss6 struct
      RDMA/uverbs: Atomically flush and mark closed the comp event queue

Yishai Hadas (1):
      IB/mlx5: Destroy the DEVX object upon error flow

 drivers/infiniband/core/cache.c             | 68 ++++++++++-----------
 drivers/infiniband/core/ucma.c              |  2 +
 drivers/infiniband/core/uverbs_cmd.c        | 68 ++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c       |  1 +
 drivers/infiniband/core/uverbs_uapi.c       |  1 +
 drivers/infiniband/hw/bnxt_re/main.c        | 93 ++++++++++++-----------------
 drivers/infiniband/hw/hfi1/chip.c           |  6 +-
 drivers/infiniband/hw/hfi1/pio.c            | 51 ++++++++++++----
 drivers/infiniband/hw/hfi1/pio.h            |  2 +
 drivers/infiniband/hw/hfi1/user_sdma.c      |  2 +-
 drivers/infiniband/hw/hfi1/verbs.c          |  8 ++-
 drivers/infiniband/hw/mlx5/devx.c           |  5 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  1 -
 14 files changed, 184 insertions(+), 130 deletions(-)

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlutIF0ACgkQOG33FX4g
mxpvPQ//QrTdL0zKmuB/nk+HrfArI3Pp0+ZYkOCm9093d92f/aqDuyRE9GUu8Y1j
YfRYlFmvr78yGX6NMTjTKZYJ5S7B7gwMHdWXIhk6N+95dJ9q2ohCS/wjoWWT9qzf
IpJGP9FIpsASD3bMCdfhxjgl4fELcOkDFdQuEZI1zDwlee4sIRDmW/g/CiJQdlK1
FCfBSkANL85s7uD1A5jVSvAsEXXLzQpqK+t6CTdEfVVliJSYUHnehgOQvMU2Pku+
Nys9v7XWi+x1zAL8TkVUEr1xG4UygDvZlRlQBWJ481/rdzLWfh6tfC+TQAK4xPVd
N3VCw6OtwbhZxUDd3KNB/BCZfuGNuog5322aiP3BQcCfiuA+zXm3eOjMo7n38V8P
S5p02YwP2KanmBlBJA6J5FMJwMDTgGD30qU5nUbvoOpDeaj1tlFpQrrUUO0Vea7o
NRYkc81OQHjAA/pc8uZ9FV31tk6DAfI3z++hOC1lqQcz8YtRwd6ohUd2xnHt+VMn
9hS3FtXt9HYl8DGl2sv4y03WCt2Y4er0EW/qbEZEov5NFM9htPI4ObOeL5q2PRfy
+3LfhTwqtZjSaEt+BmIRDvlzBGZinqH0tHmoC1IrGHskljUiyHRd97A4L87IW0Iq
7mAMTfy3QMQdKLJTZAwP8Mmrv99zl4rrBk81Nu6v0izVZ1WsP+U=
=CuWB
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
