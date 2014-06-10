From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 05/16] RDMA/ocrdma: Handle shutdown event from be2net driver
Date: Tue, 10 Jun 2014 19:32:16 +0530
Message-ID: <9f6831e5-2c91-40fc-b7a6-12e4780f89fe@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-2-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-3-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-4-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-5-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-5-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

be2net driver sends shutdown event to ocrdma during shutdown/reboot.
As part of event processing, ocrdma calls close() and remove() to
free all the resources associated with ocrdma. This also frees
irqs used by ocrdma

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 227a542..3cb20c6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -519,6 +519,12 @@ static int ocrdma_close(struct ocrdma_dev *dev)
 	return 0;
 }
 
+static void ocrdma_shutdown(struct ocrdma_dev *dev)
+{
+	ocrdma_close(dev);
+	ocrdma_remove(dev);
+}
+
 /* event handling via NIC driver ensures that all the NIC specific
  * initialization done before RoCE driver notifies
  * event to stack.
@@ -532,6 +538,9 @@ static void ocrdma_event_handler(struct ocrdma_dev *dev, u32 event)
 	case BE_DEV_DOWN:
 		ocrdma_close(dev);
 		break;
+	case BE_DEV_SHUTDOWN:
+		ocrdma_shutdown(dev);
+		break;
 	}
 }
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
