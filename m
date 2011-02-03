From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  3 Feb 2011 10:05:48 -0800
Message-ID: <1296756348-6351-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small things:
 - Low-level driver fixes to qib, cxgb4 and amso1100
 - Add PCI IDs for new Mellanox devices to mlx4
 - Add a dropped hunk of Tejun's workqueue conversion
 - Fix route query for iWARP connections

Mitko Haralanov (1):
      IB/qib: Hold link for TX SERDES settings

Ralf Thielow (1):
      RDMA/amso1100: Fix compile warnings

Roland Dreier (1):
      Merge branches 'amso1100', 'cma', 'cxgb4', 'misc', 'mlx4' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Limit MAXBURST EQ context field to 256B
      RDMA/cxgb4: Set the correct device physical function for iWARP connections
      RDMA/ucma: Copy iWARP route information on queries

Tejun Heo (1):
      RDMA: Update missed conversion of flush_scheduled_work()

Yevgeny Petrilin (1):
      mlx4_core: Add ConnectX-3 device IDs

 drivers/infiniband/core/sa_query.c      |    2 +-
 drivers/infiniband/core/ucma.c          |   22 ++++++++++++++++++++--
 drivers/infiniband/hw/amso1100/c2_vq.c  |    6 +++---
 drivers/infiniband/hw/cxgb4/cm.c        |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c        |    4 ++--
 drivers/infiniband/hw/qib/qib_iba7322.c |   30 +++++++++++-------------------
 drivers/net/mlx4/main.c                 |   15 +++++++++++++++
 7 files changed, 53 insertions(+), 28 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
