From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] IB/hfi1,rdmavt: patches for next 06/17/2017
Date: Sat, 17 Jun 2017 10:37:18 -0700
Message-ID: <20170617173620.17658.5173.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are the next set of patches for 4.13. These are two by Kaike. One fixes an
overflow for the QP timeout and the other extends our qp_stats to print info on
the ack_queue.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13
---

Kaike Wan (2):
      IB/rdmavt: Setting of QP timeout can overflow jiffies computation
      IB/hfi1: Add receiving queue info to qp_stats


 drivers/infiniband/hw/hfi1/qp.c   |    6 +++++-
 drivers/infiniband/sw/rdmavt/qp.c |    4 +---
 include/rdma/rdmavt_qp.h          |   14 ++++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
