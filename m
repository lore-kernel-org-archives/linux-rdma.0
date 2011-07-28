From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_class_port_info.c: Minor simplification to
 setting CapabilityMask2
Date: Thu, 28 Jul 2011 09:59:10 -0400
Message-ID: <4E316B2E.9000003@dev.mellanox.co.il>
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
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 743258d..a5d17a8 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -73,6 +73,7 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 	ib_sa_mad_t *p_resp_sa_mad;
 	ib_class_port_info_t *p_resp_cpi;
 	ib_gid_t zero_gid;
+	uint32_t cap_mask2;
 	uint8_t rtv;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -156,13 +157,11 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 	p_resp_cpi->cap_mask = OSM_CAP_IS_SUBN_GET_SET_NOTICE_SUP |
 	    OSM_CAP_IS_PORT_INFO_CAPMASK_MATCH_SUPPORTED;
 #endif
+	cap_mask2 = OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
+		    OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED;
 	if (sa->p_subn->opt.qos)
-		ib_class_set_cap_mask2(p_resp_cpi, OSM_CAP2_IS_QOS_SUPPORTED |
-						   OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
-						   OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED);
-	else
-		ib_class_set_cap_mask2(p_resp_cpi, OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
-						   OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED);
+		cap_mask2 |= OSM_CAP2_IS_QOS_SUPPORTED;
+	ib_class_set_cap_mask2(p_resp_cpi, cap_mask2);
 
 	if (!sa->p_subn->opt.disable_multicast)
 		p_resp_cpi->cap_mask |= OSM_CAP_IS_UD_MCAST_SUP;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
