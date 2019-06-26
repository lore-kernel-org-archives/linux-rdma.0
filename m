From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net/mlx5: remove redundant assignment to ret
Date: Wed, 26 Jun 2019 17:44:11 +0100
Message-ID: <20190626164411.20403-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable ret is being initialized with a value that is never read and
ret is being re-assigned later on.  The initialization is redundant
and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 072b56fda27e..dd47c6d03dad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1477,7 +1477,7 @@ static const struct pci_error_handlers mlx5_err_handler = {
 static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 {
 	bool fast_teardown = false, force_teardown = false;
-	int ret = 1;
+	int ret;
 
 	fast_teardown = MLX5_CAP_GEN(dev, fast_teardown);
 	force_teardown = MLX5_CAP_GEN(dev, force_teardown);
-- 
2.20.1
