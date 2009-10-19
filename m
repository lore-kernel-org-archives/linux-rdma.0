From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS rather
	than UMAD_CA_MAX_AGENTS
Date: Mon, 19 Oct 2009 11:38:46 -0400
Message-ID: <20091019153846.GA22111@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/vendor/osm_vendor_ibumad.h b/opensm/include/vendor/osm_vendor_ibumad.h
index e346a2e..f3a48e5 100644
--- a/opensm/include/vendor/osm_vendor_ibumad.h
+++ b/opensm/include/vendor/osm_vendor_ibumad.h
@@ -66,6 +66,8 @@ BEGIN_C_DECLS
 #define OSM_DEFAULT_RETRY_COUNT 3
 #define OSM_UMAD_MAX_CAS	32
 #define OSM_UMAD_MAX_PORTS_PER_CA	2
+#define OSM_UMAD_MAX_AGENTS	32
+
 /****s* OpenSM: Vendor UMAD/osm_ca_info_t
 * NAME
 *   osm_ca_info_t
@@ -154,7 +156,7 @@ typedef struct _osm_vendor {
 	osm_ca_info_t *p_ca_info;
 	uint32_t timeout;
 	int max_retries;
-	osm_bind_handle_t agents[UMAD_CA_MAX_AGENTS];
+	osm_bind_handle_t agents[OSM_UMAD_MAX_AGENTS];
 	char ca_names[OSM_UMAD_MAX_CAS][UMAD_CA_NAME_LEN];
 	vendor_match_tbl_t mtbl;
 	umad_port_t umad_port;
diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index 8d3c680..b221335 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -288,7 +288,7 @@ static void *umad_receiver(void *p_ptr)
 			}
 		}
 
-		if (mad_agent >= UMAD_CA_MAX_AGENTS ||
+		if (mad_agent >= OSM_UMAD_MAX_AGENTS ||
 		    !(p_bind = p_vend->agents[mad_agent])) {
 			OSM_LOG(p_ur->p_log, OSM_LOG_ERROR, "ERR 5407: "
 				"invalid mad agent %d - dropping\n", mad_agent);
@@ -738,7 +738,7 @@ static void osm_vendor_close_port(osm_vendor_t * const p_vend)
 	}
 
 	if (p_vend->umad_port_id >= 0) {
-		for (i = 0; i < UMAD_CA_MAX_AGENTS; i++)
+		for (i = 0; i < OSM_UMAD_MAX_AGENTS; i++)
 			if (p_vend->agents[i])
 				umad_unregister(p_vend->umad_port_id, i);
 		umad_close_port(p_vend->umad_port_id);
@@ -862,7 +862,7 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
 		goto Exit;
 	}
 
-	if (p_bind->agent_id >= UMAD_CA_MAX_AGENTS ||
+	if (p_bind->agent_id >= OSM_UMAD_MAX_AGENTS ||
 	    p_vend->agents[p_bind->agent_id]) {
 		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5427: "
 			"bad agent id %u or duplicate agent for class %u vers %u\n",
@@ -890,7 +890,7 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
 			goto Exit;
 		}
 
-		if (p_bind->agent_id1 >= UMAD_CA_MAX_AGENTS ||
+		if (p_bind->agent_id1 >= OSM_UMAD_MAX_AGENTS ||
 		    p_vend->agents[p_bind->agent_id1]) {
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5429: "
 				"bad agent id %u or duplicate agent for class 1 vers %u\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
