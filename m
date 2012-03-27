From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Added cleanup of SA cache after handover
Date: Tue, 27 Mar 2012 10:05:22 +0200
Message-ID: <20120327080522.GA32107@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Previously, when SM becomes STANDBY after being MASTER it preserved
the SA cache. When the SM will become MASTER again, its' SA cache
might be inconsistent. The solution is to clean the SA cache each
time the SM becomes STANDBY after a handover.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_port.h   |   56 +++++++++++++++++++++++++
 include/opensm/osm_subnet.h |    9 ++++-
 opensm/osm_sm_state_mgr.c   |    1 +
 opensm/osm_state_mgr.c      |   96 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+), 1 deletions(-)

diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index a6ca780..06c3e4e 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1553,5 +1553,61 @@ void osm_alias_guid_delete(IN OUT osm_alias_guid_t ** pp_alias_guid);
 *	Port
 *********/
 
+/****f* OpenSM: Port/osm_alias_guid_get_alias_guid
+* NAME
+*	osm_alias_guid_get_alias_guid
+*
+* DESCRIPTION
+*	This function retrieves alias guid from alias guid object.
+*
+* SYNOPSIS
+*/
+static inline ib_net64_t osm_alias_guid_get_alias_guid(IN osm_alias_guid_t *p_alias_guid)
+{
+	CL_ASSERT(p_alias_guid);
+	return p_alias_guid->alias_guid;
+}
+/*
+* PARAMETERS
+*	p_alias_guid
+*		[in] Pointer to a pointer to an alias guid object.
+*
+* RETURN VALUE
+*	This function returns the alias guid or NULL if fails.
+*
+* NOTES
+*
+* SEE ALSO
+*	Port
+*********/
+
+/****f* OpenSM: Port/osm_alias_guid_get_base_guid
+* NAME
+*	osm_alias_guid_get_base_guid
+*
+* DESCRIPTION
+*	This function retrieves base guid from alias guid object.
+*
+* SYNOPSIS
+*/
+static inline ib_net64_t osm_alias_guid_get_base_guid(IN osm_alias_guid_t *p_alias_guid)
+{
+	CL_ASSERT(p_alias_guid);
+	return p_alias_guid->p_base_port->guid;
+}
+/*
+* PARAMETERS
+*	p_alias_guid
+*		[in] Pointer to a pointer to an alias guid object.
+*
+* RETURN VALUE
+*	This function returns the base guid or NULL if fails.
+*
+* NOTES
+*
+* SEE ALSO
+*	Port
+*********/
+
 END_C_DECLS
 #endif				/* _OSM_PORT_H_ */
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index d88f9c7..f6b8ce8 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -584,6 +584,7 @@ typedef struct osm_subn {
 	boolean_t set_client_rereg_on_sweep;
 	boolean_t coming_out_of_standby;
 	boolean_t sweeping_enabled;
+	boolean_t clean_sa;
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
 	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
@@ -712,13 +713,19 @@ typedef struct osm_subn {
 *		TRUE on the first sweep after the SM was in standby.
 *		Used for nulling any cache of LID and Routing.
 *		The flag is set true if the SM state was standby and now
-*		changed to MASTER it is reset at the end of the sweep.
+*		changed to MASTER. It is reset at the end of the sweep.
 *
 *	sweeping_enabled
 *		FALSE - sweeping is administratively disabled, all
 *		sweeping is inhibited, TRUE - sweeping is done
 *		normally
 *
+*	clean_sa
+*		TRUE on the first sweep after SM is in standby after handover.
+*		Used for nulling the SA cache. the flag is set true if the SM
+*		state was master and now changed to standby. The flag is reset
+*		at the end of the SA cleanup.
+*
 *	need_update
 *		This flag should be on during first non-master heavy
 *		(including pre-master discovery stage)
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index ac895fa..d82d7f1 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -418,6 +418,7 @@ ib_api_status_t osm_sm_state_mgr_process(osm_sm_t * sm,
 			 */
 			sm->p_subn->sm_state = IB_SMINFO_STATE_STANDBY;
 			osm_report_sm_state(sm);
+			sm->p_subn->clean_sa = TRUE;
 			sm_state_mgr_start_polling(sm);
 			break;
 		case OSM_SM_SIGNAL_WAIT_FOR_HANDOVER:
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 9a8cf91..d54930e 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -63,7 +63,9 @@
 #include <opensm/osm_port.h>
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_inform.h>
+#include <opensm/osm_service.h>
 #include <opensm/osm_opensm.h>
+#include <opensm/osm_guid.h>
 
 extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
@@ -276,6 +278,91 @@ static ib_api_status_t state_mgr_clean_known_lids(IN osm_sm_t * sm)
 }
 
 /**********************************************************************
+ Clear SA cache
+**********************************************************************/
+static ib_api_status_t state_mgr_sa_clean(IN osm_sm_t * sm)
+{
+	ib_api_status_t status = IB_SUCCESS;
+	cl_qmap_t *p_port_guid_tbl;
+	osm_assigned_guids_t *p_assigned_guids, *p_next_assigned_guids;
+	osm_alias_guid_t *p_alias_guid, *p_next_alias_guid;
+	osm_mcm_port_t *mcm_port;
+	osm_subn_t * p_subn;
+	osm_port_t *p_port;
+	osm_infr_t *p_infr;
+	osm_svcr_t *p_svcr;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	/* we need a lock here! */
+	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+
+	p_subn = sm->p_subn;
+	/* Clean MGID table */
+	cl_fmap_remove_all(&p_subn->mgrp_mgid_tbl);
+
+	/* Clean Multicast member list on each port */
+	p_port_guid_tbl = &p_subn->port_guid_tbl;
+	for (p_port = (osm_port_t *) cl_qmap_head(p_port_guid_tbl);
+	     p_port != (osm_port_t *) cl_qmap_end(p_port_guid_tbl);
+	     p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item)) {
+		while (!cl_is_qlist_empty(&p_port->mcm_list)) {
+			mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
+					       mcm_port, list_item);
+			osm_mgrp_delete_port(p_subn, sm->p_log, mcm_port->mgrp,
+					     p_port);
+		}
+		/* Hack - clean alias guid table from physp */
+		free(p_port->p_physp->p_guids);
+		p_port->p_physp->p_guids = NULL;
+	}
+
+	/* Clean Alias Guid work objects */
+	while (cl_qlist_count(&p_subn->alias_guid_list))
+		osm_guid_work_obj_delete((osm_guidinfo_work_obj_t *)
+			cl_qlist_remove_head(&p_subn->alias_guid_list));
+
+	/* Clean Assigned GUIDs table */
+	p_next_assigned_guids = (osm_assigned_guids_t *) cl_qmap_head(&p_subn->assigned_guids_tbl);
+	while (p_next_assigned_guids !=
+	       (osm_assigned_guids_t *) cl_qmap_end(&p_subn->assigned_guids_tbl)) {
+		p_assigned_guids = p_next_assigned_guids;
+		p_next_assigned_guids = (osm_assigned_guids_t *) cl_qmap_next(&p_assigned_guids->map_item);
+		osm_assigned_guids_delete(&p_assigned_guids);
+        }
+
+	/* Clean Alias GUIDs table */
+	p_next_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&p_subn->alias_port_guid_tbl);
+	while (p_next_alias_guid !=
+	       (osm_alias_guid_t *) cl_qmap_end(&p_subn->alias_port_guid_tbl)) {
+		p_alias_guid = p_next_alias_guid;
+		p_next_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_alias_guid->map_item);
+		if (osm_alias_guid_get_alias_guid(p_alias_guid) !=
+		    osm_alias_guid_get_base_guid(p_alias_guid))
+			/* Clean if it's not base port GUID */
+			osm_alias_guid_delete(&p_alias_guid);
+	}
+
+	/* Clean InformInfo records */
+	p_infr = (osm_infr_t *) cl_qlist_remove_head(&p_subn->sa_infr_list);
+	while (p_infr !=
+	       (osm_infr_t *) cl_qlist_end(&p_subn->sa_infr_list)) {
+		osm_infr_delete(p_infr);
+		p_infr = (osm_infr_t *) cl_qlist_remove_head(&p_subn->sa_infr_list);
+	}
+
+	/* Clean Service records */
+	p_svcr = (osm_svcr_t *) cl_qlist_remove_head(&p_subn->sa_sr_list);
+	while (p_svcr !=
+	       (osm_svcr_t *) cl_qlist_end(&p_subn->sa_sr_list))
+		p_svcr = (osm_svcr_t *) cl_qlist_remove_head(&p_subn->sa_sr_list);
+
+	CL_PLOCK_RELEASE(sm->p_lock);
+	OSM_LOG_EXIT(sm->p_log);
+	return status;
+}
+
+/**********************************************************************
  Notifies the transport layer that the local LID has changed,
  which give it a chance to update address vectors, etc..
 **********************************************************************/
@@ -1088,6 +1175,15 @@ static void do_sweep(osm_sm_t * sm)
 		 */
 		state_mgr_clean_known_lids(sm);
 
+	if (sm->p_subn->clean_sa) {
+		/*
+		 * Need to clean SA cache when state changes to STANDBY
+		 * after handover.
+		 */
+		state_mgr_sa_clean(sm);
+		sm->p_subn->clean_sa = FALSE;
+	}
+
 	sm->master_sm_found = 0;
 
 	/*
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
