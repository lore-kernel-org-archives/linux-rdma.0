From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] mlx4_core: Disable SENSE_PORT for multifunction devices
Date: Thu, 27 Sep 2012 10:47:17 -0700
Message-ID: <1348768037-3660-3-git-send-email-roland@kernel.org>
References: <1348768037-3660-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348768037-3660-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

In the current driver, the SENSE_PORT firmware command is issued as a
"wrapped" command, but the command handling code doesn't have a
wrapper, so it will never do anything other than log an error message.
The latest ConnectX-3 2.11.500 firmware reports the SENSE_PORT
capability even in multi-function (SR-IOV) mode, so the driver will
try to issue the command.

At least until the driver has a proper wrapper for SENSE_PORT, make
sure we disable the command for multi-function devices.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4d40b21..1fcf0e1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -300,6 +300,9 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	/* Sense port always allowed on supported devices for ConnectX-1 and -2 */
 	if (mlx4_priv(dev)->pci_dev_data & MLX4_PCI_DEV_FORCE_SENSE_PORT)
 		dev->caps.flags |= MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
+	/* Don't do sense port on multifunction devices (for now at least) */
+	if (mlx4_is_mfunc(dev))
+		dev->caps.flags &= ~MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
 
 	dev->caps.log_num_macs  = log_num_mac;
 	dev->caps.log_num_vlans = MLX4_LOG_NUM_VLANS;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
