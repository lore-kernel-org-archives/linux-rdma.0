From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: fix double free on pd
Date: Fri,  5 Jun 2015 15:47:27 +0100
Message-ID: <1433515647-28059-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

A reorganisation of the PD allocation and deallocation in commit
9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
introduced a double free on pd, as detected by static analysis by
smatch:

drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:682 ocrdma_alloc_pd()
  error: double free of 'pd'^

The original call to ocrdma_mbx_dealloc_pd() (which does not kfree
pd) was replaced with a call to _ocrdma_dealloc_pd() (which does
kfree pd).  The kfree following this call causes the double free,
so just remove it to fix the problem.

Fixes: 9ba1377daa ("RDMA/ocrdma: Move PD resource management to driver.")
Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 9dcb660..219f212 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -679,7 +679,6 @@ err:
 		ocrdma_release_ucontext_pd(uctx);
 	} else {
 		status = _ocrdma_dealloc_pd(dev, pd);
-		kfree(pd);
 	}
 exit:
 	return ERR_PTR(status);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
