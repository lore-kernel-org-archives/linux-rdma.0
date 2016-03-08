From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Tue, 08 Mar 2016 11:14:14 -0800
Message-ID: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series adds a performance improvement to user SDMA transfers from
PSM applications by caching user buffer pages after pinning them. Subsequent
uses of the same user buffer will not incur the cost of pinning the same pages
again. Additionally, the cost of unpinning the same pages is avoided.  Buffer
pages are unpinned when the context is torn down or when the driver determines
that the buffer should be evicted from the cache. Cache evictions happen when
there is a request for a new, uncached buffer and the current size of the cache
has reached a pre-defined limit.

Series applies on "Adaptive PIO bug fixes..." series submitted yesterday and
should apply cleanly to Doug's GitHub hfi1 branch.

Can also be seen in my GitHub at:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Mitko Haralanov (16):
      IB/hfi1: Re-factor MMU notification code
      IB/hfi1: Allow MMU function execution in IRQ context
      IB/hfi1: Prevent NULL pointer dereference
      IB/hfi1: Allow remove MMU callbacks to free nodes
      IB/hfi1: Remove the use of add/remove RB function pointers
      IB/hfi1: Notify remove MMU/RB callback of calling context
      IB/hfi1: Use interval RB trees
      IB/hfi1: Add MMU tracing
      IB/hfi1: Remove compare callback
      IB/hfi1: Add filter callback
      IB/hfi1: Adjust last address values for intervals
      IB/hfi1: Implement SDMA-side buffer caching
      IB/hfi1: Add pin query function
      IB/hfi1: Specify mm when releasing pages
      IB/hfi1: Switch to using the pin query function
      IB/hfi1: Add SDMA cache eviction algorithm


 drivers/infiniband/hw/hfi1/Makefile       |    2 
 drivers/infiniband/hw/hfi1/file_ops.c     |    1 
 drivers/infiniband/hw/hfi1/hfi.h          |   16 +
 drivers/infiniband/hw/hfi1/mmu_rb.c       |  292 +++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/mmu_rb.h       |   73 ++++++
 drivers/infiniband/hw/hfi1/trace.c        |    1 
 drivers/infiniband/hw/hfi1/trace.h        |    1 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  362 ++++++++---------------------
 drivers/infiniband/hw/hfi1/user_pages.c   |   63 ++++-
 drivers/infiniband/hw/hfi1/user_sdma.c    |  319 +++++++++++++++++---------
 drivers/infiniband/hw/hfi1/user_sdma.h    |    4 
 11 files changed, 747 insertions(+), 387 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/mmu_rb.c
 create mode 100644 drivers/infiniband/hw/hfi1/mmu_rb.h

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
