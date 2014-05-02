From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  1 May 2014 17:09:10 -0700
Message-ID: <1398989350-31583-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA updates for 3.15-rc4:

 - cxgb4 hardware driver fixes

----------------------------------------------------------------
Hariprasad S (1):
      RDMA/cxgb4: Update Kconfig to include Chelsio T5 adapter

Steve Wise (3):
      RDMA/cxgb4: Fix endpoint mutex deadlocks
      RDMA/cxgb4: Force T5 connections to use TAHOE congestion control
      RDMA/cxgb4: Only allow kernel db ringing for T4 devs

 drivers/infiniband/hw/cxgb4/Kconfig       |  6 ++---
 drivers/infiniband/hw/cxgb4/cm.c          | 39 ++++++++++++++++++++++---------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |  1 +
 drivers/infiniband/hw/cxgb4/qp.c          | 13 +++++++----
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h | 14 +++++++++++
 5 files changed, 55 insertions(+), 18 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
