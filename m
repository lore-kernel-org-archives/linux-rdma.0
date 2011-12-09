From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_sa_class_port_info.c: Conditionalize setting
 of OSM_CAP2_IS_MCAST_TOP_SUPPORTED
Date: Fri, 09 Dec 2011 08:06:38 -0500
Message-ID: <4EE207DE.7060907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Only set IsMulticastFDBTop SA CapabilityMask2 bit if option is enabled

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 64e3f33..41e7447 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -157,9 +157,10 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 	p_resp_cpi->cap_mask = OSM_CAP_IS_SUBN_GET_SET_NOTICE_SUP |
 	    OSM_CAP_IS_PORT_INFO_CAPMASK_MATCH_SUPPORTED;
 #endif
-	cap_mask2 = OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
-		    OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED |
+	cap_mask2 = OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED |
 		    OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED;
+	if (sa->p_subn->opt.use_mfttop)
+		cap_mask2 |= OSM_CAP2_IS_MCAST_TOP_SUPPORTED;
 	if (sa->p_subn->opt.qos)
 		cap_mask2 |= OSM_CAP2_IS_QOS_SUPPORTED;
 	ib_class_set_cap_mask2(p_resp_cpi, cap_mask2);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
