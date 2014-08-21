From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 0/7] RoCE IP addressing fixes
Date: Thu, 21 Aug 2014 14:28:36 +0300
Message-ID: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series contains RoCE related fixes to the mlx4 IB driver 
(and one uverbs patch), which deal with the IP addressing logic.

Once applied into 3.17, we will further push them to -stable.

Or.

Jack Morgenstein (1):
  IB/mlx4: Fix lockdep splat for the iboe lock

Matan Barak (1):
  IB/core: When marsheling uverbs path, clear unused fields

Moni Shoua (5):
  IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
  IB/mlx4: Don't duplicate the default RoCE GID
  IB/mlx4: Reorder steps in RoCE GID table initialization
  IB/mlx4: Get upper dev addresses as RoCE GIDs when port comes up
  IB/mlx4: Avoid executing gid task when device is being removed

 drivers/infiniband/core/uverbs_marshall.c |    4 +
 drivers/infiniband/hw/mlx4/main.c         |  124 ++++++++++++++++++-----------
 2 files changed, 81 insertions(+), 47 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
