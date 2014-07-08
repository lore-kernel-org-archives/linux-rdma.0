From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 0/3] IPoIB fixes
Date: Tue,  8 Jul 2014 12:45:09 +0300
Message-ID: <1404812712-26187-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This short series is a batch of ipoib fixes from Erez to 3.17. 

Basically we remove the 10y old pkey polling thread/code which isn't 
needed anymore (added small ipath patch to support the event..) and
fix a deal-lock which happens on error flow.

Alex, it will allow you to rebase and simplify your 
https://patchwork.kernel.org/patch/4474321/ patch

Or.

Erez Shitrit (2):
  IB/ipoib: Use pkey change event instead of pkey polling mechanism
  IB/ipoib: Avoid flushing the workqueue from worker context

Or Gerlitz (1):
  IB/ipath: Add PKEY change event support

 drivers/infiniband/hw/ipath/ipath_mad.c   |   14 ++++--
 drivers/infiniband/ulp/ipoib/ipoib.h      |    8 +--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   81 ++++++----------------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    8 ++-
 4 files changed, 36 insertions(+), 75 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
