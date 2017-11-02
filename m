From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] RDMA core/mlx4/mlx5 fixes and MTT improvements
Date: Thu,  2 Nov 2017 15:22:23 +0200
Message-ID: <20171102132228.20985-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

* Optimization to mlx4 MTT logic
* Fixup to mlx5 ABI alignment
* Code simplification to IB/core

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-11-02

	Thanks
---------------------------------------

Guy Levi (2):
  IB/mlx4: Use optimal numbers of MTT entries
  IB/mlx4: Add contig support for control objects

Mark Bloch (1):
  IB/mlx4: Increase maximal message size under UD QP

Noa Osherovich (1):
  IB/mlx5: Fix ABI alignment to 64 bit

Parav Pandit (1):
  IB/core: Avoid unnecessary return value check

 drivers/infiniband/core/security.c   |  15 +-
 drivers/infiniband/hw/mlx4/cq.c      |   8 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   2 +
 drivers/infiniband/hw/mlx4/mr.c      | 284 ++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/qp.c      |  10 +-
 include/uapi/rdma/mlx5-abi.h         |   1 +
 6 files changed, 280 insertions(+), 40 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
