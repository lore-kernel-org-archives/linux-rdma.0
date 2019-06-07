From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] net/mlx5e: Spelling s/configuraion/configuration/
Date: Fri,  7 Jun 2019 13:10:26 +0200
Message-ID: <20190607111026.12995-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S . Miller" <davem@davemloft.net>, Jiri Kosina <trivial@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 633b117eb13e8143..7b672ada63a39733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -175,7 +175,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	@port_buffer: <output> port receive buffer configuration
  *	@change: <output>
  *
- *	Update buffer configuration based on pfc configuraiton and
+ *	Update buffer configuration based on pfc configuration and
  *	priority to buffer mapping.
  *	Buffer's lossy bit is changed to:
  *		lossless if there is at least one PFC enabled priority
-- 
2.17.1
