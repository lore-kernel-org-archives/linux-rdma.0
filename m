From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Core fixes and cleanup
Date: Sun, 19 Mar 2017 10:55:54 +0200
Message-ID: <20170319085557.6023-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below three patches for IB/core and this series
are based on v4.11-rc2.

Thanks

Jack Morgenstein (1):
  IB/core: Fix sysfs registration error flow

Leon Romanovsky (1):
  IB/umem: Drop hugetlb variable and VMA allocation

Parav Pandit (1):
  IB/core: Fix kernel crash during fail to initialize device

 drivers/infiniband/core/device.c          | 33 ++++++++++++++++++++-----------
 drivers/infiniband/core/sysfs.c           |  2 +-
 drivers/infiniband/core/umem.c            | 23 ++-------------------
 drivers/infiniband/core/umem_odp.c        |  1 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  6 +-----
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c  |  1 -
 include/rdma/ib_umem.h                    |  1 -
 8 files changed, 27 insertions(+), 42 deletions(-)

--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
