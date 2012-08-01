From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_base.h: Add some SA ClassPortInfo CapabilityMask2
 bits
Date: Wed, 01 Aug 2012 09:57:52 -0400
Message-ID: <501935E0.8080206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG RefID #4735: IsMulticastServiceRecordsSupported
Per MgtWG RefID #4858: IsPortInfoCapMask2MatchSupported

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index bedc179..9ae6e9f 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -885,6 +885,28 @@ typedef enum _osm_thread_state {
 #define OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED (1 << 7)
 /***********/
 
+/****d* OpenSM: Base/OSM_CAP2_IS_MULTICAST_SERVICE_RECS_SUPPORTED
+ * Name
+ *	OSM_CAP2_IS_MULTICAST_SERVICE_RECS_SUPPORTED
+ *
+ * DESCRIPTION
+ *	Multicast Service Records supported
+ *
+ * SYNOPSIS
+ */
+#define OSM_CAP2_IS_MULTICAST_SERVICE_RECS_SUPPORTED (1 << 8)
+
+/****d* OpenSM: Base/OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED
+ * Name
+ *	OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED
+ *
+ * DESCRIPTION
+ *	CapMask2 matching for PortInfoRecord supported
+ *
+ * SYNOPSIS
+ */
+#define OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED (1 << 9)
+
 /****d* OpenSM: Base/osm_signal_t
 * NAME
 *	osm_signal_t
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
