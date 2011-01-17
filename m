From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 17 Jan 2011 13:55:24 -0800
Message-ID: <adaei8byz3n.fsf@cisco.com>
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

This will get the last batch of InfiniBand/RDMA patches for the merge
window.  The biggest thing here is Tejun's conversion of the RDMA
stack away from flush_scheduled_work(); the remaining stuff is mostly
driver fixes, with an SRP compile warning fix and a vzalloc()
conversion patch thrown in.

Aleksey Senin (1):
      IB/mlx4: Handle protocol field in multicast table

Bart Van Assche (1):
      IB/srp: Test only once whether iu allocation succeeded

Joe Perches (1):
      RDMA: Use vzalloc() to replace vmalloc()+memset(0)

John L. Burr (1):
      IB/mthca: Fix driver when sizeof (phys_addr_t) > sizeof (long)

Maciej Sosnowski (4):
      RDMA/nes: Fix bonding on iw_nes
      RDMA/nes: Generate IB_EVENT_PORT_ERR/PORT_ACTIVE events
      RDMA/nes: Fix SFP+ link down detection issue with switch port disable
      RDMA/nes: Fix incorrect SFP+ link status detection on driver init

Roland Dreier (2):
      mlx4_{core, ib, en}: Fix driver when sizeof (phys_addr_t) > sizeof (long)
      Merge branches 'misc', 'mlx4', 'mthca', 'nes' and 'srp' into for-next

Tejun Heo (1):
      RDMA: Update workqueue usage

 drivers/infiniband/core/cache.c                |    4 +-
 drivers/infiniband/core/device.c               |   11 ++-
 drivers/infiniband/core/sa_query.c             |    2 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c       |    5 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c         |    5 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |    5 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |   11 +--
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |    5 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    2 +-
 drivers/infiniband/hw/mlx4/main.c              |   12 ++-
 drivers/infiniband/hw/mthca/mthca_catas.c      |    5 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_mr.c         |    2 +-
 drivers/infiniband/hw/nes/nes.c                |   35 ++++++++-
 drivers/infiniband/hw/nes/nes.h                |    4 +
 drivers/infiniband/hw/nes/nes_cm.c             |    8 ++-
 drivers/infiniband/hw/nes/nes_hw.c             |   95 ++++++++++++++++++++++++
 drivers/infiniband/hw/nes/nes_hw.h             |   10 +++
 drivers/infiniband/hw/nes/nes_nic.c            |   78 ++++++++++++++++---
 drivers/infiniband/hw/nes/nes_verbs.c          |   37 +++++++++-
 drivers/infiniband/hw/qib/qib_iba7220.c        |    7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c        |   14 ++--
 drivers/infiniband/hw/qib/qib_init.c           |   33 ++-------
 drivers/infiniband/hw/qib/qib_qsfp.c           |    9 +-
 drivers/infiniband/hw/qib/qib_verbs.h          |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   10 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    3 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   19 ++---
 drivers/net/mlx4/catas.c                       |    6 +-
 drivers/net/mlx4/en_main.c                     |    3 +-
 drivers/net/mlx4/main.c                        |    2 +-
 drivers/net/mlx4/mcg.c                         |   23 +++---
 include/linux/mlx4/device.h                    |   10 ++-
 include/linux/mlx4/driver.h                    |    6 +-
 include/rdma/ib_verbs.h                        |    3 +
 38 files changed, 351 insertions(+), 144 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
