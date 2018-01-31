From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC 0/2] cm_id resource tracking
Date: Wed, 31 Jan 2018 09:09:55 -0800
Message-ID: <cover.1517418595.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds rdma_cm_id tracking to the new resource tracking
database.  The patches are on top of Jason's merged rdma-next 
branch [1].

Please comment!

Thanks,

Steve.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
branch wip/for-linus-merged.

Steve Wise (2):
  RDMA/CM: move rdma_id_private into include/rdma/rdma_cm.h
  RDMA/nldev: provide detailed CM_ID information

 drivers/infiniband/core/cma.c      |  95 ++++++--------
 drivers/infiniband/core/nldev.c    | 245 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.c |  29 ++++-
 drivers/infiniband/core/ucma.c     |   8 +-
 include/rdma/rdma_cm.h             |  65 +++++++++-
 include/rdma/restrack.h            |   4 +
 include/uapi/rdma/rdma_netlink.h   |  30 +++++
 7 files changed, 406 insertions(+), 70 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
