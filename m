From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next] IB/uverbs: set ucore.outbuf to NULL if core response space is omitted
Date: Tue, 19 Nov 2013 15:48:47 +0100
Message-ID: <1384872527-26154-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the currently uncommon case of core (eg. uverbs) response
space being omitted, but hw (eg. provider) response space being
available, outbuf get defined to "response" while it must be NULL.

This patch takes care of setting ucore.outbuf to NULL
if hdr.out_words is equal to 0.

Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---

Hi Roland,

This one apply on top of my previous patch to fix sparse warning[1][2]:
rewritting the line make it obvious I missed this rather unseen before
case, but the new improved extensible command scheme allows it,
so it must done right.

[1] http://marc.info/?i=cover.1384869925.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[2] https://patchwork.kernel.org/patch/3202411/

Regards.

 drivers/infiniband/core/uverbs_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 14d8643..6c4fc63 100644
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
