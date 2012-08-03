From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/ucma.c: Fix for ucma context uid=0, causing iWarp RDMA
 applications to fail in connection establishment
Date: Thu, 2 Aug 2012 19:12:26 -0500
Message-ID: <20120803001226.GA8060@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix for ucma context uid=0, causing iWarp RDMA applications to fail in connection establishment.

If the context uid is not set before calling rdma_accept(), the RDMA_CM_EVENT_ESTABLISHED event generated asynchronously by successfull rdma_accept ends up with zero ucma context uid, resulting in segfault at librdmacm.so 

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 8002ae6..6cc40de 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -803,9 +803,8 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 	if (cmd.conn_param.valid) {
 		ucma_copy_conn_param(&conn_param, &cmd.conn_param);
 		mutex_lock(&file->mut);
+		ctx->uid = cmd.uid;
 		ret = rdma_accept(ctx->cm_id, &conn_param);
-		if (!ret)
-			ctx->uid = cmd.uid;
 		mutex_unlock(&file->mut);
 	} else
 		ret = rdma_accept(ctx->cm_id, NULL);
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
