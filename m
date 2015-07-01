From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rc-fixes 0/2] mlx4 and ipoib Fixes for 4.2-rc1
Date: Wed,  1 Jul 2015 14:31:00 +0300
Message-ID: <1435750262-32210-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

The mlx4 bug (VF query_device fails) was introduced with the time-stamping changes, 
the ipoib bug is something we stepped on while having the mlx4 issue, now fixed.

Or.


Amir Vadai (1):
  IB/IPoIB: Fix bad error flow in ipoib_add_port()

Matan Barak (1):
  IB/mlx4: Do not attemp to report HCA clock offset on VFs

 drivers/infiniband/hw/mlx4/main.c         | 11 ++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
