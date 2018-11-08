From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 00/10] Collection of ODP fixes
Date: Thu,  8 Nov 2018 21:10:07 +0200
Message-ID: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is collection of fixes to mlx5_core and mlx5_ib ODP logic.
There are two main reasons why we decided to forward it to mlx5-next
and not to rdma-rc or net like our other fixes.

1. We have large number of patches exactly in that area that are ready
for submission and we don't want to create extra merge work for
maintainers due to that. Among those future series (already ready and
tested): internal change of mlx5_core pagefaults handling, moving ODP
code to RDMA, change in EQ mechanism, simplification and moving SRQ QP
to RDMA, extra fixes to mlx5_ib ODP and ODP SRQ support.

2. Most of those fixes are for old bugs and there is no rush to fix them
right now (in -rc1/-rc2).

Thanks

Moni Shoua (10):
  net/mlx5: Release resource on error flow
  IB/mlx5: Avoid hangs due to a missing completion
  net/mlx5: Add interface to hold and release core resources
  net/mlx5: Enumerate page fault types
  IB/mlx5: Lock QP during page fault handling
  net/mlx5: Return success for PAGE_FAULT_RESUME in internal error state
  net/mlx5: Use multi threaded workqueue for page fault handling
  IB/mlx5: Call PAGE_FAULT_RESUME command asynchronously
  net/mlx5: Remove unused function
  IB/mlx5: Improve ODP debugging messages

 drivers/infiniband/core/umem_odp.c            |  14 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   1 +
 drivers/infiniband/hw/mlx5/mr.c               |  15 +-
 drivers/infiniband/hw/mlx5/odp.c              | 158 ++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  21 +--
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  20 ++-
 include/linux/mlx5/device.h                   |   7 +
 include/linux/mlx5/driver.h                   |   7 +-
 include/linux/mlx5/qp.h                       |   5 +
 10 files changed, 191 insertions(+), 59 deletions(-)
