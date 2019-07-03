From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates 2019-07-02
Date: Wed, 3 Jul 2019 07:39:24 +0000
Message-ID: <20190703073909.14965-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

This series includes some low level updates to mlx5 driver, required for
shared mlx5-next branch.

Tariq extends the WQE control fields names.
Eran adds the required HW definitions and structures for upcoming TLS
support.
Parav improves and refactors the E-Switch "function changed" handler.

In case of no objections these patches will be applied to mlx5-next and
will be sent later as pull request to both rdma-next and net-next trees.

Thanks,
Saeed.

---

Eran Ben Elisha (1):
  net/mlx5: Introduce TLS TX offload hardware bits and structures

Parav Pandit (3):
  net/mlx5: Introduce and use mlx5_eswitch_get_total_vports()
  net/mlx5: E-Switch prepare functions change handler to be modular
  net/mlx5: Refactor mlx5_esw_query_functions for modularity

Tariq Toukan (1):
  net/mlx5: Properly name the generic WQE control field

 drivers/infiniband/hw/mlx5/ib_rep.c           |   2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  42 +++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  46 +++++---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  26 +++--
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  15 ++-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  15 +++
 include/linux/mlx5/device.h                   |  14 +++
 include/linux/mlx5/driver.h                   |   9 +-
 include/linux/mlx5/eswitch.h                  |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 104 +++++++++++++++++-
 include/linux/mlx5/qp.h                       |   7 +-
 include/linux/mlx5/vport.h                    |   3 -
 13 files changed, 232 insertions(+), 61 deletions(-)

--=20
2.21.0
