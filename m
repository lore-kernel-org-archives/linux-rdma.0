From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 3/8] tlan: use pci_zalloc instead of pci_alloc
Date: Tue, 26 Feb 2019 22:09:50 -0800
Message-ID: <51125a3daac49f7b5bb360a422663aee26e6776b.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch replaces a pci_alloc_consistent and memset(,0) call
with a single call to pci_zalloc_consistent.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 drivers/net/ethernet/ti/tlan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index b4ab1a5f6cd0..e1f7e71c3b21 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -845,17 +845,16 @@ static int tlan_init(struct net_device *dev)
 
 	dma_size = (TLAN_NUM_RX_LISTS + TLAN_NUM_TX_LISTS)
 		* (sizeof(struct tlan_list));
-	priv->dma_storage = pci_alloc_consistent(priv->pci_dev,
-						 dma_size,
-						 &priv->dma_storage_dma);
+	priv->dma_storage = pci_zalloc_consistent(priv->pci_dev,
+						  dma_size,
+						  &priv->dma_storage_dma);
 	priv->dma_size = dma_size;
 
-	if (priv->dma_storage == NULL) {
+	if (!priv->dma_storage) {
 		pr_err("Could not allocate lists and buffers for %s\n",
 		       dev->name);
 		return -ENOMEM;
 	}
-	memset(priv->dma_storage, 0, dma_size);
 	priv->rx_list = (struct tlan_list *)
 		ALIGN((unsigned long)priv->dma_storage, 8);
 	priv->rx_list_dma = ALIGN(priv->dma_storage_dma, 8);
-- 
2.20.1
