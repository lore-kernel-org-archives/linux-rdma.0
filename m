From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 17 Sep 2012 08:57:47 -0700
Message-ID: <1347897467-7323-1-git-send-email-roland@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Last set of InfiniBand/RDMA fixes for 3.6:
 - Couple more IPoIB fixes for regressions introduced by path database conversion
 - Minor other fixes to low-level drivers (cxgb4, mlx4, qib, ocrdma)

----------------------------------------------------------------
Mike Marciniszyn (1):
      IB/qib: Fix failure of compliance test C14-024#06_LocalPortNum

Parav Pandit (1):
      RDMA/ocrdma: Fix CQE expansion of unsignaled WQE

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib', 'mlx4', 'ocrdma' and 'qib' into for-next

Shlomo Pongratz (2):
      IPoIB: Fix memory leak in the neigh table deletion flow
      IPoIB: Fix AB-BA deadlock when deleting neighbours

Wei Yongjun (1):
      RDMA/cxgb4: Move dereference below NULL test

Yishai Hadas (1):
      mlx4_core: Fix integer overflows so 8TBs of memory registration works

 drivers/infiniband/hw/cxgb4/cm.c               |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    8 +-
 drivers/infiniband/hw/qib/qib_mad.c            |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   93 +++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 -
 drivers/net/ethernet/mellanox/mlx4/icm.c       |   30 +++++---
 drivers/net/ethernet/mellanox/mlx4/icm.h       |   10 +--
 8 files changed, 78 insertions(+), 75 deletions(-)
