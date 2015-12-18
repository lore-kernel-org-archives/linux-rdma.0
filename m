From: ira.weiny@intel.com
Subject: [PATCH v2 00/14] Implement Expected Receive TID Caching
Date: Thu, 17 Dec 2015 23:49:50 -0500
Message-ID: <1450414204-13699-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

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
