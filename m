From: Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] cxgb4/rdma:Increase epd buff size for debug interface
Date: Thu, 16 Oct 2014 15:06:28 +0530
Message-ID: <1413452189-5427-2-git-send-email-pramod@chelsio.com>
References: <1413452189-5427-1-git-send-email-pramod@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413452189-5427-1-git-send-email-pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IPv6 address string lengths require increasing
the buffer size for debugfs handlers.

Signed-off-by: Pramod Kumar <pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 72f1f05..eb5df4e 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -670,7 +670,7 @@ static int ep_open(struct inode *inode, struct file *file)
 	idr_for_each(&epd->devp->stid_idr, count_idrs, &count);
 	spin_unlock_irq(&epd->devp->lock);
 
-	epd->bufsize = count * 160;
+	epd->bufsize = count * 240;
 	epd->buf = vmalloc(epd->bufsize);
 	if (!epd->buf) {
 		ret = -ENOMEM;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
