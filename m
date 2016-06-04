From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/7] IPoIB and IB core fixes for 4.7
Date: Sat,  4 Jun 2016 15:15:17 +0300
Message-ID: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below the patches with fixes for IPoIB and IB core.

This patchset is generated against Linus's v4.7-rc1 tag.

Available in the "topic/fixes-ib" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fixes-ib

Thanks

Aviv Heller (1):
  IB/core: Fix removal of default GID cache entry

Eli Cohen (1):
  IB/core: Fix query port failure in RoCE

Erez Shitrit (2):
  IB/IPoIB: Don't update neigh validity for unresolved entries
  IB/IPoIB: Fix race between ipoib_remove_one to sysfs functions

Mark Bloch (3):
  IB/IPoIB: Disable bottom half when dealing with device address
  IB/core: Fix incorrect array allocation
  IB/core: Initialize sysfs attributes before sysfs create group

 drivers/infiniband/core/cache.c                | 10 ++++++++--
 drivers/infiniband/core/device.c               |  3 +++
 drivers/infiniband/core/sysfs.c                | 10 ++++++++--
 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  4 ++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  8 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 15 ++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  6 ++++++
 9 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
