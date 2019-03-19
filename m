From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/4] Small set of mlx5 related fixes
Date: Tue, 19 Mar 2019 11:24:35 +0200
Message-ID: <20190319092439.10701-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Guy Levi <guyle@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Despite one change in mlx5_core, all those changes are for mlx5_ib. The
change in mlx5_core is related to MR cache initialization that is not
used in mlx5_core at all.

Thanks

Artemy Kovalyov (3):
  IB/mlx5: WQE dump jumps over first 16 bytes
  net/mlx5: Decrease default mr cache size
  IB/mlx5: Compare only index part of a memory window rkey

Moni Shoua (1):
  IB/mlx5: Reset access mask when looping inside page fault handler

 drivers/infiniband/hw/mlx5/odp.c              | 14 +++++++++++--
 drivers/infiniband/hw/mlx5/qp.c               |  5 ++---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 20 -------------------
 3 files changed, 14 insertions(+), 25 deletions(-)
