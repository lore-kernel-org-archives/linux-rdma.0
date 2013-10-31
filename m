From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Fix build warnings
Date: Thu, 31 Oct 2013 18:21:49 +0200
Message-ID: <1383236511-4337-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This little patch set removes the current "make W=1" build warnings from the IB core
and the mlx4_ib driver, which would help when we examine new patches to make sure they
don't add any warnings..

Or.

Or Gerlitz (2):
  IB/core: Fix build warnings
  IB/mlx4: Fix build warnings

 drivers/infiniband/core/iwcm.c  |    2 --
 drivers/infiniband/core/sysfs.c |    2 +-
 drivers/infiniband/core/verbs.c |    3 +--
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 4 files changed, 3 insertions(+), 6 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
