From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 7/8] Change enumeration names for masked atomic opcodes
Date: Thu, 20 Sep 2012 23:31:06 +0300
Message-ID: <1348173067-12116-8-git-send-email-ogerlitz@mellanox.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Change the enumeration names of the masked atomic opcodes to be
consistent with the ones used by the mlx4 kernel driver.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index e1daaf7..139db24 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -128,8 +128,8 @@ enum {
 	MLX4_OPCODE_RDMA_READ		= 0x10,
 	MLX4_OPCODE_ATOMIC_CS		= 0x11,
 	MLX4_OPCODE_ATOMIC_FA		= 0x12,
-	MLX4_OPCODE_ATOMIC_MASK_CS	= 0x14,
-	MLX4_OPCODE_ATOMIC_MASK_FA	= 0x15,
+	MLX4_OPCODE_MASKED_ATOMIC_CS	= 0x14,
+	MLX4_OPCODE_MASKED_ATOMIC_FA	= 0x15,
 	MLX4_OPCODE_BIND_MW		= 0x18,
 	MLX4_OPCODE_FMR			= 0x19,
 	MLX4_OPCODE_LOCAL_INVAL		= 0x1b,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
