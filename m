From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/8] User space steering
Date: Sun, 31 Mar 2019 19:44:42 +0300
Message-ID: <20190331164450.23618-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

>From Ariel,

This series of patches adds user space managed steering infrastructure
to the mlx5_ib driver.

User space managed steering requires the means to access a dedicated
memory space that is used by the device to store the packet steering
and header modification tables and rules in order to manage them directly
without the device's firmware involvement. This dedicated memory is part
of the ICM memory space.

The changes are introducing the mlx5_ib API to allocate, deallocate and
register this dedicated SW ICM memory via the existing device memory API
using a private attribute which specifies the memory type.

The allocated memory itself is not IO mapped and user can only access it
using remote RDMA operations.

In addition, the series exposed the ICM address of the receive transport
interface (TIR) of Raw Packet and RSS QPs to user since they are required
to properly create and insert steering rules that direct flows to these QPs.

Thanks

Ariel Levkovich (8):
  net/mlx5: Expose SW ICM related device memory capabilities
  IB/mlx5: Support device memory type attribute
  IB/mlx5: Warn on allocated MEMIC buffers during cleanup
  IB/mlx5: Add steering SW ICM device memory type
  IB/mlx5: Device resource control for privileged DEVX user
  net/mlx5: Expose TIR ICM address in command outbox
  net/mlx5: Introduce new TIR creation core API
  IB/mlx5: Expose TIR ICM address to user space

 drivers/infiniband/hw/mlx5/Kconfig            |   2 +-
 drivers/infiniband/hw/mlx5/cmd.c              | 155 +++++++++-
 drivers/infiniband/hw/mlx5/cmd.h              |   8 +-
 drivers/infiniband/hw/mlx5/devx.c             |   4 +
 drivers/infiniband/hw/mlx5/main.c             | 264 +++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  40 ++-
 drivers/infiniband/hw/mlx5/mr.c               |  40 ++-
 drivers/infiniband/hw/mlx5/qp.c               |  46 ++-
 .../ethernet/mellanox/mlx5/core/transobj.c    |  18 +-
 include/linux/mlx5/mlx5_ifc.h                 |  51 +++-
 include/linux/mlx5/transobj.h                 |   3 +
 include/uapi/rdma/mlx5-abi.h                  |   2 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |   1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h     |   6 +
 14 files changed, 541 insertions(+), 99 deletions(-)
