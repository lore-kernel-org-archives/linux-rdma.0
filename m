From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 17 Aug 2012 11:38:29 -0700
Message-ID: <1345228709-14247-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Grab bag of InfiniBand/RDMA fixes:
 - IPoIB fixes for regressions introduced by path database conversion
 - mlx4 fixes for bugs with large memory systems and regressions from SR-IOV patches
 - RDMA CM fix for passing bad event up to userspace
 - Other minor fixes

----------------------------------------------------------------
Bart Van Assche (1):
      IB/srp: Fix a race condition

Jack Morgenstein (1):
      IB/mlx4: Fix possible deadlock on sm_lock spinlock

Julia Lawall (1):
      IB/qib: Fix error return code in qib_init_7322_variables()

Kleber Sacilotto de Souza (1):
      IB/mlx4: Check iboe netdev pointer before dereferencing it

Masanari Iida (1):
      IB: Fix typos in infiniband drivers

Roland Dreier (3):
      RDMA/ocrdma: Don't call vlan_dev_real_dev() for non-VLAN netdevs
      mlx4_core: Clean up buddy bitmap allocation
      Merge branches 'cma', 'ipoib', 'misc', 'mlx4', 'ocrdma', 'qib' and 'srp' into for-next

Shlomo Pongratz (2):
      IB/ipoib: Add missing locking when CM object is deleted
      IB/ipoib: Fix RCU pointer dereference of wrong object

Tatyana Nikolova (1):
      RDMA/ucma.c: Fix for events with wrong context on iWARP

Yishai Hadas (2):
      mlx4_core: Allow large mlx4_buddy bitmaps
      mlx4_core: Fix integer overflow issues around MTT table

 drivers/infiniband/core/ucma.c               |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    2 +-
 drivers/infiniband/hw/mlx4/mad.c             |   16 +++--
 drivers/infiniband/hw/mlx4/main.c            |    5 +-
 drivers/infiniband/hw/mlx4/qp.c              |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   16 ++---
 drivers/infiniband/hw/qib/qib_iba7322.c      |    4 +-
 drivers/infiniband/hw/qib/qib_sd7220.c       |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    3 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   87 +++++++++++++++++++-------
 drivers/infiniband/ulp/srpt/ib_srpt.c        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c     |    9 ++-
 drivers/net/ethernet/mellanox/mlx4/icm.h     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c      |   27 +++++---
 drivers/net/ethernet/mellanox/mlx4/profile.c |    4 +-
 18 files changed, 130 insertions(+), 65 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
