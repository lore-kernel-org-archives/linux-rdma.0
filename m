From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/8] Export vendors specific ABIs
Date: Sun, 18 Sep 2016 13:50:15 +0300
Message-ID: <1474195823-10429-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The consolidate library revealed the fact that vendor specific
structures and defines are copy/pasted between kernel and user-space.

This patch set moves these headers from internal driver directory to common
place and unifies their name to be drivername-abi.h, so it will be easily shared
by numerous libraries supported in https://github.com/linux-rdma/rdma-core.git.

The drivers which were NOT handled in this patch set are mthca (dead code), hfi, qib,
rxe, usnic and i40iw.

Available in the "topic/uapi-abi" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/uapi-abi

Thanks

Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Leon Romanovsky (8):
  IB/mlx5: Move and decouple user vendor structures
  IB/cxgb3: Move user vendor structures
  IB/cxgb4: Move user vendor structures
  IB/mlx4: Move user vendor structures
  IB/ocrdma: Move user vendor structures
  IB/nes: Move user vendor structures
  IB/core: Export vendor specific structures
  MAINTAINERS: Update RDMA vendor specific UAPI files

 MAINTAINERS                                 |   6 +
 drivers/infiniband/hw/cxgb3/iwch.c          |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_user.h     |  74 --------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   2 +-
 drivers/infiniband/hw/cxgb4/user.h          |  80 --------
 drivers/infiniband/hw/mlx4/cq.c             |   2 +-
 drivers/infiniband/hw/mlx4/main.c           |   2 +-
 drivers/infiniband/hw/mlx4/qp.c             |   2 +-
 drivers/infiniband/hw/mlx4/srq.c            |   2 +-
 drivers/infiniband/hw/mlx4/user.h           | 107 -----------
 drivers/infiniband/hw/mlx5/cq.c             |   1 -
 drivers/infiniband/hw/mlx5/main.c           |   1 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  37 ++++
 drivers/infiniband/hw/mlx5/mr.c             |   1 -
 drivers/infiniband/hw/mlx5/qp.c             |   1 -
 drivers/infiniband/hw/mlx5/srq.c            |   1 -
 drivers/infiniband/hw/mlx5/user.h           | 281 ----------------------------
 drivers/infiniband/hw/nes/nes.h             |   2 +-
 drivers/infiniband/hw/nes/nes_user.h        | 114 -----------
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   | 149 ---------------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   2 +-
 include/uapi/rdma/Kbuild                    |   6 +
 include/uapi/rdma/cxgb3-abi.h               |  76 ++++++++
 include/uapi/rdma/cxgb4-abi.h               |  82 ++++++++
 include/uapi/rdma/mlx4-abi.h                | 107 +++++++++++
 include/uapi/rdma/mlx5-abi.h                | 244 ++++++++++++++++++++++++
 include/uapi/rdma/nes-abi.h                 | 114 +++++++++++
 include/uapi/rdma/ocrdma-abi.h              | 151 +++++++++++++++
 30 files changed, 833 insertions(+), 820 deletions(-)
 delete mode 100644 drivers/infiniband/hw/cxgb3/iwch_user.h
 delete mode 100644 drivers/infiniband/hw/cxgb4/user.h
 delete mode 100644 drivers/infiniband/hw/mlx4/user.h
 delete mode 100644 drivers/infiniband/hw/mlx5/user.h
 delete mode 100644 drivers/infiniband/hw/nes/nes_user.h
 delete mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_abi.h
 create mode 100644 include/uapi/rdma/cxgb3-abi.h
 create mode 100644 include/uapi/rdma/cxgb4-abi.h
 create mode 100644 include/uapi/rdma/mlx4-abi.h
 create mode 100644 include/uapi/rdma/mlx5-abi.h
 create mode 100644 include/uapi/rdma/nes-abi.h
 create mode 100644 include/uapi/rdma/ocrdma-abi.h

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
