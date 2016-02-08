From: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/3] new ib_drain_qp() API
Date: Mon, 8 Feb 2016 14:14:55 -0800
Message-ID: <cover.1454969695.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series creates a new helper API for draining a queue pair.  It is a
rework of an original patch created by Christoph Hellwig as part of the CQ
API rework and was dropped to be resubmitted by me with iw_cxgb4 support.

Original thread: http://www.spinics.net/lists/linux-rdma/msg30296.html

Changes since v1:

- added comments to the ib_drain_qp() function header specifying the
consumer requirements

- in __ib_drain_qp(), if the ib_post_send() fails, still wait for the
recv wr to drain since we already posted it.

- CC the SRP maintainer, bart.vanassche-XdAiOPVOjtvowKkBSvOlow@public.gmane.org

---

Steve Wise (3):
  IB: new common API for draining a queue pair
  iw_cxgb4: add drain_qp function
  IB/srp: use ib_drain_qp()

 drivers/infiniband/core/verbs.c        | 77 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/cq.c       |  6 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  2 +
 drivers/infiniband/hw/cxgb4/provider.c |  1 +
 drivers/infiniband/hw/cxgb4/qp.c       |  8 ++++
 drivers/infiniband/ulp/srp/ib_srp.c    | 45 ++++----------------
 include/rdma/ib_verbs.h                |  2 +
 7 files changed, 102 insertions(+), 39 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
