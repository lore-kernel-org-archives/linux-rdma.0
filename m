From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 0/8] connect reject event helpers
Date: Tue, 25 Oct 2016 13:19:03 -0700
Message-ID: <cover.1477426743.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While reviewing:

http://lists.infradead.org/pipermail/linux-nvme/2016-October/006681.html

I decided to propose transport-agnostic helper functions to better
handle connection reject event information.  Included are patches
for nvme/fabrics, iser, and rds to utilize the new helpers.

Doug, this series applies on top of v4.9-rc2 as well as sagi's nvmf-4.9-rc
branch as of today.  The series should be targeted for 4.10.

Changes since v3:
- added reviewed-by/acked-by tags
- positive logic in reject_msg helpers
- cleaned up reject message strings
- added patches to use helpers in isert and nvmet_rdma
- fixed zero-day build warning

Changes since v2:

- reworked ibcm/iwcm_reject_msg() as per Christoph's recommendation
- use ibcm_ and iwcm_ prefix instead of ib_ and iw_ for reject_msg funcs
- change rdma_consumer_reject() to rdma_is_consumer_reject()
- add rdma_consumer_reject_data() helper function to return private
  data/len
- use new helpers in nvme_rdma, ib_iser, and rdma_rds
- in nvme_rdma, add strings for nvme_rdma_cm_status values

---

Steve Wise (8):
  rdma_cm: add rdma_reject_msg() helper function
  rdma_cm: add rdma_is_consumer_reject() helper function
  rdma_cm: add rdma_consumer_reject_data helper function
  nvme-rdma: use rdma connection reject helper functions
  ib_iser: log the connection reject message
  rds_rdma: log the connection reject message
  ib_isert: log the connection reject message
  nvmet_rdma: log the connection reject message

 drivers/infiniband/core/cm.c             | 48 ++++++++++++++++++++++++++++++++
 drivers/infiniband/core/cma.c            | 43 ++++++++++++++++++++++++++++
 drivers/infiniband/core/iwcm.c           | 21 ++++++++++++++
 drivers/infiniband/ulp/iser/iser_verbs.c |  5 +++-
 drivers/infiniband/ulp/isert/ib_isert.c  |  2 ++
 drivers/nvme/host/rdma.c                 | 46 ++++++++++++++++++++++++------
 drivers/nvme/target/rdma.c               |  3 ++
 include/rdma/ib_cm.h                     |  6 ++++
 include/rdma/iw_cm.h                     |  6 ++++
 include/rdma/rdma_cm.h                   | 25 +++++++++++++++++
 net/rds/rdma_transport.c                 |  5 +++-
 11 files changed, 200 insertions(+), 10 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
