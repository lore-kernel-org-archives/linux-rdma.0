From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_vendor_ibumad.c: Add management class to
 error log message
Date: Thu, 09 Aug 2012 02:27:51 -0400
Message-ID: <50235867.1080308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index d9ed13a..b068443 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -133,6 +133,7 @@ static void clear_madw(osm_vendor_t * p_vend)
 {
 	umad_match_t *m, *e, *old_m;
 	ib_net64_t old_tid;
+	uint8_t old_mgmt_class;
 
 	OSM_LOG_ENTER(p_vend->p_log);
 	pthread_mutex_lock(&p_vend->match_tbl_mutex);
@@ -140,14 +141,16 @@ static void clear_madw(osm_vendor_t * p_vend)
 		if (m->tid) {
 			old_m = m;
 			old_tid = m->tid;
+			old_mgmt_class = m->mgmt_class;
 			m->tid = 0;
 			osm_mad_pool_put(((osm_umad_bind_info_t
 					   *) ((osm_madw_t *) m->v)->h_bind)->
 					 p_mad_pool, m->v);
 			pthread_mutex_unlock(&p_vend->match_tbl_mutex);
 			OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5401: "
-				"evicting entry %p (tid was 0x%" PRIx64 ")\n",
-				old_m, cl_ntoh64(old_tid));
+				"evicting entry %p (tid was 0x%" PRIx64
+				" mgmt class 0x%x)\n",
+				old_m, cl_ntoh64(old_tid), old_mgmt_class);
 			goto Exit;
 		}
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
