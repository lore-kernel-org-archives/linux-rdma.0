From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 01 Mar 2010 23:56:28 -0800
Message-ID: <adaeik3tavn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get my current pile for the 2.6.34 merge window:

Alexander Chiang (18):
      IB/uverbs: Convert *cdev to cdev in struct ib_uverbs_device
      IB/uverbs: Remove dev_table
      IB/uverbs: Use stack variable 'devnum' in ib_uverbs_add_one
      IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
      IB/uverbs: Increase maximum devices supported
      IB/uverbs: Pack struct ib_uverbs_event_file tighter
      IB/uverbs: Whitespace cleanup
      IB/umad: Convert *cdev to cdev in struct ib_umad_port
      IB/umad: Remove port_table[]
      IB/umad: Use stack variable 'devnum' in ib_umad_init_port
      IB/umad: Use stack variable 'base' in ib_umad_init_port
      IB/umad: Increase maximum devices supported
      IB/umad: Clean whitespace
      IB/ucm: Use stack variable 'devnum' in ib_ucm_add_one
      IB/ucm: Use stack variable 'base' in ib_ucm_add_one
      IB/ucm: Increase maximum devices supported
      IB/ucm: Clean whitespace errors
      IB/core: Pack struct ib_device a little tighter

Alexander Schmidt (3):
      IB/ehca: Do not turn off irqs in tasklet context
      IB/ehca: Allow access for ib_query_qp()
      IB/ehca: Require in_wc in process_mad()

Bart Van Assche (1):
      IB/srp: Split send and recieve CQs to reduce number of interrupts

Chien Tung (1):
      RDMA/nes: Add support for KR device id 0x0110

Eli Cohen (2):
      IB/mlx4: Simplify retrieval of ib_device
      IB/core: Fix and clean up ib_ud_header_init()

Faisal Latif (3):
      RDMA/nes: Use atomic counters for CM listener create and destroy
      RDMA/nes: Fix crash when listener destroyed during loopback setup
      RDMA/nes: Multiple disconnects cause crash during AE handling

Jiri Slaby (1):
      RDMA: Use rlimit helpers

Or Gerlitz (11):
      IPoIB: Remove TX moderation settings from ethtool support
      RDMA/nes: Change WQ overflow return code
      IB/iser: Revert commit bba7ebb "avoid recv buffer exhaustion"
      IB/iser: New receive buffer posting logic
      IB/iser: Remove atomic counter for posted receive buffers
      IB/iser: Use different CQ for send completions
      IB/iser: Simplify send flow/descriptors
      IB/iser: Use atomic allocations
      IB/iser: Remove unnecessary connection checks
      IB/iser: Use libiscsi passthrough mode
      IB/iser: Remove redundant locking from iser scsi command response flow

Roland Dreier (11):
      IB/uverbs: Use anon_inodes instead of private infinibandeventfs
      IB/srp: Clean up error path in srp_create_target_ib()
      Merge branch 'cma' into for-next
      Merge branch 'cxgb3' into for-next
      Merge branch 'ehca' into for-next
      Merge branch 'ipoib' into for-next
      Merge branch 'iser' into for-next
      Merge branch 'mlx4' into for-next
      Merge branch 'nes' into for-next
      Merge branch 'srp' into for-next
      Merge branch 'misc' into for-next

Sean Hefty (1):
      RDMA/cm: Remove unused definition of RDMA_PS_SCTP

Steve Wise (5):
      RDMA/cxgb3: Remove BUG_ON() on CQ rearm failure
      RDMA/cxgb3: Doorbell overflow avoidance and recovery
      RDMA/cxgb3: Increase the max CQ depth
      RDMA/cxgb3: Don't allocate the SW queue for user mode CQs
      RDMA/cxgb3: Mark RDMA device with CXIO_ERROR_FATAL when removing

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/core/ucm.c                  |   63 +++-
 drivers/infiniband/core/ud_header.c            |   14 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/core/user_mad.c             |  173 +++++----
 drivers/infiniband/core/uverbs.h               |   11 +-
 drivers/infiniband/core/uverbs_main.c          |  234 +++++------
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |   15 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    4 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |   17 +-
 drivers/infiniband/hw/cxgb3/iwch.c             |   80 ++++-
 drivers/infiniband/hw/cxgb3/iwch.h             |    2 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |    9 +-
 drivers/infiniband/hw/ehca/ehca_irq.c          |    5 +-
 drivers/infiniband/hw/ehca/ehca_qp.c           |    4 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +-
 drivers/infiniband/hw/mlx4/qp.c                |    4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |    2 +-
 drivers/infiniband/hw/nes/nes.c                |    1 +
 drivers/infiniband/hw/nes/nes.h                |    9 +-
 drivers/infiniband/hw/nes/nes_cm.c             |   11 +-
 drivers/infiniband/hw/nes/nes_hw.c             |  488 ++++++++++++-----------
 drivers/infiniband/hw/nes/nes_hw.h             |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c            |   61 +---
 drivers/infiniband/hw/nes/nes_verbs.c          |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   10 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       |   47 ++-
 drivers/infiniband/ulp/iser/iscsi_iser.h       |   97 +++---
 drivers/infiniband/ulp/iser/iser_initiator.c   |  506 ++++++++----------------
 drivers/infiniband/ulp/iser/iser_memory.c      |   64 +---
 drivers/infiniband/ulp/iser/iser_verbs.c       |  281 +++++++-------
 drivers/infiniband/ulp/srp/ib_srp.c            |   91 +++--
 drivers/infiniband/ulp/srp/ib_srp.h            |    6 +-
 drivers/net/cxgb3/adapter.h                    |    5 +
 drivers/net/cxgb3/cxgb3_main.c                 |   57 +++-
 drivers/net/cxgb3/cxgb3_offload.h              |    5 +-
 drivers/net/cxgb3/regs.h                       |   16 +
 drivers/net/cxgb3/sge.c                        |   10 +-
 drivers/net/cxgb3/t3_hw.c                      |    5 +-
 include/rdma/ib_pack.h                         |    1 +
 include/rdma/ib_verbs.h                        |    4 +-
 include/rdma/rdma_cm.h                         |    1 -
 44 files changed, 1221 insertions(+), 1210 deletions(-)
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
