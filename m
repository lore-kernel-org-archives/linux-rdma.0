From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] IB/ucma: Fix theoretical user triggered use-after-free
Date: Tue, 4 Aug 2015 17:13:32 -0600
Message-ID: <20150804231332.GA22959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Something like this:

CPU A                         CPU B
========================      ================================
ucma_destroy_id()
 wait_for_completion()
                              .. anything
                                ucma_put_ctx()
                                  complete()
 .. continues ...
                              ucma_leave_multicast()
                               mutex_lock(mut)
                                 atomic_inc(ctx->ref)
                               mutex_unlock(mut)
 ucma_free_ctx()
  ucma_cleanup_multicast()
   mutex_lock(mut)
     kfree(mc)
                               rdma_leave_multicast(mc->ctx->cm_id,..

Fix it by latching the ref at 0. Once it goes to 0 mc and ctx cannot
leave the mutex(mut) protection.

The other atomic_inc in ucma_get_ctx is OK because mutex(mut) protects
it from racing with ucma_destroy_id.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 29b21213ea75..acac9eafdbf6 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1321,10 +1321,10 @@ static ssize_t ucma_leave_multicast(struct ucma_file *file,
 		mc = ERR_PTR(-ENOENT);
 	else if (mc->ctx->file != file)
 		mc = ERR_PTR(-EINVAL);
-	else {
+	else if (!atomic_inc_not_zero(&mc->ctx->ref))
+		mc = ERR_PTR(-ENXIO);
+	else
 		idr_remove(&multicast_idr, mc->id);
-		atomic_inc(&mc->ctx->ref);
-	}
 	mutex_unlock(&mut);
 
 	if (IS_ERR(mc)) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
