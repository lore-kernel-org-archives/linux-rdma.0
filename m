From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/2] Allocate the per-port Q counter
Date: Sun,  9 Dec 2018 12:52:34 +0200
Message-ID: <20181209105236.26233-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi

See commit message for the patch description.

Thanks

Leon Romanovsky (1):
  net/mlx5: Add shared Q counter bits

Yishai Hadas (1):
  IB/mlx5: Allocate the per-port Q counter shared when DEVX is supported

 drivers/infiniband/hw/mlx5/cmd.c  | 17 +++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h  |  2 ++
 drivers/infiniband/hw/mlx5/main.c | 10 ++++++++--
 include/linux/mlx5/mlx5_ifc.h     |  6 +++++-
 4 files changed, 32 insertions(+), 3 deletions(-)
