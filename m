From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Setup SM port GUID in subnet object as soon as it
 is known
Date: Thu, 04 Apr 2013 07:10:23 -0400
Message-ID: <515D5F9F.5080301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than wait for local NodeInfo response
This allows plugin to know SM port GUID at construct() time

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 3c8bc59..4750505 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -219,8 +219,10 @@ typedef struct osm_opensm {
 	osm_congestion_control_t cc;
 	cl_qlist_t plugin_list;
 	osm_db_t db;
+	boolean_t mad_pool_constructed;
 	osm_mad_pool_t mad_pool;
 	osm_vendor_t *p_vendor;
+	boolean_t vl15_constructed;
 	osm_vl15_t vl15;
 	osm_log_t log;
 	cl_dispatcher_t disp;
@@ -313,6 +315,34 @@ void osm_opensm_construct(IN osm_opensm_t * p_osm);
 *	SM object, osm_opensm_init, osm_opensm_destroy
 *********/
 
+/****f* OpenSM: OpenSM/osm_opensm_construct_finish
+* NAME
+*	osm_opensm_construct_finish
+*
+* DESCRIPTION
+*	The osm_opensm_construct_finish function completes
+*	the second phase of constucting an OpenSM object.
+*
+* SYNOPSIS
+*/
+void osm_opensm_construct_finish(IN osm_opensm_t * p_osm);
+/*
+* PARAMETERS
+*	p_osm
+*		[in] Pointer to a OpenSM object to construct.
+*
+* RETURN VALUE
+*	This function does not return a value.
+*
+* NOTES
+*	Calling osm_opensm_construct/osm_construct_finish is a prerequisite
+*	to calling any other method except osm_opensm_init/osm_opensm_init_finish.
+*
+* SEE ALSO
+*	SM object, osm_opensm_init, osm_opensm_construct_finish,
+*	osm_opensm_destroy, osm_opensm_destroy_finish
+*********/
+
 /****f* OpenSM: OpenSM/osm_opensm_destroy
 * NAME
 *	osm_opensm_destroy
@@ -342,6 +372,36 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm);
 *	SM object, osm_opensm_construct, osm_opensm_init
 *********/
 
+/****f* OpenSM: OpenSM/osm_opensm_destroy_finish
+* NAME
+*	osm_opensm_destroy_finish
+*
+* DESCRIPTION
+*	The osm_opensm_destroy_finish function handles the second phase
+*	of destroying an SM, releasing all resources.
+*
+* SYNOPSIS
+*/
+void osm_opensm_destroy_finish(IN osm_opensm_t * p_osm);
+/*
+* PARAMETERS
+*	p_osm
+*		[in] Pointer to a OpenSM object to destroy.
+*
+* RETURN VALUE
+*	This function does not return a value.
+*
+* NOTES
+*	Performs second phase of any necessary cleanup of the specified OpenSM object.
+*	Further operations should not be attempted on the destroyed object.
+*	This function should only be called after a call to
+*	osm_opensm_construct_finish or osm_opensm_init_finish.
+*
+* SEE ALSO
+*	SM object, osm_opensm_construct, osm_opensm_construct_finish,
+*	osm_opensm_init, osm_opensm_init_finish
+*********/
+
 /****f* OpenSM: OpenSM/osm_opensm_init
 * NAME
 *	osm_opensm_init
@@ -371,6 +431,37 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 *	SM object, osm_opensm_construct, osm_opensm_destroy
 *********/
 
+/****f* OpenSM: OpenSM/osm_opensm_init_finish
+* NAME
+*	osm_opensm_init_finish
+*
+* DESCRIPTION
+*	The osm_opensm_init_finish function performs the second phase
+*	of initialization of an OpenSM object.
+*
+* SYNOPSIS
+*/
+ib_api_status_t osm_opensm_init_finish(IN osm_opensm_t * p_osm,
+				       IN const osm_subn_opt_t * p_opt);
+/*
+* PARAMETERS
+*	p_osm
+*		[in] Pointer to an osm_opensm_t object to initialize.
+*
+*	p_opt
+*		[in] Pointer to the subnet options structure.
+*
+* RETURN VALUES
+*	IB_SUCCESS if the OpenSM object was initialized successfully.
+*
+* NOTES
+*	Allows calling other OpenSM methods.
+*
+* SEE ALSO
+*	SM object, osm_opensm_construct, osm_opensm_construct_finish,
+*	osm_opensm_destroy, osm_opensm_destroy_finish
+*********/
+
 /****f* OpenSM: OpenSM/osm_opensm_sweep
 * NAME
 *	osm_opensm_sweep
diff --git a/opensm/main.c b/opensm/main.c
index 92b1c03..9349d79 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -1193,7 +1193,16 @@ int main(int argc, char *argv[])
 		opt.guid = get_port_guid(&osm, opt.guid);
 
 	if (opt.guid == 0)
-		goto Exit;
+		goto Exit2;
+
+	status = osm_opensm_init_finish(&osm, &opt);
+	if (status != IB_SUCCESS) {
+		const char *err_str = ib_get_err_str(status);
+		if (err_str == NULL)
+			err_str = "Unknown Error Type";
+		printf("\nError from osm_opensm_init_finish: %s.\n", err_str);
+		goto Exit2;
+	}
 
 	status = osm_opensm_bind(&osm, opt.guid);
 	if (status != IB_SUCCESS) {
@@ -1237,6 +1246,8 @@ int main(int argc, char *argv[])
 
 Exit:
 	osm_opensm_destroy(&osm);
+Exit2:
+	osm_opensm_destroy_finish(&osm);
 	complib_exit();
 	remove_pidfile();
 
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 0909a36..06a5af2 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -243,12 +243,18 @@ void osm_opensm_construct(IN osm_opensm_t * p_osm)
 	memset(p_osm, 0, sizeof(*p_osm));
 	p_osm->osm_version = OSM_VERSION;
 	osm_subn_construct(&p_osm->subn);
+	osm_db_construct(&p_osm->db);
+	osm_log_construct(&p_osm->log);
+}
+
+void osm_opensm_construct_finish(IN osm_opensm_t * p_osm)
+{
 	osm_sm_construct(&p_osm->sm);
 	osm_sa_construct(&p_osm->sa);
-	osm_db_construct(&p_osm->db);
 	osm_mad_pool_construct(&p_osm->mad_pool);
+	p_osm->mad_pool_constructed = TRUE;
 	osm_vl15_construct(&p_osm->vl15);
-	osm_log_construct(&p_osm->log);
+	p_osm->vl15_constructed = TRUE;
 }
 
 static void destroy_routing_engines(osm_opensm_t *osm)
@@ -324,9 +330,17 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 	osm_perfmgr_destroy(&p_osm->perfmgr);
 #endif				/* ENABLE_OSM_PERF_MGR */
 	osm_congestion_control_destroy(&p_osm->cc);
+}
+
+void osm_opensm_destroy_finish(IN osm_opensm_t * p_osm)
+{
 	osm_db_destroy(&p_osm->db);
-	osm_vl15_destroy(&p_osm->vl15, &p_osm->mad_pool);
-	osm_mad_pool_destroy(&p_osm->mad_pool);
+	if (p_osm->vl15_constructed && p_osm->mad_pool_constructed)
+		osm_vl15_destroy(&p_osm->vl15, &p_osm->mad_pool);
+	if (p_osm->mad_pool_constructed)
+		osm_mad_pool_destroy(&p_osm->mad_pool);
+	p_osm->vl15_constructed = FALSE;
+	p_osm->mad_pool_constructed = FALSE;
 	osm_vendor_delete(&p_osm->p_vendor);
 	osm_subn_destroy(&p_osm->subn);
 	cl_disp_destroy(&p_osm->disp);
@@ -336,8 +350,8 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 #else
 	cl_event_destroy(&p_osm->stats.event);
 #endif
-	close_node_name_map(p_osm->node_name_map);
-
+	if (p_osm->node_name_map)
+		close_node_name_map(p_osm->node_name_map);
 	cl_plock_destroy(&p_osm->lock);
 
 	osm_log_destroy(&p_osm->log);
@@ -427,10 +441,22 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 
 	p_osm->p_vendor =
 	    osm_vendor_new(&p_osm->log, p_opt->transaction_timeout);
-	if (p_osm->p_vendor == NULL) {
+	if (p_osm->p_vendor == NULL)
 		status = IB_INSUFFICIENT_RESOURCES;
-		goto Exit;
-	}
+
+Exit:
+	OSM_LOG(&p_osm->log, OSM_LOG_FUNCS, "]\n");	/* Format Waived */
+	return status;
+}
+
+ib_api_status_t osm_opensm_init_finish(IN osm_opensm_t * p_osm,
+				       IN const osm_subn_opt_t * p_opt)
+{
+	ib_api_status_t status;
+
+	osm_opensm_construct_finish(p_osm);
+
+	p_osm->subn.sm_port_guid = p_opt->guid;
 
 	status = osm_mad_pool_init(&p_osm->mad_pool);
 	if (status != IB_SUCCESS)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
