From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v3] ethernet :mellanox :mlx4: Replace pci_pool_alloc by
 pci_pool_zalloc
Date: Wed, 30 Nov 2016 01:16:12 +0530
Message-ID: <20161129194611.GA4088@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: sergei.shtylyov@cogentembedded.com, yishaih@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, sahu.rameshwar73@gmail.com
List-Id: linux-rdma@vger.kernel.org

In mlx4_alloc_cmd_mailbox(), pci_pool_alloc() followed by memset will be
replaced by pci_pool_zalloc()

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
v3:
  - Fixed alignment issues

v2:
  - Address comment from sergei
    Alignment was not proper

 drivers/net/ethernet/mellanox/mlx4/cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index e36bebc..a49072b4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2679,15 +2679,13 @@ struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev)
 	if (!mailbox)
 		return ERR_PTR(-ENOMEM);

-	mailbox->buf = pci_pool_alloc(mlx4_priv(dev)->cmd.pool, GFP_KERNEL,
-				      &mailbox->dma);
+	mailbox->buf = pci_pool_zalloc(mlx4_priv(dev)->cmd.pool, GFP_KERNEL,
+				       &mailbox->dma);
 	if (!mailbox->buf) {
 		kfree(mailbox);
 		return ERR_PTR(-ENOMEM);
 	}

-	memset(mailbox->buf, 0, MLX4_MAILBOX_SIZE);
-
 	return mailbox;
 }
 EXPORT_SYMBOL_GPL(mlx4_alloc_cmd_mailbox);
