From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 00/12] Add SRQ and XRC support for ODP MRs
Date: Tue, 22 Jan 2019 08:48:39 +0200
Message-ID: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series extend ODP to work with SRQ and XRC. Being both per-operation
(e.g. RDMA write, RDMA read and atomic) and per-transport (e.g. RC, UD and XRC),
we extend IB/core and mlx5 driver to provide needed information to user space.

Thanks

Moni Shoua (12):
  IB/mlx5: Fix locking SRQ object in ODP event
  IB/core: Allocate bit for SRQ ODP support
  IB/uverbs: Expose XRC ODP device capabilities
  IB/mlx5: Remove useless check in ODP handler
  IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
  IB/mlx5: Add XRC initiator ODP support
  IB/mlx5: Let read user wqe also from SRQ buffer
  IB/mlx5: Add ODP SRQ support
  IB/mlx5: Advertise SRQ ODP support for supported transports
  net/mlx5: Add XRC transport to ODP device capabilities layout
  IB/mlx5: Advertise XRC ODP support
  net/mlx5: Set ODP SRQ support in firmware

 drivers/infiniband/core/uverbs_cmd.c          |   1 +
 drivers/infiniband/hw/mlx5/cq.c               |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   9 +-
 drivers/infiniband/hw/mlx5/odp.c              | 138 ++++++++++---
 drivers/infiniband/hw/mlx5/qp.c               | 192 +++++++++++++-----
 drivers/infiniband/hw/mlx5/srq.h              |   2 -
 drivers/infiniband/hw/mlx5/srq_cmd.c          |  16 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  53 +++++
 include/linux/mlx5/device.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 |   5 +-
 include/rdma/ib_verbs.h                       |   2 +
 include/uapi/rdma/ib_user_verbs.h             |   2 +
 12 files changed, 331 insertions(+), 96 deletions(-)
