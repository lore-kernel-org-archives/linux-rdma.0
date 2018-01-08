From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 0/8] Revise provider initialization
Date: Mon,  8 Jan 2018 14:26:24 -0700
Message-ID: <20180108212632.5183-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This make all the context creation uniform by having every driver create a
struct verbs_context using the same startup flow.

Long ago we had a new and old flow, where the new flow was intended to support
a stable provider ABI, but now that the ABI is private we do not need that.

By having every single provider having a verbs_context we can now rely on
things like the priv existing and a sane init ordering where the priv can
exist even before the first command runs.

Having priv always available is a necessary component to introduce support for
the new ioctl kabi.

Finally, the last three patches rework the ops setup to use a struct of
function pointers scheme and provides defaults for every function. The
defaults return ENOSYS which fixes a bunch of cases where the user could have
called a function without driver support and got a crash.

This is github PR:

https://github.com/linux-rdma/rdma-core/pull/281

Jason Gunthorpe (8):
  verbs: Always allocate a verbs_context
  bnxt_re: Convert from init_context to alloc_context
  mlx4: Convert from init_context to alloc_context
  mlx5: Convert from init_context to alloc_context
  verbs: Remove init_context/uninit_context
  verbs: Provide a default implementation for every verbs op
  verbs: Convert all providers to use verbs_set_ops
  verbs: Remove tests for NULL ops

 CMakeLists.txt                     |   2 +-
 debian/libibverbs1.symbols         |   2 +-
 libibverbs/CMakeLists.txt          |   1 +
 libibverbs/cmd.c                   |  12 +-
 libibverbs/device.c                | 186 ++++++++-------
 libibverbs/driver.h                | 130 ++++++++--
 libibverbs/dummy_ops.c             | 469 +++++++++++++++++++++++++++++++++++++
 libibverbs/ibverbs.h               |   1 +
 libibverbs/libibverbs.map.in       |   3 +
 libibverbs/verbs.c                 |  14 +-
 providers/bnxt_re/main.c           |  48 ++--
 providers/bnxt_re/main.h           |   4 +-
 providers/bnxt_re/verbs.c          |   4 +-
 providers/cxgb3/iwch.c             |  39 +--
 providers/cxgb3/iwch.h             |   4 +-
 providers/cxgb4/dev.c              |  35 +--
 providers/cxgb4/libcxgb4.h         |   4 +-
 providers/hfi1verbs/hfiverbs.c     |  47 ++--
 providers/hfi1verbs/hfiverbs.h     |   4 +-
 providers/hns/hns_roce_u.c         |  53 +++--
 providers/hns/hns_roce_u.h         |   4 +-
 providers/hns/hns_roce_u_verbs.c   |   6 +-
 providers/i40iw/i40iw_umain.c      |  23 +-
 providers/i40iw/i40iw_umain.h      |   4 +-
 providers/ipathverbs/ipathverbs.c  |  45 ++--
 providers/ipathverbs/ipathverbs.h  |   4 +-
 providers/mlx4/dbrec.c             |   4 +-
 providers/mlx4/mlx4.c              | 105 +++++----
 providers/mlx4/mlx4.h              |   4 +-
 providers/mlx5/buf.c               |   2 +-
 providers/mlx5/cq.c                |   2 +-
 providers/mlx5/dbrec.c             |   4 +-
 providers/mlx5/mlx5.c              | 111 +++++----
 providers/mlx5/mlx5.h              |   4 +-
 providers/mthca/mthca.c            |  59 ++---
 providers/mthca/mthca.h            |   4 +-
 providers/nes/nes_umain.c          |  32 ++-
 providers/nes/nes_umain.h          |   4 +-
 providers/ocrdma/ocrdma_main.c     |  17 +-
 providers/ocrdma/ocrdma_main.h     |   4 +-
 providers/qedr/qelr.h              |   4 +-
 providers/qedr/qelr_main.c         |  17 +-
 providers/qedr/qelr_verbs.c        |   2 +-
 providers/rxe/rxe.c                |  16 +-
 providers/rxe/rxe.h                |   4 +-
 providers/vmw_pvrdma/pvrdma.h      |   4 +-
 providers/vmw_pvrdma/pvrdma_main.c |  17 +-
 47 files changed, 1087 insertions(+), 481 deletions(-)
 create mode 100644 libibverbs/dummy_ops.c

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
