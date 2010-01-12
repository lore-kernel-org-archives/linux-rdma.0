From: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4/IB: Add set_4k_mtu module parameter.
Date: Tue, 12 Jan 2010 14:09:02 +0200
Message-ID: <20100112120901.GA7161@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It control Infiniband link MTU for all IB ports in a host.

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/port.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 606aa58..0e9d745 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -37,6 +37,10 @@
 
 #include "mlx4.h"
 
+static int mlx4_ib_set_4k_mtu;
+module_param_named(set_4k_mtu, mlx4_ib_set_4k_mtu, int, 0444);
+MODULE_PARM_DESC(set_4k_mtu, "attempt to set 4K MTU to all ConnectX ports");
+
 #define MLX4_MAC_VALID		(1ull << 63)
 #define MLX4_MAC_MASK		0xffffffffffffULL
 
@@ -308,6 +312,12 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 
 	memset(mailbox->buf, 0, 256);
 
+	if (mlx4_ib_set_4k_mtu)
+		((__be32 *) mailbox->buf)[0] |= cpu_to_be32((1 << 22) |
+							    (1 << 21) |
+							    (5 << 12) |
+							    (2 << 4));
+
 	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
 	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
 		       MLX4_CMD_TIME_CLASS_B);
-- 
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
