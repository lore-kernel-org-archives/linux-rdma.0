From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Cleanup ibv_register_driver
Date: Tue, 28 Feb 2017 14:31:33 -0700
Message-ID: <1488317497-538-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that the provider API is private there is no reason to have two different
ways to register a driver. Consolidate everything into verbs_register_driver.

This approach is simplified by not also forcing a change to the new context
allocation protocol, which is a bit more complex.

The changes to providers are very simple and mechanical. A future series could
eliminate the old context allocation protocol.

https://github.com/linux-rdma/rdma-core/pull/87

Jason Gunthorpe (4):
  ibverbs: Make struct verbs_device and related private
  providers: Make every provider allocate a verbs_device
  providers: Move all verbs_device ops into struct verbs_device_ops
  verbs: Remove ibv_register_driver

 libibverbs/compat-1_0.c            |  4 ++--
 libibverbs/device.c                | 12 ++++++------
 libibverbs/driver.h                | 36 +++++++++++++++++++++++++++++++----
 libibverbs/init.c                  | 39 +++++++++-----------------------------
 libibverbs/verbs.h                 | 27 +++++---------------------
 providers/cxgb3/iwch.c             | 12 ++++++------
 providers/cxgb3/iwch.h             |  2 +-
 providers/cxgb4/dev.c              | 10 +++++-----
 providers/cxgb4/libcxgb4.h         |  2 +-
 providers/hfi1verbs/hfiverbs.c     | 12 ++++++------
 providers/hfi1verbs/hfiverbs.h     |  2 +-
 providers/hns/hns_roce_u.c         | 12 ++++++------
 providers/hns/hns_roce_u.h         |  2 +-
 providers/i40iw/i40iw_umain.c      | 11 ++++++-----
 providers/i40iw/i40iw_umain.h      |  5 +----
 providers/ipathverbs/ipathverbs.c  | 12 ++++++------
 providers/ipathverbs/ipathverbs.h  |  2 +-
 providers/mlx4/mlx4.c              |  9 ++++++---
 providers/mlx5/mlx5.c              |  9 +++++++--
 providers/mthca/mthca.c            | 10 +++++-----
 providers/mthca/mthca.h            |  2 +-
 providers/nes/nes_umain.c          | 11 ++++++-----
 providers/nes/nes_umain.h          |  5 +----
 providers/ocrdma/ocrdma_main.c     | 14 +++++++-------
 providers/ocrdma/ocrdma_main.h     |  4 +---
 providers/qedr/qelr.h              |  2 +-
 providers/qedr/qelr_main.c         | 14 ++++++--------
 providers/qedr/qelr_main.h         |  2 --
 providers/rxe/rxe.c                | 12 ++++++------
 providers/rxe/rxe.h                |  2 +-
 providers/vmw_pvrdma/pvrdma.h      |  2 +-
 providers/vmw_pvrdma/pvrdma_main.c | 12 ++++++------
 32 files changed, 150 insertions(+), 162 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
