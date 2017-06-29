From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 00/13] RDMA/bnxt_re: Misc fixes for bnxt_re
Date: Thu, 29 Jun 2017 12:28:06 -0700
Message-ID: <1498764499-24157-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series includes the bug fixes for bnxt_re.

Patches 1 - 8 in this series are the backlog from the previously
submitted series -
https://www.spinics.net/lists/linux-rdma/msg50984.htm (6 out of the
the 14 patches from the above series got merged into 4.12-rc).
Theise patches are already reviewed by the community.

Patches 9-13 are new patches posted for review.

Doug,
Please review this and consider applying all 13 patches in the 4.13
merge cycle.

Thanks,
Selvin Xavier

v1 -> v2: 
	Reworked on the locking for handling QPs in flushed state.
	Removes the flush_lock and uses the cq->hwq.lock for handling
	the flush state

Devesh Sharma (3):
  RDMA/bnxt_re: Free doorbell page index (DPI) during dealloc ucontext
  RDMA/bnxt_re: Enable atomics only if host bios supports
  RDMA/bnxt_re: Fix return value of poll routine

Eddie Wai (1):
  RDMA/bnxt_re: Fixed the max_rd_atomic support for initiator and
    destination QP

Kalesh AP (1):
  RDMA/bnxt_re: Add vlan tag for untagged RoCE traffic when PFC is
    configured

Selvin Xavier (5):
  RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
  RDMA/bnxt_re: Report supported value to IB stack in query_device
  RDMA/bnxt_re: Allow posting when QPs are in error
  RDMA/bnxt_re: Report MISSED_EVENTS in req_notify_cq
  RDMA/bnxt_re: Fix the value reported for local ack delay

Somnath Kotur (3):
  RDMA/bnxt_re: Fix race between netdev register and unregister events
  RDMA/bnxt_re: Fix WQE Size posted to HW to prevent it from throwing
    error
  RDMA/bnxt_re: Specify RDMA component when allocating stats context

 drivers/infiniband/hw/bnxt_re/bnxt_re.h    |  22 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 158 +++++----
 drivers/infiniband/hw/bnxt_re/ib_verbs.h   |   3 +-
 drivers/infiniband/hw/bnxt_re/main.c       |  96 +++++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 494 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  10 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c  |  10 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h  |   2 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   |  93 +++++-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h   |   5 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h   |   4 +-
 13 files changed, 766 insertions(+), 183 deletions(-)

-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
