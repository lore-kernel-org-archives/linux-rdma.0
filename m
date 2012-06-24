From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Sun, 24 Jun 2012 05:09:13 -0700
Message-ID: <1340539753-19165-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-fixes

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.5-rc:
 - Fixes to new ocrdma driver
 - Typo in test in CMA

----------------------------------------------------------------
Dan Carpenter (1):
      RDMA/ocrdma: Fix off by one in ocrdma_query_gid()

Mahesh Vardhamanaiah (2):
      RDMA/ocrdma: Correct reported max queue sizes
      RDMA/ocrdma: Correct queue SGE calculation

Parav Pandit (2):
      RDMA/ocrdma: Fixed GID table for vlan and events
      RDMA/ocrdma: Fixed RQ error CQE polling

Roland Dreier (1):
      Merge branches 'cma' and 'ocrdma' into for-linus

Sean Hefty (1):
      RDMA/cma: QP type check on received REQs should be AND not OR

 drivers/infiniband/core/cma.c               |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   18 ++++----
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   63 +++++++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   12 ++---
 6 files changed, 55 insertions(+), 46 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
