From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] staging/rdma/hfi1: Update retry timer
Date: Thu, 04 Feb 2016 10:58:49 -0800
Message-ID: <20160204185718.6973.92668.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

hfi1 specific timer optimizations to allow for a light weight modify retry
timer.

Applies on top of the previously posted "Various bug fixes for hfi1 post rdmavt"
series and can be seen in context at:
https://github.com/ddalessa/kernel/tree/for-4.6

---

Mike Marciniszyn (5):
      staging/rdma/hfi1: centralize timer routines into rc
      staging/rdma/hfi1: use new timer routines
      staging/rdma/hfi1: use mod_timer when appropriate
      staging/rdma/hfi1: add unique rnr timer
      staging/rdma/hfi1: use new RNR timer


 drivers/infiniband/hw/qib/qib_qp.c |    1 
 drivers/infiniband/sw/rdmavt/qp.c  |    1 
 drivers/staging/rdma/hfi1/qp.c     |    5 +
 drivers/staging/rdma/hfi1/rc.c     |  192 +++++++++++++++++++++++++++---------
 drivers/staging/rdma/hfi1/verbs.h  |    4 +
 5 files changed, 152 insertions(+), 51 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
