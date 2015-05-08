From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/4][RESEND] IB/mad: refactor functions based on the needs of those functions.
Date: Fri,  8 May 2015 14:27:20 -0400
Message-ID: <1431109644-27226-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Resent due to patchworks being reset.

validate_mad, ib_response_mad, and rcv_has_same_class only need the IB header.
Refactor these functions as appropriate.

In addition set const for functions which take read only structures.

Added Jason and Sean's Review by.


Ira Weiny (4):
  IB/mad: Change validate_mad signature to take const ib_mad_hdr rather
    than ib_mad
  IB/mad: Change ib_response_mad signature to take const ib_mad_hdr
    rather than ib_mad
  IB/mad: Clean up rcv_has_same_class
  IB/mad: Add const qualifiers to query only functions

 drivers/infiniband/core/mad.c      | 54 +++++++++++++++++++-------------------
 drivers/infiniband/core/mad_priv.h |  4 +--
 drivers/infiniband/core/user_mad.c |  6 ++---
 include/rdma/ib_mad.h              |  4 +--
 4 files changed, 34 insertions(+), 34 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
