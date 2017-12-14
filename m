From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 0/5] container_of tidy and minor fixes
Date: Thu, 14 Dec 2017 15:35:38 -0700
Message-ID: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are several places that open code container_of and do it more poorly
than the ccan version. Replace them all with ccan container_of then fix all
the compile errors from the additional checking ccan container_of does.

Remove container_of from verbs.h to avoid namespace pollution and to ensure we
use the ccan version.

Tidy some uses of nested container_of

Remove some pointless assignments and unnecessary function prototypes.

This is PR:

https://github.com/linux-rdma/rdma-core/pull/276


Jason Gunthorpe (5):
  verbs: Don't open code 'container_of' in the providers
  verbs: Remove container_of from the public verbs.h
  mlx4: Don't nest container_of
  hns: Remove useless assignments
  providers: Remove unneeded function prototypes

 libibverbs/verbs.h                | 21 +++++++--------------
 librdmacm/rsocket.c               |  1 +
 providers/bnxt_re/main.h          |  2 +-
 providers/cxgb3/iwch.h            |  7 +++----
 providers/cxgb4/libcxgb4.h        |  5 ++---
 providers/hfi1verbs/hfiverbs.h    |  5 ++---
 providers/hns/hns_roce_u.c        |  3 ---
 providers/hns/hns_roce_u.h        |  2 +-
 providers/i40iw/i40iw_umain.c     |  3 ---
 providers/i40iw/i40iw_umain.h     |  7 +++----
 providers/ipathverbs/ipathverbs.h |  6 ++----
 providers/mlx4/mlx4.h             | 15 ++++++---------
 providers/mlx5/mlx5.h             | 11 +++--------
 providers/mthca/mthca.h           |  6 ++----
 providers/nes/nes_umain.c         |  3 ---
 providers/nes/nes_umain.h         |  7 +++----
 providers/ocrdma/ocrdma_main.c    |  3 ---
 providers/ocrdma/ocrdma_main.h    |  7 +++----
 providers/qedr/qelr.h             |  2 +-
 providers/qedr/qelr_main.c        |  3 ---
 providers/rxe/rxe.h               |  6 ++----
 providers/vmw_pvrdma/pvrdma.h     |  2 +-
 22 files changed, 43 insertions(+), 84 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
