From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm: Cosmetic changes
Date: Tue, 20 Oct 2009 09:35:20 -0400
Message-ID: <20091020133520.GA5440@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove some unneeded osm_ prefixes`
Also, some other cosmetic formatting changes

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_node.c b/opensm/opensm/osm_node.c
index d7a6e9d..bc42ff2 100644
--- a/opensm/opensm/osm_node.c
+++ b/opensm/opensm/osm_node.c
@@ -127,7 +127,7 @@ osm_node_t *osm_node_new(IN const osm_madw_t * p_madw)
 
 /**********************************************************************
  **********************************************************************/
-static void osm_node_destroy(IN osm_node_t * p_node)
+static void node_destroy(IN osm_node_t * p_node)
 {
 	uint16_t i;
 
@@ -148,7 +148,7 @@ static void osm_node_destroy(IN osm_node_t * p_node)
 void osm_node_delete(IN OUT osm_node_t ** p_node)
 {
 	CL_ASSERT(p_node && *p_node);
-	osm_node_destroy(*p_node);
+	node_destroy(*p_node);
 	free(*p_node);
 	*p_node = NULL;
 }
diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index 1821397..ebf6439 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -312,9 +312,8 @@ osm_prtn_t *osm_prtn_make_new(osm_log_t * p_log, osm_subn_t * p_subn,
 	return p;
 }
 
-static ib_api_status_t osm_prtn_make_default(osm_log_t * p_log,
-					     osm_subn_t * p_subn,
-					     boolean_t no_config)
+static ib_api_status_t prtn_make_default(osm_log_t * p_log, osm_subn_t * p_subn,
+					 boolean_t no_config)
 {
 	ib_api_status_t status = IB_UNKNOWN_ERROR;
 	osm_prtn_t *p;
@@ -362,7 +361,7 @@ ib_api_status_t osm_prtn_make_partitions(osm_log_t * p_log, osm_subn_t * p_subn)
 
 	global_pkey_counter = 0;
 
-	status = osm_prtn_make_default(p_log, p_subn, !is_config);
+	status = prtn_make_default(p_log, p_subn, !is_config);
 	if (status != IB_SUCCESS)
 		goto _err;
 
diff --git a/opensm/opensm/osm_resp.c b/opensm/opensm/osm_resp.c
index 1e3a474..3241f57 100644
--- a/opensm/opensm/osm_resp.c
+++ b/opensm/opensm/osm_resp.c
@@ -58,11 +58,10 @@
 
 /**********************************************************************
  **********************************************************************/
-static void osm_resp_make_resp_smp(IN osm_sm_t * sm,
-				   IN const ib_smp_t * p_src_smp,
-				   IN ib_net16_t status,
-				   IN const uint8_t * p_payload,
-				   OUT ib_smp_t * p_dest_smp)
+static void resp_make_resp_smp(IN osm_sm_t * sm, IN const ib_smp_t * p_src_smp,
+			       IN ib_net16_t status,
+			       IN const uint8_t * p_payload,
+			       OUT ib_smp_t * p_dest_smp)
 {
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -133,7 +132,7 @@ ib_api_status_t osm_resp_send(IN osm_sm_t * sm,
 	 */
 	p_smp = osm_madw_get_smp_ptr(p_madw);
 	p_req_smp = osm_madw_get_smp_ptr(p_req_madw);
-	osm_resp_make_resp_smp(sm, p_req_smp, mad_status, p_payload, p_smp);
+	resp_make_resp_smp(sm, p_req_smp, mad_status, p_payload, p_smp);
 	p_madw->mad_addr.dest_lid =
 	    p_req_madw->mad_addr.addr_type.smi.source_lid;
 	p_madw->mad_addr.addr_type.smi.source_lid =
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 4035657..77d8707 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1368,8 +1368,8 @@ _repeat_discovery:
 
 	/* if we got a signal to force heavy sweep or errors
 	 * in the middle of the sweep - try another sweep. */
-	if (sm->p_subn->force_heavy_sweep
-	    || sm->p_subn->subnet_initialization_error)
+	if (sm->p_subn->force_heavy_sweep ||
+	    sm->p_subn->subnet_initialization_error)
 		osm_sm_signal(sm, OSM_SIGNAL_SWEEP);
 }
 
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 712d87a..8976b5f 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -839,7 +839,7 @@ static ib_api_status_t append_prefix_route(IN osm_subn_t * p_subn,
 	return IB_SUCCESS;
 }
 
-static ib_api_status_t osm_parse_prefix_routes_file(IN osm_subn_t * p_subn)
+static ib_api_status_t parse_prefix_routes_file(IN osm_subn_t * p_subn)
 {
 	osm_log_t *log = &p_subn->p_osm->log;
 	FILE *fp;
@@ -1263,7 +1263,7 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
 
 	osm_subn_verify_config(p_opts);
 
-	osm_parse_prefix_routes_file(p_subn);
+	parse_prefix_routes_file(p_subn);
 
 	return 0;
 }
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index 67e3ede..b05987a 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -171,10 +171,10 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
 /**********************************************************************
  **********************************************************************/
 static struct osm_remote_node *
-osm_switch_find_guid_common(IN const osm_switch_t * p_sw,
-			    IN struct osm_remote_guids_count *r,
-			    IN uint8_t port_num,
-			    IN int find_sys_guid, IN int find_node_guid)
+switch_find_guid_common(IN const osm_switch_t * p_sw,
+			IN struct osm_remote_guids_count *r,
+			IN uint8_t port_num, IN int find_sys_guid,
+			IN int find_node_guid)
 {
 	struct osm_remote_node *p_remote_guid = NULL;
 	osm_physp_t *p_physp;
@@ -206,19 +206,19 @@ osm_switch_find_guid_common(IN const osm_switch_t * p_sw,
 }
 
 static struct osm_remote_node *
-osm_switch_find_sys_guid_count(IN const osm_switch_t * p_sw,
-			       IN struct osm_remote_guids_count *r,
-			       IN uint8_t port_num)
+switch_find_sys_guid_count(IN const osm_switch_t * p_sw,
+			   IN struct osm_remote_guids_count *r,
+			   IN uint8_t port_num)
 {
-	return osm_switch_find_guid_common(p_sw, r, port_num, 1, 0);
+	return switch_find_guid_common(p_sw, r, port_num, 1, 0);
 }
 
 static struct osm_remote_node *
-osm_switch_find_node_guid_count(IN const osm_switch_t * p_sw,
-				IN struct osm_remote_guids_count *r,
-				IN uint8_t port_num)
+switch_find_node_guid_count(IN const osm_switch_t * p_sw,
+			    IN struct osm_remote_guids_count *r,
+			    IN uint8_t port_num)
 {
-	return osm_switch_find_guid_common(p_sw, r, port_num, 0, 1);
+	return switch_find_guid_common(p_sw, r, port_num, 0, 1);
 }
 
 /**********************************************************************
@@ -411,9 +411,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 		 */
 		} else if (routing_for_lmc) {
 			/* Is the sys guid already used ? */
-			p_remote_guid = osm_switch_find_sys_guid_count(p_sw,
-								       p_port->priv,
-								       port_num);
+			p_remote_guid = switch_find_sys_guid_count(p_sw,
+								   p_port->priv,
+								   port_num);
 
 			/* If not update the least hops for this case */
 			if (!p_remote_guid) {
@@ -424,9 +424,9 @@ uint8_t osm_switch_recommend_path(IN const osm_switch_t * p_sw,
 				}
 			} else {	/* same sys found - try node */
 				/* Else is the node guid already used ? */
-				p_remote_guid = osm_switch_find_node_guid_count(p_sw,
-										p_port->priv,
-										port_num);
+				p_remote_guid = switch_find_node_guid_count(p_sw,
+									    p_port->priv,
+									    port_num);
 
 				/* If not update the least hops for this case */
 				if (!p_remote_guid
@@ -507,7 +507,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
 		p_sw->lft = new_lft;
 		p_sw->lft_size = lft_size;
 	}
-
 	return 0;
 }
 
@@ -548,7 +547,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN uint16_t max_lids
 		p_sw->num_hops = max_lids + 1;
 	}
 	p_sw->max_lid_ho = max_lids;
-
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
