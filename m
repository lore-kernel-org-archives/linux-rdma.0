From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/10] mlx5 core updates and cleanups
Date: Sun,  9 Dec 2018 19:04:32 -0800
Message-ID: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi

This patchset is for mlx5-next shared branch, and will be applied there
once the review is done.

1) From Eli Britstein, add mlx5 core support for flow steering extended
destination
2) From Mikhael Goikhman, port module events cleanup and support for
PCIe power slot exceeded errors and plugged-disabled cable status.
3) Eyal Davidovich adds monitor commands layout and event data.
4) From Or Gerlitz, Simplify netdev unbinding in mlx5_ib and 
remove unsed mlx5 interface callback (get_protocol).

Thanks,
Saeed.

---

Eli Britstein (3):
  net/mlx5: Introduce extended destination fields
  net/mlx5: E-Switch, Change vhca id valid bool field to bit flag
  net/mlx5: Support extended destination format in flow steering command

Eyal Davidovich (1):
  net/mlx5: Add monitor commands layout and event data

Mikhael Goikhman (3):
  net/mlx5: Rework handling of port module events
  net/mlx5: Add support for PCIe power slot exceeded error in PME
  net/mlx5: Add support for plugged-disabled cable status in PME

Or Gerlitz (2):
  IB/mlx5: Simplify netdev unbinding
  net/mlx5: Remove the get protocol device interface entry

Oz Shlomo (1):
  net/mlx5: Revise gre and nvgre key formats

 drivers/infiniband/hw/mlx5/main.c             |  18 +--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  22 ----
 .../mellanox/mlx5/core/diag/fs_tracepoint.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 --
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   3 +
 .../mellanox/mlx5/core/eswitch_offloads.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  |  89 ++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  83 ++++++++++--
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  21 ++--
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   2 -
 include/linux/mlx5/fs.h                       |   8 +-
 include/linux/mlx5/mlx5_ifc.h                 | 119 +++++++++++++++++-
 15 files changed, 296 insertions(+), 106 deletions(-)

-- 
2.19.2
