From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] rdma UAPI: Use __kernel_sockaddr_storage
Date: Thu, 27 Oct 2016 10:51:17 -0600
Message-ID: <1477587077-15410-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The kernel side is #ifdef'd to this type, and the UAPI header
should use it directly. It has slightly different alignment
requirments from the usual user space version.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 include/uapi/rdma/rdma_user_cm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 01923d463673..d71da36e3cd6 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -110,7 +110,7 @@ struct rdma_ucm_bind {
 	__u32 id;
 	__u16 addr_size;
 	__u16 reserved;
-	struct sockaddr_storage addr;
+	struct __kernel_sockaddr_storage addr;
 };
 
 struct rdma_ucm_resolve_ip {
@@ -126,8 +126,8 @@ struct rdma_ucm_resolve_addr {
 	__u16 src_size;
 	__u16 dst_size;
 	__u32 reserved;
-	struct sockaddr_storage src_addr;
-	struct sockaddr_storage dst_addr;
+	struct __kernel_sockaddr_storage src_addr;
+	struct __kernel_sockaddr_storage dst_addr;
 };
 
 struct rdma_ucm_resolve_route {
@@ -164,8 +164,8 @@ struct rdma_ucm_query_addr_resp {
 	__u16 pkey;
 	__u16 src_size;
 	__u16 dst_size;
-	struct sockaddr_storage src_addr;
-	struct sockaddr_storage dst_addr;
+	struct __kernel_sockaddr_storage src_addr;
+	struct __kernel_sockaddr_storage dst_addr;
 };
 
 struct rdma_ucm_query_path_resp {
@@ -257,7 +257,7 @@ struct rdma_ucm_join_mcast {
 	__u32 id;
 	__u16 addr_size;
 	__u16 join_flags;
-	struct sockaddr_storage addr;
+	struct __kernel_sockaddr_storage addr;
 };
 
 struct rdma_ucm_get_event {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
