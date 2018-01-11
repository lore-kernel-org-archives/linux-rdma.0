From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Patch:  RDMA mlx5_core.c : mlx5_try_fast_unload causes panics
Date: Thu, 11 Jan 2018 13:35:51 -0500
Message-ID: <1515695751.21421.5.camel@redhat.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com> <1515694855.21421.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515694855.21421.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changes to the mlx5_core call mlx5_try_fast_unload in the shutdown.
This is causing error messages on shutdown and with the latest rdma
tree panics due to list corruption.
Remove the mlx5_try_fast_unload call so we go back to calling the
original mlx5_unload_one call only.

Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch was tested against the latest RDMA for-next tree

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d4a471a..1c66df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1522,9 +1522,7 @@ static void shutdown(struct pci_dev *pdev)
 	int err;
 
 	dev_info(&pdev->dev, "Shutdown was called\n");
-	err = mlx5_try_fast_unload(dev);
-	if (err)
-		mlx5_unload_one(dev, priv, false);
+	mlx5_unload_one(dev, priv, false);
 	mlx5_pci_disable_device(dev);
 }
 
-- 
1.8.3.1


Now on shutdown we are clean
Rebooting.
[  203.281646] kvm: exiting hardware virtualization
[  203.309916] sd 2:0:0:1: [sdbk] Synchronizing SCSI cache
..
..
[  204.240158] sd 1:0:0:2: [sdaf] Synchronizing SCSI cache
[  204.269623] sd 1:0:0:3: [sdae] Synchronizing SCSI cache
[  204.298736] sd 1:0:0:4: [sdad] Synchronizing SCSI cache
..
..
[  205.074525] sd 1:0:0:0: [sdd] Synchronizing SCSI cache
[  205.103639] mlx5_core 0000:08:00.1: Shutdown was called
[  208.244242] mlx5_1:wait_for_async_commands:735:(pid 14464): done
with all pending requests
..
..
[  208.294459] sd 1:0:0:0: [sdd] Synchronizing SCSI cache
[  208.329616] scsi 1:0:0:0: alua: Detached
[  208.352899] sd 1:0:0:29: [sde] Synchronizing SCSI cache
[  208.388955] scsi 1:0:0:29: alua: Detached
..
..
[  212.230718] scsi host1: ib_srp: connection closed
[  226.697119] mlx5_core 0000:08:00.0: Shutdown was called
[  229.899254] mlx5_0:wait_for_async_commands:735:(pid 14464): done
with all pending requests
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
