From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 2/8] net/mlxsw: use pci_zalloc_consistent instead of pci_alloc_consistent
Date: Tue, 26 Feb 2019 22:09:49 -0800
Message-ID: <9ddcd9104b83c58f74cdd350f462017ad0612d4b.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch replaces a call to pci_alloc_consistent and then
memset(0,) with a single call to pci_zalloc_consistent.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index a2321fe8d6a0..388f349573f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -830,12 +830,11 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		tasklet_init(&q->tasklet, q_ops->tasklet, (unsigned long) q);
 
 	mem_item->size = MLXSW_PCI_AQ_SIZE;
-	mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
-					     mem_item->size,
-					     &mem_item->mapaddr);
+	mem_item->buf = pci_zalloc_consistent(mlxsw_pci->pdev,
+					      mem_item->size,
+					      &mem_item->mapaddr);
 	if (!mem_item->buf)
 		return -ENOMEM;
-	memset(mem_item->buf, 0, mem_item->size);
 
 	q->elem_info = kcalloc(q->count, sizeof(*q->elem_info), GFP_KERNEL);
 	if (!q->elem_info) {
-- 
2.20.1
