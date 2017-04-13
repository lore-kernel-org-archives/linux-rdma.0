From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Common MMIO accessors for rdma-core
Date: Thu, 13 Apr 2017 16:38:42 -0600
Message-ID: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've been threatening to do this for a while, here is a refactoring of the
MMIO accessors into a common set of functions that unify all the weird
options accumulated in the various providers:

- Normal 64 bit accessors
- 32 bit emulation of 64 bit write
- ia32 XMM support for 64 bit write
- s390 syscall accessors

This is a big complex transformation that has lots of possibility for little
mistakes, it would be good for other people to look closely at this before we
merge it.

This is available on my github:

https://github.com/jgunthorpe/rdma-plumbing/tree/mmio

For this starting point I only converted the Mellanox drivers, because they
are all basically the same.

This fixes one bug in the mlx_read_clock function which attempted to double
read a register without telling the compiler, which was miscompiling :(

I have another series on top of this:

https://github.com/jgunthorpe/rdma-plumbing/tree/sparse4

Which does the last few things to make the Mellanox drivers sparse clean.

Jason Gunthorpe (5):
  util: Add common mmio macros
  mlx4: Use util/mmio.h
  mlx5: Use util/mmio.h
  mthca: Use util/mmio.h
  Add mmio_memcpy_x64

 CMakeLists.txt                |  16 +++
 buildlib/config.h.in          |   2 +
 buildlib/rdma_functions.cmake |   4 +-
 providers/mlx4/cq.c           |  14 ++-
 providers/mlx4/doorbell.h     |  70 -----------
 providers/mlx4/mlx4.c         |   1 -
 providers/mlx4/mlx4.h         |   1 -
 providers/mlx4/mmio.h         | 116 ------------------
 providers/mlx4/qp.c           |  10 +-
 providers/mlx4/srq.c          |   1 -
 providers/mlx4/verbs.c        |   9 +-
 providers/mlx5/cq.c           |  13 ++-
 providers/mlx5/doorbell.h     |  67 -----------
 providers/mlx5/mlx5.c         |   2 -
 providers/mlx5/mlx5.h         |   1 -
 providers/mlx5/qp.c           |  22 ++--
 providers/mlx5/srq.c          |   1 -
 providers/mlx5/verbs.c        |   9 +-
 providers/mthca/cq.c          |  38 +++---
 providers/mthca/doorbell.h    | 109 +----------------
 providers/mthca/qp.c          |  44 ++++---
 providers/mthca/srq.c         |  14 ++-
 util/CMakeLists.txt           |  20 +++-
 util/dummy.c                  |   0
 util/mmio.c                   |  83 +++++++++++++
 util/mmio.h                   | 265 ++++++++++++++++++++++++++++++++++++++++++
 26 files changed, 480 insertions(+), 452 deletions(-)
 delete mode 100644 providers/mlx4/doorbell.h
 delete mode 100644 providers/mlx4/mmio.h
 delete mode 100644 providers/mlx5/doorbell.h
 create mode 100644 util/dummy.c
 create mode 100644 util/mmio.c
 create mode 100644 util/mmio.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
