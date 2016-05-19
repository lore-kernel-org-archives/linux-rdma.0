From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] IB/hfi1, qib,
 rdmavt: Additional fixes and updates for 4.7
Date: Thu, 19 May 2016 05:21:11 -0700
Message-ID: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are a few more patches that would be good to get into 4.7 merge window. Two
of the fixes are for build warnings on new versions of gcc. There are a couple
bug fixes and some minor clean ups.

This patch series should apply on Doug's k.o/for-4.7 branch.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Dennis Dalessandro (1):
      IB/hfi1: Remove anti-pattern in cdev init

Ira Weiny (1):
      IB/hfi1: Remove unnecessary comment

Jianxin Xiong (1):
      IB/hfi1: Fix bug that blocks process on exit after port bounce

Jubin John (3):
      IB/rdmavt: Use kzalloc_node
      IB/hfi1: Fix sdma_event_names[] build warning
      IB/qib: Remove unused qib_7322_intr_msgs[]

Mike Marciniszyn (1):
      IB/rdmavt: Insure QP vmalloc variants zero memory

Mitko Haralanov (1):
      IB/hfi1: Fix an interval RB node reference count leak


 drivers/infiniband/hw/qib/qib_iba7322.c |   15 ---------------
 drivers/infiniband/sw/rdmavt/mr.c       |    4 +++-
 drivers/infiniband/sw/rdmavt/qp.c       |    8 ++++----
 drivers/staging/rdma/hfi1/device.c      |   14 +++++++-------
 drivers/staging/rdma/hfi1/qp.c          |    3 ---
 drivers/staging/rdma/hfi1/sdma.c        |    2 ++
 drivers/staging/rdma/hfi1/user_sdma.c   |   18 ++++++++++--------
 7 files changed, 26 insertions(+), 38 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
