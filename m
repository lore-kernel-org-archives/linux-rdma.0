From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 0/3] RoCE GID management fixes
Date: Mon,  3 Aug 2015 16:08:59 +0300
Message-ID: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch mainly fixes teardown and error flow fixes that Jason and
you have found in the recent submitted patchset. As suggested by
Jason, I've split the cache removal process to cleanup and release.
Although I don't expect the HW vendor drivers to use the cache after
it was cleaned up, releasing it in the put function could prevent
possible use-after-free errors. Saying that, we could alternatively
review the vendors' usage more carefully and probably put the release
function as part of the unregister device flow.

In addition, this patch also fixes a small error flow issue that
was found by Dan Carpenter's kbuild system and a possible dead-lock.

Thanks,
Matan

Matan Barak (3):
  IB/core: Access to one past end of array in _gid_table_setup_one
  IB/core: RoCE GID management separate cleanup and release
  IB/core: Fix possible deadlock in write_gid

 drivers/infiniband/core/cache.c     | 90 +++++++++++++++++++++++++++----------
 drivers/infiniband/core/core_priv.h |  1 +
 drivers/infiniband/core/device.c    |  4 ++
 drivers/infiniband/core/sysfs.c     |  2 +-
 4 files changed, 73 insertions(+), 24 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
