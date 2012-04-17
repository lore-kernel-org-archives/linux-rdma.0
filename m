From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm: Add additional IBM vendor ID/OUI
Date: Tue, 17 Apr 2012 07:49:41 -0400
Message-ID: <4F8D58D5.9060809@dev.mellanox.co.il>
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
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index de78f67..bedc179 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -984,6 +984,7 @@ typedef enum _osm_sm_signal {
 #define OSM_VENDOR_ID_HP3           0x0019BB
 #define OSM_VENDOR_ID_HP4           0x00237D
 #define OSM_VENDOR_ID_OPENIB        0x001405
+#define OSM_VENDOR_ID_IBM2	    0x5CF3FC
 
 /* IPoIB Broadcast Defaults */
 #define OSM_IPOIB_BROADCAST_MGRP_QKEY 0x0b1b
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index b97c8f2..2be9061 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2218,6 +2218,7 @@ const char *osm_get_manufacturer_str(IN uint64_t guid_ho)
 	case OSM_VENDOR_ID_PATHSCALE:
 		return pathscale_str;
 	case OSM_VENDOR_ID_IBM:
+	case OSM_VENDOR_ID_IBM2:
 		return ibm_str;
 	case OSM_VENDOR_ID_DIVERGENET:
 		return divergenet_str;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
