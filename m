From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
Date: Wed, 14 Sep 2016 11:27:26 +0300
Message-ID: <1473841649-8923-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The consolidate library revealed the fact that vendor specific
structures and defines are copy/pasted between kernel and user-space,
instead of sharing.

This RFC was tested by compilation only and not-ready for merge yet.

Leon Romanovsky (3):
  IB/mlx5: Move and decouple user vendor structures
  IB/core: Export mlx5 vendor specific strucutres
  MAINTAINERS: Add mlx5 uapi file

 MAINTAINERS                            |   1 +
 drivers/infiniband/hw/mlx5/cq.c        |   1 -
 drivers/infiniband/hw/mlx5/main.c      |   1 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h   |  37 +++++
 drivers/infiniband/hw/mlx5/mr.c        |   1 -
 drivers/infiniband/hw/mlx5/qp.c        |   1 -
 drivers/infiniband/hw/mlx5/srq.c       |   1 -
 drivers/infiniband/hw/mlx5/user.h      | 281 ---------------------------------
 include/uapi/rdma/Kbuild               |   1 +
 include/uapi/rdma/providers/Kbuild     |   2 +
 include/uapi/rdma/providers/mlx5-abi.h | 242 ++++++++++++++++++++++++++++
 11 files changed, 283 insertions(+), 286 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/user.h
 create mode 100644 include/uapi/rdma/providers/Kbuild
 create mode 100644 include/uapi/rdma/providers/mlx5-abi.h

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
