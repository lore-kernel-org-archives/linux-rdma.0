From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 0/2] cxgb4/i40iw interoperability fixes
Date: Fri, 19 Aug 2016 07:31:43 -0700
Message-ID: <cover.1471617103.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Doug, these would be good for 4.8-rc.  They fix some interoperability
problems between Intel and Chelsio iWARP devices.

Changes since v1:

- cleaned up commit comments.

Steve Wise (2):
  iw_cxgb4: limit IRD/ORD advertised to ULP by device max.
  iw_cxgb4: use the MPA initiator's IRD if < our ORD

 drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
