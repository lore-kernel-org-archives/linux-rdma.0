From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-next 0/5] iw_cxgb4: handle fw reply timeouts
Date: Wed, 27 Sep 2017 13:55:45 -0700
Message-ID: <cover.1506545745.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For messages sent from the host to fw that solicit a reply from fw,
the c4iw_wr_wait struct pointer is passed in the host->fw message, and
included in the fw->host fw6_msg reply.  This allows the sender to wait
until the reply is received, and the code processing the ingress reply
to wake up the sender.

If c4iw_wait_for_reply() times out, however, we need to keep the
c4iw_wr_wait object around in case the reply eventually does arrive.
Otherwise we have touch-after-free bugs in the wake_up paths.

This series refactors the c4iw_wait_wr users and the wait API to handle
this case.  The first 4 patches change the users to allocate the wait
object vs using it locally on the stack, and the 5th patch implmements the
new kref for the wait objects.

Steve Wise (5):
  iw_cxgb4: allocate wait object for each memory object
  iw_cxgb4: allocate wait object for each cq object
  iw_cxgb4: allocate wait object for each qp object
  iw_cxgb4: allocate wait object for each ep object
  iw_cxgb4: add referencing to wait objects

 drivers/infiniband/hw/cxgb4/cm.c       |  40 +++---
 drivers/infiniband/hw/cxgb4/cq.c       |  69 +++++-----
 drivers/infiniband/hw/cxgb4/device.c   |  21 +++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  66 ++++++++-
 drivers/infiniband/hw/cxgb4/mem.c      | 242 ++++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/qp.c       |  82 +++++------
 6 files changed, 330 insertions(+), 190 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
