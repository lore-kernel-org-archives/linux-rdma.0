From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/8] opensm: Allow recovery of subnets with misset mkeys
Date: Mon, 25 Jun 2012 17:54:58 -0700
Message-ID: <1340672104-18039-2-git-send-email-foraker1@llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672104-18039-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the initialization of endpoints that already have an mkey
configured that is different than that listed in the configuration
file.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_req.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 95 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 640334a..ee13517 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -59,7 +59,88 @@
 #include <opensm/osm_db_pack.h>
 
 /**********************************************************************
-  The plock MAY or MAY NOT be held before calling this function.
+  The plock must be held before calling this function.
+**********************************************************************/
+static ib_net64_t req_determine_mkey(IN osm_sm_t * sm,
+				     IN const osm_dr_path_t * p_path)
+{
+	osm_node_t *p_node;
+	osm_port_t *p_sm_port;
+	osm_physp_t *p_physp;
+	ib_net64_t dest_port_guid, m_key;
+	uint8_t hop;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	p_physp = NULL;
+
+	p_sm_port = osm_get_port_by_guid(sm->p_subn, sm->p_subn->sm_port_guid);
+
+	/* hop_count == 0: destination port guid is SM */
+	if (p_path->hop_count == 0) {
+		if (p_sm_port != NULL)
+			dest_port_guid = sm->p_subn->sm_port_guid;
+		else
+			dest_port_guid = sm->p_subn->opt.guid;
+		goto Remote_Guid;
+	}
+
+	if (p_sm_port) {
+		p_physp = p_sm_port->p_physp;
+	}
+
+	/* hop_count == 1: outgoing physp is SM physp */
+	for (hop = 2; p_physp && hop <= p_path->hop_count; hop++) {
+		p_physp = p_physp->p_remote_physp;
+		if (!p_physp) {
+			break;
+		}
+		p_node = p_physp->p_node;
+		p_physp = osm_node_get_physp_ptr(p_node, p_path->path[hop]);
+	}
+
+	/* At this point, p_physp points at the outgoing physp on the
+	   last hop, or NULL if we don't know it.
+	*/
+	if (!p_physp) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
+			"req_determine_mkey: ERR 1107: "
+			"Outgoing physp is null on non-hop_0!\n");
+		dest_port_guid = 0;
+		goto Remote_Guid;
+	}
+	
+	if (p_physp->p_remote_physp) {
+		dest_port_guid = p_physp->p_remote_physp->port_guid;
+		goto Remote_Guid;
+	}
+
+Remote_Guid:
+	if (dest_port_guid) {
+		if (!osm_db_guid2mkey_get(sm->p_subn->p_g2m,
+					  cl_ntoh64(dest_port_guid), &m_key)) {
+			m_key = cl_hton64(m_key);
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+				"Found mkey for guid 0x%"
+				PRIx64 "\n", cl_ntoh64(dest_port_guid));
+		} else {
+			OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+				"Target port mkey unknown, using default\n");
+			m_key = sm->p_subn->opt.m_key;
+		}
+	} else {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"Target port guid unknown, using default\n");
+		m_key = sm->p_subn->opt.m_key;
+	}
+
+	OSM_LOG_EXIT(sm->p_log);
+
+	return m_key;
+}
+
+/**********************************************************************
+  The plock must be held before calling this function.
 **********************************************************************/
 ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 			    IN ib_net16_t attr_id, IN ib_net32_t attr_mod,
@@ -69,6 +150,7 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_net64_t tid;
+	ib_net64_t m_key;
 
 	CL_ASSERT(sm);
 
@@ -93,15 +175,17 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 	}
 
 	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
+	m_key = req_determine_mkey(sm, p_path);
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
-		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
+		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64
+                ", MKey 0x%016" PRIx64 "\n",
 		ib_get_sm_attr_str(attr_id), cl_ntoh16(attr_id),
-		cl_ntoh32(attr_mod), cl_ntoh64(tid));
+		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key));
 
 	ib_smp_init_new(osm_madw_get_smp_ptr(p_madw), IB_MAD_METHOD_GET,
 			tid, attr_id, attr_mod, p_path->hop_count,
-			sm->p_subn->opt.m_key, p_path->path,
+			m_key, p_path->path,
 			IB_LID_PERMISSIVE, IB_LID_PERMISSIVE);
 
 	p_madw->mad_addr.dest_lid = IB_LID_PERMISSIVE;
@@ -126,7 +210,7 @@ Exit:
 }
 
 /**********************************************************************
-  The plock MAY or MAY NOT be held before calling this function.
+  The plock must be held before calling this function.
 **********************************************************************/
 ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 			    IN const uint8_t * p_payload,
@@ -138,6 +222,7 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 	osm_madw_t *p_madw;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_net64_t tid;
+	ib_net64_t m_key;
 
 	CL_ASSERT(sm);
 
@@ -163,15 +248,17 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 	}
 
 	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
+	m_key = req_determine_mkey(sm, p_path);
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
-		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
+		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 
+                ", MKey 0x%016" PRIx64 "\n",
 		ib_get_sm_attr_str(attr_id), cl_ntoh16(attr_id),
-		cl_ntoh32(attr_mod), cl_ntoh64(tid));
+		cl_ntoh32(attr_mod), cl_ntoh64(tid), cl_ntoh64(m_key));
 
 	ib_smp_init_new(osm_madw_get_smp_ptr(p_madw), IB_MAD_METHOD_SET,
 			tid, attr_id, attr_mod, p_path->hop_count,
-			sm->p_subn->opt.m_key, p_path->path,
+			m_key, p_path->path,
 			IB_LID_PERMISSIVE, IB_LID_PERMISSIVE);
 
 	p_madw->mad_addr.dest_lid = IB_LID_PERMISSIVE;
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
