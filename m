From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] ibacm: Handle EP expiration time
Date: Mon, 19 Sep 2016 10:28:21 -0700
Message-ID: <1474306101-24718-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Old destination records are removed from EP's dest_map after timeout is
expired in order to maintain a correct cache.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v0 -> v1:
	* Move the status and timeout check to acmp_acquire_dest
	* Fix typo (Record expiered).
	* Use NULL instead of 0
v1 -> v2:
	* (uint64_t)~0ULL instead of 0xFFFFFFFFFFFFFFFF
	* Calculate expiration time once
---
 prov/acmp/src/acmp.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/prov/acmp/src/acmp.c b/prov/acmp/src/acmp.c
index ec64631..a26ed83 100644
--- a/prov/acmp/src/acmp.c
+++ b/prov/acmp/src/acmp.c
@@ -356,16 +356,39 @@ acmp_put_dest(struct acmp_dest *dest)
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
 static struct acmp_dest *
 acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
 {
 	struct acmp_dest *dest;
+	int64_t rec_expr_minutes;
 
 	acm_format_name(2, log_data, sizeof log_data,
 			addr_type, addr, ACM_MAX_ADDRESS);
 	acm_log(2, "%s\n", log_data);
 	lock_acquire(&ep->lock);
 	dest = acmp_get_dest(ep, addr_type, addr);
+	if (dest && dest->state == ACMP_READY &&
+	    dest->addr_timeout != (uint64_t)~0ULL) {
+		rec_expr_minutes = dest->addr_timeout - time_stamp_min();
+		if (rec_expr_minutes <= 0) {
+			acm_log(2, "Record expired\n");
+			acmp_remove_dest(ep, dest);
+			dest = NULL;
+		} else {
+			acm_log(2, "Record valid for the next %ld minute(s)\n",
+				rec_expr_minutes);
+		}
+	}
 	if (!dest) {
 		dest = acmp_alloc_dest(addr_type, addr);
 		if (dest) {
@@ -378,15 +401,6 @@ acmp_acquire_dest(struct acmp_ep *ep, uint8_t addr_type, const uint8_t *addr)
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
