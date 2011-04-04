From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Add OSM_VENDOR_ID_OPENIB support
Date: Mon, 04 Apr 2011 14:46:51 -0400
Message-ID: <4D9A121B.3080009@dev.mellanox.co.il>
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
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index fa4c78d..3735610 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -917,6 +917,7 @@ typedef enum _osm_sm_signal {
 #define OSM_VENDOR_ID_SUPERMICRO    0x003048
 #define OSM_VENDOR_ID_HP3           0x0019BB
 #define OSM_VENDOR_ID_HP4           0x00237D
+#define OSM_VENDOR_ID_OPENIB        0x001405

 /**********/

diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 2597e50..0d8311b 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2095,6 +2095,7 @@ const char *osm_get_manufacturer_str(IN uint64_t
guid_ho)
 	static const char *xsigo_str = "Xsigo";
 	static const char *dell_str = "Dell";
 	static const char *supermicro_str = "SuperMicro";
+	static const char *openib_str = "OpenIB";
 	static const char *unknown_str = "Unknown";

 	switch ((uint32_t) (guid_ho >> (5 * 8))) {
@@ -2153,6 +2154,8 @@ const char *osm_get_manufacturer_str(IN uint64_t
guid_ho)
 		return dell_str;
 	case OSM_VENDOR_ID_SUPERMICRO:
 		return supermicro_str;
+	case OSM_VENDOR_ID_OPENIB:
+		return openib_str;
 	default:
 		return unknown_str;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
