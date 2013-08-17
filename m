From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 1/3] man: rdma_post_*(): memory region is optional only with IBV_SEND_INLINE.
Date: Sat, 17 Aug 2013 15:38:14 +0200
Message-ID: <dfe767c849fc9472bd87c723c401052b89d40d7c.1376746185.git.ydroneaud@opteya.com>
References: <cover.1376746185.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

State explicitly when MR argument is optional.

MR should be a mandatory argument to rdma_post_*() functions.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 man/rdma_post_send.3    | 2 +-
 man/rdma_post_ud_send.3 | 2 +-
 man/rdma_post_write.3   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/rdma_post_send.3 b/man/rdma_post_send.3
index 82bcf37..bf35716 100644
--- a/man/rdma_post_send.3
+++ b/man/rdma_post_send.3
@@ -22,7 +22,7 @@ The address of the memory buffer to post.
 .IP "length" 12
 The length of the memory buffer.
 .IP "mr" 12
-Optional registered memory region associated with the posted buffer.
+Registered memory region associated with the posted buffer. Optional if IBV_SEND_INLINE flag is used.
 .IP "flags" 12
 Optional flags used to control the send operation.
 .SH "DESCRIPTION"
diff --git a/man/rdma_post_ud_send.3 b/man/rdma_post_ud_send.3
index f8e2ada..dd40b8a 100644
--- a/man/rdma_post_ud_send.3
+++ b/man/rdma_post_ud_send.3
@@ -24,7 +24,7 @@ The address of the memory buffer to post.
 .IP "length" 12
 The length of the memory buffer.
 .IP "mr" 12
-Optional registered memory region associated with the posted buffer.
+Registered memory region associated with the posted buffer. Optional if IBV_SEND_INLINE_FLAG is used.
 .IP "flags" 12
 Optional flags used to control the send operation.
 .IP "ah" 12
diff --git a/man/rdma_post_write.3 b/man/rdma_post_write.3
index 896996c..3fbd8a1 100644
--- a/man/rdma_post_write.3
+++ b/man/rdma_post_write.3
@@ -24,7 +24,7 @@ The local address of the source of the write request.
 .IP "length" 12
 The length of the write operation.
 .IP "mr" 12
-Optional memory region associated with the local buffer.
+Registered memory region associated with the local buffer. Optional if IBV_SEND_INLINE flag is used.
 .IP "flags" 12
 Optional flags used to control the write operation.
 .IP "remote_addr" 12
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
