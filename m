From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/2] opensm: Add support for multicast service records
Date: Wed, 01 Aug 2012 11:29:12 -0400
Message-ID: <50194B48.30105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG RefIDs #4735 and #4737

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 31271b3..2682505 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -162,6 +162,7 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 	cap_mask2 = OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED |
 		    OSM_CAP2_IS_EXTENDED_SPEEDS_SUPPORTED |
 		    OSM_CAP2_IS_ALIAS_GUIDS_SUPPORTED |
+		    OSM_CAP2_IS_MULTICAST_SERVICE_RECS_SUPPORTED |
 		    OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED;
 	if (sa->p_subn->opt.use_mfttop)
 		cap_mask2 |= OSM_CAP2_IS_MCAST_TOP_SUPPORTED;
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index b274878..b238f94 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -110,8 +110,9 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 			goto Exit;
 		}
 
-		/* Make sure it matches the port of the ServiceGid */
-		if (comp_mask & IB_SR_COMPMASK_SGID) {
+		/* If unicast, make sure it matches the port of the ServiceGid */
+		if (comp_mask & IB_SR_COMPMASK_SGID &&
+		    !ib_gid_is_multicast(&p_service_rec->service_gid)) {
 			service_guid =
 			    p_service_rec->service_gid.unicast.interface_id;
 			service_port =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
