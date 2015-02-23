From: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix double free in ocrdma_alloc_pd()
Date: Tue, 24 Feb 2015 00:32:05 +0100
Message-ID: <1424734325-24310-1-git-send-email-cengelma@gmx.at>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 9ba1377daa51 ("RDMA/ocrdma: Move PD resource management to driver.")
modified the err exit path in function ocrdma_alloc_pd() so that a call of
_ocrdma_dealloc_pd(dev, pd) is followed by kfree(pd). However,
_ocrdma_dealloc_pd() already unconditionally frees argument pd. Thus remove
the double free. Detected by Coverity CID 1271296.

Signed-off-by: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
---
Compile tested only. Applies against linux-next.
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 877175563634..74219d288aea 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -675,12 +675,10 @@ pd_mapping:
 	return &pd->ibpd;
 
 err:
-	if (is_uctx_pd) {
+	if (is_uctx_pd)
 		ocrdma_release_ucontext_pd(uctx);
-	} else {
+	else
 		status = _ocrdma_dealloc_pd(dev, pd);
-		kfree(pd);
-	}
 exit:
 	return ERR_PTR(status);
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
