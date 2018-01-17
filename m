From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/4] Last WQE Reached event treatment
Date: Wed, 17 Jan 2018 15:52:54 +0200
Message-ID: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, root <root-btHsVWeQhtoPzdh4EBCT85oR3lBoLCS1@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: root <root-btHsVWeQhtoPzdh4EBCT85oR3lBoLCS1@public.gmane.org>

This series adds a new API to support a drain of a QP that is
associated with a SRQ (Shared Receive Queue).
Leakage problem can occur if we won't treat Last WQE Reached event:
1. QP may have consumed SRQ WQE, but no CQE received yet (especially
   in error flow that can take long time)
2. polling responder CQ at this stage is meaningless (since CQEs
   haven't been posted)
3. destroying QP at this point will cause SRQ credit leakage

So the solution (according to IB spec):
1. modify QP to err state
2. wait for Last WQE Reached event
3. poll CQ to free SRQ WQEs completions
4. destroy the QP.

In the series, I based on earlier patchset that enables
direct polling the CQ regardless of the type.
I've added support for ULPs: NVMe-oF, iSER and SRP as well.

Max Gurtovoy (4):
  IB/core: add support for draining Shared receive queues
  nvmet-rdma: notify QP on Last WQE Reached event arrival
  iser-target: remove dead code
  IB/srpt: notify QP on Last WQE Reached event arrival

 drivers/infiniband/core/verbs.c         | 69 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/isert/ib_isert.c |  3 --
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  1 +
 drivers/nvme/target/rdma.c              |  3 ++
 include/rdma/ib_verbs.h                 |  8 ++++
 5 files changed, 80 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
