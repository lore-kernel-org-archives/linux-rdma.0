From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 15 Dec 2009 23:41:41 -0800
Message-ID: <ada8wd39xhm.fsf@roland-alpha.cisco.com>
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

This will get all my pending 2.6.33 merge window stuff.  Sorry for
being so late, but I'm just now out from under my flu-induced
backlog.  None of the stuff here is in any way controversial: it's
pretty much all small fixes scattered around, with no major changes
included (we're saving those for 2.6.34).

Akinobu Mita (1):
      IB/ipath: Use bitmap_weight()

Alexander Schmidt (1):
      IB/ehca: Rework destroy_eq()

Bart Van Assche (2):
      IB: Clarify the documentation of ib_post_send()
      IB: Fix typo in ipoib.txt

Chien Tung (7):
      RDMA/nes: Add support for IB_WR_*INV
      RDMA/nes: Correct fast memory registration implementation
      RDMA/nes: Add additional SFP+ PHY uC status check and PHY reset
      RDMA/nes: Implement IB_SIGNAL_ALL_WR as an iWARP extension
      RDMA/nes: Clean up struct nes_qp
      RDMA/nes: Add max_cqe check to nes_create_cq()
      RDMA/nes: Update copyright and branding string

David J. Wilder (1):
      IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()

Eli Cohen (2):
      IB/mlx4: Remove unneeded code
      IB/mlx4: Remove limitation on LSO header size

Eric Dumazet (1):
      RDMA/addr: Use appropriate locking with for_each_netdev()

Faisal Latif (11):
      RDMA/nes: Fix MAX_CM_BUFFER define
      RDMA/nes: Fix query of ORD values
      RDMA/nes: MPA request/response error checking
      RDMA/nes: Resource not freed for REJECTed connections
      RDMA/nes: Fix crash in nes_accept()
      RDMA/nes: Abnormal listener exit causes loopback node crash
      RDMA/nes: Fix Xansation test crash on cm_node ref_count
      RDMA/nes: Check for zero STag
      RDMA/nes: Free kmap() resources
      RDMA/nes: FIN during MPA startup causes timeout
      RDMA/nes: Fix stale ARP issue

Frank Zago (5):
      RDMA/nes: In nes_post_send() always set bad_wr on error
      RDMA/nes: In nes_post_recv() always set bad_wr on error
      RDMA/amso1100: Fix error paths in post_send and post_recv
      IB/ehca: Fix error paths in post_send and post_recv
      RDMA/cxgb3: Fix error paths in post_send and post_recv

Jason Gunthorpe (2):
      RDMA/cma: Correct detection of SA Created MGID
      RDMA/cma: Fix AF_INET6 support in multicast joining

Julia Lawall (1):
      RDMA/nes: Pass correct size to ioremap_nocache()

Or Gerlitz (1):
      IB/iser: Rewrite SG handling for RDMA logic

Roel Kluin (1):
      IB/uverbs: Fix return of PTR_ERR() of wrong pointer in ib_uverbs_get_context()

Roland Dreier (1):
      Merge branches 'amso1100', 'cma', 'cxgb3', 'ehca', 'ipath', 'ipoib', 'iser', 'misc', 'mlx4' and 'nes' into for-next

Sean Hefty (7):
      RDMA/ucma: Add option to manually set IB path
      RDMA/cma: Replace net_device pointer with index
      IB/addr: Verify source and destination address families match
      IB/addr: Store net_device type instead of translating to RDMA transport
      RDMA/cm: fix loopback address support
      IB/addr: Simplify resolving IPv4 addresses
      IB/addr: Fix IPv6 routing lookup

Steve Wise (1):
      RDMA/cxgb3: Remove BUG_ON() on CQ rearm failure

Yevgeny Petrilin (1):
      mlx4_core: Fix parsing of reserved EQ cap

 Documentation/infiniband/ipoib.txt         |   10 +-
 drivers/infiniband/core/addr.c             |  275 ++++------
 drivers/infiniband/core/cma.c              |  133 +++--
 drivers/infiniband/core/sa_query.c         |    6 +
 drivers/infiniband/core/ucma.c             |   57 ++-
 drivers/infiniband/core/uverbs_cmd.c       |    2 +-
 drivers/infiniband/hw/amso1100/c2_qp.c     |   14 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c      |   32 +-
 drivers/infiniband/hw/ehca/ehca_classes.h  |    1 +
 drivers/infiniband/hw/ehca/ehca_eq.c       |    9 +-
 drivers/infiniband/hw/ehca/ehca_main.c     |    2 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c     |   67 +--
 drivers/infiniband/hw/ipath/ipath_driver.c |   10 +-
 drivers/infiniband/hw/mlx4/main.c          |    2 +-
 drivers/infiniband/hw/mlx4/qp.c            |   25 +-
 drivers/infiniband/hw/nes/Kconfig          |    9 +-
 drivers/infiniband/hw/nes/nes.c            |    5 +-
 drivers/infiniband/hw/nes/nes.h            |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c         |  201 +++++--
 drivers/infiniband/hw/nes/nes_cm.h         |    7 +-
 drivers/infiniband/hw/nes/nes_context.h    |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c         |   40 +-
 drivers/infiniband/hw/nes/nes_hw.h         |   29 +-
 drivers/infiniband/hw/nes/nes_nic.c        |    2 +-
 drivers/infiniband/hw/nes/nes_user.h       |    3 +-
 drivers/infiniband/hw/nes/nes_utils.c      |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c      |  817 ++++++++++++++--------------
 drivers/infiniband/hw/nes/nes_verbs.h      |   23 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |    1 +
 drivers/infiniband/ulp/iser/iser_memory.c  |  122 ++---
 drivers/net/mlx4/fw.c                      |    3 +-
 include/linux/mlx4/device.h                |    1 +
 include/rdma/ib_addr.h                     |   36 +-
 include/rdma/ib_sa.h                       |    6 +
 include/rdma/ib_user_sa.h                  |   16 +
 include/rdma/ib_verbs.h                    |    5 +
 include/rdma/rdma_user_cm.h                |    6 +-
 net/rds/ib.c                               |    4 +-
 net/rds/iw.c                               |    4 +-
 39 files changed, 1084 insertions(+), 907 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
