From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap in mlx4_SET_PORT
Date: Thu, 10 May 2012 23:28:08 +0300
Message-ID: <1336681689-16668-6-git-send-email-ogerlitz@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adjust the initial value of vl_cap in mlx4_SET_PORT such that only for CX3
devices we start with 8 VLs, in an attempt to avoid errors such as:

 mlx4_core 0000:06:00.0: command 0xc failed: fw status = 0x40
 mlx4_core 0000:06:00.0: vhcr command:0xc slave:0 failed with error:0, status -12

to appear in the system log.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/port.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 77535ff..53aa531 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -731,6 +731,16 @@ enum {
 	MLX4_CHANGE_PORT_MTU_CAP = 22,
 };
 
+#define CX3_PPF_DEV_ID	0x1003
+
+static int vl_cap_start(struct mlx4_dev *dev)
+{
+	/* for non CX3 devices, start with 4 VLs to avoid errors in syslog */
+	if (dev->pdev->device != CX3_PPF_DEV_ID)
+		return 4;
+	return 8;
+}
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -748,7 +758,7 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
 
 	/* IB VL CAP enum isn't used by the firmware, just numerical values */
-	for (vl_cap = 8; vl_cap >= 1; vl_cap >>= 1) {
+	for (vl_cap = vl_cap_start(dev); vl_cap >= 1; vl_cap >>= 1) {
 		((__be32 *) mailbox->buf)[0] = cpu_to_be32(
 			(1 << MLX4_CHANGE_PORT_MTU_CAP) |
 			(1 << MLX4_CHANGE_PORT_VL_CAP)  |
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
