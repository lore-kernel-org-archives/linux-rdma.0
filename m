From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for v3.13 1/8] IB/core: const'ify inbuf in struct ib_udata
Date: Mon,  2 Dec 2013 12:12:43 +0100
Message-ID: <78715231cf85ca63beb9cb02d601584324cea9c9.1385981934.git.ydroneaud@opteya.com>
References: <cover.1385981934.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Userspace input buffer is not modified by kernel,
let it be 'const'.

It's also a prerequisite to remove the implicit cast
from INIT_UDATA().

Link: http://marc.info/?i=cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h | 2 +-
 include/rdma/ib_verbs.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index bdc842e9faef..9879568aed8c 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -49,7 +49,7 @@
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
-		(udata)->inbuf  = (void __user *) (ibuf);		\
+		(udata)->inbuf  = (const void __user *) (ibuf);		\
 		(udata)->outbuf = (void __user *) (obuf);		\
 		(udata)->inlen  = (ilen);				\
 		(udata)->outlen = (olen);				\
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 979874c627ee..61e1935c91b1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -978,7 +978,7 @@ struct ib_uobject {
 };
 
 struct ib_udata {
-	void __user *inbuf;
+	const void __user *inbuf;
 	void __user *outbuf;
 	size_t       inlen;
 	size_t       outlen;
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
