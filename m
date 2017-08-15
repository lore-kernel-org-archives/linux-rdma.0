From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 0/2] Don't allocate ib/iw cm workqueues with WQ_MEM_RECLAIM
Date: Tue, 15 Aug 2017 19:12:52 +0300
Message-ID: <1502813574-6040-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It's not correct due to the fact that such workqueues cannot allocate
memory in their work execution by definition, which is definitly not
the case for cm workqueues.

Sagi Grimberg (2):
  cm: Don't allocate ib_cm workqueue with WQ_MEM_RECLAIM
  iwcm: Don't allocate iwcm workqueue with WQ_MEM_RECLAIM

 drivers/infiniband/core/cm.c   | 2 +-
 drivers/infiniband/core/iwcm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
