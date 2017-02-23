From: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Use dsgl by default
Date: Thu, 23 Feb 2017 12:31:43 +0530
Message-ID: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enable the use of dsgl by default and determine whether dsgl is
supported from lld info.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> 
Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 410408f..8db7a11 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -38,9 +38,9 @@
 
 #include "iw_cxgb4.h"
 
-int use_dsgl = 0;
+int use_dsgl = 1;
 module_param(use_dsgl, int, 0644);
-MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
+MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");
 
 #define T4_ULPTX_MIN_IO 32
 #define C4IW_MAX_INLINE_SIZE 96
@@ -231,7 +231,7 @@ static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len,
 static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 			     void *data, struct sk_buff *skb)
 {
-	if (is_t5(rdev->lldi.adapter_type) && use_dsgl) {
+	if (rdev->lldi.ulptx_memwrite_dsgl && use_dsgl) {
 		if (len > inline_threshold) {
 			if (_c4iw_write_mem_dma(rdev, addr, len, data, skb)) {
 				printk_ratelimited(KERN_WARNING
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
