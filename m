From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] IB/mad: refactor functions based on the needs of those functions.
Date: Fri,  1 May 2015 01:42:05 -0400
Message-ID: <1430458928-28465-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

validate_mad, ib_response_mad, and rcv_has_same_class only need the IB header.
Refactor these functions as appropriate.

Ira Weiny (3):
  IB/mad: Change validate_mad signature to take ib_mad_hdr rather than ib_mad
  IB/mad: Change ib_response_mad signature to take ib_mad_hdr rather than ib_mad
  IB/mad: Change cast in rcv_has_same_class

 drivers/infiniband/core/mad.c      | 34 +++++++++++++++++-----------------
 drivers/infiniband/core/user_mad.c |  6 +++---
 include/rdma/ib_mad.h              |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
