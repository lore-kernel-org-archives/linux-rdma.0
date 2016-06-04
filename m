From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 00/10] IB mlx5 fixes for 4.7
Date: Sat,  4 Jun 2016 15:15:27 +0300
Message-ID: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below the patches with fixes for IB part of mlx5 driver.

This patchset is generated against Linus's v4.7-rc1 tag.

Available in the "topic/fixes-ib-mlx5" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fixes-ib-mlx5

Thanks

Achiad Shochat (1):
  IB/mlx5: Fix alternate path code

Eran Ben Elisha (1):
  IB/mlx5: Fix FW version diaplay in sysfs

Maor Gottlieb (1):
  IB/mlx5: Set flow steering capability bit

Noa Osherovich (7):
  IB/mlx5: Return PORT_ERR in Active to Initializing tranisition
  IB/mlx5: Limit query HCA clock
  IB/mlx5: Fix returned values of query QP
  IB/mlx5: Check BlueFlame HCA support
  IB/mlx5: Fix entries checks in mlx5_ib_create_cq
  IB/mlx5: Fix entries check in mlx5_ib_resize_cq
  IB/mlx5: Fix pkey_index length in the QP path record

 drivers/infiniband/hw/mlx5/cq.c   | 12 +++++++++---
 drivers/infiniband/hw/mlx5/main.c | 22 ++++++++++++++-------
 drivers/infiniband/hw/mlx5/qp.c   | 41 ++++++++++++++++++++++++---------------
 include/linux/mlx5/qp.h           |  5 ++---
 4 files changed, 51 insertions(+), 29 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
