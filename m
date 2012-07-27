From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] RDMA/ucma: Convert open-coded equivalent to memdup_user()
Date: Fri, 27 Jul 2012 13:28:59 -0700
Message-ID: <1343420939-13764-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Suggested by scripts/coccinelle/api/memdup_user.cocci.

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 893cb87..6bf8504 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1002,23 +1002,18 @@ static ssize_t ucma_set_option(struct ucma_file *file, const char __user *inbuf,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	optval = kmalloc(cmd.optlen, GFP_KERNEL);
-	if (!optval) {
-		ret = -ENOMEM;
-		goto out1;
-	}
-
-	if (copy_from_user(optval, (void __user *) (unsigned long) cmd.optval,
-			   cmd.optlen)) {
-		ret = -EFAULT;
-		goto out2;
+	optval = memdup_user((void __user *) (unsigned long) cmd.optval,
+			     cmd.optlen);
+	if (IS_ERR(optval)) {
+		ret = PTR_ERR(optval);
+		goto out;
 	}
 
 	ret = ucma_set_option_level(ctx, cmd.level, cmd.optname, optval,
 				    cmd.optlen);
-out2:
 	kfree(optval);
-out1:
+
+out:
 	ucma_put_ctx(ctx);
 	return ret;
 }
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
