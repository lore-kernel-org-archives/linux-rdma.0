From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/3]  Packet based credit mode
Date: Fri, 30 Nov 2018 13:22:03 +0200
Message-ID: <20181130112206.19870-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Danit,

Packet based credit mode is an alternative end-to-end credit mode for QPs
set during their creation. Credits are transported from the responder
to the requester to optimize the use of its receive resources.
In packet-based credit mode, credits are issued on a per packet basis.

The advantage of this feature comes while sending large RDMA messages
through switches that are short in memory.

The first commit exposes QP creation flag and the HCA capability. The
second commit adds support for a new DV QP creation flag. The last
commit report packet based credit mode capability via the MLX5DV device
capabilities.

Thanks

Danit Goldberg (3):
  net/mlx5: Expose packet based credit mode
  IB/mlx5: Add packet based credit mode support
  IB/mlx5: Report packet based credit mode device capability

 drivers/infiniband/hw/mlx5/main.c    |  3 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 15 +++++++++++++--
 include/linux/mlx5/mlx5_ifc.h        |  6 ++++--
 include/uapi/rdma/mlx5-abi.h         |  2 ++
 5 files changed, 23 insertions(+), 4 deletions(-)
