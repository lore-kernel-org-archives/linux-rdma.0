From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc v2 0/4] Remove mlx5 support for IB_DEVICE_LOCAL_DMA_LKEY
Date: Thu, 24 Sep 2015 10:34:20 +0300
Message-ID: <1443080064-28760-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Connect-IB device has a specific issue with memory registration using
the reserved lkey (device global_dma_lkey). This caused user-space memory
registration which usually uses cached pre-registered memory keys to fail
due to a device access error during registration. kernel-space memory
registrations used an internal instance a physical memory key allocated with
the private pd context, so this error didn't happen there.

Since the reserved lkey is not fully functional, remove the support for
it altogether. Jason's patches commit 96249d70dd70 ("IB/core: Guarantee
that a local_dma_lkey is available") address consumers by allocating a physical
lkey per PD in the core layer. It also allows mlx5 driver to get rid of it's
private physical lkey (patch #2).

The ConnectX-4 device should have this issue fixed so the capability will be
restored depending on a FW query information.

Also, fix NFS client to use the PD local_dma_lkey instead of the device
local_dma_lkey (which requires a missing check of the device capability in
frwr mode). And, fix iser initiator which encountered some issues when
registering a signature capable memory region with an indirect dma_lkey
area. The fix covers a larger ground as it does not allow using a global MR
with remote access (long standing issue) but on the way makes the specific
registration issue go away.

Thanks to Haggai for catching this early enough.

Many thanks for the reviews.

Changes from v1:
- Fixed changelog of patch #3 (comments from OrG)

Changes from v0:
- Replace xprtrdma patch to Chuck's one
- Fixed typo in iser modparam description

Chuck Lever (1):
  xprtrdma: Replace global lkey with lkey local to PD

Sagi Grimberg (3):
  IB/iser: Add module parameter for always register memory
  IB/mlx5: Remove support for IB_DEVICE_LOCAL_DMA_LKEY
  IB/mlx5: Remove pa_lkey usages

 drivers/infiniband/hw/mlx5/main.c            | 67 +---------------------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  2 -
 drivers/infiniband/hw/mlx5/qp.c              |  4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  5 +++
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c    | 18 +++++---
 drivers/infiniband/ulp/iser/iser_verbs.c     | 21 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/fw.c | 22 ---------
 include/linux/mlx5/device.h                  | 11 -----
 include/linux/mlx5/driver.h                  |  1 -
 net/sunrpc/xprtrdma/fmr_ops.c                | 19 --------
 net/sunrpc/xprtrdma/frwr_ops.c               |  5 ---
 net/sunrpc/xprtrdma/physical_ops.c           | 10 +----
 net/sunrpc/xprtrdma/verbs.c                  |  2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h              |  1 -
 15 files changed, 35 insertions(+), 154 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
