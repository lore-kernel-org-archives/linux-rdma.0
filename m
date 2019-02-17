From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next 0/2] Fix W=1 compilation warnings
Date: Sun, 17 Feb 2019 15:21:26 +0200
Message-ID: <20190217132128.9709-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S . Miller" <davem@davemloft.net>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Eyal Davidovich <eyald@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi Saeed,

This short series fixes two small compilation warnings which are visible
while compiling with W=1.

Thanks

Leon Romanovsky (2):
  net/mlx5e: Add missing static function annotation
  net/mlx5: Delete unused FPGA QPN variable

 drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c        | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)
