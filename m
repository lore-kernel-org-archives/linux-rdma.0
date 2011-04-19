From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: In osm_subn_destroy, delete service
 records
Date: Tue, 19 Apr 2011 10:26:41 -0400
Message-ID: <4DAD9BA1.5020705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 61a59e4..84ac6ed 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -70,6 +70,7 @@
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_event_plugin.h>
 #include <opensm/osm_qos_policy.h>
+#include <opensm/osm_service.h>
 
 static const char null_str[] = "(null)";
 
@@ -435,6 +436,7 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 	osm_remote_sm_t *p_rsm, *p_next_rsm;
 	osm_prtn_t *p_prtn, *p_next_prtn;
 	osm_infr_t *p_infr, *p_next_infr;
+	osm_svcr_t *p_svcr, *p_next_svcr;
 
 	/* it might be a good idea to de-allocate all known objects */
 	p_next_node = (osm_node_t *) cl_qmap_head(&p_subn->node_guid_tbl);
@@ -491,6 +493,14 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 		osm_infr_delete(p_infr);
 	}
 
+	p_next_svcr = (osm_svcr_t *) cl_qlist_head(&p_subn->sa_sr_list);
+	while (p_next_svcr !=
+	       (osm_svcr_t *) cl_qlist_end(&p_subn->sa_sr_list)) {
+		p_svcr = p_next_svcr;
+		p_next_svcr = (osm_svcr_t *) cl_qlist_next(&p_svcr->list_item);
+		osm_svcr_delete(p_svcr);
+	}
+
 	cl_ptr_vector_destroy(&p_subn->port_lid_tbl);
 
 	osm_qos_policy_destroy(p_subn->p_qos_policy);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
