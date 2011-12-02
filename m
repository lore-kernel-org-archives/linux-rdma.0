From: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Subject: [PATCH net-next V0 20/21] mlx4_core: updated driver version to 1.1
Date: Fri, 2 Dec 2011 12:19:42 +0200
Message-ID: <4ED8A63E.2020604@mellanox.co.il>
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
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 3921dbf..a80121a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -50,8 +50,8 @@
 
 #define DRV_NAME	"mlx4_core"
 #define PFX		DRV_NAME ": "
-#define DRV_VERSION	"1.0"
-#define DRV_RELDATE	"July 14, 2011"
+#define DRV_VERSION	"1.1"
+#define DRV_RELDATE	"Dec, 2011"
 
 enum {
 	MLX4_HCR_BASE		= 0x80680,
-- 
1.7.7
