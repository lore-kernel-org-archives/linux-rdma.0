From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] RDMA/mlx5: Replace kzalloc with kcalloc
Date: Tue, 15 Jan 2019 00:00:48 -0600
Message-ID: <20190115060048.GA9911@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Replace kzalloc() function with its 2-factor argument form, kcalloc().

This patch replaces cases of:

	kzalloc(a * b, gfp)

with:
	kcalloc(a, b, gfp)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 11e9783cefcc..89dc2c6fc173 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3823,7 +3823,7 @@ mlx5_ib_raw_fs_rule_add(struct mlx5_ib_dev *dev,
 	if (fs_matcher->priority > MLX5_IB_FLOW_LAST_PRIO)
 		return ERR_PTR(-ENOMEM);
 
-	dst = kzalloc(sizeof(*dst) * 2, GFP_KERNEL);
+	dst = kcalloc(2, sizeof(*dst), GFP_KERNEL);
 	if (!dst)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.20.1
