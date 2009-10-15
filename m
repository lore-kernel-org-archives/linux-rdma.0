From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr.c: Cosmetic commentary changes
Date: Thu, 15 Oct 2009 14:43:07 -0400
Message-ID: <20091015184307.GA9771@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 74b5e39..990c26e 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -175,8 +175,8 @@ static void lid_mgr_validate_db(IN osm_lid_mgr_t * p_mgr)
 				lids_ok = FALSE;
 			} else if (min_lid != max_lid
 				   && (min_lid & lmc_mask) != min_lid) {
-				/* check that if the lids define a range that is valid
-				   for the current LMC mask */
+				/* check that if the lids define a range that is
+				   valid for the current LMC mask */
 				OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR,
 					"ERR 0313: "
 					"LID range [%u:%u] for guid:0x%016"
@@ -210,7 +210,7 @@ static void lid_mgr_validate_db(IN osm_lid_mgr_t * p_mgr)
 						"guid:0x%016" PRIx64 "\n",
 						p_item->guid);
 			} else {
-				/* mark it was visited */
+				/* mark that it was visited */
 				for (lid = min_lid; lid <= max_lid; lid++)
 					p_mgr->used_lids[lid] = 1;
 			}
@@ -412,8 +412,8 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 	   Our task is to find free lid ranges.
 	   A lid can be used if
 	   1. a persistent assignment exists
-	   2. the lid is used by a discovered port that does not have a persistent
-	   assignment.
+	   2. the lid is used by a discovered port that does not have a
+	   persistent assignment.
 
 	   scan through all lid values of both the persistent table and
 	   discovered table.
@@ -454,15 +454,15 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 							  lid))) {
 			/* we have a port. Now lets see if we can preserve its lid range. */
 			/* For that, we need to make sure:
-			   1. The port has a (legal) persistency entry. Then the local lid
-			   is free (we will use the persistency value).
+			   1. The port has a (legal) persistency entry. Then the
+			   local lid is free (we will use the persistency value).
 			   2. Can the port keep its local assignment?
 			   a. Make sure the lid a aligned.
-			   b. Make sure all needed lids (for the lmc) are free according
-			   to persistency table.
+			   b. Make sure all needed lids (for the lmc) are free
+			   according to persistency table.
 			 */
-			/* qualify the guid of the port is not persistently mapped to
-			   another range */
+			/* qualify the guid of the port is not persistently
+			   mapped to another range */
 			if (!osm_db_guid2lid_get(p_mgr->p_g2l,
 						 cl_ntoh64
 						 (osm_port_get_guid(p_port)),
@@ -474,8 +474,9 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 					lid, db_min_lid, db_max_lid);
 			} else {
 				/* can the port keep its assignment ? */
-				/* get the lid range of that port, and the required number
-				   of lids we are about to assign to it */
+				/* get the lid range of that port, and the
+				   required number of lids we are about to
+				   assign to it */
 				osm_port_get_lid_range_ho(p_port,
 							  &disc_min_lid,
 							  &disc_max_lid);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
