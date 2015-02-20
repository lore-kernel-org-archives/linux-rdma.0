From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 20 Feb 2015 09:08:21 -0800
Message-ID: <1424452101-10247-1-git-send-email-roland@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA changes for 3.20 merge window:
 - Re-enable on-demand paging changes with stable ABI
 - Fairly large set of ocrdma HW driver fixes
 - Some qib HW driver fixes
 - Other miscellaneous changes

----------------------------------------------------------------
Andreea-Cristina Bernat (2):
      IB/qib: Replace rcu_assign_pointer() with RCU_INIT_POINTER() in qib_qp.c
      IB/qib: Replace rcu_assign_pointer() with RCU_INIT_POINTER() in qib_keys.c

Ariel Nahum (1):
      IB/iser: Release the iscsi endpoint if ep_disconnect wasn't called

Bart Van Assche (1):
      MAINTAINERS: Update SRP initiator entry

Dan Carpenter (2):
      IB/mlx5: Fix error code in get_port_caps()
      RDMA/ocrdma: Fix off by one in ocrdma_query_gid()

Devesh Sharma (4):
      RDMA/ocrdma: Report correct count of interrupt vectors while registering ocrdma device
      RDMA/ocrdma: Discontinue support of RDMA-READ-WITH-INVALIDATE
      RDMA/ocrdma: Honor return value of ocrdma_resolve_dmac
      RDMA/ocrdma: set vlan present bit for user AH

Eli Cohen (1):
      IB/core: Add support for extended query device caps

Haggai Eran (3):
      IB/core: Properly handle registration of on-demand paging MRs after dereg
      IB/core: Add on demand paging caps to ib_uverbs_ex_query_device
      IB/mlx5: Enable the ODP capability query verb

Hariprasad S (2):
      RDMA/cxgb4: Serialize CQ event upcalls with CQ destruction
      RDMA/cxgb4: Don't hang threads forever waiting on WR replies

Ilya Nelkenbaum (1):
      IB/core: When marshaling ucma path from user-space, clear unused fields

Jack Morgenstein (1):
      IB/mlx4: In mlx4_ib_demux_cm, print out GUID in host-endian order

Majd Dibbiny (3):
      IB/mlx4: Fix memory leak in __mlx4_ib_modify_qp
      IB/mlx4: Bug fixes in mlx4_ib_resize_cq
      IB/mlx5: Update the dev in reg_create

Mike Marciniszyn (3):
      IB/qib: Fix sizeof checkpatch warnings
      IB/qib: Fix checkpatch warnings
      IB/qib: Add blank line after declaration

Mitesh Ahuja (7):
      RDMA/ocrdma: Add support for IB stack compliant stats in sysfs.
      RDMA/ocrdma: Increase the GID table size.
      RDMA/ocrdma: Move PD resource management to driver.
      RDMA/ocrdma: Host crash on destroying device resources
      RDMA/ocrdma: Add support for interrupt moderation
      RDMA/ocrdma: remove reference of ocrdma_dev out of ocrdma_qp structure
      RDMA/ocrdma: Update the ocrdma module version string

Mitko Haralanov (1):
      IB/qib: Do not write EEPROM

Moshe Lazer (1):
      IB/core: Fix deadlock on uverbs modify_qp error flow

Or Gerlitz (1):
      IB/mlx4: Fix wrong usage of IPv4 protocol for multicast attach/detach

Padmanabh Ratnakar (1):
      RDMA/ocrdma: Report correct state in ibv_query_qp

Rasmus Villemoes (2):
      RDMA/ocrdma: Help gcc generate better code for ocrdma_srq_toggle_bit
      RDMA/ocrdma: Use unsigned for bit index

Rickard Strandqvist (1):
      IB/ipath: Remove unused function in ipath_wc_ppc64

Roi Dayan (1):
      IB/iser: Use correct dma direction when unmapping SGs

Roland Dreier (1):
      Merge branches 'core', 'cxgb4', 'iser', 'mlx4', 'mlx5', 'ocrdma', 'odp', 'qib' and 'srp' into for-next

Sagi Grimberg (1):
      IB/iser: Fix memory regions possible leak

Selvin Xavier (2):
      RDMA/ocrdma: Debugfs enhancments for ocrdma driver
      RDMA/ocrdma: Allow expansion of the SQ CQEs via buddy CQ expansion of the QP

Vinit Agnihotri (1):
      IB/qib: Add support for the new QMH7360 card

 MAINTAINERS                                   |   2 +-
 drivers/infiniband/core/ucma.c                |   3 +
 drivers/infiniband/core/umem_odp.c            |   3 +-
 drivers/infiniband/core/uverbs.h              |   1 +
 drivers/infiniband/core/uverbs_cmd.c          | 158 +++++++++----
 drivers/infiniband/core/uverbs_main.c         |   1 +
 drivers/infiniband/hw/cxgb4/ev.c              |   9 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |  29 ++-
 drivers/infiniband/hw/ipath/ipath_kernel.h    |   3 -
 drivers/infiniband/hw/ipath/ipath_wc_ppc64.c  |  13 --
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c |  15 --
 drivers/infiniband/hw/mlx4/cm.c               |   2 +-
 drivers/infiniband/hw/mlx4/cq.c               |   7 +-
 drivers/infiniband/hw/mlx4/main.c             |  10 +-
 drivers/infiniband/hw/mlx4/qp.c               |   6 +-
 drivers/infiniband/hw/mlx5/main.c             |   4 +-
 drivers/infiniband/hw/mlx5/mr.c               |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma.h         |  38 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |  38 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |   6 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c      | 312 ++++++++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h      |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c    |  12 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h     |  68 +++++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c   | 241 ++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h   |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   | 183 ++++++++++++---
 drivers/infiniband/hw/qib/qib.h               |  16 +-
 drivers/infiniband/hw/qib/qib_common.h        |   4 +-
 drivers/infiniband/hw/qib/qib_debugfs.c       |   1 -
 drivers/infiniband/hw/qib/qib_diag.c          |   9 +-
 drivers/infiniband/hw/qib/qib_driver.c        |   5 +-
 drivers/infiniband/hw/qib/qib_eeprom.c        | 198 +---------------
 drivers/infiniband/hw/qib/qib_file_ops.c      |  26 ++-
 drivers/infiniband/hw/qib/qib_fs.c            |   9 +-
 drivers/infiniband/hw/qib/qib_iba6120.c       |  15 +-
 drivers/infiniband/hw/qib/qib_iba7220.c       |  14 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |  52 +++--
 drivers/infiniband/hw/qib/qib_init.c          |  12 +-
 drivers/infiniband/hw/qib/qib_intr.c          |   1 -
 drivers/infiniband/hw/qib/qib_keys.c          |   4 +-
 drivers/infiniband/hw/qib/qib_mad.c           |  20 +-
 drivers/infiniband/hw/qib/qib_mmap.c          |   2 +-
 drivers/infiniband/hw/qib/qib_mr.c            |  10 +-
 drivers/infiniband/hw/qib/qib_pcie.c          |  10 +-
 drivers/infiniband/hw/qib/qib_qp.c            |   8 +-
 drivers/infiniband/hw/qib/qib_qsfp.c          |  13 +-
 drivers/infiniband/hw/qib/qib_rc.c            |   4 +-
 drivers/infiniband/hw/qib/qib_ruc.c           |   8 +-
 drivers/infiniband/hw/qib/qib_sd7220.c        |   9 +-
 drivers/infiniband/hw/qib/qib_sysfs.c         |  28 +--
 drivers/infiniband/hw/qib/qib_twsi.c          |   5 +-
 drivers/infiniband/hw/qib/qib_tx.c            |   1 +
 drivers/infiniband/hw/qib/qib_ud.c            |   2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c     |   8 +-
 drivers/infiniband/hw/qib/qib_verbs.c         |  15 +-
 drivers/infiniband/hw/qib/qib_verbs_mcast.c   |   4 +-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c     |   7 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h      |   4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c  |  16 +-
 drivers/infiniband/ulp/iser/iser_memory.c     |   9 +-
 drivers/infiniband/ulp/iser/iser_verbs.c      |  27 ++-
 include/uapi/rdma/ib_user_verbs.h             |  23 ++
 63 files changed, 1212 insertions(+), 560 deletions(-)
