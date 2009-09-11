From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 10 Sep 2009 21:23:26 -0700
Message-ID: <ada3a6ujeip.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the batch of RDMA/InfiniBand changes for the 2.6.32
merge window:

Alexander Schmidt (1):
      IB/ehca: Make port autodetect mode the default

Arputham Benjamin (2):
      mlx4_core: Distinguish multiple devices in /proc/interrupts
      IB/mthca: Distinguish multiple devices in /proc/interrupts

Chien Tung (1):
      RDMA/nes: Map MTU to IB_MTU_* and correctly report link state

Don Wood (10):
      RDMA/nes: Update refcnt during disconnect
      RDMA/nes: Allocate work item for disconnect event handling
      RDMA/nes: Change memory allocation for cqp request to GFP_ATOMIC
      RDMA/nes: Clean out CQ completions when QP is destroyed
      RDMA/nes: Add CQ error handling
      RDMA/nes: Implement Terminate Packet
      RDMA/nes: Use flush mechanism to set status for wqe in error
      RDMA/nes: Make poll_cq return correct number of wqes during flush
      RDMA/nes: Use the flush code to fill in cqe error
      RDMA/nes: Rework the disconn routine for terminate and flushing

Hal Rosenstock (1):
      IB/mad: Allow tuning of QP0 and QP1 sizes

Jack Morgenstein (3):
      IB/uverbs: Return ENOSYS for unimplemented commands (not EINVAL)
      IB/mlx4: Don't allow userspace open while recovering from catastrophic error
      IB/mthca: Don't allow userspace open while recovering from catastrophic error

Jason Gunthorpe (1):
      IPoIB: Check multicast address format

Joachim Fenkes (2):
      IB/ehca: Construct MAD redirect replies from request MAD
      IB/ehca: Fix CQE flags reporting

Marcin Slusarz (1):
      IB: Use printk_once() for driver versions

Roel Kluin (2):
      IB/ipath: strncpy() doesn't always NUL-terminate
      RDMA/amso1100: Check kmalloc() result in c2_register_device()

Roland Dreier (15):
      IPoIB: Remove unused <rdma/ib_cache.h> includes
      IPoIB: Drop priv->lock before calling ipoib_send()
      IB/mad: Check hop count field in directed route MAD to avoid array overflow
      IB: Use DEFINE_SPINLOCK() for static spinlocks
      mlx4_core: Use pci_request_regions()
      mlx4_core: Remove unnecessary includes of <linux/init.h>
      IB/mlx4: Annotate CQ locking
      mlx4_core: Allocate and map sufficient ICM memory for EQ context
      IB/mthca: Remove unnecessary include of <asm/page.h>
      IB/mthca: Remove unnecessary include of <linux/init.h>
      IB/mthca: Annotate CQ locking
      IB/mad: Fix possible lock-lock-timer deadlock
      MAINTAINERS: InfiniBand/RDMA mailing list transition to vger
      Merge branches 'cxgb3', 'ehca', 'ipath', 'ipoib', 'misc', 'mlx4', 'mthca' and 'nes' into for-linus
      Merge branch 'mad' into for-linus

Steve Wise (8):
      RDMA/cxgb3: iwch_unregister_device leaks memory
      RDMA/cxgb3: Set the appropriate IO channel in rdma_init work requests
      RDMA/cxgb3: Handle port events properly
      RDMA/cxgb3: Don't free endpoints early
      RDMA/cxgb3: Wake up any waiters on peer close/abort
      RDMA/cxgb3: Don't ignore insert_handle() failures
      RDMA/cxgb3: Clean up properly on FW mismatch failures
      RDMA/iwcm: Reject the connection when the cm_id is destroyed

Tobias Klauser (1):
      RDMA/amso1100: Use %pM conversion specifier

Yevgeny Petrilin (1):
      mlx4_core: Avoid double free_icms

Yossi Etigin (1):
      IB/core: Fix send multicast group leave retry

 MAINTAINERS                                    |   12 +-
 drivers/infiniband/core/iwcm.c                 |    1 +
 drivers/infiniband/core/mad.c                  |   35 +-
 drivers/infiniband/core/mad_priv.h             |    3 +
 drivers/infiniband/core/multicast.c            |   10 +-
 drivers/infiniband/core/sa_query.c             |    7 +-
 drivers/infiniband/core/smi.c                  |    8 +
 drivers/infiniband/core/uverbs_main.c          |   10 +-
 drivers/infiniband/hw/amso1100/c2.c            |    6 +-
 drivers/infiniband/hw/amso1100/c2_provider.c   |   24 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |    5 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |    6 +
 drivers/infiniband/hw/cxgb3/iwch.c             |   37 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |   68 ++-
 drivers/infiniband/hw/cxgb3/iwch_cm.h          |    9 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c         |   21 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   52 ++-
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c         |    8 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c         |    6 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c          |   47 ++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |    2 +-
 drivers/infiniband/hw/ipath/ipath_mad.c        |    2 +-
 drivers/infiniband/hw/mlx4/main.c              |   12 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    1 +
 drivers/infiniband/hw/mlx4/qp.c                |   12 +-
 drivers/infiniband/hw/mthca/mthca_catas.c      |    1 +
 drivers/infiniband/hw/mthca/mthca_config_reg.h |    2 -
 drivers/infiniband/hw/mthca/mthca_dev.h        |    1 +
 drivers/infiniband/hw/mthca/mthca_eq.c         |   17 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |    8 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    3 +
 drivers/infiniband/hw/mthca/mthca_provider.h   |    1 +
 drivers/infiniband/hw/mthca/mthca_qp.c         |   12 +-
 drivers/infiniband/hw/mthca/mthca_reset.c      |    1 -
 drivers/infiniband/hw/nes/nes.h                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |  128 ++--
 drivers/infiniband/hw/nes/nes_cm.h             |    2 -
 drivers/infiniband/hw/nes/nes_hw.c             |  767 +++++++++++++++++-------
 drivers/infiniband/hw/nes/nes_hw.h             |  103 ++++
 drivers/infiniband/hw/nes/nes_utils.c          |    5 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |  204 +++++--
 drivers/infiniband/hw/nes/nes_verbs.h          |   16 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   21 +
 drivers/net/cxgb3/cxgb3_main.c                 |    6 +-
 drivers/net/cxgb3/cxgb3_offload.c              |    6 +-
 drivers/net/cxgb3/cxgb3_offload.h              |    8 +-
 drivers/net/mlx4/cq.c                          |    1 -
 drivers/net/mlx4/eq.c                          |   77 +--
 drivers/net/mlx4/icm.c                         |    1 -
 drivers/net/mlx4/main.c                        |   37 +-
 drivers/net/mlx4/mcg.c                         |    1 -
 drivers/net/mlx4/mlx4.h                        |    7 +-
 drivers/net/mlx4/mr.c                          |    1 -
 drivers/net/mlx4/pd.c                          |    1 -
 drivers/net/mlx4/profile.c                     |    2 -
 drivers/net/mlx4/qp.c                          |    2 -
 drivers/net/mlx4/reset.c                       |    1 -
 drivers/net/mlx4/srq.c                         |    2 -
 drivers/scsi/cxgb3i/cxgb3i_init.c              |   12 +-
 63 files changed, 1278 insertions(+), 595 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
