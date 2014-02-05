From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 0/5] mlx4 IP addressing fixes
Date: Wed,  5 Feb 2014 15:12:57 +0200
Message-ID: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

This batch contain few small fixes to the mlx4 logic that deals with 
managing the RoCE ports GID table management under IP addressing, which
needs to go into 3.14 along with the other two patches I sent you earlier
this week.

Or.

Moni Shoua (5):
  IB/mlx4: Make sure GID index 0 is always occupied
  IB/mlx4: Move rtnl locking to the right location
  IB/mlx4: Do IBoE locking earlier when initializing the GID table
  IB/mlx4: Do IBoE GID table resets in port based manner
  IB/mlx4: Build the port IBoE GID table properly under bonding

 drivers/infiniband/hw/mlx4/main.c |  176 ++++++++++++++++++++++++++----------
 1 files changed, 127 insertions(+), 49 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
