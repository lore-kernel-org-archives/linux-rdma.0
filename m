From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/3] Dump and fill MKEY
Date: Tue, 19 Jun 2018 08:47:21 +0300
Message-ID: <20180619054724.32677-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

MLX5 IB HCA offers the memory key, dump_fill_mkey to increase
performance, when used in a send or receive operations.

It is used to force local HCA operations to skip the PCI bus access,
while keeping track of the processed length in the ibv_sge handling.

In this three patch series, we expose various bits in our HW
spec file (mlx5_ifc.h), move unneeded for mlx5_core FW command and
export such memory key to user space thought our mlx5-abi header file.

Thanks

Leon Romanovsky (1):
  net/mlx5: Add hardware definitions for dump_fill_mkey

Yonatan Cohen (2):
  net/mlx5: Limit scope of dump_fill_mkey function
  IB/mlx5: Expose dump and fill memory key

 drivers/infiniband/hw/mlx5/cmd.c             | 15 +++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h             |  1 +
 drivers/infiniband/hw/mlx5/main.c            | 16 +++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 17 -----------------
 include/linux/mlx5/driver.h                  |  2 --
 include/linux/mlx5/mlx5_ifc.h                |  4 +++-
 include/uapi/rdma/mlx5-abi.h                 |  3 ++-
 7 files changed, 36 insertions(+), 22 deletions(-)
