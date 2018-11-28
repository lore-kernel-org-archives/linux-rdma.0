From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 00/11] Remove SRQ code from mlx5_core
Date: Wed, 28 Nov 2018 20:53:32 +0200
Message-ID: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi Doug and Jason,

This series is intended to be applied on mlx5-next after Saeed's
infrastructure changes series are accepted:
https://patchwork.kernel.org/project/linux-rdma/list/?series=47809

----------------------------------------------------------------------
The following patchset brings mlx5 SRQ functionality to the module
which is actually using it - mlx5_ib. The original code being not used
in mlx5_core/mlx5_en, but located there, caused to unneeded maintenance
overhead.

By moving mlx5 SRQ code to mlx5_ib, we successfully reduced ~200 LOC codes
and minimized exports and headers pollution.

The proposed patches are divided to three logical groups: move from
netdev, fix IB part and cleanup.

Thanks

Leon Romanovsky (11):
  net/mlx5: Align SRQ licenses and copyright information
  net/mlx5: Remove dead transobj code
  net/mlx5: Remove not-used lib/eq.h header file
  net/mlx5: Remove references to local mlx5_core functions
  net/mlx5: Move SRQ functions to RDMA part
  RDMA/mlx5: Remove SRQ signature global flag
  RDMA/mlx5: Use stages for callback to setup and release DEVX
  RDMA/mlx5: Update SRQ functions signatures to mlx5_ib format
  RDMA/mlx5: Initialize SRQ tables on mlx5_ib
  RDMA/mlx5: Unfold create RMP function
  RDMA/mlx5: Unfold modify RMP function

 drivers/infiniband/hw/mlx5/Makefile           |   4 +-
 drivers/infiniband/hw/mlx5/cq.c               |   4 +-
 drivers/infiniband/hw/mlx5/ib_rep.c           |   4 +
 drivers/infiniband/hw/mlx5/main.c             |  33 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   6 +-
 drivers/infiniband/hw/mlx5/srq.c              |  49 +--
 drivers/infiniband/hw/mlx5/srq.h              |  73 ++++
 .../srq.c => infiniband/hw/mlx5/srq_cmd.c}    | 321 ++++++++----------
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 -
 .../ethernet/mellanox/mlx5/core/transobj.c    | 109 ------
 include/linux/mlx5/driver.h                   |  33 --
 include/linux/mlx5/srq.h                      |  72 ----
 include/linux/mlx5/transobj.h                 |  11 -
 14 files changed, 274 insertions(+), 452 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/srq.h
 rename drivers/{net/ethernet/mellanox/mlx5/core/srq.c => infiniband/hw/mlx5/srq_cmd.c} (71%)
 delete mode 100644 include/linux/mlx5/srq.h
