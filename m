From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/2] DevX fixes
Date: Tue, 14 May 2019 14:44:10 +0300
Message-ID: <20190514114412.30604-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

There are two very short but important fixes to DevX flows.

Thanks

Yishai Hadas (2):
  IB/mlx5: Verify DEVX general object type correctly
  net/mlx5: Set completion EQs as shared resources

 drivers/infiniband/hw/mlx5/devx.c            | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  3 +++
 include/linux/mlx5/mlx5_ifc.h                |  2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)
