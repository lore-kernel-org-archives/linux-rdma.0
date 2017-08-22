From: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Subject: [PATCH rdma-core 1/2] rsockets: fix a race-condition in rs_free()
Date: Tue, 22 Aug 2017 15:59:18 -0600
Message-ID: <29EC6B54-616C-4263-BC75-C37A3286ABD8@lanl.gov>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If rs_free() releases the fd before calling rs_remove(), a second
thread in rsocket() may acquire the same fd and store its own rs in
the corresponding index-element.  When the first thread then gets
around to calling rs_remove() it ends up removing the rs of the second
thread, and storing a NULL there.

Several functions still do not check for NULL after retrieving an rs
from the index for an open rsocket.  Thus, the second thread would get
a segfault in any of the following functions: rrecv, rrecvfrom, rsend,
rsendto, rsendv, riomap, riounmap, riowrite.

Fixes:  cf7aae3 "rsocket: Index map item is cleaned before it is used in iomapping cleanup"

Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
---
 librdmacm/rsocket.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index f28529c..77a6df4 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -1012,6 +1012,9 @@ static void rs_free(struct rsocket *rs)
 		free(rs->target_buffer_list);
 	}
 
+	if (rs->index >= 0)
+		rs_remove(rs);
+
 	if (rs->cm_id) {
 		rs_free_iomappings(rs);
 		if (rs->cm_id->qp) {
@@ -1021,9 +1024,6 @@ static void rs_free(struct rsocket *rs)
 		rdma_destroy_id(rs->cm_id);
 	}
 
-	if (rs->index >= 0)
-		rs_remove(rs);
-
 	fastlock_destroy(&rs->map_lock);
 	fastlock_destroy(&rs->cq_wait_lock);
 	fastlock_destroy(&rs->cq_lock);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
