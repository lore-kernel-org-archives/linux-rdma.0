From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 00/12] IB/mlx4: Add RoCEv2 support
Date: Thu, 14 Jan 2016 17:50:31 +0200
Message-ID: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCEv2 is the InfiniBand transport protocol encapsulated in ETH/IP/UDP link
and network protocols.
The implementation to the IB/core driver was added by Matan Barak as an
infrastructure for any vendor driver and this patch set uses it to add
RoCEv2 support for ConnectX-3Pro NICs

Matan Barak (1):
  IB/mlx4: Advertise RoCE v2 support

Moni Shoua (11):
  net/mlx4: Query RoCE support
  IB/mlx4: Add gid_type to GID properties
  net/mlx4_core: Configure mlx4 hardware for mixed RoCE v1/v2 modes
  IB/mlx4: Add support for setting RoCEv2 gids in hardware
  net/mlx4_core: Add support for configuring RoCE v2 UDP port
  net/mlx4_core: Add support for RoCE v2 entropy
  IB/core: Add definition for the standard RoCE V2 UDP port
  IB/mlx4: Support modify_qp for RoCE v2
  IB/mlx4: Enable RoCE v2 when the IB device is added
  IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
  IB/mlx4: Create and use another QP1 for RoCEv2

 drivers/infiniband/core/ud_header.c       |   2 +-
 drivers/infiniband/hw/mlx4/main.c         | 101 ++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   8 +
 drivers/infiniband/hw/mlx4/qp.c           | 256 ++++++++++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/fw.c   |  39 ++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   5 +-
 drivers/net/ethernet/mellanox/mlx4/port.c |   7 +
 drivers/net/ethernet/mellanox/mlx4/qp.c   |  26 +++
 include/linux/mlx4/cmd.h                  |   3 +-
 include/linux/mlx4/device.h               |  11 +-
 include/linux/mlx4/qp.h                   |  15 +-
 include/rdma/ib_pack.h                    |   4 +-
 include/rdma/ib_verbs.h                   |   1 +
 13 files changed, 425 insertions(+), 53 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
