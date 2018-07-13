From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 13 Jul 2018 11:13:31 -0600
Message-ID: <20180713171331.GA27807@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Second pull request for -rc

Things have been quite slow, only 6 RC patches have been sent to the
list. Lots of stuff in for-next already though.

The following changes since commit 6f0d349d922ba44e4348a17a78ea51b7135965b1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-06-25 15:58:17 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to d63c46734c545ad0488761059004a65c46efdde3:

  RDMA/mlx5: Fix memory leak in mlx5_ib_create_srq() error path (2018-07-11 14:16:13 -0600)

----------------------------------------------------------------
Regression, user visible bugs, and crashing fixes:

- cxgb4 could wrongly fail MR creation due to a typo

- Various crashes if the wrong QP type is mixed in with APIs that expect
  other types

- Syzkaller oops

- Using ERR_PTR and NULL together cases HFI1 to crash in some cases

- mlx5 memory leak in error unwind

----------------------------------------------------------------
Kamal Heib (1):
      RDMA/mlx5: Fix memory leak in mlx5_ib_create_srq() error path

Leon Romanovsky (3):
      RDMA/uverbs: Protect from attempts to create flows on unsupported QP
      RDMA/uverbs: Fix slab-out-of-bounds in ib_uverbs_ex_create_flow
      RDMA/uverbs: Don't fail in creation of multiple flows

Michael J. Ruhl (1):
      IB/hfi1: Fix incorrect mixing of ERR_PTR and NULL return values

Steve Wise (1):
      iw_cxgb4: correctly enforce the max reg_mr depth

 drivers/infiniband/core/uverbs_cmd.c     | 28 +++++++++++++++++-----------
 drivers/infiniband/hw/cxgb4/mem.c        |  2 +-
 drivers/infiniband/hw/hfi1/rc.c          |  2 +-
 drivers/infiniband/hw/hfi1/uc.c          |  4 ++--
 drivers/infiniband/hw/hfi1/ud.c          |  4 ++--
 drivers/infiniband/hw/hfi1/verbs_txreq.c |  4 ++--
 drivers/infiniband/hw/hfi1/verbs_txreq.h |  4 ++--
 drivers/infiniband/hw/mlx5/srq.c         | 18 ++++++++++++------
 8 files changed, 39 insertions(+), 27 deletions(-)

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJbSN24AAoJEDht9xV+IJsa31gP/26hmxUoeTswL/2tYQ5bA/HN
PjH3WGG90qPOI2aDxl/eWYuju5xmeE2aCc2s/tJ4PXIcCJwKx6OdJ/fneXMHsuun
oYT1z5DCk3zlXdsHMQz6XqOoSMVyEdKz3y0WMQn7DJtOIq/6XXRRAvTDIIDpOs4B
IQGY7VZSn+qjnV8pyQs8L6kDoUU1Sppa9pQlx/zY+HFwXLDom8btgzkBaKF9j8SL
IZZXi26P+Fku9acDeTRTl66fAYYxieSBdfYUwiJHJmdp3KgMcdqoKamQbhUkrh7V
hsND5rLh/slQvIm4RCP2uNhT9d7KVAA5VzylurLlfl4+VZisuzmaX0tjkdX9JbGh
2LL86nBvql6+Kbqs+6jYu+BoDFGR2HrDELWr/PlHqBu7Qe0HJgQGUkwRVSXPzblI
fEa6OeQGBLDJxsNonvkCk9Q5JtiucNgub1J8iaLq/w/SrK6JZ3UuxiNgOnT8ksck
fQatESKpSNsBdWRRP8p26HH/4OgyT8KYCYXlwqSl9S0rJFcci+Ov8zupx/DIGAd+
6wuA7qeqmHY7ix29Y+Bn+kZ/RB6kBD4fhlbj6VKjwxZbN1OWmhNScbshhR40z/Dh
/3+DrZ+BHYBf2ZrI9ZG9b3bAV2H3J5yXmk7h//1Y2sLt6405GjQnKu0xbzXAv/zI
9XQcHnM7bwFyvEdRHvdl
=bcbr
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
