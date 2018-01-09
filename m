From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Refactor rdma_cm query GID API
Date: Tue,  9 Jan 2018 13:10:55 +0200
Message-ID: <20180109111058.29534-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

The following patchset continues the previous refactoring series
targeted for rdma-next.

The goal of the folliwing patches is to simplify and provide consistient
interface to query GIDs from rdma_cm.

Thanks

Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Parav Pandit (3):
  RDMA/core: Remove RoCE support from rdma_addr_get_sgid()
  RDMA/cma: Introduce API to read GIDs for multiple transports
  RDMA: Use rdma_cm API to query GID

 drivers/infiniband/core/cma.c  | 18 ++++++++++++++++
 drivers/infiniband/core/ucma.c |  8 +++----
 include/rdma/ib_addr.h         | 49 +++++++++++++++++++-----------------------
 include/rdma/rdma_cm.h         | 19 ++++++++++++++++
 net/rds/ib.c                   |  6 ++----
 5 files changed, 65 insertions(+), 35 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
