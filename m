From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 5/8] at12: use pci_zalloc instead of pci_alloc
Date: Tue, 26 Feb 2019 22:09:52 -0800
Message-ID: <485f61fd135d56e6e0c66ec41770ce7e5b8b219e.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>, "David S. Miller" <davem@davemloft.net>, Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch replaces a pci_alloc and memset(,0) call
with a single call to pci_zalloc.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 drivers/net/ethernet/atheros/atlx/atl2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index bb41becb6609..a145c2d1b1d2 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -300,11 +300,10 @@ static s32 atl2_setup_ring_resources(struct atl2_adapter *adapter)
 		adapter->txs_ring_size * 4 + 7 +	/* dword align */
 		adapter->rxd_ring_size * 1536 + 127;	/* 128bytes align */
 
-	adapter->ring_vir_addr = pci_alloc_consistent(pdev, size,
-		&adapter->ring_dma);
+	adapter->ring_vir_addr = pci_zalloc_consistent(pdev, size,
+						       &adapter->ring_dma);
 	if (!adapter->ring_vir_addr)
 		return -ENOMEM;
-	memset(adapter->ring_vir_addr, 0, adapter->ring_size);
 
 	/* Init TXD Ring */
 	adapter->txd_dma = adapter->ring_dma ;
-- 
2.20.1
