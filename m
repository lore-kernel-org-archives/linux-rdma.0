From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/6] mlx5 profile infrastructure to add and remove stages
Date: Sun, 24 Dec 2017 14:40:09 +0200
Message-ID: <20171224124015.31917-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mark's patches continues e-switch series introduced in shared pull request
and refactors the mlx5_ib initialization and cleanup logic to work in the
stages.

Such modular separation provides an easy way to construct any initialization
sequences and skip unneeded stages as we will have in RDMA/IB representors code.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-12-24

	Thanks
---------------------------------------

Mark Bloch (6):
  IB/mlx5: Create profile infrastructure to add and remove stages
  IB/mlx5: Move RoCE/ETH initialization to the corresponding stage
  IB/mlx5: Move ODP initialization to the corresponding stage
  IB/mlx5: Move hardware counters initialization to the corresponding
    stage
  IB/mlx5: Move loopback initialization to the corresponding stage
  IB/mlx5: Move locks initialization to the corresponding stage

 drivers/infiniband/hw/mlx5/main.c    | 370 ++++++++++++++++++++++++-----------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  51 ++++-
 drivers/infiniband/hw/mlx5/mr.c      |   7 +-
 drivers/infiniband/hw/mlx5/odp.c     |  38 ++--
 4 files changed, 324 insertions(+), 142 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
