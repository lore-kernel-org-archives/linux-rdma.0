From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 0/7] IPoIB fixes for 3.13
Date: Wed, 16 Oct 2013 17:37:46 +0300
Message-ID: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

Here's a set of IPoIB fixes which came through regression case failures 
from the team here targeted to 3.13.

Or.

Erez Shitrit (6):
  IB/ipoib: Fix crash in dev_open error flow
  IB/ipoib: Fix deadlock between dev_change_flags to __ipoib_dev_flush
  IB/ipoib: Avoid flushing the driver work-queue on dev_down
  IB/ipoib: Fix usage of uninitialized multicast objects
  IB/ipoib: Add path queries flushing in ipoib_ib_dev_cleanup
  IB/ipoib: Start multicast join process only on active ports

Tal Alon (1):
  IB/ipoib: Change CM skb memory allocation to be non-atomic on init flow

 drivers/infiniband/ulp/ipoib/ipoib.h           |    4 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   14 +++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   24 ++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   10 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   29 ++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   10 +++++---
 7 files changed, 65 insertions(+), 30 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
