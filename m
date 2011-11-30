From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Wed, 30 Nov 2011 09:50:59 -0800
Message-ID: <1322675459-24792-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes:

 - Fixes for missing RCU read locking due to net neighbour changes
 - Fix for IPoIB softlockup in error path
 - Low-level driver fixes to cxgb4 and qib

Thanks!

Eric Dumazet (1):
      IB: Fix RCU lockdep splats

Jonathan Lallinger (1):
      RDMA/cxgb4: Fix iw_cxgb4 count_rcqes() logic

Kumar Sanghvi (1):
      RDMA/cxgb4: Fix retry with MPAv1 logic for MPAv2

Mike Marciniszyn (3):
      IB/qib: Don't use schedule_work()
      IB/qib: Fix over-scheduling of QSFP work
      IB/ipoib: Prevent hung task or softlockup processing multicast response

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib', 'misc' and 'qib' into for-next

 drivers/infiniband/core/addr.c                 |    9 ++++++---
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    4 ++++
 drivers/infiniband/hw/cxgb4/cm.c               |   10 +++++++++-
 drivers/infiniband/hw/cxgb4/cq.c               |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |    6 ++++--
 drivers/infiniband/hw/qib/qib_iba7322.c        |   18 +++++++++---------
 drivers/infiniband/hw/qib/qib_qsfp.c           |   12 ------------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   13 ++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   20 ++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   13 +++++++++----
 10 files changed, 62 insertions(+), 45 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
