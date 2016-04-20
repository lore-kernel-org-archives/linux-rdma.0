From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] IB/hfi1, rdmavt: Additional bug fixes for 4.6 RC
Date: Wed, 20 Apr 2016 06:05:18 -0700
Message-ID: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are three more fixes that should probably end up going in the next RC for
4.6. These apply on top of the previously submitted  RC patch set:

http://marc.info/?l=linux-rdma&m=146048314707180&w=4

These fixes address a memory leak, locking problem, and a panic.

They can also be seen in my GitHub repo.
https://github.com/ddalessa/kernel/tree/for-4.6

---

Jubin John (1):
      IB/rdmavt,hfi1,qib: Fix memory leak

Mike Marciniszyn (1):
      IB/hfi1: Fix missing lock/unlock in verbs drain callback

Mitko Haralanov (1):
      IB/hfi1: Don't attempt to free resources if initialization failed


 drivers/infiniband/hw/qib/qib_init.c     |    4 +-
 drivers/infiniband/sw/rdmavt/vt.c        |   13 +++++++
 drivers/staging/rdma/hfi1/file_ops.c     |   60 ++++++++++++++----------------
 drivers/staging/rdma/hfi1/init.c         |    4 +-
 drivers/staging/rdma/hfi1/qp.c           |    2 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c |    2 +
 include/rdma/rdma_vt.h                   |    1 +
 7 files changed, 49 insertions(+), 37 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
