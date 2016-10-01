From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Two fixes for prev 4.9 and two new fixes
Date: Fri, 30 Sep 2016 20:10:52 -0700
Message-ID: <20161001030935.15264.34730.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

The first two patches here are fixes for patches you picked up in your hfi1
branch for 4.9. You may want to squash them. The commit SHAs referrenced are
from your GitHub repo.

Pathces 3 and 4 are new fixes for 4.9.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.9

---

Ira Weiny (1):
      IB/hfi1: Fix invalid lockdep assert

Jianxin Xiong (1):
      IB/hfi1: Update SMA ingress checks for response packets

Mike Marciniszyn (2):
      IB/core: Fix atomic regression with ib_hdrs
      IB/hfi1: Fix trace of atomic ack


 drivers/infiniband/hw/hfi1/qp.c    |    1 -
 drivers/infiniband/hw/hfi1/trace.c |    4 +--
 drivers/infiniband/hw/hfi1/ud.c    |   49 ++++++++++++++++++------------------
 drivers/infiniband/hw/hfi1/verbs.c |    2 +
 include/rdma/ib_hdrs.h             |    6 ++--
 5 files changed, 30 insertions(+), 32 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
