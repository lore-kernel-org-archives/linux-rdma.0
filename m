From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/7] Add RoCE v2 support for mlx4 driver
Date: Tue, 29 Dec 2015 15:24:00 +0200
Message-ID: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series adds RoCE v2 support for mlx4 driver.
It implements the required bits in the new RoCE v2 API while adding
the necessary firmware commands and handling.

Patch 0001 queries the firmware if RoCE is supported.
Patch 0002 introduces a new firmware command that sets the GID table,
such that we store the GID type along the GID itself in the table.
Patch 0003 configures the device to work in RoCE v1 and RoCE v2 mixed
mode.
Patch 0004 adds the support to create steering rules for IPv4 based
packets. This is necessary in order to support RoCE multicast.
Patch 0005 introduces the support for sending RoCE v2 packets from
QP1.
Patch 0006 creates another QP in order to receive QP1 RoCE v2 traffic.
Patch 0007 advertises RoCE v2 support for upper layer. From this point
and on, the GID table will be populated with RoCE v2 based GIDs (if
the hardware supports so).

Regards,
Moni and Matan

Maor Gottlieb (1):
  net/mlx4_core: Add handlning of RoCE v2 over IPV4 in attach_flow

Matan Barak (2):
  IB/mlx4: Add RoCE per GID support for add_gid and del_gid
  IB/mlx4: Advertise RoCE support

Moni Shoua (4):
  IB/mlx4: Query RoCE support
  IB/mlx4: Configure device to work in RoCEv2
  IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
  IB/mlx4: Create and use another QP1 for RoCEv2

 drivers/infiniband/hw/mlx4/main.c         | 100 +++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   8 +
 drivers/infiniband/hw/mlx4/qp.c           | 283 ++++++++++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx4/fw.c   |  19 +-
 drivers/net/ethernet/mellanox/mlx4/main.c |   6 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c  |  14 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   7 +-
 drivers/net/ethernet/mellanox/mlx4/port.c |   8 +
 drivers/net/ethernet/mellanox/mlx4/qp.c   |  28 +++
 include/linux/mlx4/cmd.h                  |   3 +-
 include/linux/mlx4/device.h               |  18 +-
 include/linux/mlx4/qp.h                   |  15 +-
 include/rdma/ib_verbs.h                   |   2 +
 13 files changed, 434 insertions(+), 77 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
