From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH v2] opensm/osmeventplugin: Added new event for plugin reporting
 duplicated guid
Date: Sun, 06 Jun 2010 10:14:01 +0300
Message-ID: <4C0B4AB9.8010004@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When OSM encounters duplicated guid in fabric,
event is sent to EPI.

Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_event_plugin.h |    1 +
 opensm/opensm/osm_node_info_rcv.c        |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
index 33d1920..7c4ed93 100644
--- a/opensm/include/opensm/osm_event_plugin.h
+++ b/opensm/include/opensm/osm_event_plugin.h
@@ -72,6 +72,7 @@ typedef enum {
 	OSM_EVENT_ID_PORT_SELECT,
 	OSM_EVENT_ID_TRAP,
 	OSM_EVENT_ID_SUBNET_UP,
+	OSM_EVENT_ID_DUPLICATED_GUID,
 	OSM_EVENT_ID_MAX
 } osm_epi_event_id_t;
 
diff --git a/opensm/opensm/osm_node_info_rcv.c b/opensm/opensm/osm_node_info_rcv.c
index b3e272c..1f7e010 100644
--- a/opensm/opensm/osm_node_info_rcv.c
+++ b/opensm/opensm/osm_node_info_rcv.c
@@ -68,6 +68,7 @@ static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 {
 	osm_physp_t *p_old, *p_new;
 	osm_dr_path_t path;
+	osm_epi_port_id_t epi_pe_data;
 
 	p_old = p_physp->p_remote_physp;
 	p_new = osm_node_get_physp_ptr(p_neighbor_node, port_num);
@@ -82,6 +83,11 @@ static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 		cl_ntoh64(p_old->p_node->node_info.node_guid), p_old->port_num,
 		cl_ntoh64(p_new->p_node->node_info.node_guid), p_new->port_num);
 
+	osm_epi_create_port_id(&epi_pe_data,
+		p_physp->p_node->node_info.node_guid, p_physp->port_num,
+		(char*)p_physp->p_node->node_desc.description);
+	osm_opensm_report_event(sm->p_subn->p_osm,
+		OSM_EVENT_ID_DUPLICATED_GUID, &epi_pe_data);
 	osm_dump_dr_path(sm->p_log, osm_physp_get_dr_path_ptr(p_physp),
 			 OSM_LOG_ERROR);
 
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
