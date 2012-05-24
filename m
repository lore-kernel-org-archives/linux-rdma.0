From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] net/mlx4_core: Fix setting VL_cap in mlx4_SET_PORT wrapper flow
Date: Thu, 24 May 2012 16:08:09 +0300
Message-ID: <1337864889-20886-4-git-send-email-ogerlitz@mellanox.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337864889-20886-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Commit 096335b3f (mlx4_core: Allow dynamic MTU configuration for IB
ports) modifies the port VL setting.  This exposes a bug in procedure
mlx4_common_set_port(), where the VL cap value passed in (inside the
command mailbox) is incorrectly zeroed-out. The problem flow is as follows:

mlx4_SET_PORT modifies the VL_cap field (byte 3 of the mailbox).
Since the SET_PORT command is paravirtualized on the master as
well as on the slaves, mlx4_SET_PORT_wrapper() is invoked on the
master. This procedure calls mlx4_common_set_port() where mailbox
byte 3 gets overwritten by a code which should only set a single
bit in that byte (for the reset qkey counter flag) -- but instead
overwrites the entire byte.

The result is that when running in SRIOV mode, the VL_cap will
be set to zero, fix that.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/port.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 1fe2c7a..a8fb529 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -697,10 +697,10 @@ static int mlx4_common_set_port(struct mlx4_dev *dev, int slave, u32 in_mod,
 	if (slave != dev->caps.function)
 		memset(inbox->buf, 0, 256);
 	if (dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
-		*(u8 *) inbox->buf	   = !!reset_qkey_viols << 6;
+		*(u8 *) inbox->buf	   |= !!reset_qkey_viols << 6;
 		((__be32 *) inbox->buf)[2] = agg_cap_mask;
 	} else {
-		((u8 *) inbox->buf)[3]     = !!reset_qkey_viols;
+		((u8 *) inbox->buf)[3]     |= !!reset_qkey_viols;
 		((__be32 *) inbox->buf)[1] = agg_cap_mask;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
