From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>
Subject: [PATCH v4 0/4] new ib_drain_qp() API
Date: Wed, 17 Feb 2016 12:35:36 -0800
Message-ID: <cover.1455741336.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series creates new helper API functions for draining a queue pair.
It is a rework of an original patch created by Christoph Hellwig as
part of the CQ API rework and was dropped to be resubmitted by me with
iw_cxgb4 support.

Original thread: http://www.spinics.net/lists/linux-rdma/msg30296.html


Changes since v3:

- WARN_ONCE() if the CQ is using IB_POLL_DIRECT context.

- added iser patch to use ib_drain_sq().

- fixed up function comments to specify caller requirements

- checkpatched


Changes since v2:

- created 3 drain API functions: ib_drain_rq(), ib_drain_sq(), and
ib_drain_qp()

- add provider-specific drain function pointers for the sq and rq

- refactored the code a bit

- support for IB_DIRECT_POLL CQs


Changes since v1:

- added comments to the ib_drain_qp() function header specifying the
consumer requirements

- in __ib_drain_qp(), if the ib_post_send() fails, still wait for the
recv wr to drain since we already posted it.

- CC the SRP maintainer, bart.vanassche-XdAiOPVOjtvowKkBSvOlow@public.gmane.org

---

Steve Wise (4):
  IB: new common API for draining queues
  iw_cxgb4: add queue drain functions
  IB/srp: Use ib_drain_rq()
  IB/iser: Use ib_drain_sq()

 drivers/infiniband/core/verbs.c              | 164 +++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/cq.c             |   9 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |   4 +
 drivers/infiniband/hw/cxgb4/provider.c       |   2 +
 drivers/infiniband/hw/cxgb4/qp.c             |  16 +++
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   7 --
 drivers/infiniband/ulp/iser/iser_initiator.c |   7 --
 drivers/infiniband/ulp/iser/iser_verbs.c     |  15 +--
 drivers/infiniband/ulp/srp/ib_srp.c          |  40 +------
 include/rdma/ib_verbs.h                      |   5 +
 10 files changed, 205 insertions(+), 64 deletions(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
