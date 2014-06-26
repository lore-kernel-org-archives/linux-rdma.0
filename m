From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_state_mgr.c: Improve error flow with wrong LIDs
Date: Thu, 26 Jun 2014 07:47:46 -0400
Message-ID: <53AC0862.604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of errors, setting NULL in the entry of port_lid_tbl
should be done only for LIDs assigned by lid manager in
order to avoid unnecessary expansion of port_lid_tbl and
further incorrect max_lid calculation that is based
on port_lid_tbl vector size.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 11e8353..3c76f62 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1438,7 +1438,7 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 			 * same for this lid. Nothing to do. */
 			continue;
 
-		if (p_port_ref == NULL)
+		if (p_port_ref == NULL) {
 			/* There is an object in the subnet database for this
 			 * lid, but no such object exists in the reference
 			 * port_list_tbl. This can occur if we wanted to assign
@@ -1455,7 +1455,8 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 				cl_ntoh64(osm_port_get_guid(p_port_stored)),
 				p_port_stored->p_node->print_desc,
 				p_port_stored->p_physp->port_num);
-		else if (p_port_stored == NULL)
+			cl_ptr_vector_set(p_port_lid_tbl, lid, NULL);
+		} else if (p_port_stored == NULL)
 			/* There is an object in the new database, but no
 			 * object in our subnet database. This is the matching
 			 * case of the prior check - the port still has its
@@ -1467,7 +1468,7 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 				cl_ntoh64(osm_port_get_guid(p_port_ref)),
 				p_port_ref->p_node->print_desc,
 				p_port_ref->p_physp->port_num, lid);
-		else
+		else {
 			/* if we reached here then p_port_stored != p_port_ref.
 			 * We were trying to set a lid to p_port_stored, but
 			 * it didn't reach it, and p_port_ref also didn't get
@@ -1483,11 +1484,9 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 				cl_ntoh64(osm_port_get_guid(p_port_stored)),
 				p_port_stored->p_node->print_desc,
 				p_port_stored->p_physp->port_num);
-
-		/* In any of these cases we want to set NULL in the
-		 * port_lid_tbl, since this entry is invalid. Also, make sure
-		 * we'll do another heavy sweep. */
-		cl_ptr_vector_set(p_port_lid_tbl, lid, NULL);
+			cl_ptr_vector_set(p_port_lid_tbl, lid, NULL);
+		}
+		/* Make sure we'll do another heavy sweep. */
 		sm->p_subn->subnet_initialization_error = TRUE;
 	}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
