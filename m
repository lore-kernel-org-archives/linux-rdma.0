From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] RoCE Path Record refactoring
Date: Mon,  8 Jan 2018 17:04:42 +0200
Message-ID: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This series is mostly refactoring code in CMA area as a preparation
to RoCE containers code, however there are two small fixes which is also
targeted to rdma-next.

Thanks

Parav Pandit (6):
  RDMA/cma: Use the net namespace of the rdma_cm_id
  RDMA/cma: Provide function to set RoCE path record L2 parameters
  RDMA/{cma, ucma}: Simplify and rename rdma_set_ib_paths
  RDMA/{cma, ucma}: Refactor to have transport specific checks
  RDMA/cma: Fix setting RoCE specific path record fields
  RDMA/cma: Fix returning correct path record entry for RoCE

 drivers/infiniband/core/cma.c  | 119 +++++++++++++++++++++++++++--------------
 drivers/infiniband/core/ucma.c |  16 ++----
 include/rdma/rdma_cm_ib.h      |   8 +--
 3 files changed, 89 insertions(+), 54 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
