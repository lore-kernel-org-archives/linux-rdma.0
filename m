From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Add creation flags for user space QPs
Date: Sun, 14 Sep 2014 16:20:00 +0300
Message-ID: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This small series addresses a long time (2008..) pain point, namely 
the inability to specify creation flags for user-space QPs. We use 
the existing uverbs command and a reserved field there to specify the flags.

Or.

Or Gerlitz (2):
  IB/uverbs: Add QP creation flags, allow blocking UD multicast loopback
  IB/mlx4: Enable blocking multicast loopback for user-space consumers

 drivers/infiniband/core/uverbs_cmd.c |   35 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/qp.c      |   13 +++++++----
 include/uapi/rdma/ib_user_verbs.h    |    2 +-
 3 files changed, 42 insertions(+), 8 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
