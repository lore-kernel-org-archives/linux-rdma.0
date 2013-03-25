From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 25 Mar 2013 09:42:03 -0700
Message-ID: <1364229723-6092-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Small batch of InfiniBand/RDMA fixes for 3.9:

 - Fix for TX lockup in IPoIB
 - QLogic -> Intel update for qib driver
 - Small static checker fix for qib
 - Fix error path return value in cxgb4

----------------------------------------------------------------
Dan Carpenter (1):
      IB/ipath: Silence a static checker warning

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib' and 'qib' into for-next

Vinit Agnihotri (1):
      IB/qib: change QLogic to Intel

Wei Yongjun (1):
      RDMA/cxgb4: Fix error return code in create_qp()

 drivers/infiniband/hw/cxgb4/qp.c          | 4 +++-
 drivers/infiniband/hw/ipath/ipath_verbs.c | 2 +-
 drivers/infiniband/hw/qib/Kconfig         | 6 +++---
 drivers/infiniband/hw/qib/qib_driver.c    | 5 +++--
 drivers/infiniband/hw/qib/qib_iba6120.c   | 3 ++-
 drivers/infiniband/hw/qib/qib_init.c      | 8 ++++----
 drivers/infiniband/hw/qib/qib_sd7220.c    | 4 ++--
 drivers/infiniband/hw/qib/qib_verbs.c     | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 8 ++++++--
 firmware/Makefile                         | 2 +-
 firmware/{qlogic => intel}/sd7220.fw.ihex | 0
 11 files changed, 27 insertions(+), 19 deletions(-)
 rename firmware/{qlogic => intel}/sd7220.fw.ihex (100%)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
