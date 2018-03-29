From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 29 Mar 2018 13:17:29 -0600
Message-ID: <20180329191729.GA24187@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Fifth pull request for -rc.

It has been fairly silent lately on our -rc front. Big queue of patches on the
mailing list going to for-next though.

The following changes since commit e8980d67d6017c8eee8f9c35f782c4bd68e004c9:

  RDMA/ucma: Ensure that CM_ID exists prior to access it (2018-03-20 11:07:21 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 84652aefb347297aa08e91e283adf7b18f77c2d5:

  RDMA/ucma: Introduce safer rdma_addr_size() variants (2018-03-28 16:13:36 -0600)

----------------------------------------------------------------
Fifth pull request for 4.16-rc

Bug fixes:
- qedr driver bugfixes causing application hangs, wrong uapi errnos, and a
  race condition
- 3 syzkaller found bugfixes in the ucma uapi

Regression fixes for things introduced in 4.16:
- Crash on error introduced in mlx5 UMR flow
- Crash on module unload/etc introduced by bad interaction of restrack
  and mlx5 patches this cycle
- Typo in a two line syzkaller bugfix causing a bad regression
- Coverity report of nonsense code in hns driver

----------------------------------------------------------------
Chien Tin Tung (1):
      RDMA/ucma: Correct option size check using optlen

Colin Ian King (1):
      RDMA/hns: ensure for-loop actually iterates and free's buffers

Jason Gunthorpe (1):
      RDMA/rdma_cm: Fix use after free race with process_one_req

Kalderon, Michal (3):
      RDMA/qedr: fix QP's ack timeout configuration
      RDMA/qedr: Fix rc initialization on CNQ allocation failure
      RDMA/qedr: Fix QP state initialization race

Leon Romanovsky (3):
      RDMA/restrack: Move restrack_clean to be symmetrical to restrack_init
      RDMA/ucma: Check that device is connected prior to access it
      RDMA/ucma: Check that device exists prior to accessing it

Mark Bloch (1):
      IB/mlx5: Don't clean uninitialized UMR resources

Roland Dreier (1):
      RDMA/ucma: Introduce safer rdma_addr_size() variants

 drivers/infiniband/core/addr.c             | 25 ++++++++++++++++
 drivers/infiniband/core/device.c           |  3 +-
 drivers/infiniband/core/ucma.c             | 47 +++++++++++++++++-------------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |  2 +-
 drivers/infiniband/hw/mlx5/main.c          | 12 ++++++--
 drivers/infiniband/hw/mlx5/mr.c            |  3 ++
 drivers/infiniband/hw/qedr/main.c          |  3 +-
 drivers/infiniband/hw/qedr/verbs.c         | 45 +++++++++++++++++++---------
 include/rdma/ib_addr.h                     |  2 ++
 9 files changed, 102 insertions(+), 40 deletions(-)
