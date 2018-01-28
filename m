From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] RDMA fixes for 4.16
Date: Sun, 28 Jan 2018 11:25:28 +0200
Message-ID: <20180128092533.4156-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is batch of unrelated fixes and two cleanup patches from Parav.

The fix from Jack is to well-known series 44c58487d51a ("IB/core:
Define 'ib' and 'roce' rdma_ah_attr types") and it is targeted for
stable@.

Thanks

Jack Morgenstein (1):
  IB/umad: Fix use of unprotected device pointer

Leon Romanovsky (2):
  RDMA/mlx5: Avoid memory leak in case of XRCD dealloc failure
  RDMA/cm: Fix access to uninitialized variable

Parav Pandit (2):
  IB/core: Avoid SGID attributes query while converting GID from OPA to
    IB
  RDMA/cma: Use existing netif_is_bond_master function

 drivers/infiniband/core/cm.c       | 6 +-----
 drivers/infiniband/core/cma.c      | 2 +-
 drivers/infiniband/core/user_mad.c | 2 +-
 drivers/infiniband/hw/mlx5/qp.c    | 5 +----
 4 files changed, 4 insertions(+), 11 deletions(-)

--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
