From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/22] infiniband: ib_copy_from_udata(): check input length
Date: Sun, 18 Aug 2013 20:28:39 +0200
Message-ID: <2bf102a41c51f61965ee09df827abe8fefb523a9.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch makes ib_copy_from_udata() check the input length
before reading from userspace buffer to prevent out of bound access.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 include/rdma/ib_verbs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 21dbc42..e5551ac 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1355,6 +1355,9 @@ void  ib_set_client_data(struct ib_device *device, struct ib_client *client,
 
 static inline int ib_copy_from_udata(void *dest, const struct ib_udata *udata, size_t len)
 {
+	if (udata->inlen < len) {
+		return -EINVAL;
+	}
 	return copy_from_user(dest, udata->inbuf, len) ? -EFAULT : 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
