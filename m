From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Change the driver version
Date: Thu, 14 Jul 2011 17:36:42 +0300
Message-ID: <201107141736.43279.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Many features were added to this driver, and the driver version should change too.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index dd7d745..ea529b4 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -48,8 +48,8 @@
 #include <linux/mlx4/doorbell.h>
 
 #define DRV_NAME	"mlx4_core"
-#define DRV_VERSION	"0.01"
-#define DRV_RELDATE	"May 1, 2007"
+#define DRV_VERSION	"1.00"
+#define DRV_RELDATE	"July 14, 2011"
 
 enum {
 	MLX4_HCR_BASE		= 0x80680,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
