From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.2] IBoE fixes
Date: Mon, 10 Oct 2011 10:51:55 +0200
Message-ID: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

This is a batch of IBoE related fixes plus addition of extended PMA counters.

Or.

Or Gerlitz (5):
      ib/mlx4: enable 4K MTU for IBoE
      ib/mlx4: remove setting of vlan in IBoE WQEs control segment
      net/mlx4_core: remove module param controlling the vlan table size
      ib/core: add support for extended performance counters in sysfs
      ib/mlx4: add support for extended PMA counters under IBoE

 drivers/infiniband/core/sysfs.c   |  100 ++++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mad.c  |   49 +++++++++++++++---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 drivers/infiniband/hw/mlx4/qp.c   |   11 +---
 drivers/net/mlx4/main.c           |   12 +---
 include/rdma/ib_pma.h             |    1 +
 6 files changed, 148 insertions(+), 27 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
