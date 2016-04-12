From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/12] IB/hfi1, IB/rdmavt,
 IB/qib: Important bug fixes for 4.6 RC
Date: Tue, 12 Apr 2016 10:45:44 -0700
Message-ID: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches fix bugs in the hfi1, qib, and rdmavt drivers that should go into
the next 4.6 RC. These are fixes for deadlocks, hangs, and memory leaks, as well
as a data corruption. I think this should meet the criteria for RC. More patches
will follow but those will be more appropriate for the next merge window.

There is also a serious performance regression fix here due to some inverted logic
when porting post_send routines from hfi1/qib to rdmavt.

This applies on 2fe785717 in Doug's k.o/for-4.6-rc branch.

Patches can be viewed in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Jubin John (1):
      IB/rdmavt: Fix send scheduling

Mike Marciniszyn (2):
      IB/rdmavt: Fix adaptive pio hang
      IB/qib, IB/hfi1: Fix up UD loopback use of irq flags

Mitko Haralanov (9):
      IB/hfi1: Prevent NULL pointer deferences in caching code
      IB/hfi1: Fix deadlock caused by locking with wrong scope
      IB/hfi1: Prevent unpinning of wrong pages
      IB/hfi1: Don't remove list entries if they are not in a list
      IB/hfi1: Fix memory leak in user ExpRcv and SDMA
      IB/hfi1: Protect the interval RB tree when cleaning up
      IB/hfi1: Correctly compute node interval
      IB/hfi1: Extract and reinsert MMU RB node on lookup
      IB/hfi1: Fix buffer cache races which may cause corruption


 drivers/infiniband/hw/qib/qib_rc.c       |    2 
 drivers/infiniband/hw/qib/qib_ruc.c      |    4 -
 drivers/infiniband/hw/qib/qib_uc.c       |    2 
 drivers/infiniband/hw/qib/qib_ud.c       |   10 +-
 drivers/infiniband/hw/qib/qib_verbs.h    |    6 +
 drivers/infiniband/sw/rdmavt/qp.c        |    4 -
 drivers/staging/rdma/hfi1/mmu_rb.c       |   69 ++++++++++++-----
 drivers/staging/rdma/hfi1/mmu_rb.h       |    5 +
 drivers/staging/rdma/hfi1/ruc.c          |   20 +++--
 drivers/staging/rdma/hfi1/ud.c           |    8 +-
 drivers/staging/rdma/hfi1/user_exp_rcv.c |   16 ++--
 drivers/staging/rdma/hfi1/user_sdma.c    |  123 ++++++++++++++++++++----------
 drivers/staging/rdma/hfi1/verbs.h        |    1 
 include/rdma/rdmavt_qp.h                 |    5 +
 14 files changed, 178 insertions(+), 97 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
