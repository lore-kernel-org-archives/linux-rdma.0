From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Add client_rereg flag to Port Info context
Date: Fri, 03 Jan 2014 08:40:48 -0500
Message-ID: <52C6BDE0.1040602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of ports that don't set client_rereg in response
the port info context will contain additional client_rereg
flag that will indicate that it was already sent and
therefore it won't be sent in future.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_madw.h  |    1 +
 opensm/osm_lid_mgr.c       |    5 ++++-
 opensm/osm_link_mgr.c      |    1 +
 opensm/osm_node_info_rcv.c |    1 +
 opensm/osm_pkey_mgr.c      |    1 +
 opensm/osm_port_info_rcv.c |    3 ++-
 opensm/osm_state_mgr.c     |    1 +
 opensm/osm_trap_rcv.c      |    1 +
 8 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_madw.h b/include/opensm/osm_madw.h
index fd6ba7f..9fb7d5d 100644
--- a/include/opensm/osm_madw.h
+++ b/include/opensm/osm_madw.h
@@ -182,6 +182,7 @@ typedef struct osm_pi_context {
 	boolean_t set_method;
 	boolean_t light_sweep;
 	boolean_t active_transition;
+	boolean_t client_rereg;
 } osm_pi_context_t;
 /*********/
 
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 3ba1a79..757a9e3 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1043,9 +1043,12 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			"Setting client rereg on %s, port %d\n",
 			p_port->p_node->print_desc, p_port->p_physp->port_num);
 		ib_port_info_set_client_rereg(p_pi, 1);
+		context.pi_context.client_rereg = TRUE;
 		send_set = TRUE;
-	} else
+	} else {
 		ib_port_info_set_client_rereg(p_pi, 0);
+		context.pi_context.client_rereg = FALSE;
+	}
 
 	/* We need to send the PortInfo Set request with the new sm_lid
 	   in the following cases:
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 6bcfbf6..ed19d75 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -451,6 +451,7 @@ Send:
 	context.pi_context.port_guid = osm_physp_get_port_guid(p_physp);
 	context.pi_context.set_method = TRUE;
 	context.pi_context.light_sweep = FALSE;
+	context.pi_context.client_rereg = FALSE;
 
 	/* We need to send the PortInfoSet request with the new sm_lid
 	   in the following cases:
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 786bcde..4242924 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -307,6 +307,7 @@ static void ni_rcv_get_port_info(IN osm_sm_t * sm, IN osm_node_t * node,
 	context.pi_context.set_method = FALSE;
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
+	context.pi_context.client_rereg = FALSE;
 
 	for (; port < num_ports; port++) {
 		status = osm_req_get(sm, osm_physp_get_dr_path_ptr(physp),
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index d9f2d94..0809d1e 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -253,6 +253,7 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	context.pi_context.set_method = TRUE;
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
+	context.pi_context.client_rereg = FALSE;
 
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_physp),
 			     payload, sizeof(payload),
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index a8ac75b..5c12989 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -566,10 +566,12 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 
 	/* On receipt of client reregister, clear the reregister bit so
 	   reregistering won't be sent again and again */
-	if (p_context->set_method && ib_port_info_get_client_rereg(p_pi)) {
+	if (p_context->set_method &&
+	    (ib_port_info_get_client_rereg(p_pi) || p_context->client_rereg)) {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Client reregister received on response\n");
 		ib_port_info_set_client_rereg(p_pi, 0);
+		p_context->client_rereg = FALSE;
 	}
 
 	/*
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 85b233d..c86627d 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -186,6 +186,7 @@ static void state_mgr_get_remote_port_info(IN osm_sm_t * sm,
 	mad_context.pi_context.set_method = FALSE;
 	mad_context.pi_context.light_sweep = TRUE;
 	mad_context.pi_context.active_transition = FALSE;
+	mad_context.pi_context.client_rereg = FALSE;
 
 	/* note that with some negative logic - if the query failed it means
 	 * that there is no point in going to heavy sweep */
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index c2c0ed2..663fa35 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -241,6 +241,7 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	context.pi_context.set_method = TRUE;
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
+	context.pi_context.client_rereg = FALSE;
 	if (osm_node_get_type(p->p_node) == IB_NODE_TYPE_SWITCH &&
 	    osm_physp_get_port_num(p) != 0) {
 		physp0 = osm_node_get_physp_ptr(p->p_node, 0);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
