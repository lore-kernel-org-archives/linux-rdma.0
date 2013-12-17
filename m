From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 for-3.13 04/10] IB/uverbs: set outbuf to NULL when no core response space is provided
Date: Tue, 17 Dec 2013 10:58:53 +0100
Message-ID: <330b13a0884b6cc03e287a32f8f49c1aac6bdbed.1387273677.git.ydroneaud@opteya.com>
References: <cover.1387273677.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the currently uncommon case of core (eg. uverbs) response
space being omitted, but hw (eg. provider) response space being
available, outbuf get defined to "response" while it must be NULL.

This patch takes care of setting ucore->outbuf to NULL
if hdr.out_words is equal to 0.

Link: http://marc.info/?i=cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 14d864371050..6c4fc6338b26 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -681,7 +681,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 
 		INIT_UDATA(&ucore,
 			   (hdr.in_words) ? buf : NULL,
-			   response,
+			   (hdr.out_words) ? response : NULL,
 			   hdr.in_words * 8,
 			   hdr.out_words * 8);
 
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
