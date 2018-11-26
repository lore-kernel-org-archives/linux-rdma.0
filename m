From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/13] net/mlx5: Forward all mlx5 events to mlx5 notifiers chain
Date: Mon, 26 Nov 2018 14:38:59 -0800
Message-ID: <20181126223908.15988-5-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This to allow seamless migration to the new notifier chain API, and to
eventually deprecate interfaces dev->event callback.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 3 +++
 include/linux/mlx5/driver.h                   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 7eedbea38a78..d63ba8813829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -32,6 +32,7 @@
 
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
+#include "lib/mlx5.h"
 
 static LIST_HEAD(intf_list);
 static LIST_HEAD(mlx5_dev_list);
@@ -425,6 +426,8 @@ void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
 			dev_ctx->intf->event(dev, dev_ctx->context, event, param);
 
 	spin_unlock_irqrestore(&priv->ctx_lock, flags);
+
+	mlx5_notifier_call_chain(dev->priv.events, event, (void *)param);
 }
 
 void mlx5_dev_list_lock(void)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b96929d0cc9c..14ca74707275 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -195,7 +195,7 @@ struct mlx5_rsc_debug {
 };
 
 enum mlx5_dev_event {
-	MLX5_DEV_EVENT_SYS_ERROR,
+	MLX5_DEV_EVENT_SYS_ERROR = 128, /* 0 - 127 are FW events */
 	MLX5_DEV_EVENT_PORT_UP,
 	MLX5_DEV_EVENT_PORT_DOWN,
 	MLX5_DEV_EVENT_PORT_INITIALIZED,
-- 
2.19.1
