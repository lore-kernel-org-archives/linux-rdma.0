From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 0/2] HW Device hot-removal support
Date: Tue, 18 Nov 2014 14:11:20 +0200
Message-ID: <1416312682-7899-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Similarly, if the device is hot-unplugged or reset, the device driver
hardware removal flow blocks until all user contexts are destroyed.

This patchset removes the above limitations. The IB-core and uverbs
layers are still required to remain loaded as long as there are user
applications using the verbs API. However, the hardware device drivers
are not blocked any more by the user space activity.

To support this, the hardware device needs to expose a new kernel API
named 'disassociate_ucontext'. The device driver is given a ucontext
to detach from, and it should block this user context from any future
hardware access. In the IB-core level, we use this interface to
deactivate all ucontext that address a specific device when handling a
remove_one callback for it.

The first patch introduces the new API between the HW device driver and
the IB core. For devices which implement the functionality, IB core
will use it in remove_one, disassociating any active ucontext from the
hardware device. Other drivers that didn't implement it will behave as
today, remove_one will block until all ucontexts referring the device
are destroyed before returning.

The second patch provides implementation of this API for the mlx4
driver. 

Changes from V0:
patch #1: ib_uverbs_close, reduced mutex scope to enable tasks run in parallel. 

Yishai Hadas (2):
  IB/uverbs: Enable device removal when there are active user space
    applications
  IB/mlx4_ib: Disassociate support

 drivers/infiniband/core/uverbs.h      |    9 +
 drivers/infiniband/core/uverbs_cmd.c  |    8 +
 drivers/infiniband/core/uverbs_main.c |  324 +++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c     |  119 ++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |   12 ++
 include/rdma/ib_verbs.h               |    2 +
 6 files changed, 417 insertions(+), 57 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
