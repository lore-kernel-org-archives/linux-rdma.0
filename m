From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx4_en: fix spelling mistake: "quiting" -> "quitting"
Date: Sun, 17 Feb 2019 23:03:31 +0000
Message-ID: <20190217230331.18678-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a en_err error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 6b88881b8e35..c1438ae52a11 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3360,7 +3360,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	dev->addr_len = ETH_ALEN;
 	mlx4_en_u64_to_mac(dev->dev_addr, mdev->dev->caps.def_mac[priv->port]);
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-		en_err(priv, "Port: %d, invalid mac burned: %pM, quiting\n",
+		en_err(priv, "Port: %d, invalid mac burned: %pM, quitting\n",
 		       priv->port, dev->dev_addr);
 		err = -EINVAL;
 		goto out;
-- 
2.20.1
