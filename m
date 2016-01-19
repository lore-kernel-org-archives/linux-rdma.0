From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] IB/rdmavt: clean ups, mad agents and query_qp
Date: Tue, 19 Jan 2016 14:27:35 -0800
Message-ID: <20160119222314.27985.81482.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add some minor clean ups as well as the mad agents and query queue pair to
rdmavt.

This patch set should apply on a merged tree of Doug's kernel.org for 4.5 branch
and the current head of Linus' tree.

---

Dennis Dalessandro (3):
      IB/rdmavt: Add device structure allocation
      IB/rdmavt: Add mad agents to rdmavt
      IB/rdmavt: Fix copyright date

Harish Chegondi (1):
      IB/rdmavt: Add support for rvt_query_qp

Ira Weiny (2):
      IB/rdmavt: Remove unused variable from Queue Pair
      IB/rdmavt: add modify queue pair driver helpers


 drivers/infiniband/sw/rdmavt/ah.c    |    2 -
 drivers/infiniband/sw/rdmavt/ah.h    |    2 -
 drivers/infiniband/sw/rdmavt/cq.c    |    2 -
 drivers/infiniband/sw/rdmavt/cq.h    |    2 -
 drivers/infiniband/sw/rdmavt/dma.c   |    2 -
 drivers/infiniband/sw/rdmavt/dma.h   |    2 -
 drivers/infiniband/sw/rdmavt/mad.c   |   74 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mad.h   |    5 +-
 drivers/infiniband/sw/rdmavt/mcast.c |    2 -
 drivers/infiniband/sw/rdmavt/mcast.h |    2 -
 drivers/infiniband/sw/rdmavt/mmap.c  |    2 -
 drivers/infiniband/sw/rdmavt/mmap.h  |    2 -
 drivers/infiniband/sw/rdmavt/mr.c    |    2 -
 drivers/infiniband/sw/rdmavt/mr.h    |    2 -
 drivers/infiniband/sw/rdmavt/pd.c    |    2 -
 drivers/infiniband/sw/rdmavt/pd.h    |    2 -
 drivers/infiniband/sw/rdmavt/qp.c    |   56 +++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/qp.h    |    2 -
 drivers/infiniband/sw/rdmavt/srq.c   |    2 -
 drivers/infiniband/sw/rdmavt/srq.h   |    2 -
 drivers/infiniband/sw/rdmavt/trace.c |    2 -
 drivers/infiniband/sw/rdmavt/trace.h |    2 -
 drivers/infiniband/sw/rdmavt/vt.c    |   36 +++++++++++------
 drivers/infiniband/sw/rdmavt/vt.h    |    3 +
 include/rdma/rdma_vt.h               |   16 ++++++-
 include/rdma/rdmavt_mr.h             |    2 -
 include/rdma/rdmavt_qp.h             |    3 -
 27 files changed, 190 insertions(+), 43 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
