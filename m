From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/3] Expose ENCAP mode to mlx5_ib
Date: Thu,  6 Jun 2019 14:06:06 +0300
Message-ID: <20190606110609.11588-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is short series from Maor to expose and use enacap mode inside mlx5_ib.

Thanks

Maor Gottlieb (3):
  net/mlx5: Expose eswitch encap mode
  RDMA/mlx5: Consider eswitch encap mode
  RDMA/mlx5: Enable decap and packet reformat on FDB

 drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++
 include/linux/mlx5/eswitch.h                  | 10 ++++++++
 3 files changed, 39 insertions(+), 6 deletions(-)
