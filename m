From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 18 Jul 2014 13:40:06 -0700
Message-ID: <1405716006-19437-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA fixes for 3.16

 - cxgb4 hardware driver regression fixes
 - mlx5 hardware driver regression fixes

----------------------------------------------------------------
Hariprasad S (2):
      RDMA/cxgb4: Fix skb_leak in reject_cr()
      RDMA/cxgb4: Clean up connection on ARP error

Or Gerlitz (1):
      IB/mlx5: Enable "block multicast loopback" for kernel consumers

Roland Dreier (1):
      Merge branches 'cxgb4' and 'mlx5' into for-next

Sagi Grimberg (1):
      mlx5_core: Fix possible race between mr tree insert/delete

Steve Wise (2):
      RDMA/cxgb4: Initialize the device status page
      RDMA/cxgb4: Call iwpm_init() only once

 drivers/infiniband/hw/cxgb4/cm.c             | 14 +++++++++++---
 drivers/infiniband/hw/cxgb4/device.c         | 18 +++++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  2 +-
 drivers/infiniband/hw/mlx5/qp.c              |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 19 +++++++++++++++----
 5 files changed, 39 insertions(+), 16 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
