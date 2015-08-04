From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V7 0/6] HW Device hot-removal support
Date: Tue,  4 Aug 2015 17:03:22 +0300
Message-ID: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently, if there is any user space application using an IB device,
it is impossible to unload the HW device driver for this device.

Similarly, if the device is hot-unplugged or reset, the device driver
hardware removal flow blocks until all user contexts are destroyed.

This patchset removes the above limitations from both uverbs and ucma.

The IB-core and uverbs layers are still required to remain loaded as
long as there are user applications using the verbs API. However, the
hardware device drivers are not blocked any more by the user space
activity.

To support this, the hardware device needs to expose a new kernel API
named 'disassociate_ucontext'. The device driver is given a ucontext
to detach from, and it should block this user context from any future
hardware access. In the IB-core level, we use this interface to
deactivate all ucontext that address a specific device when handling a
remove_one callback for it.

In the RDMA-CM layer, a similar change is needed in the ucma module,
to prevent blocking of the remove_one operation. This allows for
hot-removal of devices with RDMA-CM users in the user space.

The first three patches are preparation for this series.
The first patch fixes a reference counting issue pointed by Jason Gunthorpe.
The second patch fixes a race condition issue pointed by Jason Gunthorpe.
The third patch is a preparation step for deploying RCU for the device
removal flow.

The fourth patch introduces the new API between the HW device driver and
the IB core. For devices which implement the functionality, IB core
will use it in remove_one, disassociating any active ucontext from the
hardware device. Other drivers that didn't implement it will behave as
today, remove_one will block until all ucontexts referring the device
are destroyed before returning.

The fifth patch provides implementation of this API for the mlx4
driver.

The last patch extends ucma to avoid blocking remove_one operation in
the cma module. When such device removal event is received, ucma is
turning all user contexts to zombie contexts. This is done by
releasing all underlying resources and preventing any further user
operations on the context.

Changes from V6:
Added an extra patch #2 to solve a race that was introduced 5 years ago and was reported by Jason.
patch #4 (previously #3): Adapted to the fix of patch #2.

Changes from V5:
Addressed Jason's comments for below patches:
patch #1: Improve kref usage.
patch #3: Use 2 different krefs for complete and memory, improve some comments.

Changes from V4:
patch #1,#3 - addressed Jason's comments.
patch #2, #4 - rebased upon last stuff.

Changes from V3:
Add 2 patches as a preparation for this series, details above.
patch #3: Change the locking schema based on Jason's comments.

Changes from V2:
patch #1: Rebase over ODP patches.

Changes from V1:
patch #1: Use uverbs flags instead of disassociate support, drop fatal_event_raised flag.
patch #3: Add support in ucma for handling device removal.

Changes from V0:
patch #1: ib_uverbs_close, reduced mutex scope to enable tasks run in parallel.
Yishai Hadas (6):
  IB/uverbs: Fix reference counting usage of event files
  IB/uverbs: Fix race between ib_uverbs_open and remove_one
  IB/uverbs: Explicitly pass ib_dev to uverbs commands
  IB/uverbs: Enable device removal when there are active user space
    applications
  IB/mlx4_ib: Disassociate support
  IB/ucma: HW Device hot-removal support

 drivers/infiniband/core/ucma.c        |  130 +++++++++-
 drivers/infiniband/core/uverbs.h      |   16 +-
 drivers/infiniband/core/uverbs_cmd.c  |  114 ++++++----
 drivers/infiniband/core/uverbs_main.c |  442 +++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c     |  139 ++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |   13 +
 include/rdma/ib_verbs.h               |    1 +
 7 files changed, 718 insertions(+), 137 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
