From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 20 Jun 2018 15:00:36 -0600
Message-ID: <20180620210036.GA4734@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

First pull request for -rc

Here are eight fairly small fixes collected over the last two weeks.

Thanks,
Jason

The following changes since commit c1191a19fecad92b73c25770a7f47174280ca564:

  RDMA/mlx5: Update SPDX tags to show proper license (2018-06-05 14:04:20 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 375dc53d032fc11e98036b5f228ad13f7c5933f5:

  IB/rxe: Fix missing completion for mem_reg work requests (2018-06-18 11:36:13 -0600)

----------------------------------------------------------------
4.18-rc

Regression and crashing bug fixes:

- mlx4/5: Fixes for issues found from various checkers
- A resource tracking and uverbs regression in the core code
- qedr: NULL pointer regression found during testing
- rxe: Various small bugs

----------------------------------------------------------------
Bharat Potnuri (1):
      RDMA/core: Save kernel caller name when creating CQ using ib_create_cq()

Christophe Jaillet (1):
      IB/mlx4: Fix an error handling path in 'mlx4_ib_rereg_user_mr()'

Gustavo A. R. Silva (1):
      IB/mlx5: Fix memory leak in mlx5_ib_create_flow

Jason Gunthorpe (1):
      IB/uverbs: Fix ordering of ucontext check in ib_uverbs_write

Kalderon, Michal (1):
      RDMA/qedr: Fix NULL pointer dereference when running over iWARP without RDMA-CM

Vijay Immanuel (1):
      IB/rxe: Fix missing completion for mem_reg work requests

Zhu Yanjun (1):
      IB/rxe: avoid double kfree skb

weiyongjun (A) (1):
      IB/mlx5: Fix return value check in flow_counters_set_data()

 drivers/infiniband/core/uverbs_main.c | 14 ++++++++++----
 drivers/infiniband/core/verbs.c       | 14 ++++++++------
 drivers/infiniband/hw/mlx4/mr.c       |  7 +++++--
 drivers/infiniband/hw/mlx5/main.c     | 36 ++++++++++++++++++++---------------
 drivers/infiniband/hw/qedr/verbs.c    |  3 +++
 drivers/infiniband/sw/rxe/rxe_req.c   |  5 ++++-
 include/rdma/ib_verbs.h               | 13 ++++++++-----
 7 files changed, 59 insertions(+), 33 deletions(-)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJbKsByAAoJEDht9xV+IJsaH+4QAJNtd1WhZmlurMBMbKUaOqjC
7IQk9HmsY6F4/DUYBD3Q1naOu4zweWugtk1Dw8Et1kP2WQxF5DJoHK/9dE6rtTZ3
Wc+KO8BnaGaCJvAVit8IzBowGKW2VX93GC1qawtfZouJFSNAungbgzmNjKnKlWa3
ruqL/D6BxGlh49zd5ZaMNzCxdiGb3XI1gBjltFL3IdcpZnXmBy4hR9645aKLNXt8
UySZF5grUzXPxJV1R4esXzOs34UgRArCxrEpwvx1K5r3HcaGkbLgkkT9s9DzmsJ2
aVJQ6PCXZXmjcarFh3MI8eK5NwgLse3ud7oIJ/14a0QVXBrnFR3BYlThThCqZCrX
uFVrndDRDk1d08fDsQJRaL7OWIfUXghOuBQg2yIJx54KtXRa1FQ/gH8z3mTWtCwd
SVOAcY/EEqM3XAvNkf5NsdddHXWqQ95/21foNZByP2EtV7Qlsxz84hjBpaoJ1ybk
vp/ubFP2pV4Adsz5V1ZnfG0mYOT1rxhGYGw+PMErpPLt5v5fJrvPt10djKRbQW4a
lrnsEqhyb/5qaqd7wFEZ9pEKoqQXg8Izzu9x1s6YbZnVBwIfNqwfoCTkZzD4BUQV
KWk45VEKSkMuCxkpdrigJ4e2yYmrMsRtGCj6zh7AmpS5B0tKmsvbpMCBecWq+GBc
G6aHY3ywIFw+P0wJM1yW
=l6Gm
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
