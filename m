From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 0/8] Small verbs cleanups
Date: Tue,  5 Dec 2017 16:17:13 -0700
Message-ID: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Small verbs changes that should have no binary impact. These are just little
cleanups I've noticed lately.

This is a PR:

https://github.com/linux-rdma/rdma-core/pull/270

Jason Gunthorpe (8):
  verbs: Fix typo in copying IBV_FLOW_SPEC_UDP/TCP 'val'
  verbs: Remove duplicate NULL test from flow ops
  verbs: Get rid of verbs_context->has_comp_mask
  verbs: Bitwise flag values should be unsigned
  verbs: Remove bogus cq_fd
  verbs: Fill in the libibverbs.map file
  verbs: Remove dead _HAS_ defines for providers
  verbs: Get rid of verbs_set_ctx_op

 libibverbs/cmd.c                  |  2 +-
 libibverbs/device.c               |  3 ---
 libibverbs/driver.h               |  2 --
 libibverbs/libibverbs.map.in      | 56 ++++++++++++++++++++++++++++-----------
 libibverbs/man/ibv_query_device.3 |  2 +-
 libibverbs/verbs.h                | 36 ++++++++-----------------
 providers/mlx4/cq.c               |  2 +-
 providers/mlx4/mlx4.c             | 36 ++++++++++++-------------
 providers/mlx5/cq.c               |  2 +-
 providers/mlx5/mlx5.c             | 34 ++++++++++++------------
 providers/mlx5/mlx5.h             |  2 +-
 11 files changed, 90 insertions(+), 87 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
