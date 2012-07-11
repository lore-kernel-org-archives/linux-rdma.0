From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs] memory: commented unused verify() function
Date: Wed, 11 Jul 2012 17:10:10 +0200
Message-ID: <1342019410-10004-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index faa43f3..ea9e712 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -268,6 +268,7 @@ static void __mm_rotate_left(struct ibv_mem_node *node)
 	node->parent = tmp;
 }
 
+#if 0
 static int verify(struct ibv_mem_node *node)
 {
 	int hl, hr;
@@ -293,6 +294,7 @@ static int verify(struct ibv_mem_node *node)
 
 	return hl + 1;
 }
+#endif
 
 static void __mm_add_rebalance(struct ibv_mem_node *node)
 {
-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
