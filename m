From: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Subject: [PATCH net-next V1 21/21] mlx4_en: updated driver version to 2.0
Date: Mon, 12 Dec 2011 16:47:49 +0200
Message-ID: <4EE61415.1030401@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, roland@purestorage.com, yevgenyp@mellanox.co.il, liranl@mellanox.co.il, jackm@dev.mellanox.co.il
List-Id: linux-rdma@vger.kernel.org

From: Yevgeny Petrilin <yevgenyp@mellanox.co.il>

Signed-off-by: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index ea2ba68..f2a8e65 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -51,8 +51,8 @@
 #include "en_port.h"
 
 #define DRV_NAME	"mlx4_en"
-#define DRV_VERSION	"1.5.4.2"
-#define DRV_RELDATE	"October 2011"
+#define DRV_VERSION	"2.0"
+#define DRV_RELDATE	"Dec 2011"
 
 #define MLX4_EN_MSG_LEVEL	(NETIF_MSG_LINK | NETIF_MSG_IFDOWN)
 
-- 
1.7.7
