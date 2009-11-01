From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: Improvements in log_trap_info()
Date: Sun, 1 Nov 2009 18:36:59 +0200
Message-ID: <20091101163659.GI29434@me>
References: <20091031122501.GA24260@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091031122501.GA24260-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In log_trap_info() return when log level is not requested, merge generic
notice logging code.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_trap_rcv.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index c6fe9e9..a414f55 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -278,34 +278,30 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			  ib_net16_t source_lid, ib_net64_t trans_id)
 {
+	if (!osm_log_is_active(p_log, OSM_LOG_ERROR))
+		return;
+
 	if (ib_notice_is_generic(p_ntci)) {
+		char str[32];
+
 		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(129)) ||
 		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(130)) ||
 		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(131)))
-			OSM_LOG(p_log, OSM_LOG_ERROR,
-				"Received Generic Notice type:%u "
-				"num:%u (%s) Producer:%u (%s) "
-				"from LID:%u Port %d TID:0x%016" PRIx64 "\n",
-				ib_notice_get_type(p_ntci),
-				cl_ntoh16(p_ntci->g_or_v.generic.trap_num),
-				ib_get_trap_str(p_ntci->g_or_v.generic.trap_num),
-				cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
-				ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
-				cl_hton16(source_lid),
-				p_ntci->data_details.ntc_129_131.port_num,
-				cl_ntoh64(trans_id));
+			snprintf(str, sizeof(str), " Port %u",
+				 p_ntci->data_details.ntc_129_131.port_num);
 		else
-			OSM_LOG(p_log, OSM_LOG_ERROR,
-				"Received Generic Notice type:%u "
-				"num:%u (%s) Producer:%u (%s) "
-				"from LID:%u TID:0x%016" PRIx64 "\n",
-				ib_notice_get_type(p_ntci),
-				cl_ntoh16(p_ntci->g_or_v.generic.trap_num),
-				ib_get_trap_str(p_ntci->g_or_v.generic.trap_num),
-				cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
-				ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
-				cl_hton16(source_lid),
-				cl_ntoh64(trans_id));
+			str[0] = '\0';
+
+		OSM_LOG(p_log, OSM_LOG_ERROR,
+			"Received Generic Notice type:%u "
+			"num:%u (%s) Producer:%u (%s) "
+			"from LID:%u%s TID:0x%016" PRIx64 "\n",
+			ib_notice_get_type(p_ntci),
+			cl_ntoh16(p_ntci->g_or_v.generic.trap_num),
+			ib_get_trap_str(p_ntci->g_or_v.generic.trap_num),
+			cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
+			ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
+			cl_hton16(source_lid), str, cl_ntoh64(trans_id));
 	} else
 		OSM_LOG(p_log, OSM_LOG_ERROR,
 			"Received Vendor Notice type:%u vend:0x%06X "
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
