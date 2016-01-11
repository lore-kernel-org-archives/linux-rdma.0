From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Mon, 11 Jan 2016 12:56:36 -0500
Message-ID: <1452535010-14087-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

NOTE:

This is being resubmitted to linux-rdma (for patchworks) to aid Doug Ledford in
taking over the staging/rdma subtree.

https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg30860.html

Doug, these apply on top of the work already accepted by Greg.  So we will need
you to merge with Gregs staging tree before applying these.  All future
submissions will apply on top of this work in order as well.

Thanks,
Ira


Expected receives work by user-space libraries (PSM) calling into the driver
with information about the user's receive buffer and have the driver DMA-map
that buffer and program the HFI to receive data directly into it.

This is an expensive operation as it requires the driver to pin the pages which
the user's buffer maps to, DMA-map them, and then program the HFI.

When the receive is complete, user-space libraries have to call into the driver
again so the buffer is removed from the HFI, un-mapped, and the pages unpinned.

All of these operations are expensive, considering that a lot of applications
(especially micro-benchmarks) use the same buffer over and over.

In order to get better performance for user-space applications, it is highly
beneficial that they don't continuously call into the driver to register and
unregister the same buffer. Rather, they can register the buffer and cache it
for future work. The buffer can be unregistered when it is freed by the user.

This change implements such buffer caching by making use of the kernel's MMU
notifier API. User-space libraries call into the driver only when they need to
register a new buffer.

Once a buffer is registered, it stays programmed into the HFI until the kernel
notifies the driver that the buffer has been freed by the user. At that time,
the user-space library is notified and it can do the necessary work to remove
the buffer from its cache.

Buffers which have been invalidated by the kernel are not automatically removed
from the HFI and do not have their pages unpinned. Buffers are only completely
removed when the user-space libraries call into the driver to free them.  This
is done to ensure that any ongoing transfers into that buffer are complete.
This is important when a buffer is not completely freed but rather it is
shrunk. The user-space library could still have uncompleted transfers into the
remaining buffer.

With this feature, it is important that systems are setup with reasonable
limits for the amount of lockable memory.  Keeping the limit at "unlimited" (as
we've done up to this point), may result in jobs being killed by the kernel's
OOM due to them taking up excessive amounts of memory.


TID caching started as a single patch which we have broken up.

Original patch here.

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-November/080855.html


This directly depends on the initial break up work which was submitted before:

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-December/082339.html

---
Changes from V1:
	Add comment to program_rcvarray
	Fix >= on tididx


Mitko Haralanov (14):
  staging/rdma/hfi1: Add function stubs for TID caching
  uapi/rdma/hfi/hfi1_user.h: Correct comment for capability bit
  uapi/rdma/hfi/hfi1_user.h: Convert definitions to use BIT() macro
  uapi/rdma/hfi/hfi1_user.h: Add command and event for TID caching
  staging/rdma/hfi1: Add definitions needed for TID caching support
  staging/rdma/hfi1: Remove un-needed variable
  staging/rdma/hfi1: Add definitions and support functions for TID groups
  staging/rdma/hfi1: Start adding building blocks for TID caching
  staging/rdma/hfi1: Convert lock to mutex
  staging/rdma/hfi1: Add Expected receive init and free functions
  staging/rdma/hfi1: Add MMU notifier callback function
  staging/rdma/hfi1: Add TID free/clear function bodies
  staging/rdma/hfi1: Add TID entry program function body
  staging/rdma/hfi1: Enable TID caching feature

 drivers/staging/rdma/hfi1/Kconfig        |    1 +
 drivers/staging/rdma/hfi1/Makefile       |    2 +-
 drivers/staging/rdma/hfi1/file_ops.c     |  458 +----------
 drivers/staging/rdma/hfi1/hfi.h          |   40 +-
 drivers/staging/rdma/hfi1/init.c         |    5 +-
 drivers/staging/rdma/hfi1/trace.h        |  132 ++--
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 1208 ++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h |    8 +
 drivers/staging/rdma/hfi1/user_pages.c   |   14 -
 include/uapi/rdma/hfi/hfi1_user.h        |   68 +-
 10 files changed, 1400 insertions(+), 536 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
