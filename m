From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 0/3] Raw Packet QP Fixes for 4.8
Date: Sun,  3 Jul 2016 15:42:04 +0300
Message-ID: <1467549727-23479-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch series includes raw packet QP fixes which are targeted for 4.8.
They apply cleanly on top of your k.o/for-4.8 branch.

These patches are available in the "topic/fix_raw_eth_qos" branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fix_raw_eth_qos

Thanks

Talat Batheesh (3):
  IB/core: Add optional AV attribute for Raw Packet QP in INIT to RTR
  IB/core: Fix ib_resolve_eth_dmac for Raw Packet QP
  IB/mlx5: Fix mlx5_set_path for Raw Packet QP

 drivers/infiniband/core/verbs.c | 3 ++-
 drivers/infiniband/hw/mlx5/qp.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
