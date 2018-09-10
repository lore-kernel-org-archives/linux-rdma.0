From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Mon, 10 Sep 2018 17:04:52 -0600
Message-ID: <20180910230452.GA14095@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

This fixes one major regression with NFS and mlx4 due to the max_sg
rework in this merge window, tidies a few minor error_path
regressions, and various small fixes.

The HFI1 driver is broken this cycle due to a regression caused by a
PCI change, it is looking like Bjorn will merge a fix for this. Also,
the lingering ipoib issue I mentioned earlier still remains unfixed.

The following changes since commit 57361846b52bc686112da6ca5368d11210796804:

  Linux 4.19-rc2 (2018-09-02 14:37:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 8f28b178f71cc56eccf2a6e2c0ace17c82f900d7:

  RDMA/mlx4: Ensure that maximal send/receive SGE less than supported by HW (2018-09-06 13:16:12 -0600)

----------------------------------------------------------------
First rc pull request

- Fix possible FD type confusion crash

- Fix a user trigger-able crash in cxgb4

- Fix bad handling of IOMMU resources causing user controlled leaking in
  bnxt

- Add missing locking in ipoib to fix a rare 'stuck tx' situation

- Add missing locking in cma

- Add two missing missing uverbs cleanups on failure paths, regressions
  from this merge window

- Fix a regression from this merge window that caused RDMA NFS to not work
  with the mlx4 driver due to the max_sg changes

----------------------------------------------------------------
Aaron Knister (1):
      IB/ipoib: Avoid a race condition between start_xmit and cm_rep_handler

Artemy Kovalyov (1):
      IB/core: Release object lock if destroy failed

Jann Horn (1):
      RDMA/ucma: check fd type in ucma_migrate_id()

Leon Romanovsky (1):
      RDMA/mlx4: Ensure that maximal send/receive SGE less than supported by HW

Parav Pandit (2):
      RDMA/uverbs: Fix error cleanup path of ib_uverbs_add_one()
      RDMA/cma: Protect cma dev list with lock

Somnath Kotur (1):
      bnxt_re: Fix couple of memory leaks that could lead to IOMMU call traces

Steve Wise (1):
      iw_cxgb4: only allow 1 flush on user qps

 drivers/infiniband/core/cma.c            | 12 +++++++-----
 drivers/infiniband/core/rdma_core.c      |  2 ++
 drivers/infiniband/core/ucma.c           |  6 ++++++
 drivers/infiniband/core/uverbs_main.c    |  5 ++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  2 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |  2 +-
 drivers/infiniband/hw/cxgb4/qp.c         |  6 ++++++
 drivers/infiniband/hw/mlx4/main.c        |  8 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c  |  2 ++
 9 files changed, 33 insertions(+), 12 deletions(-)
