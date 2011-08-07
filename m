From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 6/7] Fix a compiler warning about an unused function
Date: Sun, 7 Aug 2011 20:04:19 +0200
Message-ID: <201108072004.19950.bvanassche@acm.org>
References: <201108072000.16383.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108072000.16383.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 9f13774..7d97e55 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -269,6 +269,7 @@ static void __mm_rotate_left(struct ibv_mem_node *node)
 	node->parent = tmp;
 }
 
+#if 0
 static int verify(struct ibv_mem_node *node)
 {
 	int hl, hr;
@@ -294,6 +295,7 @@ static int verify(struct ibv_mem_node *node)
 
 	return hl + 1;
 }
+#endif
 
 static void __mm_add_rebalance(struct ibv_mem_node *node)
 {
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
