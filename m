From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/3] Indirect MKEY over DEVX
Date: Sun, 13 Jan 2019 16:01:15 +0200
Message-ID: <20190113140118.10204-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

>From Yishai,
-----------------------------------------------------------------------

This series enables using indirect mkey over DEVX.

The first patch recognizes the creation of an indirect mkey as part of
DEVX object creation, in that case the umem valid bit shouldn't be set as
this mkey doesn't really hold a umem.

The next two patches manage indirection mkey upon DEVX flow to support ODP.

To support a page fault event on an indirection mkey it needs to be part
of the device mkey radix tree. Both the creation and the deletion flows for a
DEVX object which is indirection mkey were adapted to handle that.

In addition, the page fault flow was adapted to support indirect mkey type,
it's handled in a similar flow as of the memory window mkey type.

Yishai

Yishai Hadas (3):
  IB/mlx5: DEVX handling for indirection MKEY
  IB/mlx5: Manage indirection mkey upon DEVX flow for ODP
  IB/mlx5: Add support for ODP for DEVX indirection mkey

 drivers/infiniband/hw/mlx5/devx.c    | 125 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/main.c    |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
 drivers/infiniband/hw/mlx5/odp.c     |  26 ++++--
 include/linux/mlx5/driver.h          |   1 +
 5 files changed, 152 insertions(+), 7 deletions(-)
