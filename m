From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/22] infiniband: ib_copy_{from,to}_udata(): const'ify arguments
Date: Sun, 18 Aug 2013 20:28:37 +0200
Message-ID: <9dcb48d02ca489604f9535ba6d38fe1988f9496e.1376847403.git.ydroneaud@opteya.com>
References: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Source buffers are not modified, let them be 'const'.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 include/rdma/ib_verbs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a84d3df..ef37c59 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1353,12 +1353,12 @@ void *ib_get_client_data(struct ib_device *device, struct ib_client *client);
 void  ib_set_client_data(struct ib_device *device, struct ib_client *client,
 			 void *data);
 
-static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t len)
+static inline int ib_copy_from_udata(void *dest, const struct ib_udata *udata, size_t len)
 {
 	return copy_from_user(dest, udata->inbuf, len) ? -EFAULT : 0;
 }
 
-static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
+static inline int ib_copy_to_udata(struct ib_udata *udata, const void *src, size_t len)
 {
 	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
