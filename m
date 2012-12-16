From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 1/1] OpenSM: DFSSSP does not find LIDs due to wrong byte order
Date: Mon, 17 Dec 2012 01:06:53 +0900
Message-ID: <1355674013-3779-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

Problem:
path_sl(...) arguments for slid/dlid are in network byte order; internal storage of lids is host byte order; this mismatch results in a return value of 'hint_for_default_sl' of DFSSSP's get_dfsssp_sl function for every request

Fix:
lids will be stored in network byte order, so that a conversion is not necessaryand DFSSSP returns the correct SL for tht request

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index ffc317f..903966c 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -339,7 +339,7 @@ static void heap_free(binary_heap_t * heap)
 /* compare function of two lids for stdlib qsort */
 static int cmp_lids(const void *l1, const void *l2)
 {
-	uint16_t lid1 = *((uint16_t *) l1), lid2 = *((uint16_t *) l2);
+	ib_net16_t lid1 = *((ib_net16_t *) l1), lid2 = *((ib_net16_t *) l2);
 
 	if (lid1 < lid2)
 		return -1;
@@ -352,19 +352,19 @@ static int cmp_lids(const void *l1, const void *l2)
 /* use stdlib to sort the lid array */
 static inline void vltable_sort_lids(vltable_t * vltable)
 {
-	qsort(vltable->lids, vltable->num_lids, sizeof(uint16_t), cmp_lids);
+	qsort(vltable->lids, vltable->num_lids, sizeof(ib_net16_t), cmp_lids);
 }
 
 /* use stdlib to get index of key in lid array;
    return -1 if lid isn't found in lids array
 */
-static inline int64_t vltable_get_lidindex(uint16_t * key, vltable_t * vltable)
+static inline int64_t vltable_get_lidindex(ib_net16_t * key, vltable_t * vltable)
 {
-	uint16_t *found_lid = NULL;
+	ib_net16_t *found_lid = NULL;
 
 	found_lid =
-	    (uint16_t *) bsearch(key, vltable->lids, vltable->num_lids,
-				 sizeof(uint16_t), cmp_lids);
+	    (ib_net16_t *) bsearch(key, vltable->lids, vltable->num_lids,
+				   sizeof(ib_net16_t), cmp_lids);
 	if (found_lid)
 		return found_lid - vltable->lids;
 	else
@@ -374,7 +374,7 @@ static inline int64_t vltable_get_lidindex(uint16_t * key, vltable_t * vltable)
 /* get virtual lane from src lid X dest lid kombination;
    return -1 for invalid lids
 */
-static int32_t vltable_get_vl(vltable_t * vltable, uint16_t slid, uint16_t dlid)
+static int32_t vltable_get_vl(vltable_t * vltable, ib_net16_t slid, ib_net16_t dlid)
 {
 	int64_t ind1 = vltable_get_lidindex(&slid, vltable);
 	int64_t ind2 = vltable_get_lidindex(&dlid, vltable);
@@ -387,8 +387,8 @@ static int32_t vltable_get_vl(vltable_t * vltable, uint16_t slid, uint16_t dlid)
 }
 
 /* set a virtual lane in the matrix */
-static inline void vltable_insert(vltable_t * vltable, uint16_t slid,
-				  uint16_t dlid, uint8_t vl)
+static inline void vltable_insert(vltable_t * vltable, ib_net16_t slid,
+				  ib_net16_t dlid, uint8_t vl)
 {
 	int64_t ind1 = vltable_get_lidindex(&slid, vltable);
 	int64_t ind2 = vltable_get_lidindex(&dlid, vltable);
@@ -436,8 +436,8 @@ static void vltable_print(osm_ucast_mgr_t * p_mgr, vltable_t * vltable)
 				OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 					"   route from src_lid=%" PRIu16
 					" to dest_lid=%" PRIu16 " on vl=%" PRIu8
-					"\n", vltable->lids[ind1],
-					vltable->lids[ind2],
+					"\n", cl_ntoh16(vltable->lids[ind1]),
+					cl_ntoh16(vltable->lids[ind2]),
 					vltable->vls[ind1 +
 						     ind2 * vltable->num_lids]);
 			}
@@ -464,7 +464,7 @@ static int vltable_alloc(vltable_t ** vltable, uint64_t size)
 	if (!(*vltable))
 		goto ERROR;
 	(*vltable)->num_lids = size;
-	(*vltable)->lids = (uint16_t *) malloc(size * sizeof(uint16_t));
+	(*vltable)->lids = (ib_net16_t *) malloc(size * sizeof(ib_net16_t));
 	if (!((*vltable)->lids))
 		goto ERROR;
 	(*vltable)->vls = (uint8_t *) malloc(size * size * sizeof(uint8_t));
@@ -1645,7 +1645,7 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 			osm_port_get_lid_range_ho(dest_port, &min_lid_ho,
 						  &max_lid_ho);
 			for (dlid = min_lid_ho; dlid <= max_lid_ho; dlid++, i++)
-				srcdest2vl_table->lids[i] = dlid;
+				srcdest2vl_table->lids[i] = cl_hton16(dlid);
 		}
 	}
 	/* sort lids */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
