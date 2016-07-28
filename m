From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/16] Fix SDMA/TID caching code
Date: Thu, 28 Jul 2016 15:21:11 -0400
Message-ID: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This series fixes a number of bugs found while debugging the use of the
mm_struct "current->mm".  When PSM jobs were stopped unexpectedly (for example
control-c) it was possible for the wrong mm struct to be used in
mmu_notifier_unregister.  This was causing memory corruption.  In addition, a
number of might sleep conditions were found when mmap_sem needed to be taken
while a spinlock was held.

The following are stand alone fixes which can probably be reordered if
necessary:

	IB/hfi1: Prevent null pointer dereference
	IB/hfi1: Use the same capability state for all shared contexts
	IB/hfi1: Validate SDMA user request index
	IB/hfi1: Validate SDMA user iovector count
	IB/hfi1: Release node on insert failure
	IB/hfi1: Fix error condition that needs to clean up
	IB/hfi1: Fix user SDMA racy user request claim

The use of mm and locking issues are fixed with the following commits (they
depend on the previous commits and must be ordered among themselves):

	IB/hfi1: Make use of mm consistent
	IB/hfi1: Make the cache handler own its rb tree root
	IB/hfi1: Fix TID caching actions
	IB/hfi1: Add evict operation to the mmu rb handler
	IB/hfi1: Use evict mmu rb operation
	IB/hfi1: Consistently call ops->remove outside spinlock
	IB/hfi1: Remove unneeded mm argument in remove function
	IB/hfi1: Fix memory leak during unexpected shutdown
	IB/hfi1: Add cache evict LRU list

Special thanks to Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> for suggestions on how to fix
the main issues.

This series requires the clean up patch series sent previously.

Dean Luick (13):
  IB/hfi1: Use the same capability state for all shared contexts
  IB/hfi1: Validate SDMA user request index
  IB/hfi1: Validate SDMA user iovector count
  IB/hfi1: Release node on insert failure
  IB/hfi1: Fix error condition that needs to clean up
  IB/hfi1: Fix user SDMA racy user request claim
  IB/hfi1: Make the cache handler own its rb tree root
  IB/hfi1: Fix TID caching actions
  IB/hfi1: Add evict operation to the mmu rb handler
  IB/hfi1: Use evict mmu rb operation
  IB/hfi1: Consistently call ops->remove outside spinlock
  IB/hfi1: Remove unneeded mm argument in remove function
  IB/hfi1: Add cache evict LRU list

Ira Weiny (3):
  IB/hfi1: Prevent null pointer dereference
  IB/hfi1: Make use of mm consistent
  IB/hfi1: Fix memory leak during unexpected shutdown

 drivers/infiniband/hw/hfi1/chip.c         |   8 --
 drivers/infiniband/hw/hfi1/chip.h         |   2 -
 drivers/infiniband/hw/hfi1/file_ops.c     |  31 ++--
 drivers/infiniband/hw/hfi1/hfi.h          |  13 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c       | 214 ++++++++++++++++++---------
 drivers/infiniband/hw/hfi1/mmu_rb.h       |  32 +++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 115 ++++++++-------
 drivers/infiniband/hw/hfi1/user_pages.c   |  19 +--
 drivers/infiniband/hw/hfi1/user_sdma.c    | 230 +++++++++++++++---------------
 drivers/infiniband/hw/hfi1/user_sdma.h    |   8 +-
 10 files changed, 386 insertions(+), 286 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
