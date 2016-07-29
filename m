From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 0/2] iwarp device removal deadlock fixes
Date: Fri, 29 Jul 2016 13:36:17 -0700
Message-ID: <cover.1469824577.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series fixes the deadlock issue discovered while testing nvmf/rdma
handling rdma device removal events from the rdma_cm.  For a discussion
of the deadlock that can happen, see

http://lists.infradead.org/pipermail/linux-nvme/2016-July/005440.html.

For my description of the deadlock itself, see this post in the above thread:

http://lists.infradead.org/pipermail/linux-nvme/2016-July/005465.html

In a nutshell, iw_cxgb4 and the iw_cm block during qp/cm_id destruction
until all references are removed.  This combined with the iwarp CM passing
disconnect events up to the rdma_cm during disconnect and/or qp/cm_id destruction
leads to a deadlock.

My proposed solution is to remove the need for iw_cxgb4 and iw_cm to
block during object destruction for the refnts to reach 0, but rather to
let the freeing of the object memory be deferred when the last deref is
done, which is SOP in the much of the linux kernel. This allows all the
qps/cm_ids to be destroyed without blocking, and all the object memory
freeing ends up happinging when the application's device_remove event
handler function returns to the rdma_cm.

This series is needed along with Sagi's fixes from:
https://www.spinics.net/lists/linux-rdma/msg38715.html

Hey Faisal, it would be great to get some review/test tags from Intel
on the iw_cm change.  Thanks!

Changes since v1:

- reworded commit text for the iw_cm patch

- added a iw_cm_id flag to drop pending events when the cm_id has
been marked for destruction.

---

Steve Wise (2):
  iw_cxgb4: don't block in destroy_qp awaiting the last deref
  iw_cm: free cm_id resources on the last deref

 drivers/infiniband/core/iwcm.c         | 54 +++++++++++-----------------------
 drivers/infiniband/core/iwcm.h         |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 +-
 drivers/infiniband/hw/cxgb4/qp.c       | 21 ++++++++-----
 4 files changed, 33 insertions(+), 46 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
