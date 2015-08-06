From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 0/4]  RoCE GID management fixes
Date: Thu,  6 Aug 2015 20:13:56 +0300
Message-ID: <1438881240-22790-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch-set mainly fixes teardown and error flow fixes that Jason and
you have found in the recent submitted patchset. As suggested by
Jason, I've split the cache removal process to cleanup and release.
Although I don't expect the HW vendor drivers to use the cache after
it was cleaned up, releasing it in the put function could prevent
possible use-after-free errors. Saying that, we could alternatively
review the vendors' usage more carefully and probably put the release
function as part of the unregister device flow, but asynchronous contexts
make it harder to review.

The third patch in this series was written by Jason.
The current implementation of ib_register_device could have caused
the device to be released if an error occurs. By then, a consumer
would call  ib_dealloc_device and get a double-free bug.
This patch makes the following schema mandatory for all flows:
ib_alloc_device
ib_register_device
ib_unregister_device
ib_dealloc_device

In addition, this patch-set also fixes a small error flow issue that
was found by Dan Carpenter's kbuild system and a possible dead-lock.

Except for patch 0003, these patches could be squashed into
"IB/core: Add RoCE GID table management". If you choose to do so,
patch 0003 should come before this series. I can of course re-send
the RoCE GID table management series if needed.

Thanks,
Matan

Jason Gunthorpe (1):
  IB/core: Make ib_alloc_device initialize the kobject

Matan Barak (3):
  IB/core: Access to one past end of array in _gid_table_setup_one
  IB/core: Fix possible deadlock in write_gid
  IB/core: RoCE GID management separate cleanup and release

 drivers/infiniband/core/cache.c     | 109 +++++++++++++++++++++++++-----------
 drivers/infiniband/core/core_priv.h |   4 +-
 drivers/infiniband/core/device.c    | 109 +++++++++++++++++++++++-------------
 drivers/infiniband/core/sysfs.c     |  52 ++---------------
 4 files changed, 151 insertions(+), 123 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
