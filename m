From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2]: fixes to port query and sysfs in 3.4-rc1
Date: Mon,  2 Apr 2012 17:45:19 +0300
Message-ID: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz (2):
  IB/mlx4: fix the case of invalid speed value returned when the port is down
  IB/core: add missing string for the display of SDR rates in sysfs

 drivers/infiniband/core/sysfs.c   |    1 +
 drivers/infiniband/hw/mlx4/main.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
