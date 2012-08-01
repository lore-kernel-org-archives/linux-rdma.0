From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_sa_class_port_info.c: Indicate support for
 PortInfo CapMask2 matching in SA ClassPortInfo:CapabilityMask2
Date: Wed, 01 Aug 2012 09:58:04 -0400
Message-ID: <501935EC.5090108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG RefID #4858

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 8027ebc..31271b3 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -161,7 +161,8 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 #endif
 	cap_mask2 = OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED |
 		    OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED |
-		    OSM_CAP2_IS_ALIAS_GUIDS_SUPPORTED;
+		    OSM_CAP2_IS_ALIAS_GUIDS_SUPPORTED |
+		    OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED;
 	if (sa->p_subn->opt.use_mfttop)
 		cap_mask2 |= OSM_CAP2_IS_MCAST_TOP_SUPPORTED;
 	if (sa->p_subn->opt.qos)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
