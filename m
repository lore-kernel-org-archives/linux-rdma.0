From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/5] more mlx4 RoCE fixes
Date: Thu, 11 Sep 2014 14:11:15 +0300
Message-ID: <1410433880-12439-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series from Jack addresses few issues in the mlx4 RoCE support which 
we stepped on recently in regression testing and customer environments.

The series isn't directly depedent on the RoCE IP addressing series of
fixes from Moni which I sent you last month (planning to pick it or respond 
any time soon?!) @ http://marc.info/?l=linux-rdma&m=140862053707413&w=2 
but for proper maintainance should be applied on top of it.

Or.

Jack Morgenstein (5):
  mlx4: Fix mlx4 reg/unreg mac to work properly with 0-mac addresses
  IB/mlx4: Avoid accessing netdevice when building RoCE qp1 header
  IB/mlx4: Don't update QP1 under native mode
  IB/mlx4: Do not allow APM under RoCE
  IB/mlx4: Fix VF mac handling in RoCE

 drivers/infiniband/hw/mlx4/main.c         |   40 ++++++++++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    1 +
 drivers/infiniband/hw/mlx4/qp.c           |   60 ++++++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/port.c |   11 +++--
 4 files changed, 80 insertions(+), 32 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
