From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] [RESEND] IB/uverbs: fix gcc-7 type warning
Date: Wed,  6 Sep 2017 15:45:31 +0200
Message-ID: <20170906134558.3279199-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We get a harmless warning about the fact that we use the result of a
multiplication as a condition:

drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
drivers/infiniband/core/uverbs_main.c:787:40: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:787:117: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:50: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:151: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

This changes the macro to explicitly check the number for a positive
length, which avoids the warning.

Fixes: a96e4e2ffe43 ("IB/uverbs: New macro to set pointers to NULL if length is 0 in INIT_UDATA()")
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
Originally submitted on July 14, but this patch is still pending.
I modified the change text this time, as the first version incorrectly
stated that it only happens with ccache.
---
 drivers/infiniband/core/uverbs.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 37c8903e7fd0..986a8a66ebbe 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -55,12 +55,14 @@
 		(udata)->outlen = (olen);				\
 	} while (0)
 
-#define INIT_UDATA_BUF_OR_NULL(udata, ibuf, obuf, ilen, olen)			\
-	do {									\
-		(udata)->inbuf  = (ilen) ? (const void __user *) (ibuf) : NULL;	\
-		(udata)->outbuf = (olen) ? (void __user *) (obuf) : NULL;	\
-		(udata)->inlen  = (ilen);					\
-		(udata)->outlen = (olen);					\
+#define INIT_UDATA_BUF_OR_NULL(udata, ibuf, obuf, ilen, olen)		\
+	do {								\
+		(udata)->inbuf  = (ilen) > 0 ?				\
+				  (const void __user *) (ibuf) : NULL;	\
+		(udata)->outbuf = (olen) > 0 ?				\
+				  (void __user *) (obuf) : NULL;	\
+		(udata)->inlen  = (ilen);				\
+		(udata)->outlen = (olen);				\
 	} while (0)
 
 /*
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
