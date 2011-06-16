From: Manuel Zerpies <manuel.f.zerpies-BvGhN7WtUVpvnyFi9AzMs1NpE/a5I+DW@public.gmane.org>
Subject: [PATCH 05/11] RDMA/hw/cxgb4: use printk_ratelimited() instead of
 printk_ratelimit()
Date: Thu, 16 Jun 2011 14:10:40 +0200
Message-ID: <3bf562d8c92207221d39b2c96af4731308324d61.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies-BvGhN7WtUVpvnyFi9AzMs1NpE/a5I+DW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kern
Cc: christian.dietrich-jNDFPZUTrfT6U6xlzOR6HsSSVFg4/55HhC4ANOJQIlc@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited().

Signed-off-by: Manuel Zerpies <manuel.f.zerpies-BvGhN7WtUVpvnyFi9AzMs1NpE/a5I+DW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/resource.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 4fb50d5..407ff39 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/genalloc.h>
+#include <linux/ratelimit.h>
 #include "iw_cxgb4.h"
 
 #define RANDOM_SIZE 16
@@ -311,8 +312,8 @@ u32 c4iw_pblpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->pbl_pool, size);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size);
-	if (!addr && printk_ratelimit())
-		printk(KERN_WARNING MOD "%s: Out of PBL memory\n",
+	if (!addr)
+		printk_ratelimited(KERN_WARNING MOD "%s: Out of PBL memory\n",
 		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
@@ -373,8 +374,8 @@ u32 c4iw_rqtpool_alloc(struct c4iw_rdev *rdev, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev->rqt_pool, size << 6);
 	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size << 6);
-	if (!addr && printk_ratelimit())
-		printk(KERN_WARNING MOD "%s: Out of RQT memory\n",
+	if (!addr)
+		printk_ratelimited(KERN_WARNING MOD "%s: Out of RQT memory\n",
 		       pci_name(rdev->lldi.pdev));
 	return (u32)addr;
 }
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
