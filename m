From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 06/15] IB/uverbs: Fix method merging in uverbs_ioctl_merge
Date: Tue, 13 Feb 2018 12:18:32 +0200
Message-ID: <20180213101841.20101-7-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix a bug in uverbs_ioctl_merge that looked at objects iterators
number instead of methods iterators number when merging methods.

While we're at it, make the uverbs_ioctl_merge code a bit more clear
and faster.

Fixes: 118620d3686b ('IB/core: Add uverbs merge trees functionality')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl_merge.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl_merge.c b/drivers/infiniband/core/uverbs_ioctl_merge.c
index 062485f9300d..62e1eb1d2a28 100644
--- a/drivers/infiniband/core/uverbs_ioctl_merge.c
+++ b/drivers/infiniband/core/uverbs_ioctl_merge.c
@@ -114,6 +114,7 @@ static size_t get_elements_above_id(const void **iters,
 	short min = SHRT_MAX;
 	const void *elem;
 	int i, j, last_stored = -1;
+	unsigned int equal_min = 0;
 
 	for_each_element(elem, i, j, elements, num_elements, num_offset,
 			 data_offset) {
@@ -136,6 +137,10 @@ static size_t get_elements_above_id(const void **iters,
 		 */
 		iters[last_stored == i ? num_iters - 1 : num_iters++] = elem;
 		last_stored = i;
+		if (min == GET_ID(id))
+			equal_min++;
+		else
+			equal_min = 1;
 		min = GET_ID(id);
 	}
 
@@ -146,15 +151,10 @@ static size_t get_elements_above_id(const void **iters,
 	 * Therefore, we need to clean the beginning of the array to make sure
 	 * all ids of final elements are equal to min.
 	 */
-	for (i = num_iters - 1; i >= 0 &&
-	     GET_ID(*(u16 *)(iters[i] + id_offset)) == min; i--)
-		;
-
-	num_iters -= i + 1;
-	memmove(iters, iters + i + 1, sizeof(*iters) * num_iters);
+	memmove(iters, iters + num_iters - equal_min, sizeof(*iters) * equal_min);
 
 	*min_id = min;
-	return num_iters;
+	return equal_min;
 }
 
 #define find_max_element_entry_id(num_elements, elements, num_objects_fld, \
@@ -322,7 +322,7 @@ static struct uverbs_method_spec *build_method_with_attrs(const struct uverbs_me
 		hash = kzalloc(sizeof(*hash) +
 			       ALIGN(sizeof(*hash->attrs) * (attr_max_bucket + 1),
 				     sizeof(long)) +
-			       BITS_TO_LONGS(attr_max_bucket) * sizeof(long),
+			       BITS_TO_LONGS(attr_max_bucket + 1) * sizeof(long),
 			       GFP_KERNEL);
 		if (!hash) {
 			res = -ENOMEM;
@@ -509,7 +509,7 @@ static struct uverbs_object_spec *build_object_with_methods(const struct uverbs_
 			 * first handler which != NULL. This also defines the
 			 * set of flags used for this handler.
 			 */
-			for (i = num_object_defs - 1;
+			for (i = num_method_defs - 1;
 			     i >= 0 && !method_defs[i]->handler; i--)
 				;
 			hash->methods[min_id++] = method;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
