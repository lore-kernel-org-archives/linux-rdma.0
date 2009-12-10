From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH v2] mlx4_core: Cleanup bug in __mlx4_init_one()
Date: Thu, 10 Dec 2009 13:37:28 +0200
Message-ID: <20091210113728.GC18037@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If mlx4_init_port_info() fails, cleanup the initialized ports only.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes: rebase the patch on Roland's for-next branch

 drivers/net/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 291a505..3cf56d9 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1174,7 +1174,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_port:
-	for (port = 1; port <= dev->caps.num_ports; port++)
+	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
 
 	mlx4_cleanup_mcg_table(dev);
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
