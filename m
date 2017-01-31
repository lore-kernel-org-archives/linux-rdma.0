From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/6] Fixes for new warnings in gcc 7
Date: Tue, 31 Jan 2017 14:08:00 -0700
Message-ID: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hopefull gcc 7 will be available in travis soon, here is enough fixing to
quiet the new warnings it finds.

Jason Gunthorpe (6):
  Add Debian experimental gcc-7 to cbuild
  hns: Fix strange placement of fprintf:
  mlx5: Fix missing break statement in sq_overhead
  Annotate correct switch fall throughs with SWITCH_FALLTHROUGH
  acm: Fix snprintf truncation
  Check the return value from snprintf when working with paths

 buildlib/cbuild                  | 12 ++++++++++++
 ibacm/prov/acmp/src/acmp.c       |  2 +-
 ibacm/src/acm.c                  |  7 +++++--
 libibverbs/examples/asyncwatch.c |  2 ++
 libibverbs/init.c                | 24 +++++++++++++++---------
 librdmacm/examples/riostream.c   |  2 ++
 librdmacm/examples/rstream.c     |  2 ++
 librdmacm/examples/udpong.c      |  2 ++
 providers/hns/hns_roce_u_hw_v1.c |  2 +-
 providers/mlx4/cq.c              |  3 +++
 providers/mlx5/cq.c              |  3 +++
 providers/mlx5/verbs.c           |  2 ++
 providers/ocrdma/ocrdma_verbs.c  |  3 +++
 providers/qedr/qelr_verbs.c      |  3 ++-
 util/CMakeLists.txt              |  1 +
 util/compiler.h                  |  7 +++++++
 util/util.h                      | 13 +++++++++++++
 17 files changed, 76 insertions(+), 14 deletions(-)
 create mode 100644 util/util.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
