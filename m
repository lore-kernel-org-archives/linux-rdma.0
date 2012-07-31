From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 31 Jul 2012 13:56:45 -0700
Message-ID: <1343768205-13825-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Final RDMA changes for the 3.6 merge window:
 - Fix IPoIB to stop using unsafe linkage between networking neighbour
   layer and private path database.
 - Small fixes for bugs found by Fengguang Wu's automated builds.

----------------------------------------------------------------
Fengguang Wu (1):
      RDMA/cma: Use PTR_RET rather than if (IS_ERR(...)) + PTR_ERR

Mike Marciniszyn (1):
      IB/qib: Fix size of cc_supported_table_entries

Roland Dreier (3):
      RDMA/ocrdma: Fix check of GSI CQs
      RDMA/ucma: Convert open-coded equivalent to memdup_user()
      Merge branches 'cma', 'ipoib', 'ocrdma' and 'qib' into for-next

Shlomo Pongratz (1):
      IPoIB: Use a private hash table for path lookup in xmit path

 drivers/infiniband/core/cma.c                  |    5 +-
 drivers/infiniband/core/ucma.c                 |   19 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    4 +-
 drivers/infiniband/hw/qib/qib.h                |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   56 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   16 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  646 ++++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   57 +--
 8 files changed, 555 insertions(+), 258 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
