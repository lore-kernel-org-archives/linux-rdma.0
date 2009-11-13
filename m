From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm: Cosmetic changes
Date: Fri, 13 Nov 2009 11:37:21 -0500
Message-ID: <20091113163720.GA13938@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Compressed some type declarations and assignments into single line
Removed some unneeded underbars
Some minor reformatting including comment lines
Fixed some tabbing
Fixed some typos
Eliminated trailing periods in messages
Eliminated some unneeded braces

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/complib/cl_nodenamemap.h b/opensm/include/complib/cl_nodenamemap.h
index 9b2ada4..97984b1 100644
--- a/opensm/include/complib/cl_nodenamemap.h
+++ b/opensm/include/complib/cl_nodenamemap.h
@@ -56,8 +56,7 @@ typedef cl_qmap_t nn_map_t;
  */
 nn_map_t *open_node_name_map(char *node_name_map);
 void  close_node_name_map(nn_map_t *map);
-char *remap_node_name(nn_map_t *map, uint64_t target_guid,
-			char *nodedesc);
+char *remap_node_name(nn_map_t *map, uint64_t target_guid, char *nodedesc);
 	/* NOTE: parameter "nodedesc" may be modified here. */
 int parse_node_map(const char *file_name,
 		   int (*create)(void *, uint64_t, char *), void *cxt);
diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index f6a1cf4..1facbd3 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -2415,7 +2415,7 @@ typedef struct _ib_path_rec {
 *		Another global routing parameter.
 *
 *	num_path
-*     Reversible path - 1 bit to say if path is reversible.
+*		Reversible path - 1 bit to say if path is reversible.
 *		num_path [6:0] In queries, maximum number of paths to return.
 *		In responses, undefined.
 *
@@ -2766,7 +2766,7 @@ ib_path_rec_init_local(IN ib_path_rec_t * const p_rec,
 *		[in] LID of source port.
 *
 *	num_path
-*     [in] Reversible path - 1 bit to say if path is reversible.
+*		[in] Reversible path - 1 bit to say if path is reversible.
 *		num_path [6:0] In queries, maximum number of paths to return.
 *		In responses, undefined.
 *
@@ -4316,7 +4316,7 @@ ib_sa_mad_get_payload_ptr(IN const ib_sa_mad_t * const p_sa_mad)
 *	ib_node_info_get_local_port_num
 *
 * DESCRIPTION
-*	Gets a the local port number from the NodeInfo attribute.
+*	Gets the local port number from the NodeInfo attribute.
 *
 * SYNOPSIS
 */
diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
index aa8ffe1..33d1920 100644
--- a/opensm/include/opensm/osm_event_plugin.h
+++ b/opensm/include/opensm/osm_event_plugin.h
@@ -142,8 +142,8 @@ typedef struct osm_event_plugin {
 	const char *osm_version;
 	void *(*create) (struct osm_opensm *osm);
 	void (*delete) (void *plugin_data);
-	void (*report) (void *plugin_data,
-			osm_epi_event_id_t event_id, void *event_data);
+	void (*report) (void *plugin_data, osm_epi_event_id_t event_id,
+			void *event_data);
 } osm_event_plugin_t;
 
 /** =========================================================================
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index c50670b..206e7f7 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -1241,12 +1241,12 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 			} else
 				fprintf(out, "No file name passed\n");
 		} else if (!(p_regexp = malloc(sizeof(*p_regexp)))) {
-			fprintf(out, "No memory.\n");
+			fprintf(out, "No memory\n");
 			break;
 		} else if (regcomp(&p_regexp->exp, p_cmd,
 				   REG_NOSUB | REG_EXTENDED) != 0) {
 			fprintf(out, "Cannot parse regular expression \'%s\'."
-				" Skipping.\n", p_cmd);
+				" Skipping\n", p_cmd);
 			free(p_regexp);
 			continue;
 		} else {
@@ -1262,7 +1262,7 @@ static void dump_portguid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 	}
 
 	if (p_osm->sm.p_subn->need_update != 0) {
-		fprintf(out, "Subnet is not ready yet. Try again later.\n");
+		fprintf(out, "Subnet is not ready yet. Try again later\n");
 		return;
 	}
 
diff --git a/opensm/opensm/osm_drop_mgr.c b/opensm/opensm/osm_drop_mgr.c
index b749260..879e21f 100644
--- a/opensm/opensm/osm_drop_mgr.c
+++ b/opensm/opensm/osm_drop_mgr.c
@@ -88,11 +88,13 @@ static void drop_mgr_clean_physp(osm_sm_t * sm, IN osm_physp_t * p_physp)
 						     p_remote_physp->port_guid);
 
 		if (p_remote_port) {
-			/* Let's check if this is a case of link that is lost (both ports
-			   weren't recognized), or a "hiccup" in the subnet - in which case
-			   the remote port was recognized, and its state is ACTIVE.
-			   If this is just a "hiccup" - force a heavy sweep in the next sweep.
-			   We don't want to lose that part of the subnet. */
+			/* Let's check if this is a case of link that is lost
+			   (both ports weren't recognized), or a "hiccup" in the
+			   subnet - in which case the remote port was
+			   recognized, and its state is ACTIVE.
+			   If this is just a "hiccup" - force a heavy sweep in
+			   the next sweep. We don't want to lose that part of
+			   the subnet. */
 			if (p_remote_port->discovery_count &&
 			    osm_physp_get_port_state(p_remote_physp) ==
 			    IB_LINK_ACTIVE) {
@@ -105,9 +107,10 @@ static void drop_mgr_clean_physp(osm_sm_t * sm, IN osm_physp_t * p_physp)
 				sm->p_subn->force_heavy_sweep = TRUE;
 			}
 
-			/* If the remote node is ca or router - need to remove the remote port,
-			   since it is no longer reachable. This can be done if we reset the
-			   discovery count of the remote port. */
+			/* If the remote node is ca or router - need to remove
+			   the remote port, since it is no longer reachable.
+			   This can be done if we reset the discovery count
+			   of the remote port. */
 			if (!p_remote_physp->p_node->sw) {
 				p_remote_port->discovery_count = 0;
 				OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
@@ -130,8 +133,8 @@ static void drop_mgr_clean_physp(osm_sm_t * sm, IN osm_physp_t * p_physp)
 			p_remote_physp->port_num);
 
 		if (sm->ucast_mgr.cache_valid)
-			osm_ucast_cache_add_link(&sm->ucast_mgr,
-						 p_physp, p_remote_physp);
+			osm_ucast_cache_add_link(&sm->ucast_mgr, p_physp,
+						 p_remote_physp);
 
 		osm_physp_unlink(p_physp, p_remote_physp);
 
@@ -406,12 +409,9 @@ Exit:
 
 void osm_drop_mgr_process(osm_sm_t * sm)
 {
-	cl_qmap_t *p_node_guid_tbl;
-	cl_qmap_t *p_port_guid_tbl;
-	osm_port_t *p_port;
-	osm_port_t *p_next_port;
-	osm_node_t *p_node;
-	osm_node_t *p_next_node;
+	cl_qmap_t *p_node_guid_tbl, *p_port_guid_tbl;
+	osm_port_t *p_port, *p_next_port;
+	osm_node_t *p_node, *p_next_node;
 
 	CL_ASSERT(sm);
 
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index a553310..77ae89e 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -58,7 +58,7 @@
 #define ARR_SIZE(a) (sizeof(a)/sizeof((a)[0]))
 
 /* we use two tables - one for queries and one for responses */
-static const char *__ib_sa_method_str[] = {
+static const char *ib_sa_method_str[] = {
 	"RESERVED",		/* 0 */
 	"SubnAdmGet",		/* 1 */
 	"SubnAdmSet",		/* 2 */
@@ -84,7 +84,7 @@ static const char *__ib_sa_method_str[] = {
 	"UNKNOWN"		/* 16 */
 };
 
-static const char *__ib_sa_resp_method_str[] = {
+static const char *ib_sa_resp_method_str[] = {
 	"RESERVED",		/* 80 */
 	"SubnAdmGetResp",	/* 81 */
 	"RESERVED (SetResp?)",	/* 82 */
@@ -112,7 +112,7 @@ static const char *__ib_sa_resp_method_str[] = {
 
 #define OSM_SA_METHOD_STR_UNKNOWN_VAL 0x16
 
-static const char *__ib_sm_method_str[] = {
+static const char *ib_sm_method_str[] = {
 	"RESERVED0",		/* 0 */
 	"SubnGet",		/* 1 */
 	"SubnSet",		/* 2 */
@@ -150,7 +150,7 @@ static const char *__ib_sm_method_str[] = {
 
 #define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x21
 
-static const char *__ib_sm_attr_str[] = {
+static const char *ib_sm_attr_str[] = {
 	"RESERVED",		/* 0 */
 	"ClassPortInfo",	/* 1 */
 	"Notice",		/* 2 */
@@ -189,7 +189,7 @@ static const char *__ib_sm_attr_str[] = {
 
 #define OSM_SM_ATTR_STR_UNKNOWN_VAL 0x21
 
-static const char *__ib_sa_attr_str[] = {
+static const char *ib_sa_attr_str[] = {
 	"RESERVED",		/* 0 */
 	"ClassPortInfo",	/* 1 */
 	"Notice",		/* 2 */
@@ -460,11 +460,11 @@ const char *ib_get_sa_method_str(IN uint8_t method)
 		if (method > OSM_SA_METHOD_STR_UNKNOWN_VAL)
 			method = OSM_SA_METHOD_STR_UNKNOWN_VAL;
 		/* it is a response - use the response table */
-		return __ib_sa_resp_method_str[method];
+		return ib_sa_resp_method_str[method];
 	} else {
 		if (method > OSM_SA_METHOD_STR_UNKNOWN_VAL)
 			method = OSM_SA_METHOD_STR_UNKNOWN_VAL;
-		return __ib_sa_method_str[method];
+		return ib_sa_method_str[method];
 	}
 }
 
@@ -474,7 +474,7 @@ const char *ib_get_sm_method_str(IN uint8_t method)
 		method = (method & 0x0F) | 0x10;
 	if (method > OSM_SM_METHOD_STR_UNKNOWN_VAL)
 		method = OSM_SM_METHOD_STR_UNKNOWN_VAL;
-	return __ib_sm_method_str[method];
+	return ib_sm_method_str[method];
 }
 
 const char *ib_get_sm_attr_str(IN ib_net16_t attr)
@@ -484,7 +484,7 @@ const char *ib_get_sm_attr_str(IN ib_net16_t attr)
 	if (host_attr > OSM_SM_ATTR_STR_UNKNOWN_VAL)
 		host_attr = OSM_SM_ATTR_STR_UNKNOWN_VAL;
 
-	return __ib_sm_attr_str[host_attr];
+	return ib_sm_attr_str[host_attr];
 }
 
 const char *ib_get_sa_attr_str(IN ib_net16_t attr)
@@ -494,7 +494,7 @@ const char *ib_get_sa_attr_str(IN ib_net16_t attr)
 	if (host_attr > OSM_SA_ATTR_STR_UNKNOWN_VAL)
 		host_attr = OSM_SA_ATTR_STR_UNKNOWN_VAL;
 
-	return __ib_sa_attr_str[host_attr];
+	return ib_sa_attr_str[host_attr];
 }
 
 const char *ib_get_trap_str(ib_net16_t trap_num)
@@ -1992,7 +1992,6 @@ const char *osm_get_sm_signal_str(IN osm_signal_t signal)
 	return sm_signal_str[signal];
 }
 
-
 static const char *disp_msg_str[] = {
 	"OSM_MSG_NONE",
 	"OSM_MSG_MAD_NODE_INFO",
@@ -2210,7 +2209,6 @@ const char *osm_get_lsa_str(IN uint8_t lsa)
 		return lsa_str_fixed_width[lsa];
 }
 
-
 static const char *sm_mgr_signal_str[] = {
 	"OSM_SM_SIGNAL_NONE",	/* 0 */
 	"OSM_SM_SIGNAL_DISCOVERY_COMPLETED",	/* 2 */
diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 2a2c4b3..2531255 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -1212,9 +1212,8 @@ int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * p_mgr)
 		   to look for any field change and will only send an updated
 		   if required */
 		OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
-			"Assigned port 0x%016" PRIx64
-			", LID [%u,%u]\n", cl_ntoh64(port_guid),
-			min_lid_ho, max_lid_ho);
+			"Assigned port 0x%016" PRIx64 ", LID [%u,%u]\n",
+			cl_ntoh64(port_guid), min_lid_ho, max_lid_ho);
 
 		/* the proc returns the fact it sent a set port info */
 		if (lid_mgr_set_physp_pi(p_mgr, p_port, p_port->p_physp,
diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_mgr.c
index e56b684..03a585b 100644
--- a/opensm/opensm/osm_link_mgr.c
+++ b/opensm/opensm/osm_link_mgr.c
@@ -58,10 +58,8 @@
 static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
 	osm_opensm_t *p_osm = sm->p_subn->p_osm;
-	const osm_port_t *p_sm_port;
-	const osm_port_t *p_src_port;
-	ib_net16_t slid;
-	ib_net16_t smlid;
+	const osm_port_t *p_sm_port, *p_src_port;
+	ib_net16_t slid, smlid;
 	uint8_t sl;
 
 	OSM_LOG_ENTER(sm->p_log);
diff --git a/opensm/opensm/osm_node.c b/opensm/opensm/osm_node.c
index ea28c70..5975cf8 100644
--- a/opensm/opensm/osm_node.c
+++ b/opensm/opensm/osm_node.c
@@ -132,9 +132,8 @@ static void node_destroy(IN osm_node_t * p_node)
 		osm_physp_destroy(&p_node->physp_table[i]);
 
 	/* cleanup printable node_desc field */
-	if (p_node->print_desc) {
+	if (p_node->print_desc)
 		free(p_node->print_desc);
-	}
 }
 
 void osm_node_delete(IN OUT osm_node_t ** p_node)
diff --git a/opensm/opensm/osm_node_info_rcv.c b/opensm/opensm/osm_node_info_rcv.c
index 42637e6..b3e272c 100644
--- a/opensm/opensm/osm_node_info_rcv.c
+++ b/opensm/opensm/osm_node_info_rcv.c
@@ -183,14 +183,14 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,
 		   (2 nodes have the same guid) or a 12x link with lane reversal
 		   that is not configured correctly.
 		   We will try to recover by querying NodeInfo again.
-		   In order to catch even fast port moving to new location(s) and
-		   back we will count up to 5.
-		   Some crazy reconnections (newly created switch loop right before
-		   targeted CA) will not be catched this way. So in worst case -
-		   report GUID duplication and request new discovery.
-		   When switch node is targeted NodeInfo querying will be done in
-		   opposite order, this is much stronger check, unfortunately it is
-		   impossible with CAs.
+		   In order to catch even fast port moving to new location(s)
+		   and back we will count up to 5.
+		   Some crazy reconnections (newly created switch loop right
+		   before targeted CA) will not be catched this way. So in worst
+		   case - report GUID duplication and request new discovery.
+		   When switch node is targeted NodeInfo querying will be done
+		   in opposite order, this is much stronger check, unfortunately
+		   it is impossible with CAs.
 		 */
 		p_physp = osm_node_get_physp_ptr(p_node, port_num);
 		if (p_ni_context->dup_count > 5) {
@@ -430,7 +430,7 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
 		}
 
 		/* If we are a master, then this means the port is new on the subnet.
-		   Mark it as new - need to send trap 64 on these ports.
+		   Mark it as new - need to send trap 64 for these ports.
 		   The condition that we are master is true, since if we are in discovering
 		   state (meaning we woke up from standby or we are just initializing),
 		   then these ports may be new to us, but are not new on the subnet.
diff --git a/opensm/opensm/osm_pkey_mgr.c b/opensm/opensm/osm_pkey_mgr.c
index de79e3d..df2cc20 100644
--- a/opensm/opensm/osm_pkey_mgr.c
+++ b/opensm/opensm/osm_pkey_mgr.c
@@ -113,8 +113,8 @@ pkey_mgr_process_physical_port(IN osm_log_t * p_log,
 						   &p_pending->index) !=
 		    IB_SUCCESS) {
 			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0503: "
-				"Failed to obtain P_Key 0x%04x block and index for node "
-				"0x%016" PRIx64 " port %u\n",
+				"Failed to obtain P_Key 0x%04x block and index "
+				"for node 0x%016" PRIx64 " port %u\n",
 				cl_ntoh16(ib_pkey_get_base(pkey)),
 				cl_ntoh64(osm_node_get_node_guid(p_node)),
 				osm_physp_get_port_num(p_physp));
diff --git a/opensm/opensm/osm_pkey_rcv.c b/opensm/opensm/osm_pkey_rcv.c
index 7f41748..b637d11 100644
--- a/opensm/opensm/osm_pkey_rcv.c
+++ b/opensm/opensm/osm_pkey_rcv.c
@@ -88,8 +88,7 @@ void osm_pkey_rcv_process(IN void *context, IN void *data)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4806: "
 			"No port object for port with GUID 0x%" PRIx64
 			"\n\t\t\t\tfor parent node GUID 0x%" PRIx64
-			", TID 0x%" PRIx64 "\n",
-			cl_ntoh64(port_guid),
+			", TID 0x%" PRIx64 "\n", cl_ntoh64(port_guid),
 			cl_ntoh64(node_guid), cl_ntoh64(p_smp->trans_id));
 		goto Exit;
 	}
diff --git a/opensm/opensm/osm_port_info_rcv.c b/opensm/opensm/osm_port_info_rcv.c
index 9babcd2..8a99064 100644
--- a/opensm/opensm/osm_port_info_rcv.c
+++ b/opensm/opensm/osm_port_info_rcv.c
@@ -69,7 +69,7 @@ static void pi_rcv_check_and_fix_lid(osm_log_t * log, ib_port_info_t * pi,
 	if (cl_ntoh16(pi->base_lid) > IB_LID_UCAST_END_HO) {
 		OSM_LOG(log, OSM_LOG_ERROR, "ERR 0F04: "
 			"Got invalid base LID %u from the network. "
-			"Corrected to %u.\n", cl_ntoh16(pi->base_lid),
+			"Corrected to %u\n", cl_ntoh16(pi->base_lid),
 			cl_ntoh16(p->port_info.base_lid));
 		pi->base_lid = p->port_info.base_lid;
 	}
@@ -352,8 +352,8 @@ static void get_pkey_table(IN osm_log_t * p_log, IN osm_sm_t * sm,
 	port_num = p_physp->port_num;
 
 	if (!p_node->sw || port_num == 0)
-		/* The maximum blocks is defined by the node info partition cap for CA,
-		   router, and switch management ports. */
+		/* The maximum blocks is defined by the node info partition cap
+		   for CA, router, and switch management ports. */
 		max_blocks =
 		    (cl_ntoh16(p_node->node_info.partition_cap) +
 		     IB_NUM_PKEY_ELEMENTS_IN_BLOCK - 1)
diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index f1094e3..f953876 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -145,7 +145,8 @@ ib_api_status_t osm_prtn_add_all(osm_log_t * p_log, osm_subn_t * p_subn,
 		p_item = cl_qmap_next(p_item);
 		if (!type || osm_node_get_type(p_port->p_node) == type) {
 			status = osm_prtn_add_port(p_log, p_subn, p,
-						   osm_port_get_guid(p_port), full);
+						   osm_port_get_guid(p_port),
+						   full);
 			if (status != IB_SUCCESS)
 				goto _err;
 		}
diff --git a/opensm/opensm/osm_req.c b/opensm/opensm/osm_req.c
index 462403a..daccc01 100644
--- a/opensm/opensm/osm_req.c
+++ b/opensm/opensm/osm_req.c
@@ -203,8 +203,7 @@ int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
 	osm_madw_t *madw;
 	ib_smp_t *smp;
 	ib_mad_notice_attr_t *ntc;
-	osm_port_t *port;
-	osm_port_t *smport;
+	osm_port_t *port, *smport;
 	ib_port_info_t *pi;
 
 	port = osm_get_port_by_guid(sm->p_subn, sm->p_subn->sm_port_guid);
diff --git a/opensm/opensm/osm_sa_informinfo.c b/opensm/opensm/osm_sa_informinfo.c
index d677170..09934ef 100644
--- a/opensm/opensm/osm_sa_informinfo.c
+++ b/opensm/opensm/osm_sa_informinfo.c
@@ -121,8 +121,8 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 		/* get the destination InformInfo physical port */
 		p_physp = p_port->p_physp;
 
-		/* make sure that the requester and destination port can access each other
-		   according to the current partitioning. */
+		/* make sure that the requester and destination port can access
+		   each other according to the current partitioning. */
 		if (!osm_physp_share_pkey
 		    (sa->p_log, p_physp, p_requester_physp)) {
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
@@ -143,8 +143,8 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 		    cl_ntoh16(p_infr_rec->inform_record.inform_info.
 			      lid_range_end);
 
-		/* lid_range_end is set to zero if no range desired. In this case -
-		   just make it equal to the lid_range_begin. */
+		/* lid_range_end is set to zero if no range desired. In this
+		   case - just make it equal to the lid_range_begin. */
 		if (lid_range_end == 0)
 			lid_range_end = lid_range_begin;
 
@@ -277,8 +277,8 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 
 	/* get the subscriber InformInfo physical port */
 	p_subscriber_physp = p_subscriber_port->p_physp;
-	/* make sure that the requester and subscriber port can access each other
-	   according to the current partitioning. */
+	/* make sure that the requester and subscriber port can access each
+	   other according to the current partitioning. */
 	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_subscriber_physp)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"requester and subscriber ports don't share pkey\n");
@@ -558,8 +558,7 @@ void osm_infr_rcv_process(IN void *context, IN void *data)
 	CL_ASSERT(p_sa_mad->attr_id == IB_MAD_ATTR_INFORM_INFO);
 
 	if (p_sa_mad->method != IB_MAD_METHOD_SET) {
-		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-			"Unsupported Method (%s)\n",
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unsupported Method (%s)\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/opensm/osm_sa_mad_ctrl.c b/opensm/opensm/osm_sa_mad_ctrl.c
index 8f058fd..bde88fa 100644
--- a/opensm/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/opensm/osm_sa_mad_ctrl.c
@@ -102,11 +102,11 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 
 	/*
 	   If the dispatcher is showing us that it is overloaded
-	   there is no point in placing the request in. We should instead provide
-	   immediate response - IB_RESOURCE_BUSY
+	   there is no point in placing the request in. We should instead
+	   provide immediate response - IB_RESOURCE_BUSY
 	   But how do we know?
-	   The dispatcher reports back the number of outstanding messages and the
-	   time the last message stayed in the queue.
+	   The dispatcher reports back the number of outstanding messages and
+	   the time the last message stayed in the queue.
 	   HACK: Actually, we cannot send a mad from within the receive callback;
 	   thus - we will just drop it.
 	 */
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 7103f98..dc9d508 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -643,7 +643,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	}
 
 	/*
-	 * Set PathRecord SL.
+	 * Set PathRecord SL
 	 */
 
 	is_lash = (p_osm->routing_engine_used == OSM_ROUTING_ENGINE_TYPE_LASH);
@@ -967,17 +967,15 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	/*
 	   Refine our search if the client specified end-point LIDs
 	 */
-	if (comp_mask & IB_PR_COMPMASK_DLID) {
-		dest_lid_min_ho = cl_ntoh16(p_pr->dlid);
-		dest_lid_max_ho = cl_ntoh16(p_pr->dlid);
-	} else
+	if (comp_mask & IB_PR_COMPMASK_DLID)
+		dest_lid_max_ho = dest_lid_min_ho = cl_ntoh16(p_pr->dlid);
+	else
 		osm_port_get_lid_range_ho(p_dest_port, &dest_lid_min_ho,
 					  &dest_lid_max_ho);
 
-	if (comp_mask & IB_PR_COMPMASK_SLID) {
-		src_lid_min_ho = cl_ntoh16(p_pr->slid);
-		src_lid_max_ho = cl_ntoh16(p_pr->slid);
-	} else
+	if (comp_mask & IB_PR_COMPMASK_SLID)
+		src_lid_max_ho = src_lid_min_ho = cl_ntoh16(p_pr->slid);
+	else
 		osm_port_get_lid_range_ho(p_src_port, &src_lid_min_ho,
 					  &src_lid_max_ho);
 
@@ -1452,7 +1450,7 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 
 	comp_mask = p_sa_mad->comp_mask;
 
-	/* check that MLID of the MC group matchs the PathRecord DLID */
+	/* check that MLID of the MC group matches the PathRecord DLID */
 	if ((comp_mask & IB_PR_COMPMASK_DLID) && p_mgrp->mlid != p_pr->dlid)
 		goto Exit;
 
diff --git a/opensm/opensm/osm_sminfo_rcv.c b/opensm/opensm/osm_sminfo_rcv.c
index 5753e27..e9394d7 100644
--- a/opensm/opensm/osm_sminfo_rcv.c
+++ b/opensm/opensm/osm_sminfo_rcv.c
@@ -252,7 +252,8 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 	status = osm_sm_state_mgr_check_legality(sm, sm_signal);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F07: "
-			"Failed check of legality of needed SM transition. AttributeModifier:0x%X RemoteState:%s\n",
+			"Failed check of legality of needed SM transition. "
+			"AttributeModifier:0x%X RemoteState:%s\n",
 			p_smp->attr_mod,
 			osm_get_sm_mgr_state_str(ib_sminfo_get_state(sm_smi)));
 		status = osm_resp_send(sm, p_madw, 7, payload);
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 122a8d4..32b162c 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -174,8 +174,8 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
 	mad_context.pi_context.light_sweep = TRUE;
 	mad_context.pi_context.active_transition = FALSE;
 
-	/* note that with some negative logic - if the query failed it means that
-	 * there is no point in going to heavy sweep */
+	/* note that with some negative logic - if the query failed it means
+	 * that there is no point in going to heavy sweep */
 	status = osm_req_get(sm, &rem_node_dr_path,
 			     IB_MAD_ATTR_PORT_INFO, 0, CL_DISP_MSGID_NONE,
 			     &mad_context);
@@ -445,12 +445,12 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 		break;
 
 	case IB_NODE_TYPE_SWITCH:
-		/* Need to go over all the ports of the switch, and send a node_info
-		 * from them. This doesn't include the port 0 of the switch, which
-		 * hosts the SM.
-		 * Note: We'll send another switchInfo on port 0, since if no ports
-		 * are connected, we still want to get some response, and have the
-		 * subnet come up.
+		/* Need to go over all the ports of the switch, and send a
+		 * node_info from them. This doesn't include the port 0 of the
+		 * switch, which hosts the SM.
+		 * Note: We'll send another switchInfo on port 0, since if no
+		 * ports are connected, we still want to get some response, and
+		 * have the subnet come up.
 		 */
 		num_ports = osm_node_get_num_physp(p_node);
 		for (port_num = 1; port_num < num_ports; port_num++) {
@@ -497,6 +497,7 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
 	osm_sm_t *sm = cxt;
 	ib_api_status_t ret;
 
+OSM_LOG(sm->p_log, OSM_LOG_ERROR, "GUID 0x%" PRIx64 "\n", cl_ntoh64(r_sm->p_port->guid));
 	context.smi_context.port_guid = r_sm->p_port->guid;
 	context.smi_context.set_method = FALSE;
 	context.smi_context.light_sweep = TRUE;
@@ -834,7 +835,7 @@ static void state_mgr_report_new_ports(IN osm_sm_t * sm)
 		/* details of the notice */
 		notice.generic_type = 0x83;	/* is generic subn mgt type */
 		ib_notice_set_prod_type_ho(&notice, 4);	/* A Class Manager generator */
-		/* endport becomes to be reachable */
+		/* endport becomes reachable */
 		notice.g_or_v.generic.trap_num = CL_HTON16(64);
 		/* The sm_base_lid is saved in network order already. */
 		notice.issuer_lid = sm->p_subn->sm_base_lid;
@@ -1125,7 +1126,7 @@ static void do_sweep(osm_sm_t * sm)
 	}
 
 	/* go to heavy sweep */
-_repeat_discovery:
+repeat_discovery:
 
 	/* First of all - unset all flags */
 	sm->p_subn->force_heavy_sweep = FALSE;
@@ -1162,7 +1163,7 @@ _repeat_discovery:
 	    wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
 
-	/* discovery completed - check other sm presense */
+	/* discovery completed - check other sm presence */
 	if (sm->master_sm_found) {
 		/*
 		 * Call the sm_state_mgr with signal
@@ -1179,7 +1180,7 @@ _repeat_discovery:
 
 	/* if new sweep requested - don't bother with the rest */
 	if (sm->p_subn->force_heavy_sweep)
-		goto _repeat_discovery;
+		goto repeat_discovery;
 
 	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HEAVY SWEEP COMPLETE");
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
