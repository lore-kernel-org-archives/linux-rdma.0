From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/7] Mellanox ConnectX-4/Connect-IB sniffer support
Date: Sun, 28 Aug 2016 14:16:27 +0300
Message-ID: <1472382994-32091-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set adds sniffer support to mlx5 flow steering.
A sniffer rule could be created via ib_create_flow verb with
IB_FLOW_ATTR_SNIFFER type. When the user adds a sniffer rule,
its destination QP expects to receive all incoming and
outgoing packets from the port. Only raw packet QPs are
supported as destinations.

In ConnectX-4 based adapters, each incoming packet is duplicated and
sent to the sniffer RX flow table in addition to the NIC RX root flow
table. Each out going packet is duplicated and sent to the sniffer TX
flow table in addition to the wire.

In order to sniff all the traffic, we add a single "*" rule both
to the RX and TX sniffer flow tables. "*" rule is used to receive
all the traffic, this rule don't contain any criteria.

Available in the "topic/sniffer-verb" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/sniffer-verb

Thanks,
  Maor & Leon

Maor Gottlieb (7):
  net/mlx5: Introduce sniffer steering hardware capabilities
  net/mlx5: Add sniffer namespaces
  IB/mlx5: Fix steering resource leak
  IB/mlx5: Save flow table priority handler instead of index
  IB/mlx5: Fix coverity warning
  IB/mlx5: Increase flow table reference count in create rule
  IB/mlx5: Add sniffer support to steering

 drivers/infiniband/hw/mlx5/main.c                 | 91 ++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 58 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  4 +
 include/linux/mlx5/device.h                       | 12 +++
 include/linux/mlx5/fs.h                           |  2 +
 include/linux/mlx5/mlx5_ifc.h                     |  4 +-
 7 files changed, 164 insertions(+), 11 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
