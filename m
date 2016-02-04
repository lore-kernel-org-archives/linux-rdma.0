From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] IB/qib,staging/rdma/hfi1: Dual lock pre-reqs
Date: Thu, 04 Feb 2016 11:02:52 -0800
Message-ID: <20160204190024.8378.5080.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series includes some prerequisite patches in order to add a dual lock
on the send side. It also brings in a patch based on one submitted by Hari.

Series applies on the previously submitted "Update retry timer" for hfi1 and can
be seen in context at: https://github.com/ddalessa/kernel/tree/for-4.6

---

Hari Prasath Gujulan Elango (1):
      IB/qib,staging/rdma/hfi1: use setup_timer api

Mike Marciniszyn (5):
      staging/rdma/hfi1: remove duplicate timeout print
      staging/rdma/hfi1: add s_retry to diagnostics
      staging/rdma/hfi1: Insure last cursor is updated prior to complete
      IB/qib: Insure last cursor is updated prior to complete
      IB/rdmavt: remove unused qp field


 drivers/infiniband/hw/qib/qib_rc.c    |   20 ++++++++++++++++----
 drivers/infiniband/hw/qib/qib_ruc.c   |   12 +++++++-----
 drivers/infiniband/hw/qib/qib_verbs.c |    4 +---
 drivers/staging/rdma/hfi1/qp.c        |    4 ++--
 drivers/staging/rdma/hfi1/rc.c        |   20 ++++++++++++++++----
 drivers/staging/rdma/hfi1/ruc.c       |   12 +++++++-----
 drivers/staging/rdma/hfi1/verbs.c     |    4 +---
 include/rdma/rdmavt_qp.h              |    1 -
 8 files changed, 50 insertions(+), 27 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
