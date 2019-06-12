From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Date: Wed, 12 Jun 2019 15:20:10 +0300
Message-ID: <20190612122014.22359-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog v0->v1:
 * Added patch to devlink to use declared enum for encap mode instead of u8
 * Constify input argumetn to encap mode function
 * fix encap variable type to be boolean

---------------------------------------------------------------------
Hi,

This is short series from Maor to expose and use enacap mode inside mlx5_ib.

Thanks

Leon Romanovsky (1):
  net/mlx5: Declare more strictly devlink encap mode

Maor Gottlieb (3):
  net/mlx5: Expose eswitch encap mode
  RDMA/mlx5: Consider eswitch encap mode
  RDMA/mlx5: Enable decap and packet reformat on FDB

 drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++---
 .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +++--
 include/linux/mlx5/eswitch.h                  | 12 +++++++++
 include/net/devlink.h                         |  6 +++--
 net/core/devlink.c                            |  6 +++--
 7 files changed, 59 insertions(+), 15 deletions(-)
