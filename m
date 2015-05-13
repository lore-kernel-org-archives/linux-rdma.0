From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Wed, 13 May 2015 14:10:35 +0300
Message-ID: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
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

The first patch introduces the new API between the HW device driver and
the IB core. For devices which implement the functionality, IB core
will use it in remove_one, disassociating any active ucontext from the
hardware device. Other drivers that didn't implement it will behave as
today, remove_one will block until all ucontexts referring the device
are destroyed before returning.

The second patch provides implementation of this API for the mlx4
driver.

The third patch extends ucma to avoid blocking remove_one operation in
the cma module. When such device removal event is received, ucma is
turning all user contexts to zombie contexts. This is done by
releasing all underlying resources and preventing any further user
operations on the context.

Changes from V2:
patch #1: Rebase over ODP patches.

Changes from V1:
patch #1: Use uverbs flags instead of disassociate support, drop fatal_event_raised flag.
patch #3: Add support in ucma for handling device removal.

Changes from V0:
patch #1: ib_uverbs_close, reduced mutex scope to enable tasks run in parallel.

Yishai Hadas (3):
  IB/uverbs: Enable device removal when there are active user space
    applications
  IB/mlx4_ib: Disassociate support
  IB/ucma: HW Device hot-removal support

 drivers/infiniband/core/ucma.c        |  130 ++++++++++++-
 drivers/infiniband/core/uverbs.h      |   12 ++
 drivers/infiniband/core/uverbs_cmd.c  |    8 +
 drivers/infiniband/core/uverbs_main.c |  325 +++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c     |  125 +++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |   12 ++
 include/rdma/ib_verbs.h               |    1 +
 7 files changed, 545 insertions(+), 68 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
