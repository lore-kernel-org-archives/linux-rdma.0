From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/6] mlx4 and more IPoIB changes for 4.1
Date: Thu,  2 Apr 2015 13:38:59 +0300
Message-ID: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series has one mlx4 bug fix and few fixes / enhancements 
on top of Doug's major cleanup in the multicast area.

Next week both of us will be OOO as of a holiday, so Erez will 
be able to address comments only on the week on that follows.

Erez and Or.

Erez Shitrit (6):
  IB/ipoib: Use one linear skb in RX flow
  IB/ipoib: Update broadcast record values after each successful join request
  IB/ipoib: Handle QP in SQE state
  IB/ipoib: Save only IPOIB_MAX_PATH_REC_QUEUE skb's
  IB/ipoib: Remove IPOIB_MCAST_RUN bit
  IB/mlx4: Fix WQE LSO segment calculation

 drivers/infiniband/hw/mlx4/qp.c                |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   11 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  126 +++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   13 ++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24 ++++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   13 +--
 6 files changed, 106 insertions(+), 84 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
