From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_helper.c: Add CapabilityMask2 to notice dump
 for trap 144
Date: Wed, 25 Jul 2012 06:40:59 -0400
Message-ID: <500FCD3B.7000705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG RefID #4855

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 47d4ddb..afee3e1 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2399,13 +2399,16 @@ static void osm_dump_notice_to_buf_generic(IN const ib_mad_notice_attr_t * p_ntc
 				"\t\t\t\tlid......................%u\n"
 				"\t\t\t\tlocal_changes............%u\n"
 				"\t\t\t\tnew_cap_mask.............0x%08x\n"
-				"\t\t\t\tchange_flags.............0x%x\n",
+				"\t\t\t\tchange_flags.............0x%x\n"
+				"\t\t\t\tcap_mask2................0x%x\n",
 				cl_ntoh16(p_ntci->data_details.ntc_144.lid),
 				p_ntci->data_details.ntc_144.local_changes,
 				cl_ntoh32(p_ntci->data_details.ntc_144.
 					  new_cap_mask),
 				cl_ntoh16(p_ntci->data_details.ntc_144.
-					  change_flgs));
+					  change_flgs),
+				cl_ntoh16(p_ntci->data_details.ntc_144.
+					  cap_mask2));
 			break;
 		case 145:
 			sprintf(buff,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
