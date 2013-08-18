From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/22] infiniband: ib_udata: const'ify inbuf
Date: Sun, 18 Aug 2013 20:28:38 +0200
Message-ID: <3050a98379b4342ea59d59aeaf1ce162171df928.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Userspace input buffer is not modified by kernel, let it be 'const'.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 include/rdma/ib_verbs.h              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b105140..6ca3c86 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -57,7 +57,7 @@ static struct uverbs_lock_class xrcd_lock_class = { .name = "XRCD-uobj" };
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
-		(udata)->inbuf  = (void __user *) (ibuf);		\
+		(udata)->inbuf  = (const void __user *) (ibuf);		\
 		(udata)->outbuf = (void __user *) (obuf);		\
 		(udata)->inlen  = (ilen);				\
 		(udata)->outlen = (olen);				\
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ef37c59..21dbc42 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -974,7 +974,7 @@ struct ib_uobject {
 };
 
 struct ib_udata {
-	void __user *inbuf;
+	const void __user *inbuf;
 	void __user *outbuf;
 	size_t       inlen;
 	size_t       outlen;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
