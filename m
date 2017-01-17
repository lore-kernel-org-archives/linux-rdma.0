From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC rdma-core 0/3] Common Provider Debug Printing
Date: Tue, 17 Jan 2017 13:45:31 -0600
Message-ID: <1484682331-111172-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Similar debug printing functionality is
refactored to reduce code duplication in two
rdma-core providers. Please review and comment
whether the proposed debug printing approach
should be adopted by the rdma-core providers.

For more information about the issue this patch
series addresses, see the email thread titled
"[PATCH V2 08/10] i40iw: Control debug error prints using env variable"

Tatyana Nikolova (3):
  util: Add common code for provider debug
  mlx5: Use common provider debug macros
  qedr: Use common provider debug macros

 buildlib/rdma_functions.cmake |   2 +-
 providers/mlx5/buf.c          |  18 ++---
 providers/mlx5/cq.c           |   6 +-
 providers/mlx5/mlx5.c         |  51 ++++---------
 providers/mlx5/mlx5.h         |  27 +------
 providers/mlx5/qp.c           |  24 +++---
 providers/mlx5/verbs.c        |  48 ++++++------
 providers/qedr/qelr.h         |  57 +-------------
 providers/qedr/qelr_main.c    |  68 +++--------------
 providers/qedr/qelr_verbs.c   | 168 ++++++++++++++++++++++++------------------
 util/CMakeLists.txt           |   8 ++
 util/dbg.c                    |  83 +++++++++++++++++++++
 util/dbg.h                    |  95 ++++++++++++++++++++++++
 13 files changed, 358 insertions(+), 297 deletions(-)
 create mode 100644 util/dbg.c
 create mode 100644 util/dbg.h

-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
