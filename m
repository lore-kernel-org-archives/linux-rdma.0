From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 0/2] DEVX VHCA tunnel support
Date: Mon,  1 Jul 2019 21:14:00 +0300
Message-ID: <20190701181402.25286-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Max Gurtovoy <maxg@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Those two patches introduce VHCA tunnel mechanism to DEVX interface
needed for Bluefield SOC. See extensive commit messages for more
information.

Thanks

Max Gurtovoy (2):
  net/mlx5: Introduce VHCA tunnel device capability
  IB/mlx5: Implement VHCA tunnel mechanism in DEVX

 drivers/infiniband/hw/mlx5/devx.c | 24 ++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h     | 10 ++++++++--
 2 files changed, 28 insertions(+), 6 deletions(-)
