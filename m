From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Mon, 17 Sep 2018 13:30:45 +0300
Message-ID: <20180917103049.18235-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is short series from Mark which extends handling of loopback
traffic. Originally mlx5 IB dynamically enabled/disabled both unicast
and multicast based on number of users. However RAW ethernet QPs need
more granular access.

Thanks

Mark Bloch (4):
  net/mlx5: Rename incorrect naming in IFC file
  RDMA/mlx5: Refactor transport domain bookkeeping logic
  RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
  RDMA/mlx5: Enable vport loopback when user context or QP mandate

 drivers/infiniband/hw/mlx5/main.c                  | 61 ++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h               | 16 +++-
 drivers/infiniband/hw/mlx5/qp.c                    | 96 +++++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  2 +-
 include/linux/mlx5/mlx5_ifc.h                      |  4 +-
 include/uapi/rdma/mlx5-abi.h                       |  2 +
 6 files changed, 138 insertions(+), 43 deletions(-)
