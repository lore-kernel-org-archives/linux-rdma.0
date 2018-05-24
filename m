From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 24 May 2018 14:51:15 -0600
Message-ID: <20180524205114.GA8656@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Second pull request for -rc

We haven't had quite the same rate of -rc patches this cycle, not much Syzkaller
related stuff right now as the remaining bugs it has found require some kind of
significant redesign to solve. The -next branch is also somewhat quieter than
normal.

This is pretty much just the usual array of smallish driver bugs.

There is a patch that cleans up the kconfig around INFINIBAND_ADDR_TRANS that
touches a few files, this is related the the patch introducing
INFINIBAND_ADDR_TRANS that was accepted earlier this cycle
  f7cb7b85be55 ("IB: make INFINIBAND_ADDR_TRANS configurable")

The following changes since commit 9aa169213d1166d30ae357a44abbeae93459339d:

  RDMA/cma: Do not query GID during QP state transition to RTR (2018-05-03 15:45:18 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 55ba49cbcef37053d973f9a45bc58818c333fe13:

  RDMA/hns: Move the location for initializing tmp_len (2018-05-23 15:45:44 -0600)

----------------------------------------------------------------
Merge candidates for 4.17-rc

- Remove bouncing addresses from the MAINTAINERS file
- Kernel oops and bad error handling fixes for hfi, i40iw, cxgb4, and hns drivers
- Various small LOC behavioral/operational bugs in mlx5, hns, qedr and i40iw drivers
- Two fixes for patches already sent during the merge window
- A long standing bug related to not decreasing the pinned pages count in the right
  MM was found and fixed

----------------------------------------------------------------
Alexandru Moise (1):
      nvmet,rxe: defer ip datagram sending to tasklet

Andrew Boyer (3):
      RDMA/i40iw: Avoid panic when objects are being created and destroyed
      RDMA/i40iw: Avoid reference leaks when processing the AEQ
      RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint

Christophe Jaillet (1):
      iw_cxgb4: Fix an error handling path in 'c4iw_get_dma_mr()'

Daria Velikovsky (1):
      RDMA/mlx5: Use proper spec flow label type

Greg Thelen (1):
      IB: remove redundant INFINIBAND kconfig dependencies

Jason Gunthorpe (1):
      IB/uverbs: Fix uverbs_attr_get_obj

Kalderon, Michal (1):
      RDMA/qedr: Fix doorbell bar mapping for dpi > 1

Leon Romanovsky (1):
      MAINTAINERS: Remove bouncing @mellanox.com addresses

Lidong Chen (1):
      IB/umem: Use the correct mm during ib_umem_release

Michael J. Ruhl (1):
      IB/hfi1: Use after free race condition in send context error path

Mustafa Ismail (2):
      i40iw: Fix memory leak in error path of create QP
      i40iw: Use correct address in dst_neigh_lookup for IPv6

Yishai Hadas (1):
      RDMA/mlx5: Don't assume that medium blueFlame register exists

oulijun (13):
      RDMA/hns: Add rq inline flags judgement
      RDMA/hns: Bugfix for rq record db for kernel
      RDMA/hns: Load the RoCE dirver automatically
      RDMA/hns: Update convert function of endian format
      RDMA/hns: Add return operation when configured global param fail
      RDMA/hns: Not support qp transition from reset to reset for hip06
      RDMA/hns: Fix the bug with rq sge
      RDMA/hns: Set desc_dma_addr for zero when free cmq desc
      RDMA/hns: Enable inner_pa_vld filed of mpt
      RDMA/hns: Set NULL for __internal_mr
      RDMA/hns: Fix the bug with NULL pointer
      RDMA/hns: Bugfix for cq record db for kernel
      RDMA/hns: Move the location for initializing tmp_len

 MAINTAINERS                                |  6 ---
 drivers/infiniband/core/umem.c             |  7 +---
 drivers/infiniband/hw/cxgb4/mem.c          |  4 +-
 drivers/infiniband/hw/hfi1/chip.c          |  4 ++
 drivers/infiniband/hw/hns/hns_roce_cq.c    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |  3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 32 +++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_main.c  |  2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 10 ++++-
 drivers/infiniband/hw/i40iw/i40iw.h        |  1 +
 drivers/infiniband/hw/i40iw/i40iw_cm.c     |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c     |  4 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c   |  7 ++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c  | 13 +++++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.h  |  1 +
 drivers/infiniband/hw/mlx5/main.c          |  2 +-
 drivers/infiniband/hw/mlx5/qp.c            | 18 +++++----
 drivers/infiniband/hw/qedr/verbs.c         | 60 +++++++++++++++---------------
 drivers/infiniband/sw/rxe/rxe_verbs.c      | 10 +----
 drivers/infiniband/ulp/srpt/Kconfig        |  2 +-
 drivers/nvme/host/Kconfig                  |  2 +-
 drivers/nvme/target/Kconfig                |  2 +-
 drivers/staging/lustre/lnet/Kconfig        |  2 +-
 fs/cifs/Kconfig                            |  2 +-
 include/rdma/ib_umem.h                     |  1 -
 include/rdma/uverbs_ioctl.h                | 10 ++---
 net/9p/Kconfig                             |  2 +-
 net/rds/Kconfig                            |  2 +-
 net/sunrpc/Kconfig                         |  2 +-
 29 files changed, 116 insertions(+), 98 deletions(-)
