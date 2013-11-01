From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Fix possible use of lid 0 when sending set PortInfo
 after failure of the first PortInfo set
Date: Fri, 01 Nov 2013 09:17:57 -0400
Message-ID: <5273AA05.8090409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jim Mott <jim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 8e34b84..f1edcf9 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1166,6 +1166,7 @@ typedef struct osm_port {
 	unsigned int cc_timeout_count;
 	int cc_unavailable_flag;
 	void *priv;
+	ib_net16_t lid;
 } osm_port_t;
 /*
 * FIELDS
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index ae8d234..99080d7 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -879,6 +879,7 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 		   sizeof(p_pi->subnet_prefix)))
 		send_set = TRUE;
 
+	p_port->lid = lid;
 	p_pi->base_lid = lid;
 	if (memcmp(&p_pi->base_lid, &p_old_pi->base_lid,
 		   sizeof(p_pi->base_lid)))
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index e0f0fff..2420e4f 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -107,6 +107,7 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 	ib_net32_t attr_mod, cap_mask;
 	boolean_t update_mkey = FALSE;
 	ib_net64_t m_key = 0;
+	osm_port_t *p_port;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -116,6 +117,24 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 
 	port_num = osm_physp_get_port_num(p_physp);
 
+	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
+
+	if (osm_node_get_type(p_node) != IB_NODE_TYPE_SWITCH ||
+	    port_num == 0) {
+		/* Need to make sure LID and SMLID fields in PortInfo are not 0 */
+		if (!p_pi->base_lid) {
+			p_port = osm_get_port_by_guid(sm->p_subn,
+						      osm_physp_get_port_guid(p_physp));
+			p_pi->base_lid = p_port->lid;
+			send_set = TRUE;
+		}
+
+		/* we are initializing the ports with our local sm_base_lid */
+		p_pi->master_sm_base_lid = sm->p_subn->sm_base_lid;
+		if (p_pi->master_sm_base_lid != p_old_pi->master_sm_base_lid)
+			send_set = TRUE;
+	}
+
 	if (port_num == 0) {
 		/*
 		   CAs don't have a port 0, and for switch port 0,
@@ -143,7 +162,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 					PRIx64 "\n", smsl,
 					cl_ntoh64(osm_physp_get_port_guid
 						  (p_physp)));
-			} else {
+			/* Enter if base lid and master_sm_lid didn't change */
+			} else if (send_set == FALSE) {
 				/* This means the switch doesn't support
 				   enhanced port 0 and we don't need to
 				   change SMSL. Can skip it. */
@@ -158,8 +178,6 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 			esp0 = TRUE;
 	}
 
-	memcpy(payload, p_old_pi, sizeof(ib_port_info_t));
-
 	/*
 	   Should never write back a value that is bigger then 3 in
 	   the PortPhysicalState field - so can not simply copy!
@@ -208,18 +226,6 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 				   sizeof(p_pi->subnet_prefix)))
 				send_set = TRUE;
 
-			p_pi->base_lid = osm_physp_get_base_lid(p_physp);
-			if (memcmp(&p_pi->base_lid, &p_old_pi->base_lid,
-				   sizeof(p_pi->base_lid)))
-				send_set = TRUE;
-
-			/* we are initializing the ports with our local sm_base_lid */
-			p_pi->master_sm_base_lid = sm->p_subn->sm_base_lid;
-			if (memcmp(&p_pi->master_sm_base_lid,
-				   &p_old_pi->master_sm_base_lid,
-				   sizeof(p_pi->master_sm_base_lid)))
-				send_set = TRUE;
-
 			smsl = link_mgr_get_smsl(sm, p_physp);
 			if (smsl != ib_port_info_get_master_smsl(p_old_pi)) {
 
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 9b1d271..bfeb203 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -217,6 +217,7 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	osm_madw_context_t context;
 	ib_port_info_t *pi = (ib_port_info_t *)payload;
 	osm_physp_t *physp0;
+	osm_port_t *p_port;
 	ib_net64_t m_key;
 	ib_api_status_t status;
 
@@ -247,6 +248,15 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	} else
 		m_key = ib_port_info_get_m_key(&p->port_info);
 
+	if (osm_node_get_type(p->p_node) != IB_NODE_TYPE_SWITCH) {
+		if (!pi->base_lid) {
+			p_port = osm_get_port_by_guid(sm->p_subn,
+						      osm_physp_get_port_guid(p));
+			pi->base_lid = p_port->lid;
+		}
+		pi->master_sm_base_lid = sm->p_subn->sm_base_lid;
+	}
+
 	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
 			   payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
