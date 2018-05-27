From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/3] Introduce new mlx5 CQE format
Date: Sun, 27 May 2018 13:42:31 +0300
Message-ID: <20180527104234.17261-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Introduce new internal to mlx5 CQE format - mini-CQE. It is a CQE in
compressed form that holds data needed to extra a single full CQE.

It stride index, byte count and packet checksum.

Thanks

Yonatan Cohen (3):
  net/mlx5: Exposing a new mini-CQE format
  IB/mlx5: Refactor CQE compression response
  IB/mlx5: Introduce a new mini-CQE format

 drivers/infiniband/hw/mlx5/cq.c   | 42 +++++++++++++++++++++++++++++----------
 drivers/infiniband/hw/mlx5/main.c | 20 +++++++++++++------
 include/linux/mlx5/mlx5_ifc.h     |  3 ++-
 include/uapi/rdma/mlx5-abi.h      |  2 +-
 4 files changed, 49 insertions(+), 18 deletions(-)
