From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/11] IB/hfi1: Additional fixes for 4.6
Date: Tue, 15 Mar 2016 10:54:00 -0700
Message-ID: <20160315174916.613.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These are some more fixes we've identified that we would like to make it into
4.6 if possible. Two of these are related to the pinned page cache series which
is undergoing discussion if that series does not go these two from Mitko below
would not apply.

Otherwise this will apply on your hfi1 branch on GitHub.

Can also be seen in my GitHub at:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dean Luick (7):
      IB/hfi1: Fix sysfs file offset usage
      IB/hfi1: Fix i2c resource reservation checks
      IB/hfi1: Fix QOS num_vl bit width
      IB/hfi1: Remove invalid QOS check
      IB/hfi1: Fix QOS rule mappings
      IB/hfi1: Correctly obtain the full service class
      IB/hfi1: Simplify init_qpmap_table()

Mike Marciniszyn (1):
      IB/rdmavt: Fix adaptive pio hang

Mitko Haralanov (2):
      IB/hfi1: Prevent NULL pointer deferences in caching code
      IB/hfi1: Fix deadlock caused by locking with wrong scope

Sebastian Sanchez (1):
      IB/hfi1: Adjust default MTU to be 10KB


 drivers/infiniband/hw/hfi1/chip.c         |   59 ++++++++++++-----------------
 drivers/infiniband/hw/hfi1/hfi.h          |    6 +--
 drivers/infiniband/hw/hfi1/mmu_rb.c       |   40 ++++++++++++--------
 drivers/infiniband/hw/hfi1/mmu_rb.h       |    3 +
 drivers/infiniband/hw/hfi1/qp.c           |    6 ++-
 drivers/infiniband/hw/hfi1/qsfp.c         |    8 ++--
 drivers/infiniband/hw/hfi1/sysfs.c        |    4 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    9 ++--
 drivers/infiniband/hw/hfi1/user_sdma.c    |   24 ++++++++----
 include/rdma/rdmavt_qp.h                  |    5 +-
 10 files changed, 89 insertions(+), 75 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
