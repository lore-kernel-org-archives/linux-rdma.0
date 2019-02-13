From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/15] mlx5-next updates (ECPF & 50Gbps per lane)
Date: Tue, 12 Feb 2019 22:55:31 -0800
Message-ID: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

This series from Bodong and Aya provides two low level updates to mlx5
core driver that are required for both mlx5e netdev and mlx5_ib drivers.

>From Bodong Wang:
1) Introduction of ECPF (Embedded CPU Physical Function), and low level
bits for mlx5 SmartNic capabilities support. 
2) Vport enumeration refactoring that affect mlx5_ib and mlx5_core

>From Aya Levin,
3) Add support for 50Gbps per lane link modes in the Port Type and Speed
register (PTYS)
4) Refactor low level query functions for PTYS register
5) Add support for 50Gbps per lane link modes to mlx5_ib

Thanks,
Saeed.

---

Aya Levin (4):
  net/mlx5: Refactor queries to speed fields in Port Type and Speed
    register
  net/mlx5: Add new fields to Port Type and Speed register
  net/mlx5: Add support to ext_* fields introduced in Port Type and
    Speed register
  IB/mlx5: Add support for 50Gbps per lane link modes

Bodong Wang (11):
  net/mlx5: Use void pointer as the type in address_of macro
  net/mlx5: Use consistent vport num argument type
  IB/mlx5: Use unified register/load function for uplink and VF vports
  net/mlx5: Introduce Mellanox SmartNIC and modify page management logic
  net/mlx5: Update enable HCA dependency
  net/mlx5: Add query host params command
  net/mlx5: Add host params change event
  net/mlx5: Provide an alternative VF upper bound for ECPF
  net/mlx5: E-Switch, Normalize the name of uplink vport number
  net/mlx5: Relocate vport macros to the vport header file
  net/mlx5: E-Switch, Avoid magic numbers when initializing offloads
    mode

 drivers/infiniband/hw/mlx5/ib_rep.c           |  73 +++------
 drivers/infiniband/hw/mlx5/ib_rep.h           |  10 +-
 drivers/infiniband/hw/mlx5/main.c             |  95 +++++++++---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 112 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    |  33 ++++
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 142 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  16 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  28 ++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  22 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  42 +++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 -
 .../mellanox/mlx5/core/eswitch_offloads.c     |  39 ++---
 .../net/ethernet/mellanox/mlx5/core/events.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  16 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/pagealloc.c   |  54 +++++--
 .../net/ethernet/mellanox/mlx5/core/port.c    | 106 -------------
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |   8 +-
 include/linux/mlx5/device.h                   |   6 +-
 include/linux/mlx5/driver.h                   |  27 +++-
 include/linux/mlx5/mlx5_ifc.h                 |  71 +++++++--
 include/linux/mlx5/port.h                     |  30 ++--
 include/linux/mlx5/vport.h                    |  21 ++-
 29 files changed, 641 insertions(+), 333 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ecpf.h

-- 
2.20.1
