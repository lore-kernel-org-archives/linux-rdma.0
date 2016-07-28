From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/13] Code clean ups for 4.8
Date: Thu, 28 Jul 2016 12:27:24 -0400
Message-ID: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following patches perform some code clean up in preparation for up coming
fixes.

Functionality is not changed.

Dean Luick (6):
  IB/hfi1: Remove unused uctxt->subpid and uctxt->pid
  IB/hfi1: Remove unused function hfi1_mmu_rb_search
  IB/hfi1: Always expect ops functions
  IB/hfi1: Make iovec loop index easy to understand
  IB/hfi1: Remove unneeded empty check in hfi1_mmu_rb_unregister()
  IB/hfi1: Rename TID mmu_rb_* functions

Ira Weiny (7):
  IB/hfi1: Fix minor format error
  IB/hfi1: Add parameter names to function declarations
  IB/hfi1: Add parameter names to callback declarations
  IB/hfi1: Consolidate __mmu_rb_remove and hfi1_mmu_rb_remove
  IB/hfi1: Remove unused sub-context parameter
  IB/hfi1: Use "false" not 0
  IB/hfi1: Restructure hfi1_file_open

 drivers/infiniband/hw/hfi1/file_ops.c     | 18 ++++----
 drivers/infiniband/hw/hfi1/hfi.h          | 11 +++--
 drivers/infiniband/hw/hfi1/mmu_rb.c       | 74 ++++++++-----------------------
 drivers/infiniband/hw/hfi1/mmu_rb.h       | 13 +++---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 33 +++++++-------
 drivers/infiniband/hw/hfi1/user_sdma.c    | 11 ++---
 6 files changed, 62 insertions(+), 98 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
