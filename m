From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/5] clang support
Date: Fri,  7 Oct 2016 16:36:07 -0600
Message-ID: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series gets clang running warning free and has travis run the build
through clang-3.9 so we don't break it again.

Jason Gunthorpe (5):
  Pull uninitialized_var into util/compiler.h
  ibacm: Avoid clang 3.8 warning -Wmissing-field-initializers
  mthca: Avoid bogus gcc 4.8 warning -Wmaybe-uninitialized
  Improve linker flag detection to work with clang and -Werror
  Update TravisCI to use clang 3.9 as well

 .travis.yml                    | 20 +++++++++++++++++---
 CMakeLists.txt                 | 22 ++++++++++++++--------
 buildlib/FindLDSymVer.cmake    | 16 ++++++++++++----
 buildlib/RDMA_EnableCStd.cmake | 25 +++++++++++++++++++++++++
 ibacm/prov/acmp/src/acmp.c     |  2 +-
 providers/cxgb4/cq.c           |  1 +
 providers/cxgb4/libcxgb4.h     |  2 --
 providers/cxgb4/qp.c           |  1 +
 providers/mlx4/mlx4.h          |  4 ----
 providers/mlx4/qp.c            |  1 +
 providers/mlx5/mlx5.h          |  4 ----
 providers/mlx5/qp.c            |  1 +
 providers/mthca/qp.c           | 23 +++++------------------
 util/CMakeLists.txt            |  3 +++
 util/compiler.h                | 18 ++++++++++++++++++
 15 files changed, 99 insertions(+), 44 deletions(-)
 create mode 100644 util/CMakeLists.txt
 create mode 100644 util/compiler.h

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
