From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/4] few mlx4 IB driver fixes for 4.3
Date: Thu, 30 Jul 2015 17:34:20 +0300
Message-ID: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Some fixes included, none of them accounts for regression introduced in 4.2-rc1,
so all can go to 4.3 -- genetated them again 4.2-rc4

Or.

Jack Morgenstein (3):
  IB/mlx4: Fix potential deadlock when sending mad to wire
  IB/mlx4: Deprecate mcast group warning message to debug because of flooding
  IB/mlx4: In sysfs under RoCE, do not allow changing the paravirtualization mapping for pkeys

Noa Osherovich (1):
  IB/mlx4: Use correct SL on AH query under RoCE

 drivers/infiniband/hw/mlx4/ah.c    |  6 +++++-
 drivers/infiniband/hw/mlx4/mcg.c   | 15 ++++++++++-----
 drivers/infiniband/hw/mlx4/sysfs.c |  5 ++++-
 3 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
