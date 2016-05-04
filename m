From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3] net/mlx5e: Kconfig fixes
Date: Wed,  4 May 2016 14:26:07 +0200
Message-ID: <1462364774-3792510-1-git-send-email-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

I saw two new build errors with invalid configurations on mlx5e, and a
closer look revealed that one of them was caused by a slightly incorrect
fix for which I had sent a different patch when it first broke.

This series reverts the new fix for the VXLAN problem as it caused
another bug, and follows up with a new version of my patch (adapted
as originally requested), and another patch for the simiar RFS
bug that was just introduced.

        Arnd
