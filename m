From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Add cleanup of SA cache after handover
Date: Wed, 03 Jun 2015 10:59:38 -0400
Message-ID: <556F165A.7000805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 19 Aug 2012 18:39:44 +0300

Previously, when SM becomes STANDBY after being MASTER, it preserved
the SA cache. When the SM will become MASTER again, it's SA cache
might be inconsistent. The solution is to clean the SA cache each
time that the SM becomes STANDBY after a handover.

Also, enhance drop_event_subscriptions option for ServiceRecords

drop_event_subscriptions is supposed to be just drop SA event subscriptions
(InformInfos). AGUID and MC subscriptions are always dropped
as client reregister mechanism works there.

As we are aware of potential issues with ServiceRecords (not being
reregistered), dropping of those is also controlled by this option.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 206c4a9..da06d31 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1611,5 +1611,61 @@ void osm_alias_guid_delete(IN OUT osm_alias_guid_t ** pp_alias_guid);
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
+	return osm_port_get_guid(p_alias_guid->p_base_port);
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
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 976a691..9094db6 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -69,6 +69,8 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_congestion_control.h>
 #include <opensm/osm_db.h>
+#include <opensm/osm_service.h>
+#include <opensm/osm_guid.h>
 
 extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
@@ -291,6 +293,105 @@ static ib_api_status_t state_mgr_clean_known_lids(IN osm_sm_t * sm)
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
+	p_subn = sm->p_subn;
+
+	/* we need a lock here! */
+	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+
+	if (p_subn->opt.drop_event_subscriptions) {
+		/* Clean InformInfo records */
+		p_infr = (osm_infr_t *) cl_qlist_remove_head(&p_subn->sa_infr_list);
+		while (p_infr !=
+		       (osm_infr_t *) cl_qlist_end(&p_subn->sa_infr_list)) {
+			osm_infr_delete(p_infr);
+			p_infr = (osm_infr_t *) cl_qlist_remove_head(&p_subn->sa_infr_list);
+		}
+
+		/* For now, treat Service Records in same category as InformInfos */
+		/* Clean Service records */
+		p_svcr = (osm_svcr_t *) cl_qlist_remove_head(&p_subn->sa_sr_list);
+		while (p_svcr !=
+		       (osm_svcr_t *) cl_qlist_end(&p_subn->sa_sr_list)) {
+			osm_svcr_delete(p_svcr);
+			p_svcr = (osm_svcr_t *) cl_qlist_remove_head(&p_subn->sa_sr_list);
+		}
+	}
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
+	p_next_assigned_guids = (osm_assigned_guids_t *)
+				cl_qmap_head(&p_subn->assigned_guids_tbl);
+	while (p_next_assigned_guids !=
+	       (osm_assigned_guids_t *) cl_qmap_end(&p_subn->assigned_guids_tbl)) {
+		p_assigned_guids = p_next_assigned_guids;
+		p_next_assigned_guids = (osm_assigned_guids_t *)
+					cl_qmap_next(&p_assigned_guids->map_item);
+		cl_qmap_remove_item(&p_subn->assigned_guids_tbl,
+				    &p_assigned_guids->map_item);
+		osm_assigned_guids_delete(&p_assigned_guids);
+        }
+
+	/* Clean Alias GUIDs table */
+	p_next_alias_guid = (osm_alias_guid_t *)
+			    cl_qmap_head(&p_subn->alias_port_guid_tbl);
+	while (p_next_alias_guid !=
+	       (osm_alias_guid_t *) cl_qmap_end(&p_subn->alias_port_guid_tbl)) {
+		p_alias_guid = p_next_alias_guid;
+		p_next_alias_guid = (osm_alias_guid_t *)
+				    cl_qmap_next(&p_alias_guid->map_item);
+		if (osm_alias_guid_get_alias_guid(p_alias_guid) !=
+		    osm_alias_guid_get_base_guid(p_alias_guid)) {
+			/* Clean if it's not base port GUID */
+			cl_qmap_remove_item(&p_subn->alias_port_guid_tbl,
+					    &p_alias_guid->map_item);
+			osm_alias_guid_delete(&p_alias_guid);
+		}
+	}
+
+	p_subn->p_osm->sa.dirty = TRUE;
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
@@ -1197,6 +1298,12 @@ static void do_sweep(osm_sm_t * sm)
 		state_mgr_clean_known_lids(sm);
 
 		/*
+		 * Need to clean SA cache when state changes to STANDBY
+		 * after handover.
+		 */
+		state_mgr_sa_clean(sm);
+
+		/*
 		 * Need to reconfigure LFTs, PKEYs, and QoS on all switches
 		 * when coming out of STANDBY
 		 */
@@ -1323,6 +1430,7 @@ repeat_discovery:
 	if (state_mgr_is_sm_port_down(sm) == TRUE) {
 		if (sm->p_subn->last_sm_port_state) {
 			sm->p_subn->last_sm_port_state = 0;
+			state_mgr_sa_clean(sm);
 			osm_log_v2(sm->p_log, OSM_LOG_SYS, FILE_ID,
 				   "SM port is down\n");
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 26038c3..457772f 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2613,7 +2613,7 @@ void osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"sm_inactive %s\n\n"
 		"# Babbling Port Policy\n"
 		"babbling_port_policy %s\n\n"
-		"# Drop event subscriptions (InformInfo) if the port goes away\n"
+		"# Drop event subscriptions (InformInfo and ServiceRecord) on port removal and SM coming out of STANDBY\n"
 		"drop_event_subscriptions %s\n\n"
 		"# Use Optimized SLtoVLMapping programming if supported by device\n"
 		"use_optimized_slvl %s\n\n"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
