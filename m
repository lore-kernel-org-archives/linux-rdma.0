From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib: bug in cl_list_insert_array_head/tail functions
Date: Sun, 08 Nov 2009 15:28:16 +0200
Message-ID: <4AF6C770.9020107@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing bug in cl_list_insert_array_head/tail functions.
In case of failure, no cleanup is done.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/complib/cl_list.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/opensm/complib/cl_list.c b/opensm/complib/cl_list.c
index a30d3be..555a968 100644
--- a/opensm/complib/cl_list.c
+++ b/opensm/complib/cl_list.c
@@ -424,6 +424,7 @@ cl_status_t cl_list_insert_array_head(IN cl_list_t * const p_list,
 {
 	cl_status_t status;
 	void *p_object;
+	uint32_t items_remain = item_count;

 	CL_ASSERT(p_list);
 	CL_ASSERT(cl_is_qpool_inited(&p_list->list_item_pool));
@@ -439,11 +440,11 @@ cl_status_t cl_list_insert_array_head(IN cl_list_t * const p_list,
 	p_object = ((uint8_t *) p_array + (item_size * (item_count - 1)));

 	/* Continue to add all items to the list. */
-	while (item_count--) {
+	while (items_remain--) {
 		status = cl_list_insert_head(p_list, p_object);
 		if (status != CL_SUCCESS) {
 			/* Remove all items that have been inserted. */
-			while (item_count++ < item_count)
+			while (items_remain++ < (item_count - 1))
 				cl_list_remove_head(p_list);
 			return (status);
 		}
@@ -462,6 +463,7 @@ cl_status_t cl_list_insert_array_tail(IN cl_list_t * const p_list,
 {
 	cl_status_t status;
 	void *p_object;
+	uint32_t items_remain = item_count;

 	CL_ASSERT(p_list);
 	CL_ASSERT(cl_is_qpool_inited(&p_list->list_item_pool));
@@ -473,11 +475,11 @@ cl_status_t cl_list_insert_array_tail(IN cl_list_t * const p_list,
 	p_object = (void *)p_array;

 	/* Continue to add all items to the list. */
-	while (item_count--) {
+	while (items_remain--) {
 		status = cl_list_insert_tail(p_list, p_object);
 		if (status != CL_SUCCESS) {
 			/* Remove all items that have been inserted. */
-			while (item_count++ < item_count)
+			while (items_remain++ < (item_count - 1))
 				cl_list_remove_tail(p_list);
 			return (status);
 		}
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
