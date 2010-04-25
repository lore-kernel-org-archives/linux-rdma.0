From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: conversion to osm_get_port_by_lid()
Date: Sun, 25 Apr 2010 21:45:18 +0300
Message-ID: <20100425184518.GR23994@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Simplify many obvious flows by using osm_get_port_by_lid*() helpers.

This also introduces osm_get_port_by_lid_ho() helper where lid parameter
is used in host byte order - this is in order to prevent double byte
order conversion in routing engines code.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h     |   33 +++++++++++++-
 opensm/opensm/osm_console.c            |    4 +-
 opensm/opensm/osm_dump.c               |    6 +-
 opensm/opensm/osm_inform.c             |    5 +-
 opensm/opensm/osm_link_mgr.c           |    9 +---
 opensm/opensm/osm_sa_informinfo.c      |    2 +-
 opensm/opensm/osm_sa_path_record.c     |   75 ++++++++++++--------------------
 opensm/opensm/osm_sa_portinfo_record.c |   37 +++-------------
 opensm/opensm/osm_subnet.c             |   23 ++--------
 opensm/opensm/osm_trap_rcv.c           |   51 ++++++---------------
 opensm/opensm/osm_ucast_ftree.c        |    4 +-
 opensm/opensm/osm_ucast_lash.c         |    2 +-
 opensm/opensm/osm_ucast_updn.c         |   18 +++----
 13 files changed, 106 insertions(+), 163 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 8a7c0d9..d79ed8f 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -958,6 +958,31 @@ struct osm_port *osm_get_port_by_guid(IN osm_subn_t const *p_subn,
 *	osm_port_t
 *********/
 
+/****f* OpenSM: Port/osm_get_port_by_lid_ho
+* NAME
+*	osm_get_port_by_lid_ho
+*
+* DESCRIPTION
+*	Returns a pointer of the port object for given lid value.
+*
+* SYNOPSIS
+*/
+struct osm_port *osm_get_port_by_lid_ho(const osm_subn_t * subn, uint16_t lid);
+/*
+* PARAMETERS
+*	subn
+*		[in] Pointer to the subnet data structure.
+*
+*	lid
+*		[in] LID requested in hot byte order.
+*
+* RETURN VALUES
+*	The port structure pointer if found. NULL otherwise.
+*
+* SEE ALSO
+*       Subnet object, osm_port_t
+*********/
+
 /****f* OpenSM: Port/osm_get_port_by_lid
 * NAME
 *	osm_get_port_by_lid
@@ -967,14 +992,18 @@ struct osm_port *osm_get_port_by_guid(IN osm_subn_t const *p_subn,
 *
 * SYNOPSIS
 */
-struct osm_port *osm_get_port_by_lid(const osm_subn_t * subn, ib_net16_t lid);
+static inline struct osm_port *osm_get_port_by_lid(IN osm_subn_t const * subn,
+						   IN ib_net16_t lid)
+{
+	return osm_get_port_by_lid_ho(subn, cl_ntoh16(lid));
+}
 /*
 * PARAMETERS
 *	subn
 *		[in] Pointer to the subnet data structure.
 *
 *	lid
-*		[in] LID requested.
+*		[in] LID requested in network byte order.
 *
 * RETURN VALUES
 *	The port structure pointer if found. NULL otherwise.
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index a27bee3..968486e 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -515,9 +515,7 @@ static void querylid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 
 	lid = (uint16_t) strtoul(p_cmd, NULL, 0);
 	cl_plock_acquire(&p_osm->lock);
-	if (lid > cl_ptr_vector_get_capacity(&(p_osm->subn.port_lid_tbl)))
-		goto invalid_lid;
-	p_port = cl_ptr_vector_get(&(p_osm->subn.port_lid_tbl), lid);
+	p_port = osm_get_port_by_lid_ho(&p_osm->subn, lid);
 	if (!p_port)
 		goto invalid_lid;
 
diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index 86e9c00..fe2c3bc 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -140,7 +140,7 @@ static void dump_ucast_routes(cl_map_item_t * item, FILE * file, void *cxt)
 	for (lid_ho = 1; lid_ho <= max_lid_ho; lid_ho++) {
 		fprintf(file, "0x%04X : ", lid_ho);
 
-		p_port = cl_ptr_vector_get(&p_osm->subn.port_lid_tbl, lid_ho);
+		p_port = osm_get_port_by_lid_ho(&p_osm->subn, lid_ho);
 		if (!p_port) {
 			fprintf(file, "UNREACHABLE\n");
 			continue;
@@ -313,7 +313,7 @@ static void dump_lid_matrix(cl_map_item_t * item, FILE * file, void *cxt)
 		for (port = 0; port < max_port; port++)
 			fprintf(file, " %02x",
 				osm_switch_get_hop_count(p_sw, lid, port));
-		p_port = cl_ptr_vector_get(&p_osm->subn.port_lid_tbl, lid);
+		p_port = osm_get_port_by_lid_ho(&p_osm->subn, lid);
 		if (p_port)
 			fprintf(file, " # portguid 0x016%" PRIx64,
 				cl_ntoh64(osm_port_get_guid(p_port)));
@@ -344,7 +344,7 @@ static void dump_ucast_lfts(cl_map_item_t * item, FILE * file, void *cxt)
 
 		fprintf(file, "0x%04x %03u # ", lid, port);
 
-		p_port = cl_ptr_vector_get(&p_osm->subn.port_lid_tbl, lid);
+		p_port = osm_get_port_by_lid_ho(&p_osm->subn, lid);
 		if (p_port) {
 			p_node = p_port->p_node;
 			fprintf(file, "%s portguid 0x%016" PRIx64 ": \'%s\'",
diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
index 8108213..46aa835 100644
--- a/opensm/opensm/osm_inform.c
+++ b/opensm/opensm/osm_inform.c
@@ -485,9 +485,8 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
 		goto Exit;
 	}
 
-	p_dest_port =
-	    cl_ptr_vector_get(&p_subn->port_lid_tbl,
-			      cl_ntoh16(p_infr_rec->report_addr.dest_lid));
+	p_dest_port = osm_get_port_by_lid(p_subn,
+					  p_infr_rec->report_addr.dest_lid);
 	if (!p_dest_port) {
 		OSM_LOG(p_log, OSM_LOG_INFO,
 			"Cannot find destination port with LID:%u\n",
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index 03a585b..e6c9b3b 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -59,7 +59,7 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
 	osm_opensm_t *p_osm = sm->p_subn->p_osm;
 	const osm_port_t *p_sm_port, *p_src_port;
-	ib_net16_t slid, smlid;
+	ib_net16_t slid;
 	uint8_t sl;
 
 	OSM_LOG_ENTER(sm->p_log);
@@ -72,13 +72,10 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 	}
 
 	/* Find osm_port of the SM itself = dest_port */
-	smlid = sm->p_subn->sm_base_lid;
-	p_sm_port =
-	    cl_ptr_vector_get(&sm->p_subn->port_lid_tbl, cl_ntoh16(smlid));
+	p_sm_port = osm_get_port_by_lid(sm->p_subn, sm->p_subn->sm_base_lid);
 
 	/* Find osm_port of the source = p_physp */
-	p_src_port =
-	    cl_ptr_vector_get(&sm->p_subn->port_lid_tbl, cl_ntoh16(slid));
+	p_src_port = osm_get_port_by_lid(sm->p_subn, slid);
 
 	/* Call lash to find proper SL */
 	sl = osm_get_lash_sl(p_osm, p_src_port, p_sm_port);
diff --git a/opensm/opensm/osm_sa_informinfo.c b/opensm/opensm/osm_sa_informinfo.c
index 9fb3608..be7aba7 100644
--- a/opensm/opensm/osm_sa_informinfo.c
+++ b/opensm/opensm/osm_sa_informinfo.c
@@ -158,7 +158,7 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 		/* go over all defined lids within the range and make sure that the
 		   requester port can access them according to current partitioning. */
 		for (lid = lid_range_begin; lid <= lid_range_end; lid++) {
-			p_port = osm_get_port_by_lid(sa->p_subn, cl_hton16(lid));
+			p_port = osm_get_port_by_lid_ho(sa->p_subn, lid);
 			if (p_port == NULL)
 				continue;
 
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 62102f4..9fa0c1e 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1149,7 +1149,6 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 	const ib_path_rec_t *p_pr = ib_sa_mad_get_payload_ptr(sa_mad);
 	ib_net64_t comp_mask = sa_mad->comp_mask;
 	ib_net64_t dest_guid;
-	ib_api_status_t status;
 	ib_net16_t sa_status = IB_SA_MAD_STATUS_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -1177,7 +1176,6 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 					"Non local SGID subnet prefix 0x%016"
 					PRIx64 "\n",
 					cl_ntoh64(p_pr->sgid.unicast.prefix));
-
 				sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 				goto Exit;
 			}
@@ -1195,32 +1193,24 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 				"No source port with GUID 0x%016" PRIx64 "\n",
 				cl_ntoh64(p_pr->sgid.unicast.interface_id));
-
 			sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 			goto Exit;
 		}
-	} else {
-		*pp_src_port = 0;
-		if (comp_mask & IB_PR_COMPMASK_SLID) {
-			status = cl_ptr_vector_at(&sa->p_subn->port_lid_tbl,
-						  cl_ntoh16(p_pr->slid),
-						  (void **)pp_src_port);
-
-			if ((status != CL_SUCCESS) || (*pp_src_port == NULL)) {
-				/*
-				   This 'error' is the client's fault (bad lid) so
-				   don't enter it as an error in our own log.
-				   Return an error response to the client.
-				 */
-				OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
-					"No source port with LID %u\n",
-					cl_ntoh16(p_pr->slid));
-
-				sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
-				goto Exit;
-			}
+	} else if (comp_mask & IB_PR_COMPMASK_SLID) {
+		*pp_src_port = osm_get_port_by_lid(sa->p_subn, p_pr->slid);
+		if (!*pp_src_port) {
+			/*
+			   This 'error' is the client's fault (bad lid) so
+			   don't enter it as an error in our own log.
+			   Return an error response to the client.
+			 */
+			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE, "No source port "
+				"with LID %u\n", cl_ntoh16(p_pr->slid));
+			sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
+			goto Exit;
 		}
-	}
+	} else
+		*pp_src_port = NULL;
 
 	if (comp_mask & IB_PR_COMPMASK_DGID) {
 		if (!ib_gid_is_link_local(&p_pr->dgid) &&
@@ -1253,32 +1243,24 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 				"No dest port with GUID 0x%016" PRIx64 "\n",
 				cl_ntoh64(dest_guid));
-
 			sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 			goto Exit;
 		}
-	} else {
-		*pp_dest_port = 0;
-		if (comp_mask & IB_PR_COMPMASK_DLID) {
-			status = cl_ptr_vector_at(&sa->p_subn->port_lid_tbl,
-						  cl_ntoh16(p_pr->dlid),
-						  (void **)pp_dest_port);
-
-			if ((status != CL_SUCCESS) || (*pp_dest_port == NULL)) {
-				/*
-				   This 'error' is the client's fault (bad lid)
-				   so don't enter it as an error in our own log.
-				   Return an error response to the client.
-				 */
-				OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
-					"No dest port with LID %u\n",
-					cl_ntoh16(p_pr->dlid));
-
-				sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
-				goto Exit;
-			}
+	} else if (comp_mask & IB_PR_COMPMASK_DLID) {
+		*pp_dest_port = osm_get_port_by_lid(sa->p_subn, p_pr->dlid);
+		if (!*pp_dest_port) {
+			/*
+			   This 'error' is the client's fault (bad lid)
+			   so don't enter it as an error in our own log.
+			   Return an error response to the client.
+			 */
+			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE, "No dest port "
+				"with LID %u\n", cl_ntoh16(p_pr->dlid));
+			sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
+			goto Exit;
 		}
-	}
+	} else
+		*pp_dest_port = NULL;
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -1594,7 +1576,6 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	if (pr_rcv_get_end_points(sa, p_sa_mad, &p_src_port, &p_dest_port,
 				  &p_dgid) != IB_SA_MAD_STATUS_SUCCESS)
 		goto Unlock;
-
 	/*
 	   What happens next depends on the type of endpoint information
 	   that was specified....
diff --git a/opensm/opensm/osm_sa_portinfo_record.c b/opensm/opensm/osm_sa_portinfo_record.c
index 72b976c..c5b88b8 100644
--- a/opensm/opensm/osm_sa_portinfo_record.c
+++ b/opensm/opensm/osm_sa_portinfo_record.c
@@ -442,12 +442,10 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	osm_madw_t *p_madw = data;
 	const ib_sa_mad_t *p_rcvd_mad;
 	const ib_portinfo_record_t *p_rcvd_rec;
-	const cl_ptr_vector_t *p_tbl;
 	const osm_port_t *p_port = NULL;
 	const ib_port_info_t *p_pi;
 	cl_qlist_t rec_list;
 	osm_pir_search_ctxt_t context;
-	ib_api_status_t status = IB_SUCCESS;
 	ib_net64_t comp_mask;
 	osm_physp_t *p_req_physp;
 
@@ -487,7 +485,6 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_portinfo_record(sa->p_log, p_rcvd_rec, OSM_LOG_DEBUG);
 
-	p_tbl = &sa->p_subn->port_lid_tbl;
 	p_pi = &p_rcvd_rec->port_info;
 
 	cl_qlist_init(&rec_list);
@@ -502,41 +499,21 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 
 	cl_plock_acquire(sa->p_lock);
 
-	CL_ASSERT(cl_ptr_vector_get_size(p_tbl) < 0x10000);
-
 	/*
 	   If the user specified a LID, it obviously narrows our
 	   work load, since we don't have to search every port
 	 */
-	if (comp_mask & IB_PIR_COMPMASK_LID) {
+	if (comp_mask & (IB_PIR_COMPMASK_LID | IB_PIR_COMPMASK_BASELID)) {
 		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
-		if (!p_port) {
-			status = IB_NOT_FOUND;
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2109: "
-				"No port found with LID %u\n",
-				cl_ntoh16(p_rcvd_rec->lid));
-		}
-	} else if (comp_mask & IB_PIR_COMPMASK_BASELID) {
-		if ((uint16_t) cl_ptr_vector_get_size(p_tbl) >
-		    cl_ntoh16(p_pi->base_lid))
-			p_port = cl_ptr_vector_get(p_tbl,
-						   cl_ntoh16(p_pi->base_lid));
-		else {
-			status = IB_NOT_FOUND;
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2103: "
-				"Given LID (%u) is out of range:%u\n",
-				cl_ntoh16(p_pi->base_lid),
-				cl_ptr_vector_get_size(p_tbl));
-		}
-	}
-
-	if (status == IB_SUCCESS) {
 		if (p_port)
 			sa_pir_by_comp_mask(sa, p_port->p_node, &context);
 		else
-			cl_qmap_apply_func(&sa->p_subn->node_guid_tbl,
-					   sa_pir_by_comp_mask_cb, &context);
-	}
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2109: "
+				"No port found with LID %u\n",
+				cl_ntoh16(p_rcvd_rec->lid));
+	} else
+		cl_qmap_apply_func(&sa->p_subn->node_guid_tbl,
+				   sa_pir_by_comp_mask_cb, &context);
 
 	cl_plock_release(sa->p_lock);
 
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 6acf4bc..ac8cb37 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -539,27 +539,13 @@ osm_port_t *osm_get_port_by_mad_addr(IN osm_log_t * p_log,
 				     IN const osm_subn_t * p_subn,
 				     IN osm_mad_addr_t * p_mad_addr)
 {
-	const cl_ptr_vector_t *p_port_lid_tbl;
-	osm_port_t *p_port = NULL;
-
-	/* Find the port gid of the request in the subnet */
-	p_port_lid_tbl = &p_subn->port_lid_tbl;
-
-	CL_ASSERT(cl_ptr_vector_get_size(p_port_lid_tbl) < 0x10000);
-
-	if ((uint16_t) cl_ptr_vector_get_size(p_port_lid_tbl) >
-	    cl_ntoh16(p_mad_addr->dest_lid)) {
-		p_port =
-		    cl_ptr_vector_get(p_port_lid_tbl,
-				      cl_ntoh16(p_mad_addr->dest_lid));
-	} else {
-		/* The dest_lid is not in the subnet table - this is an error */
+	osm_port_t *port = osm_get_port_by_lid(p_subn, p_mad_addr->dest_lid);
+	if (!port)
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 7504: "
 			"Lid is out of range: %u\n",
 			cl_ntoh16(p_mad_addr->dest_lid));
-	}
 
-	return p_port;
+	return port;
 }
 
 ib_api_status_t osm_get_gid_by_mad_addr(IN osm_log_t * p_log,
@@ -629,9 +615,8 @@ osm_port_t *osm_get_port_by_guid(IN osm_subn_t const *p_subn, IN ib_net64_t guid
 	return p_port;
 }
 
-osm_port_t *osm_get_port_by_lid(IN osm_subn_t const * subn, IN ib_net16_t lid)
+osm_port_t *osm_get_port_by_lid_ho(IN osm_subn_t const * subn, IN uint16_t lid)
 {
-	lid = cl_ntoh16(lid);
 	if (lid < cl_ptr_vector_get_size(&subn->port_lid_tbl))
 		return cl_ptr_vector_get(&subn->port_lid_tbl, lid);
 	return NULL;
diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 52f8832..bf13239 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -81,16 +81,10 @@ extern void osm_req_get_node_desc(IN osm_sm_t * sm, osm_physp_t *p_physp);
  *
  **********************************************************************/
 
-static osm_physp_t *get_physp_by_lid_and_num(IN osm_sm_t * sm, IN uint16_t lid,
-					     IN uint8_t num)
+static osm_physp_t *get_physp_by_lid_and_num(IN osm_sm_t * sm,
+					     IN ib_net16_t lid, IN uint8_t num)
 {
-	cl_ptr_vector_t *p_vec = &(sm->p_subn->port_lid_tbl);
-	osm_port_t *p_port;
-
-	if (lid > cl_ptr_vector_get_size(p_vec))
-		return NULL;
-
-	p_port = (osm_port_t *) cl_ptr_vector_get(p_vec, lid);
+	osm_port_t *p_port = osm_get_port_by_lid(sm->p_subn, lid);
 	if (!p_port)
 		return NULL;
 
@@ -104,7 +98,7 @@ static uint64_t aging_tracker_callback(IN uint64_t key, IN uint32_t num_regs,
 				       IN void *context)
 {
 	osm_sm_t *sm = context;
-	uint16_t lid;
+	ib_net16_t lid;
 	uint8_t port_num;
 	osm_physp_t *p_physp;
 
@@ -114,20 +108,20 @@ static uint64_t aging_tracker_callback(IN uint64_t key, IN uint32_t num_regs,
 		/* We got an exit flag - do nothing */
 		return 0;
 
-	lid = cl_ntoh16((uint16_t) ((key & 0x0000FFFF00000000ULL) >> 32));
+	lid = (ib_net16_t) ((key & 0x0000FFFF00000000ULL) >> 32);
 	port_num = (uint8_t) ((key & 0x00FF000000000000ULL) >> 48);
 
 	p_physp = get_physp_by_lid_and_num(sm, lid, port_num);
 	if (!p_physp)
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Cannot find port num:%u with lid:%u\n",
-			port_num, lid);
+			port_num, cl_ntoh16(lid));
 	/* make sure the physp is still valid */
 	/* If the health port was false - set it to true */
 	else if (!osm_physp_is_healthy(p_physp)) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Clearing health bit of port num:%u with lid:%u\n",
-			port_num, lid);
+			port_num, cl_ntoh16(lid));
 
 		/* Clear its health bit */
 		osm_physp_set_health(p_physp, TRUE);
@@ -282,14 +276,14 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			cl_ntoh16(source_lid), cl_ntoh64(trans_id));
 }
 
-static int shutup_noisy_port(osm_sm_t *sm, uint16_t lid, uint8_t port,
+static int shutup_noisy_port(osm_sm_t *sm, ib_net16_t lid, uint8_t port,
 			     unsigned num)
 {
 	osm_physp_t *p = get_physp_by_lid_and_num(sm, lid, port);
 	if (!p) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3805: "
 			"Failed to find physical port by lid:%u num:%u\n",
-			lid, port);
+			cl_ntoh16(lid), port);
 		return -1;
 	}
 
@@ -299,7 +293,8 @@ static int shutup_noisy_port(osm_sm_t *sm, uint16_t lid, uint8_t port,
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Disabling noisy physical port 0x%016" PRIx64
 			": lid %u, num %u\n",
-			cl_ntoh64(osm_physp_get_port_guid(p)), lid, port);
+			cl_ntoh64(osm_physp_get_port_guid(p)),
+			cl_ntoh16(lid), port);
 		if (disable_port(sm, p))
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3811: "
 				"Failed to disable.\n");
@@ -312,7 +307,7 @@ static int shutup_noisy_port(osm_sm_t *sm, uint16_t lid, uint8_t port,
 	if (osm_physp_is_healthy(p)) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Marking unhealthy physical port by lid:%u num:%u\n",
-			lid, port);
+			cl_ntoh16(lid), port);
 		osm_physp_set_health(p, FALSE);
 		return 2;
 	}
@@ -330,7 +325,6 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	uint64_t trap_key;
 	uint32_t num_received;
 	osm_physp_t *p_physp;
-	cl_ptr_vector_t *p_tbl;
 	osm_port_t *p_port;
 	ib_net16_t source_lid = 0;
 	boolean_t is_gsi = TRUE;
@@ -462,8 +456,7 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 			 * we mark it as unhealthy.
 			 */
 			if (physp_change_trap == TRUE) {
-				int ret = shutup_noisy_port(sm,
-							    cl_ntoh16(source_lid),
+				int ret = shutup_noisy_port(sm, source_lid,
 							    port_num,
 							    num_received);
 				if (ret == 1) /* port disabled */
@@ -562,22 +555,8 @@ check_sweep:
 		       sizeof(ib_gid_t));
 	} else {
 		/* Need to use the IssuerLID */
-		p_tbl = &sm->p_subn->port_lid_tbl;
-
-		CL_ASSERT(cl_ptr_vector_get_size(p_tbl) < 0x10000);
-
-		if ((uint16_t) cl_ptr_vector_get_size(p_tbl) <=
-		    cl_ntoh16(source_lid)) {
-			/*  the source lid is out of range */
-			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-				"source lid is out of range:%u\n",
-				cl_ntoh16(source_lid));
-
-			goto Exit;
-		}
-		p_port = cl_ptr_vector_get(p_tbl, cl_ntoh16(source_lid));
-		if (p_port == 0) {
-			/* We have the lid - but no corresponding port */
+		p_port = osm_get_port_by_lid(sm->p_subn, source_lid);
+		if (!p_port) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Cannot find port corresponding to lid:%u\n",
 				cl_ntoh16(source_lid));
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 39268eb..88ea344 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -2994,8 +2994,8 @@ static void fabric_route_roots(IN ftree_fabric_t * p_ftree)
 			    p_leaf_sw->hops[lid] == OSM_NO_PATH)
 				continue;
 
-			p_port = cl_ptr_vector_get(
-				&p_ftree->p_osm->subn.port_lid_tbl, lid);
+			p_port = osm_get_port_by_lid_ho(&p_ftree->p_osm->subn,
+							lid);
 
 			/* we're interested only in switches */
 			if (!p_port || !p_port->p_node->sw)
diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index 3054a56..4669946 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -1008,7 +1008,7 @@ static void populate_fwd_tbls(lash_t * p_lash)
 		memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
 
 		for (lid = 1; lid <= max_lid_ho; lid++) {
-			port = cl_ptr_vector_get(&p_subn->port_lid_tbl, lid);
+			port = osm_get_port_by_lid_ho(p_subn, lid);
 			if (!port)
 				continue;
 
diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index 01e40eb..164c6f4 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -280,20 +280,18 @@ static int updn_subn_rank(IN updn_t * p_updn)
 }
 
 /* hack: preserve min hops entries to any other root switches */
-static void updn_clear_non_root_hops(updn_t * p_updn, osm_switch_t * p_sw)
+static void updn_clear_non_root_hops(updn_t * updn, osm_switch_t * sw)
 {
-	osm_port_t *p_port;
+	osm_port_t *port;
 	unsigned i;
 
-	for (i = 0; i < p_sw->num_hops; i++)
-		if (p_sw->hops[i]) {
-			p_port =
-			    cl_ptr_vector_get(&p_updn->p_osm->subn.port_lid_tbl,
-					      i);
-			if (!p_port || !p_port->p_node->sw
-			    || ((struct updn_node *)p_port->p_node->sw->priv)->
+	for (i = 0; i < sw->num_hops; i++)
+		if (sw->hops[i]) {
+			port = osm_get_port_by_lid_ho(&updn->p_osm->subn, i);
+			if (!port || !port->p_node->sw
+			    || ((struct updn_node *)port->p_node->sw->priv)->
 			    rank != 0)
-				memset(p_sw->hops[i], 0xff, p_sw->num_ports);
+				memset(sw->hops[i], 0xff, sw->num_ports);
 		}
 }
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
