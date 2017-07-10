From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 0/5] Device hot plug support
Date: Mon, 10 Jul 2017 18:05:32 +0300
Message-ID: <1499699137-29037-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Maor adds support for device hot plug.
Sending V1 to handle some cleanup note came on github from Jason, details
below.

Hot plug is the method in which a new hardware becomes available in the system
or is being removed from it.

The IB device list is returned by ibv_get_device_list() from libibverbs.
Today, this list is created once by scanning /sys/class/infiniband_verbs, the
list is cached and never updated, no matter if there were hardware changes in
the system.

libibverbs must be able to provide the application access to new ibv_device
objects, according to the recent system hardware changes.

For this purpose, the device scanning logic, should be separated from the
libibverbs singleton initialization step, an updated list should be returned
upon any call to ibv_get_device_list().

User can call ibv_open_device() while holding this list (see man pages) and once
ibv_free_device_list() is called libibverbs can release the unused ibv_device
objects. Later, upon a call to ibv_close_device() the ibv_device object should
be released.

Currently, on ibv_free_device_list(), only the array is freed, while the
ibv_device objects are never freed.

This series comes to handle the above notes based on the discussion that followed
an RFC on that.

The solution:
- The initialization part was separated from ibv_get_device_list().
- Upon a call to ibv_get_device_list() the sysfs is scanned to look for
  new/removed entries.
- Same device is recognized based on name and timestamp creation.
- libibverbs will maintain a ref count for each verbs_device object, once
  it became zero, it calls the provider library to release the 'strcut
  verbs_device' which it allocated before. For this purpose each provider library
  provide a function to release the verbs_device.

Further details exist in the commit logs of the series.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/157

Changes from V0:
#Patch #3: Use the introduced mutex also for the initialization step, dropping
           the pthread_once usage.

Yishai
Maor Gottlieb (5):
  utils: Add timespec compare utility
  verbs: Split ibverbs_init functionality
  verbs: Refresh cahced ibv_device list
  verbs: Avoid ibv_device memory leak
  providers: Add support for uninit_device for all providers

 debian/libibverbs1.symbols         |   2 +-
 libibverbs/device.c                |  50 +++++++----
 libibverbs/driver.h                |   6 ++
 libibverbs/ibverbs.h               |   5 +-
 libibverbs/init.c                  | 166 ++++++++++++++++++++++++-------------
 libibverbs/libibverbs.map          |   2 +-
 providers/cxgb3/iwch.c             |  10 ++-
 providers/cxgb4/dev.c              |  10 ++-
 providers/hfi1verbs/hfiverbs.c     |  10 ++-
 providers/hns/hns_roce_u.c         |  10 ++-
 providers/i40iw/i40iw_umain.c      |  10 ++-
 providers/ipathverbs/ipathverbs.c  |  10 ++-
 providers/mlx4/mlx4.c              |   8 ++
 providers/mlx5/mlx5.c              |   8 ++
 providers/mthca/mthca.c            |  10 ++-
 providers/nes/nes_umain.c          |   9 +-
 providers/ocrdma/ocrdma_main.c     |  10 ++-
 providers/qedr/qelr_main.c         |  10 ++-
 providers/rxe/rxe.c                |   8 ++
 providers/vmw_pvrdma/pvrdma_main.c |  10 ++-
 srp_daemon/srp_daemon.h            |   7 +-
 util/util.h                        |   6 ++
 22 files changed, 284 insertions(+), 93 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
