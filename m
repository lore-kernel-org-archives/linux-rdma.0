From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: [PATCH net 0/2] mlx5_core fixes for 3.18
Date: Thu,  6 Nov 2014 12:51:20 +0200
Message-ID: <1415271082-7644-1-git-send-email-eli@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Dave,
the following two patches fix races to could lead to kernel panic in some cases.

Thanks,
Eli

Eli Cohen (2):
  net/mlx5_core: Fix race in create EQ
  net/mlx5_core: Fix race on driver load

 drivers/net/ethernet/mellanox/mlx5/core/eq.c   | 7 +++----
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.1.2
