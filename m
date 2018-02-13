From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND v1 rdma-next 0/6] cm_id, cq, mr, and pd resource tracking
Date: Tue, 13 Feb 2018 12:13:20 -0800
Message-ID: <cover.1518552800.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

NOTE: I added cq, mr, and pd resources in this series.

This series adds rdma_cm_id, ib_cq, ib_mr, and ib_pd information to the
new resource tracking database.  The patches are on top of Jason's merged
rdma-next branch [1] plus the recent restrack fix destined for rdma-rc
[2].  I'll rebase everything on rdma-next once it rebases on 4.16-rc2.

Changes since v0 RFC:

- move rdma_id_private into new header cma_priv.h
- fixed up code comments as suggested
- fixed RDMA_NLDEV_CMD_RES_QP_GET cut/paste error
- no BE attributes
- add cq, mr, pd resource information
- remove RFC tag

Thanks,

Steve.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
branch wip/for-linus-merged.

[2] https://www.spinics.net/lists/linux-rdma/msg60672.html


Steve Wise (6):
  RDMA/CM: move rdma_id_private to cma_priv.h
  RDMA/nldev: provide detailed CM_ID information
  RDMA/nldev: provide detailed CQ information
  iw_cxgb4: initialize ib_mr fields for user mrs
  RDMA/nldev: provide detailed MR information
  RDMA/nldev: provide detailed PD information

 drivers/infiniband/core/cma.c        |  96 ++---
 drivers/infiniband/core/cma_priv.h   |  75 ++++
 drivers/infiniband/core/nldev.c      | 811 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/restrack.c   |  61 ++-
 drivers/infiniband/core/ucma.c       |   8 +-
 drivers/infiniband/core/uverbs_cmd.c |   6 +
 drivers/infiniband/core/verbs.c      |   3 +
 drivers/infiniband/hw/cxgb4/mem.c    |   3 +
 include/rdma/ib_verbs.h              |   5 +
 include/rdma/rdma_cm.h               |  24 +-
 include/rdma/restrack.h              |   8 +
 include/uapi/rdma/rdma_netlink.h     |  56 +++
 12 files changed, 1052 insertions(+), 104 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_priv.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
