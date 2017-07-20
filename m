From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 0/8] Sparse updates for Mellanox and vmw_pvrdma providers
Date: Thu, 20 Jul 2017 11:00:56 -0600
Message-ID: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This makes 4 more providers sparse clean

There are two more small changes to the user facing API, around the
invalidate_rkey/imm_data duality, these matches the changes already
made.

Changes since v1:
 - Revised !! patch to use an inline function (Bart, CH)
 - Moved __force to variable declaration (CH)
 
Jason Gunthorpe (8):
  verbs: Annotate ibv_wc helpers with endian
  verbs: Annotate ibv_send_wr with endian
  mlx4: Add sparse annotations
  mlx5: Avoid sparse complaints about !!
  mlx5: Add sparse annotations
  mthca: Add sparse annotations
  vmw_pvrdma: Update kernel header
  vmw_pvrdma: Add sparse annotations

 CMakeLists.txt                               | 12 ++--
 buildlib/fixup-include/rdma-vmw_pvrdma-abi.h |  4 +-
 libibverbs/man/ibv_create_cq_ex.3            |  5 +-
 libibverbs/man/ibv_post_send.3               |  7 ++-
 libibverbs/verbs.h                           | 21 ++++++-
 providers/mlx4/cq.c                          |  9 ++-
 providers/mlx4/dbrec.c                       |  7 ++-
 providers/mlx4/mlx4.h                        | 17 +++---
 providers/mlx4/mlx4dv.h                      | 84 ++++++++++++++--------------
 providers/mlx4/qp.c                          |  4 +-
 providers/mlx4/verbs.c                       | 11 +---
 providers/mlx5/cq.c                          | 32 ++++++-----
 providers/mlx5/dbrec.c                       |  6 +-
 providers/mlx5/mlx5.h                        | 14 ++---
 providers/mlx5/mlx5dv.h                      | 68 +++++++++++-----------
 providers/mlx5/qp.c                          | 10 ++--
 providers/mlx5/verbs.c                       |  4 +-
 providers/mlx5/wqe.h                         | 34 +++++------
 providers/mthca/cq.c                         | 32 +++++------
 providers/mthca/memfree.c                    |  4 +-
 providers/mthca/mthca.h                      | 24 ++++----
 providers/mthca/qp.c                         |  4 +-
 providers/mthca/wqe.h                        | 60 ++++++++++----------
 providers/vmw_pvrdma/pvrdma.h                |  6 +-
 providers/vmw_pvrdma/verbs.c                 |  7 +--
 25 files changed, 253 insertions(+), 233 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
