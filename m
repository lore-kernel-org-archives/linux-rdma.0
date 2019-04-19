From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] net/mlx5e: remove meaningless CFLAGS_tracepoint.o
Date: Fri, 19 Apr 2019 14:17:31 +0900
Message-ID: <20190419051731.15111-1-yamada.masahiro@socionext.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

CFLAGS_tracepoint.o specifies CFLAGS for compiling tracepoint.c but
it does not exist under drivers/net/ethernet/mellanox/mlx5/core/.

CFLAGS_tracepoint.o is unused.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/net/ethernet/mellanox/mlx5/core/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 1a16f6d73cbc..fa12c2ca9fc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -57,5 +57,3 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o
-
-CFLAGS_tracepoint.o := -I$(src)
-- 
2.17.1
