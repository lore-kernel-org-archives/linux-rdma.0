From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 21 Dec 2012 13:42:32 -0800
Message-ID: <1356126152-397-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Second batch of InfiniBand/RDMA changes for 3.8:
 - cxgb4 changes to fix lookup engine hash collisions
 - mlx4 changes to make flow steering usable
 - fix to IPoIB to avoid pinning dst reference for too long

----------------------------------------------------------------
Hadar Hen Zion (2):
      mlx4_core: Add QPN enforcement for flow steering rules set by VFs
      mlx4_core: Fix error flow in the flow steering wrapper

Jack Morgenstein (2):
      mlx4_core: Adjustments to Flow Steering activation logic for SR-IOV
      mlx4_core: Allow choosing flow steering mode

Roland Dreier (2):
      IPoIB: Call skb_dst_drop() once skb is enqueued for sending
      Merge branches 'cxgb4', 'ipoib' and 'mlx4' into for-next

Vipul Pandya (5):
      cxgb4: Add T4 filter support
      cxgb4: Add LE hash collision bug fix path in LLD driver
      RDMA/cxgb4: Fix LE hash collision bug for active open connection
      RDMA/cxgb4: Fix LE hash collision bug for passive open connection
      RDMA/cxgb4: Fix bug for active and passive LE hash collision path

 drivers/infiniband/hw/cxgb4/cm.c                   | 791 ++++++++++++++++++---
 drivers/infiniband/hw/cxgb4/device.c               | 210 +++++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  33 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   3 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         | 136 ++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 459 +++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |  23 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |  32 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.h           |   3 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  22 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  66 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |  37 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      | 418 +++++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  15 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          | 115 ++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   7 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   6 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  28 +-
 drivers/scsi/csiostor/t4fw_api_stor.h              |  39 -
 include/linux/mlx4/device.h                        |   1 +
 22 files changed, 2234 insertions(+), 214 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
