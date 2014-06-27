From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Skip state_mgr_check_tbl_consistency when no LID changed
 by lid or link managers
Date: Fri, 27 Jun 2014 07:16:50 -0400
Message-ID: <53AD52A2.9030507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If no LID was changed/allocated during by the lid manager and no
PortInfo(Set) was sent, there is no need to run the 
state_mgr_check_tbl_consistency routine.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_lid_mgr.h |   12 ++++++++----
 opensm/osm_lid_mgr.c         |    1 +
 opensm/osm_link_mgr.c        |    1 +
 opensm/osm_state_mgr.c       |    7 +++++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/opensm/osm_lid_mgr.h b/include/opensm/osm_lid_mgr.h
index 40f0d30..f95a2a1 100644
--- a/include/opensm/osm_lid_mgr.h
+++ b/include/opensm/osm_lid_mgr.h
@@ -98,6 +98,7 @@ typedef struct osm_lid_mgr {
 	cl_plock_t *p_lock;
 	osm_db_domain_t *p_g2l;
 	cl_qlist_t free_ranges;
+	boolean_t dirty;
 	uint8_t used_lids[IB_LID_UCAST_END_HO + 1];
 } osm_lid_mgr_t;
 /*
@@ -120,16 +121,19 @@ typedef struct osm_lid_mgr {
 *	p_g2l
 *		Pointer to the database domain storing guid to lid mapping.
 *
-*	used_lids
-*		An array of used lids. keeps track of
-*		existing and non existing mapping of guid->lid
-*
 *	free_ranges
 *		A list of available free lid ranges. The list is initialized
 *		by the code that initializes the lid assignment and is consumed
 *		by the procedure that finds a free range. It holds elements of
 *		type osm_lid_mgr_range_t
 *
+*	dirty
+*		 Indicates that lid table was updated
+*
+*	used_lids
+*		 An array of used lids. keeps track of
+*		 existing and non existing mapping of guid->lid
+*
 * SEE ALSO
 *	LID Manager object
 *********/
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index fc6bd37..703f30d 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -892,6 +892,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 		 */
 		osm_physp_set_base_lid(p_physp, 0);
 		send_set = TRUE;
+		p_mgr->dirty = TRUE;
 	}
 
 	/* we are updating the ports with our local sm_base_lid */
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 0d00984..f09783a 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -129,6 +129,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			p_port = osm_get_port_by_guid(sm->p_subn,
 						      osm_physp_get_port_guid(p_physp));
 			p_pi->base_lid = p_port->lid;
+			sm->lid_mgr.dirty = TRUE;
 			send_set = TRUE;
 		}
 
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 3c76f62..1b55ce4 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1400,6 +1400,11 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 
 	OSM_LOG_ENTER(sm->p_log);
 
+	if (sm->lid_mgr.dirty == FALSE)
+		goto Exit;
+
+	sm->lid_mgr.dirty = FALSE;
+
 	cl_ptr_vector_construct(&ref_port_lid_tbl);
 	cl_ptr_vector_init(&ref_port_lid_tbl,
 			   cl_ptr_vector_get_size(&sm->p_subn->port_lid_tbl),
@@ -1491,6 +1496,8 @@ static void state_mgr_check_tbl_consistency(IN osm_sm_t * sm)
 	}
 
 	cl_ptr_vector_destroy(&ref_port_lid_tbl);
+
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
