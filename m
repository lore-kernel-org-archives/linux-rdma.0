From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: improve search common pkeys.
Date: Wed, 18 Jul 2012 17:07:59 +0300
Message-ID: <1342620479-14923-1-git-send-email-danielk@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

improving runtim of search comon pkeys code to o(n).

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey.c |   94 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 69657dc..ef5c033 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -374,9 +374,6 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 	pkey_tbl1 = osm_physp_get_pkey_tbl(p_physp1);
 	pkey_tbl2 = osm_physp_get_pkey_tbl(p_physp2);
 
-	if (allow_both_pkeys)
-		goto SearchByKeys;
-
 	map_iter1 = cl_map_head(&pkey_tbl1->keys);
 	map_iter2 = cl_map_head(&pkey_tbl2->keys);
 
@@ -401,34 +398,81 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 			map_iter1 = cl_map_next(map_iter1);
 	}
 
-	return 0;
+	if (!allow_both_pkeys)
+		return 0;
 
-SearchByKeys:
+	/*
+	   When using allow_both_pkeys, the keys in pkey tables are the
+	   pkey value including membership bit.
+	   Therefore, in order to complete the search, we also need to
+	   compare port\s 1 full pkeys with port 2 limited pkeys, and
+	   port 2 full pkeys with port 1 full pkeys.
+	*/
 
-	/* Select to iterate over the table with the least elements */
-	if (cl_map_count(&pkey_tbl1->keys) < cl_map_count(&pkey_tbl2->keys)) {
-		map_iter = cl_map_head(&pkey_tbl1->keys);
-		map_end = cl_map_end(&pkey_tbl1->keys);
-		pkey_tbl = pkey_tbl2;
-	} else {
-		map_iter = cl_map_head(&pkey_tbl2->keys);
-		map_end = cl_map_end(&pkey_tbl2->keys);
-		pkey_tbl =  pkey_tbl1;
-	}
+	map_iter1 = cl_map_head(&pkey_tbl1->keys);
+	map_iter2 = cl_map_head(&pkey_tbl2->keys);
 
-	while (map_iter != map_end) {
-		pkey1 = (ib_net16_t *) cl_map_obj(map_iter);
-		key = cl_map_key(map_iter);
+	/* comparing pkey_tbl1 full with pkey_tbl2 limited */
+	while ((map_iter1 != cl_map_end(&pkey_tbl1->keys)) &&
+	       (map_iter2 != cl_map_end(&pkey_tbl2->keys))) {
+		pkey1 = (ib_net16_t *) cl_map_obj(map_iter1);
+		pkey2 = (ib_net16_t *) cl_map_obj(map_iter2);
 
-		pkey2 = cl_map_get(&pkey_tbl->keys, key | IB_PKEY_TYPE_MASK);
-		if (!pkey2)
-			pkey2 = cl_map_get(&pkey_tbl->keys,
-					key & ~IB_PKEY_TYPE_MASK);
+		if (!ib_pkey_is_full_member(*pkey1)) {
+			map_iter1 = cl_map_next(map_iter1);
+			continue;
+		}
+		if (ib_pkey_is_full_member(*pkey2)) {
+			map_iter2 = cl_map_next(map_iter2);
+			continue;
+		}
+
+		if (match_pkey(pkey1, pkey2))
+			return *pkey1;
+
+		/* advance the lower value if they are not equal */
+		pkey1_base = cl_map_key(map_iter1);
+		pkey2_base = cl_map_key(map_iter2);
+		if (pkey2_base == pkey1_base) {
+			map_iter1 = cl_map_next(map_iter1);
+			map_iter2 = cl_map_next(map_iter2);
+		} else if (pkey2_base < pkey1_base)
+			map_iter2 = cl_map_next(map_iter2);
+		else
+			map_iter1 = cl_map_next(map_iter1);
+	}
 
-		if (pkey2 && match_pkey(pkey1, pkey2))
-			return (pkey_tbl == pkey_tbl2 ? *pkey1 : *pkey2);
+	map_iter1 = cl_map_head(&pkey_tbl1->keys);
+	map_iter2 = cl_map_head(&pkey_tbl2->keys);
 
-		map_iter = cl_map_next(map_iter);
+	/* comparing pkey_tbl1 limited with pkey_tbl2 full */
+	while ((map_iter1 != cl_map_end(&pkey_tbl1->keys)) &&
+	       (map_iter2 != cl_map_end(&pkey_tbl2->keys))) {
+		pkey1 = (ib_net16_t *) cl_map_obj(map_iter1);
+		pkey2 = (ib_net16_t *) cl_map_obj(map_iter2);
+
+		if (ib_pkey_is_full_member(*pkey1)) {
+			map_iter1 = cl_map_next(map_iter1);
+			continue;
+		}
+		if (!ib_pkey_is_full_member(*pkey2)) {
+			map_iter2 = cl_map_next(map_iter2);
+			continue;
+		}
+
+		if (match_pkey(pkey1, pkey2))
+			return *pkey1;
+
+		/* advance the lower value if they are not equal */
+		pkey1_base = cl_map_key(map_iter1);
+		pkey2_base = cl_map_key(map_iter2);
+		if (pkey2_base == pkey1_base) {
+			map_iter1 = cl_map_next(map_iter1);
+			map_iter2 = cl_map_next(map_iter2);
+		} else if (pkey2_base < pkey1_base)
+			map_iter2 = cl_map_next(map_iter2);
+		else
+			map_iter1 = cl_map_next(map_iter1);
 	}
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
