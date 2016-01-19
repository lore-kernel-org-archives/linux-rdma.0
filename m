From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/7] IB/qib: Use rdmavt for cq, post send/recv, some qp ops
Date: Tue, 19 Jan 2016 14:33:23 -0800
Message-ID: <20160119223130.30925.93860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set continues to remove code from qib and use the rdmavt version. It
includes usage of completion queues, post send and receive as well as the query
qp functionality. The patch set also pulls in the rdmavt version of create/free
mad agents and device allocation.
---

Dennis Dalessandro (2):
      IB/qib: Use rdmavt device allocation function
      IB/qib: Remove create and free mad agents

Harish Chegondi (5):
      IB/qib: Remove completion queue data structures and functions from qib
      IB/qib: Use rdmavt version of post_send
      IB/qib: Remove qib_post_receive and use rdmavt version
      IB/qib: Remove qib multicast verbs functions
      IB/qib: Remove qib_query_qp function


 drivers/infiniband/hw/qib/Makefile          |    4 
 drivers/infiniband/hw/qib/qib.h             |    2 
 drivers/infiniband/hw/qib/qib_cq.c          |  545 ---------------------------
 drivers/infiniband/hw/qib/qib_driver.c      |    8 
 drivers/infiniband/hw/qib/qib_iba7322.c     |   10 
 drivers/infiniband/hw/qib/qib_init.c        |   10 
 drivers/infiniband/hw/qib/qib_mad.c         |   99 +----
 drivers/infiniband/hw/qib/qib_qp.c          |   66 ---
 drivers/infiniband/hw/qib/qib_rc.c          |   52 +--
 drivers/infiniband/hw/qib/qib_ruc.c         |   41 +-
 drivers/infiniband/hw/qib/qib_sdma.c        |    4 
 drivers/infiniband/hw/qib/qib_uc.c          |   14 -
 drivers/infiniband/hw/qib/qib_ud.c          |   14 -
 drivers/infiniband/hw/qib/qib_verbs.c       |  310 +--------------
 drivers/infiniband/hw/qib/qib_verbs.h       |  135 -------
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |  368 ------------------
 16 files changed, 149 insertions(+), 1533 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_cq.c
 delete mode 100644 drivers/infiniband/hw/qib/qib_verbs_mcast.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
