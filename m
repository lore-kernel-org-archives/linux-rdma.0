From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ibacm: Handle EP expiration time
Date: Thu, 15 Sep 2016 07:14:22 -0700
Message-ID: <1473948862-7461-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Old destination records are removed from EP's dest_map after timeout is
expired in order to maintain a correct cache.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 prov/acmp/src/acmp.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index ec64631..607c97f 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -356,6 +356,22 @@ acmp_put_dest(struct acmp_dest *dest)
 	}
 }
 
+/* Caller must hold ep lock. */
+static void
+acmp_remove_dest(struct acmp_ep *ep, struct acmp_dest *dest)
+{
+	acm_log(2, "%s\n", dest->name);
+	tdelete(dest->address, &ep->dest_map[dest->addr_type - 1],
+		acmp_compare_dest);
+	acmp_put_dest(dest);
+}
+
+static inline is_dest_ready(struct acmp_dest *dest)
+{
+	return dest->state == ACMP_READY &&
+	       dest->addr_timeout != 0xFFFFFFFFFFFFFFFF;
+}
+
 static struct acmp_dest *
 acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 {
@@ -366,6 +382,15 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 	acm_log(2, "%s\n", log_data);
 	lock_acquire(&ep->lock);
 	dest = acmp_get_dest(ep, addr_type, addr);
+	if (dest && is_dest_ready(dest)) {
+		acm_log(2, "Record valid for the next %ld minute(s)\n",
+			dest->addr_timeout - time_stamp_min());
+		if (time_stamp_min() >= dest->addr_timeout) {
+			acm_log(2, "Record expiered\n");
+			acmp_remove_dest(ep, dest);
+			dest = 0;
+		}
+	}
 	if (!dest) {
 		dest = acmp_alloc_dest(addr_type, addr);
 		if (dest) {
@@ -378,15 +403,6 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 	return dest;
 }
 
-/* Caller must hold ep lock. */
-//static void
-//acmp_remove_dest(struct acmp_ep *ep, struct acmp_dest *dest)
-//{
-//	acm_log(2, "%s\n", dest->name);
-//	tdelete(dest->address, &ep->dest_map[dest->addr_type - 1], acmp_compare_dest);
-//	acmp_put_dest(dest);
-//}
-
 static struct acmp_request *acmp_alloc_req(uint64_t id, struct acm_msg *msg)
 {
 	struct acmp_request *req;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
