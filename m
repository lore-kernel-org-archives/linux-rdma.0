From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] Add Per Module Logging support for Congestion Manager
Date: Fri, 09 Nov 2012 08:36:46 -0500
Message-ID: <509D06EE.4070507@dev.mellanox.co.il>
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
diff --git a/include/opensm/osm_file_ids.h b/include/opensm/osm_file_ids.h
index 713a0f9..e23710c 100644
--- a/include/opensm/osm_file_ids.h
+++ b/include/opensm/osm_file_ids.h
@@ -149,6 +149,7 @@ typedef enum _osm_file_ids_enum {
 	OSM_FILE_VL_ARB_RCV_C,
 	OSM_FILE_ST_C,
 	OSM_FILE_UCAST_DFSSSP_C,
+	OSM_FILE_CONGESTION_CONTROL_C,
 } osm_file_ids_enum;
 /***********/
 
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index b9a491b..0056049 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -184,9 +184,10 @@ static const char *module_name_str[] = {
 	"osm_vl_arb_rcv.c",
 	"st.c",
 	"osm_ucast_dfsssp.c",
+	"osm_congestion_control.c",
 	/* Add new module names here ... */
 	/* FILE_ID define in those modules must be identical to index here */
-	/* last FILE_ID is currently 88 */
+	/* last FILE_ID is currently 89 */
 };
 
 #define MOD_NAME_STR_UNKNOWN_VAL (ARR_SIZE(module_name_str))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
