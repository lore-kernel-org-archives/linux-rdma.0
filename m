From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Improve symbol version support in ibverbs & providers
Date: Thu, 24 Aug 2017 16:00:26 -0600
Message-ID: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This changes the macros used to delcare symbol versions to something that can
really safely support static libraries by removing all traces of symbol versioning
when the static library is built.

This also addresses the uclib problem and solves the need for ugly function prototypes
in a different way, using a fairly ugly macro to generate all the needed prototypes
and versions for the different operating modes instead.


Jason Gunthorpe (3):
  Add util/symver.h
  verbs: Use util/symver.h for all symbol versioning
  mlx5: Fix ABI break from revising the UAR pointer

 CMakeLists.txt                   |   9 ++
 buildlib/config.h.in             |   4 +
 buildlib/rdma_functions.cmake    |   3 +
 debian/ibverbs-providers.symbols |   2 +
 libibverbs/compat-1_0.c          | 270 ++++++++++++++++++---------------------
 libibverbs/device.c              |  58 ++++-----
 libibverbs/ibverbs.h             |   6 -
 libibverbs/verbs.c               | 202 +++++++++++++----------------
 providers/mlx5/CMakeLists.txt    |   2 +-
 providers/mlx5/libmlx5.map       |   5 +
 providers/mlx5/mlx5.c            |  24 +++-
 providers/mlx5/mlx5dv.h          |   2 +-
 util/CMakeLists.txt              |   1 +
 util/symver.h                    | 100 +++++++++++++++
 14 files changed, 390 insertions(+), 298 deletions(-)
 create mode 100644 util/symver.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
