From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 0/7] Preparation to DevX extension series
Date: Thu, 20 Sep 2018 21:35:19 +0300
Message-ID: <20180920183526.13995-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog v0->v1:
 * Update commit messages
 * Split DevX series to small sub-series.
 * Change static initialization from {0} to be {}

------- From Yishai,

Set uid as part of various IB commands so that the firmware can manage
the IB object in a secured way.

The firmware should mark this IB object with the given uid so that it
can be used later on only by objects with the same uid.

Upon DEVX flows that use this objec, the pointed object must have
the same uid as of the issuer uid command.

When a command is issued with uid=0 it means that the issuer of the
command is trusted (i.e. kernel), in that case any pointed object
can be used regardless of its uid.

Thanks

Leon Romanovsky (1):
  net/mlx5: Update mlx5_ifc with DEVX UID bits

Yishai Hadas (6):
  net/mlx5: Set uid as part of CQ commands
  net/mlx5: Set uid as part of QP commands
  net/mlx5: Set uid as part of RQ commands
  net/mlx5: Set uid as part of SQ commands
  net/mlx5: Set uid as part of SRQ commands
  net/mlx5: Set uid as part of DCT commands

 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  81 +++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/srq.c |  30 +++++-
 include/linux/mlx5/cq.h                       |   1 +
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 | 135 +++++++++++++++-----------
 include/linux/mlx5/qp.h                       |   1 +
 include/linux/mlx5/srq.h                      |   1 +
 8 files changed, 171 insertions(+), 83 deletions(-)
