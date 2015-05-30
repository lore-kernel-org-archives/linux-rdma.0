From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] RDMA/ocrdma: Fix memory leak in _ocrdma_alloc_pd()
Date: Fri, 29 May 2015 23:10:31 -0700
Message-ID: <1432966231-12125-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

If ocrdma_get_pd_num() fails, then we need to free the pd struct we allocated.

This was detected by Coverity (CID 1271245).

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 9dcb66077d6c..fcb86749efc9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -375,7 +375,12 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 
 	if (dev->pd_mgr->pd_prealloc_valid) {
 		status = ocrdma_get_pd_num(dev, pd);
-		return (status == 0) ? pd : ERR_PTR(status);
+		if (status == 0) {
+			return pd;
+		} else {
+			kfree(pd);
+			return ERR_PTR(status);
+		}
 	}
 
 retry:
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
