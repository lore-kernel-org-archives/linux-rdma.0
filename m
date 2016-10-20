From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC v2 0/3] connect reject event helpers
Date: Thu, 20 Oct 2016 15:40:35 -0700
Message-ID: <cover.1477003235.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While reviewing:

http://lists.infradead.org/pipermail/linux-nvme/2016-October/006681.html

I decided to propose transport-agnostic helper functions to better
handle connection reject event information.  I've included a nvme_rdma
patch to utilize the new helpers.

Thoughts?

Changes since v1:

- moved reject logic to cm.c and iwcm.c.
- added rdma_consumer_reject() helper.
- added nvme-rdma change to utilize the new helpers.

Steve Wise (3):
  rdma_cm: add rdma_reject_msg() helper function
  rdma_cm: add rdma_consumer_reject() helper function
  nvme-rdma: use rdma_reject_msg() to log connection rejects

 drivers/infiniband/core/cm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/cma.c  | 26 ++++++++++++++++++++++++
 drivers/infiniband/core/iwcm.c | 18 +++++++++++++++++
 drivers/nvme/host/rdma.c       | 18 ++++++++++-------
 include/rdma/ib_cm.h           | 15 ++++++++++++++
 include/rdma/iw_cm.h           | 15 ++++++++++++++
 include/rdma/rdma_cm.h         | 14 +++++++++++++
 7 files changed, 145 insertions(+), 7 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
