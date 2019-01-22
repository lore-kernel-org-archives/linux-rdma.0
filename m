From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6/8] infiniband: ocrdma: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:17:58 +0100
Message-ID: <20190122151800.15092-7-gregkh@linuxfoundation.org>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Leon Romanovsky <leon@kernel.org>, Yuval Shaia <yuval.shaia@oracle.com>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 67 +++++++--------------
 1 file changed, 22 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 6be0ea109138..a902942adb5d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -767,88 +767,65 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
 
 	/* Create post stats base dir */
 	dev->dir = debugfs_create_dir(pci_name(pdev), ocrdma_dbgfs_dir);
-	if (!dev->dir)
-		goto err;
 
 	dev->rsrc_stats.type = OCRDMA_RSRC_STATS;
 	dev->rsrc_stats.dev = dev;
-	if (!debugfs_create_file("resource_stats", S_IRUSR, dev->dir,
-				 &dev->rsrc_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("resource_stats", S_IRUSR, dev->dir,
+			    &dev->rsrc_stats, &ocrdma_dbg_ops);
 
 	dev->rx_stats.type = OCRDMA_RXSTATS;
 	dev->rx_stats.dev = dev;
-	if (!debugfs_create_file("rx_stats", S_IRUSR, dev->dir,
-				 &dev->rx_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("rx_stats", S_IRUSR, dev->dir, &dev->rx_stats,
+			    &ocrdma_dbg_ops);
 
 	dev->wqe_stats.type = OCRDMA_WQESTATS;
 	dev->wqe_stats.dev = dev;
-	if (!debugfs_create_file("wqe_stats", S_IRUSR, dev->dir,
-				 &dev->wqe_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("wqe_stats", S_IRUSR, dev->dir, &dev->wqe_stats,
+			    &ocrdma_dbg_ops);
 
 	dev->tx_stats.type = OCRDMA_TXSTATS;
 	dev->tx_stats.dev = dev;
-	if (!debugfs_create_file("tx_stats", S_IRUSR, dev->dir,
-				 &dev->tx_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("tx_stats", S_IRUSR, dev->dir, &dev->tx_stats,
+			    &ocrdma_dbg_ops);
 
 	dev->db_err_stats.type = OCRDMA_DB_ERRSTATS;
 	dev->db_err_stats.dev = dev;
-	if (!debugfs_create_file("db_err_stats", S_IRUSR, dev->dir,
-				 &dev->db_err_stats, &ocrdma_dbg_ops))
-		goto err;
-
+	debugfs_create_file("db_err_stats", S_IRUSR, dev->dir,
+			    &dev->db_err_stats, &ocrdma_dbg_ops);
 
 	dev->tx_qp_err_stats.type = OCRDMA_TXQP_ERRSTATS;
 	dev->tx_qp_err_stats.dev = dev;
-	if (!debugfs_create_file("tx_qp_err_stats", S_IRUSR, dev->dir,
-				 &dev->tx_qp_err_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("tx_qp_err_stats", S_IRUSR, dev->dir,
+			    &dev->tx_qp_err_stats, &ocrdma_dbg_ops);
 
 	dev->rx_qp_err_stats.type = OCRDMA_RXQP_ERRSTATS;
 	dev->rx_qp_err_stats.dev = dev;
-	if (!debugfs_create_file("rx_qp_err_stats", S_IRUSR, dev->dir,
-				 &dev->rx_qp_err_stats, &ocrdma_dbg_ops))
-		goto err;
-
+	debugfs_create_file("rx_qp_err_stats", S_IRUSR, dev->dir,
+			    &dev->rx_qp_err_stats, &ocrdma_dbg_ops);
 
 	dev->tx_dbg_stats.type = OCRDMA_TX_DBG_STATS;
 	dev->tx_dbg_stats.dev = dev;
-	if (!debugfs_create_file("tx_dbg_stats", S_IRUSR, dev->dir,
-				 &dev->tx_dbg_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("tx_dbg_stats", S_IRUSR, dev->dir,
+			    &dev->tx_dbg_stats, &ocrdma_dbg_ops);
 
 	dev->rx_dbg_stats.type = OCRDMA_RX_DBG_STATS;
 	dev->rx_dbg_stats.dev = dev;
-	if (!debugfs_create_file("rx_dbg_stats", S_IRUSR, dev->dir,
-				 &dev->rx_dbg_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("rx_dbg_stats", S_IRUSR, dev->dir,
+			    &dev->rx_dbg_stats, &ocrdma_dbg_ops);
 
 	dev->driver_stats.type = OCRDMA_DRV_STATS;
 	dev->driver_stats.dev = dev;
-	if (!debugfs_create_file("driver_dbg_stats", S_IRUSR, dev->dir,
-					&dev->driver_stats, &ocrdma_dbg_ops))
-		goto err;
+	debugfs_create_file("driver_dbg_stats", S_IRUSR, dev->dir,
+			    &dev->driver_stats, &ocrdma_dbg_ops);
 
 	dev->reset_stats.type = OCRDMA_RESET_STATS;
 	dev->reset_stats.dev = dev;
-	if (!debugfs_create_file("reset_stats", 0200, dev->dir,
-				&dev->reset_stats, &ocrdma_dbg_ops))
-		goto err;
-
-
-	return;
-err:
-	debugfs_remove_recursive(dev->dir);
-	dev->dir = NULL;
+	debugfs_create_file("reset_stats", 0200, dev->dir, &dev->reset_stats,
+			    &ocrdma_dbg_ops);
 }
 
 void ocrdma_rem_port_stats(struct ocrdma_dev *dev)
 {
-	if (!dev->dir)
-		return;
 	debugfs_remove_recursive(dev->dir);
 }
 
-- 
2.20.1
