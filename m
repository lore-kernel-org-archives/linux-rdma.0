From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] net/mlx4: fix spelling mistake: "Inrerface" -> "Interface" and rephrase message
Date: Tue, 22 May 2018 16:42:51 +0100
Message-ID: <20180522154251.16789-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in mlx4_dbg debug message and also
change the phrasing of the message so that is is more readable

Signed-off-by: Colin Ian King <colin.king@canonical.com>

---
V2: rephrase message, as helpfully suggested by Tariq Toukan
---
 drivers/net/ethernet/mellanox/mlx4/intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index 2edcce98ab2d..65482f004e50 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -172,7 +172,7 @@ int mlx4_do_bond(struct mlx4_dev *dev, bool enable)
 		list_add_tail(&dev_ctx->list, &priv->ctx_list);
 		spin_unlock_irqrestore(&priv->ctx_lock, flags);
 
-		mlx4_dbg(dev, "Inrerface for protocol %d restarted with when bonded mode is %s\n",
+		mlx4_dbg(dev, "Interface for protocol %d restarted with bonded mode %s\n",
 			 dev_ctx->intf->protocol, enable ?
 			 "enabled" : "disabled");
 	}
-- 
2.17.0
