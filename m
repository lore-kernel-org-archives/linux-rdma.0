From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/9] IPoIB fixes for 4.11
Date: Tue, 27 Dec 2016 15:39:02 +0200
Message-ID: <20161227133911.14340-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

There are 8 patches from Feras for IPoIB.

The patchset was generated against v4.10-rc1 and targeted for 4.11.

The patch "IB/ipoib: Fix deadlock between rmmod and set_mode" which fix kernel panic
is marked as candidate for stable tree inclusion.

Available in the "topic/ipoib-fixes-4.11" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/ipoib-fixes-4.11

Thanks

Feras Daoud (9):
  IB/ipoib: Add warning message when changing the MTU in UD over the max
    range
  IB/ipoib: Set device connection mode only when needed
  IB/ipoib: Fix deadlock over vlan_mutex
  IB/ipoib: Fix deadlock between rmmod and set_mode
  IB/ipoib: rtnl_unlock can not come after free_netdev
  IB/ipoib: Add detailed error message to dev_queue_xmit call
  IB/ipoib: Use debug prints instead of warnings in RNR WC status
  IB/ipoib: Replace list_del of the neigh->list with list_del_init
  IB/ipoib: Change list_del to list_del_init in the tx object

 drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 30 ++++++++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 34 +++++++++++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  6 +++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      | 10 +++++---
 4 files changed, 52 insertions(+), 28 deletions(-)

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
