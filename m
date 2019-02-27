From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 8/8] net: ethernet: ixp4xx_eth: remove memset(,0) with zalloc
Date: Tue, 26 Feb 2019 22:09:55 -0800
Message-ID: <0f9d3e4eec82da38366721a20030e55ceb311aec.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Krzysztof Halasa <khalasa@piap.pl>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch removes a call to memset(,0) by replacing the
prior call to dma_pool_alloc with a call to dma_pool_zalloc.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index aee55c03def0..8471e1857d53 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1107,11 +1107,10 @@ static int init_queues(struct port *port)
 		if (!dma_pool)
 			return -ENOMEM;
 	}
-
-	if (!(port->desc_tab = dma_pool_alloc(dma_pool, GFP_KERNEL,
-					      &port->desc_tab_phys)))
+	port->desc_tab = dma_pool_zalloc(dma_pool, GFP_KERNEL,
+					 &port->desc_tab_phys);
+	if (!port->desc_tab)
 		return -ENOMEM;
-	memset(port->desc_tab, 0, POOL_ALLOC_SIZE);
 	memset(port->rx_buff_tab, 0, sizeof(port->rx_buff_tab)); /* tables */
 	memset(port->tx_buff_tab, 0, sizeof(port->tx_buff_tab));
 
-- 
2.20.1
